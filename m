From: akpm@linux-foundation.org
Subject: + tmpfs-quit-when-fallocate-fills-memory.patch added to -mm tree
Date: Mon, 14 May 2012 16:14:10 -0700
Message-ID: <20120514231410.DEC6EA00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:48272 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757353Ab2ENXON (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 May 2012 19:14:13 -0400
Received: by lagr15 with SMTP id r15so220683lag.1
        for <mm-commits@vger.kernel.org>; Mon, 14 May 2012 16:14:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, amwang@redhat.com, hch@infradead.org, kay@vrfy.org


The patch titled
     Subject: tmpfs: quit when fallocate fills memory
has been added to the -mm tree.  Its filename is
     tmpfs-quit-when-fallocate-fills-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: tmpfs: quit when fallocate fills memory

As it stands, a large fallocate() on tmpfs is liable to fill memory with
pages, freed on failure except when they run into swap, at which point
they become fixed into the file despite the failure.  That feels quite
wrong, to be consuming resources precisely when they're in short supply.

Go the other way instead: shmem_fallocate() indicate the range it has
fallocated to shmem_writepage(), keeping count of pages it's allocating;
shmem_writepage() reactivate instead of swapping out pages fallocated by
this syscall (but happily swap out those from earlier occasions), keeping
count; shmem_fallocate() compare counts and give up once the reactivated
pages have started to coming back to writepage (approximately: some zones
would in fact recycle faster than others).

This is a little unusual, but works well: although we could consider the
failure to swap as a bug, and fix it later with SWAP_MAP_FALLOC handling
added in swapfile.c and memcontrol.c, I doubt that we shall ever want to.

(If there's no swap, an over-large fallocate() on tmpfs is limited in the
same way as writing: stopped by rlimit, or by tmpfs mount size if that was
set sensibly, or by __vm_enough_memory() heuristics if OVERCOMMIT_GUESS or
OVERCOMMIT_NEVER.  If OVERCOMMIT_ALWAYS, then it is liable to OOM-kill
others as writing would, but stops and frees if interrupted.)

Now that everything is freed on failure, we can then skip updating ctime.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Cong Wang <amwang@redhat.com>
Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   58 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 56 insertions(+), 2 deletions(-)

diff -puN mm/shmem.c~tmpfs-quit-when-fallocate-fills-memory mm/shmem.c
--- a/mm/shmem.c~tmpfs-quit-when-fallocate-fills-memory
+++ a/mm/shmem.c
@@ -84,6 +84,18 @@ struct shmem_xattr {
 	char value[0];
 };
 
+/*
+ * shmem_fallocate and shmem_writepage communicate via inode->i_private
+ * (with i_mutex making sure that it has only one user at a time):
+ * we would prefer not to enlarge the shmem inode just for that.
+ */
+struct shmem_falloc {
+	pgoff_t start;		/* start of range currently being fallocated */
+	pgoff_t next;		/* the next page offset to be fallocated */
+	pgoff_t nr_falloced;	/* how many new pages have been fallocated */
+	pgoff_t nr_unswapped;	/* how often writepage refused to swap out */
+};
+
 /* Flag allocation requirements to shmem_getpage */
 enum sgp_type {
 	SGP_READ,	/* don't exceed i_size, don't allocate page */
@@ -791,8 +803,28 @@ static int shmem_writepage(struct page *
 	 * This is somewhat ridiculous, but without plumbing a SWAP_MAP_FALLOC
 	 * value into swapfile.c, the only way we can correctly account for a
 	 * fallocated page arriving here is now to initialize it and write it.
+	 *
+	 * That's okay for a page already fallocated earlier, but if we have
+	 * not yet completed the fallocation, then (a) we want to keep track
+	 * of this page in case we have to undo it, and (b) it may not be a
+	 * good idea to continue anyway, once we're pushing into swap.  So
+	 * reactivate the page, and let shmem_fallocate() quit when too many.
 	 */
 	if (!PageUptodate(page)) {
+		if (inode->i_private) {
+			struct shmem_falloc *shmem_falloc;
+			spin_lock(&inode->i_lock);
+			shmem_falloc = inode->i_private;
+			if (shmem_falloc &&
+			    index >= shmem_falloc->start &&
+			    index < shmem_falloc->next)
+				shmem_falloc->nr_unswapped++;
+			else
+				shmem_falloc = NULL;
+			spin_unlock(&inode->i_lock);
+			if (shmem_falloc)
+				goto redirty;
+		}
 		clear_highpage(page);
 		flush_dcache_page(page);
 		SetPageUptodate(page);
@@ -1647,6 +1679,7 @@ static long shmem_fallocate(struct file 
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
+	struct shmem_falloc shmem_falloc;
 	pgoff_t start, index, end;
 	int error;
 
@@ -1679,6 +1712,14 @@ static long shmem_fallocate(struct file 
 		goto out;
 	}
 
+	shmem_falloc.start = start;
+	shmem_falloc.next  = start;
+	shmem_falloc.nr_falloced = 0;
+	shmem_falloc.nr_unswapped = 0;
+	spin_lock(&inode->i_lock);
+	inode->i_private = &shmem_falloc;
+	spin_unlock(&inode->i_lock);
+
 	for (index = start; index < end; index++) {
 		struct page *page;
 
@@ -1688,6 +1729,8 @@ static long shmem_fallocate(struct file 
 		 */
 		if (signal_pending(current))
 			error = -EINTR;
+		else if (shmem_falloc.nr_unswapped > shmem_falloc.nr_falloced)
+			error = -ENOMEM;
 		else
 			error = shmem_getpage(inode, index, &page, SGP_FALLOC,
 									NULL);
@@ -1696,10 +1739,18 @@ static long shmem_fallocate(struct file 
 			shmem_undo_range(inode,
 				(loff_t)start << PAGE_CACHE_SHIFT,
 				(loff_t)index << PAGE_CACHE_SHIFT, true);
-			goto ctime;
+			goto undone;
 		}
 
 		/*
+		 * Inform shmem_writepage() how far we have reached.
+		 * No need for lock or barrier: we have the page lock.
+		 */
+		shmem_falloc.next++;
+		if (!PageUptodate(page))
+			shmem_falloc.nr_falloced++;
+
+		/*
 		 * If !PageUptodate, leave it that way so that freeable pages
 		 * can be recognized if we need to rollback on error later.
 		 * But set_page_dirty so that memory pressure will swap rather
@@ -1714,8 +1765,11 @@ static long shmem_fallocate(struct file 
 
 	if (!(mode & FALLOC_FL_KEEP_SIZE) && offset + len > inode->i_size)
 		i_size_write(inode, offset + len);
-ctime:
 	inode->i_ctime = CURRENT_TIME;
+undone:
+	spin_lock(&inode->i_lock);
+	inode->i_private = NULL;
+	spin_unlock(&inode->i_lock);
 out:
 	mutex_unlock(&inode->i_mutex);
 	return error;
_
Subject: Subject: tmpfs: quit when fallocate fills memory

Patches currently in -mm which might be from hughd@google.com are

linux-next.patch
mm-remove-swap-token-code.patch
mm-vmscan-remove-lumpy-reclaim.patch
mm-vmscan-do-not-stall-on-writeback-during-memory-compaction.patch
mm-vmscan-remove-reclaim_mode_t.patch
mm-mmapc-find_vma-remove-unnecessary-ifmm-check.patch
mm-mmapc-find_vma-remove-unnecessary-ifmm-check-fix.patch
mm-fork-fix-overflow-in-vma-length-when-copying-mmap-on-clone.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
bug-introduce-build_bug_on_invalid-macro.patch
bug-completely-remove-code-generated-by-disabled-vm_bug_on.patch
shmem-replace-page-if-mapping-excludes-its-zone.patch
tmpfs-enable-nosec-optimization.patch
tmpfs-optimize-clearing-when-writing.patch
tmpfs-support-fallocate-falloc_fl_punch_hole.patch
mm-fs-route-madv_remove-to-falloc_fl_punch_hole.patch
mm-fs-remove-truncate_range.patch
tmpfs-support-fallocate-preallocation.patch
tmpfs-undo-fallocation-on-failure.patch
tmpfs-quit-when-fallocate-fills-memory.patch
tmpfs-support-seek_data-and-seek_hole.patch
memcg-fix-change-behavior-of-shared-anon-at-moving-task.patch
memcg-swap-mem_cgroup_move_swap_account-never-needs-fixup.patch
memcg-swap-use-mem_cgroup_uncharge_swap.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch
memcg-add-mlock-statistic-in-memorystat.patch
memcg-add-mlock-statistic-in-memorystat-fix.patch
mm-vmscan-store-priority-in-struct-scan_control.patch
mm-add-link-from-struct-lruvec-to-struct-zone.patch
mm-vmscan-push-lruvec-pointer-into-isolate_lru_pages.patch
mm-vmscan-push-zone-pointer-into-shrink_page_list.patch
mm-vmscan-remove-update_isolated_counts.patch
mm-vmscan-push-lruvec-pointer-into-putback_inactive_pages.patch
mm-vmscan-replace-zone_nr_lru_pages-with-get_lruvec_size.patch
mm-vmscan-push-lruvec-pointer-into-inactive_list_is_low.patch
mm-vmscan-push-lruvec-pointer-into-shrink_list.patch
mm-vmscan-push-lruvec-pointer-into-get_scan_count.patch
mm-vmscan-push-lruvec-pointer-into-should_continue_reclaim.patch
mm-vmscan-kill-struct-mem_cgroup_zone.patch
mm-huge_memoryc-use-lockdep_assert_held.patch
proc-clean-up-proc-pid-environ-handling.patch
proc-remove-mm_for_maps.patch
proc-use-mm_access-instead-of-ptrace_may_access.patch
proc-report-file-anon-bit-in-proc-pid-pagemap.patch
proc-use-is_err_or_null.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
prio_tree-debugging-patch.patch

