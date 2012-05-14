From: akpm@linux-foundation.org
Subject: + tmpfs-support-fallocate-falloc_fl_punch_hole.patch added to -mm tree
Date: Mon, 14 May 2012 16:13:54 -0700
Message-ID: <20120514231354.AC98BA00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:54485 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757353Ab2ENXN4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 May 2012 19:13:56 -0400
Received: by eeit10 with SMTP id t10so279923eei.1
        for <mm-commits@vger.kernel.org>; Mon, 14 May 2012 16:13:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, amwang@redhat.com, hch@infradead.org


The patch titled
     Subject: tmpfs: support fallocate FALLOC_FL_PUNCH_HOLE
has been added to the -mm tree.  Its filename is
     tmpfs-support-fallocate-falloc_fl_punch_hole.patch

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
Subject: tmpfs: support fallocate FALLOC_FL_PUNCH_HOLE

tmpfs has supported hole-punching since 2.6.16, via
madvise(,,MADV_REMOVE).  But nowadays
fallocate(,FALLOC_FL_PUNCH_HOLE|FALLOC_FL_KEEP_SIZE,,) is the agreed way
to punch holes.

So add shmem_fallocate() to support that, and tweak shmem_truncate_range()
to support partial pages at both the beginning and end of range (never
needed for madvise, which demands rounded addr and rounds up length).

Based-on-patch-by: Cong Wang <amwang@redhat.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Cong Wang <amwang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   68 ++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 57 insertions(+), 11 deletions(-)

diff -puN mm/shmem.c~tmpfs-support-fallocate-falloc_fl_punch_hole mm/shmem.c
--- a/mm/shmem.c~tmpfs-support-fallocate-falloc_fl_punch_hole
+++ a/mm/shmem.c
@@ -53,6 +53,7 @@ static struct vfsmount *shm_mnt;
 #include <linux/blkdev.h>
 #include <linux/pagevec.h>
 #include <linux/percpu_counter.h>
+#include <linux/falloc.h>
 #include <linux/splice.h>
 #include <linux/security.h>
 #include <linux/swapops.h>
@@ -432,21 +433,23 @@ void shmem_truncate_range(struct inode *
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	pgoff_t start = (lstart + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
-	unsigned partial = lstart & (PAGE_CACHE_SIZE - 1);
-	pgoff_t end = (lend >> PAGE_CACHE_SHIFT);
+	pgoff_t end = (lend + 1) >> PAGE_CACHE_SHIFT;
+	unsigned int partial_start = lstart & (PAGE_CACHE_SIZE - 1);
+	unsigned int partial_end = (lend + 1) & (PAGE_CACHE_SIZE - 1);
 	struct pagevec pvec;
 	pgoff_t indices[PAGEVEC_SIZE];
 	long nr_swaps_freed = 0;
 	pgoff_t index;
 	int i;
 
-	BUG_ON((lend & (PAGE_CACHE_SIZE - 1)) != (PAGE_CACHE_SIZE - 1));
+	if (lend == -1)
+		end = -1;	/* unsigned, so actually very big */
 
 	pagevec_init(&pvec, 0);
 	index = start;
-	while (index <= end) {
+	while (index < end) {
 		pvec.nr = shmem_find_get_pages_and_swap(mapping, index,
-			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1,
+				min(end - index, (pgoff_t)PAGEVEC_SIZE),
 							pvec.pages, indices);
 		if (!pvec.nr)
 			break;
@@ -455,7 +458,7 @@ void shmem_truncate_range(struct inode *
 			struct page *page = pvec.pages[i];
 
 			index = indices[i];
-			if (index > end)
+			if (index >= end)
 				break;
 
 			if (radix_tree_exceptional_entry(page)) {
@@ -479,22 +482,39 @@ void shmem_truncate_range(struct inode *
 		index++;
 	}
 
-	if (partial) {
+	if (partial_start) {
 		struct page *page = NULL;
 		shmem_getpage(inode, start - 1, &page, SGP_READ, NULL);
 		if (page) {
-			zero_user_segment(page, partial, PAGE_CACHE_SIZE);
+			unsigned int top = PAGE_CACHE_SIZE;
+			if (start > end) {
+				top = partial_end;
+				partial_end = 0;
+			}
+			zero_user_segment(page, partial_start, top);
 			set_page_dirty(page);
 			unlock_page(page);
 			page_cache_release(page);
 		}
 	}
+	if (partial_end) {
+		struct page *page = NULL;
+		shmem_getpage(inode, end, &page, SGP_READ, NULL);
+		if (page) {
+			zero_user_segment(page, 0, partial_end);
+			set_page_dirty(page);
+			unlock_page(page);
+			page_cache_release(page);
+		}
+	}
+	if (start >= end)
+		return;
 
 	index = start;
 	for ( ; ; ) {
 		cond_resched();
 		pvec.nr = shmem_find_get_pages_and_swap(mapping, index,
-			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1,
+				min(end - index, (pgoff_t)PAGEVEC_SIZE),
 							pvec.pages, indices);
 		if (!pvec.nr) {
 			if (index == start)
@@ -502,7 +522,7 @@ void shmem_truncate_range(struct inode *
 			index = start;
 			continue;
 		}
-		if (index == start && indices[0] > end) {
+		if (index == start && indices[0] >= end) {
 			shmem_deswap_pagevec(&pvec);
 			pagevec_release(&pvec);
 			break;
@@ -512,7 +532,7 @@ void shmem_truncate_range(struct inode *
 			struct page *page = pvec.pages[i];
 
 			index = indices[i];
-			if (index > end)
+			if (index >= end)
 				break;
 
 			if (radix_tree_exceptional_entry(page)) {
@@ -1578,6 +1598,31 @@ static ssize_t shmem_file_splice_read(st
 	return error;
 }
 
+static long shmem_fallocate(struct file *file, int mode, loff_t offset,
+							 loff_t len)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	int error = -EOPNOTSUPP;
+
+	mutex_lock(&inode->i_mutex);
+
+	if (mode & FALLOC_FL_PUNCH_HOLE) {
+		struct address_space *mapping = file->f_mapping;
+		loff_t unmap_start = round_up(offset, PAGE_SIZE);
+		loff_t unmap_end = round_down(offset + len, PAGE_SIZE) - 1;
+
+		if ((u64)unmap_end > (u64)unmap_start)
+			unmap_mapping_range(mapping, unmap_start,
+					    1 + unmap_end - unmap_start, 0);
+		shmem_truncate_range(inode, offset, offset + len - 1);
+		/* No need to unmap again: hole-punching leaves COWed pages */
+		error = 0;
+	}
+
+	mutex_unlock(&inode->i_mutex);
+	return error;
+}
+
 static int shmem_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(dentry->d_sb);
@@ -2478,6 +2523,7 @@ static const struct file_operations shme
 	.fsync		= noop_fsync,
 	.splice_read	= shmem_file_splice_read,
 	.splice_write	= generic_file_splice_write,
+	.fallocate	= shmem_fallocate,
 #endif
 };
 
_
Subject: Subject: tmpfs: support fallocate FALLOC_FL_PUNCH_HOLE

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

