From: akpm@linux-foundation.org
Subject: + tmpfs-support-seek_data-and-seek_hole.patch added to -mm tree
Date: Mon, 14 May 2012 16:14:12 -0700
Message-ID: <20120514231413.15E2FA00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:54485 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758246Ab2ENXOO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 May 2012 19:14:14 -0400
Received: by mail-ee0-f74.google.com with SMTP id t10so279923eei.1
        for <mm-commits@vger.kernel.org>; Mon, 14 May 2012 16:14:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, adilger@dilger.ca, andi@firstfloor.org, chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org, jeff.liu@oracle.com, josef@redhat.com, marco.stornelli@gmail.com, sunil.mushran@oracle.com


The patch titled
     Subject: tmpfs: support SEEK_DATA and SEEK_HOLE
has been added to the -mm tree.  Its filename is
     tmpfs-support-seek_data-and-seek_hole.patch

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
Subject: tmpfs: support SEEK_DATA and SEEK_HOLE

It's quite easy for tmpfs to scan the radix_tree to support llseek's new
SEEK_DATA and SEEK_HOLE options: so add them while the minutiae are still
on my mind (in particular, the !PageUptodate-ness of pages fallocated but
still unwritten).

But I don't know who actually uses SEEK_DATA or SEEK_HOLE, and whether it
would be of any use to them on tmpfs.  This code adds 92 lines and 752
bytes on x86_64 - is that bloat or worthwhile?

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Josef Bacik <josef@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Andreas Dilger <adilger@dilger.ca>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Jeff liu <jeff.liu@oracle.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   94 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 93 insertions(+), 1 deletion(-)

diff -puN mm/shmem.c~tmpfs-support-seek_data-and-seek_hole mm/shmem.c
--- a/mm/shmem.c~tmpfs-support-seek_data-and-seek_hole
+++ a/mm/shmem.c
@@ -439,6 +439,56 @@ void shmem_unlock_mapping(struct address
 }
 
 /*
+ * llseek SEEK_DATA or SEEK_HOLE through the radix_tree.
+ */
+static pgoff_t shmem_seek_hole_data(struct address_space *mapping,
+				    pgoff_t index, pgoff_t end, int origin)
+{
+	struct page *page;
+	struct pagevec pvec;
+	pgoff_t indices[PAGEVEC_SIZE];
+	bool done = false;
+	int i;
+
+	pagevec_init(&pvec, 0);
+	pvec.nr = 1;		/* start small: we may be there already */
+	while (!done) {
+		pvec.nr = shmem_find_get_pages_and_swap(mapping, index,
+					pvec.nr, pvec.pages, indices);
+		if (!pvec.nr) {
+			if (origin == SEEK_DATA)
+				index = end;
+			break;
+		}
+		for (i = 0; i < pvec.nr; i++, index++) {
+			if (index < indices[i]) {
+				if (origin == SEEK_HOLE) {
+					done = true;
+					break;
+				}
+				index = indices[i];
+			}
+			page = pvec.pages[i];
+			if (page && !radix_tree_exceptional_entry(page)) {
+				if (!PageUptodate(page))
+					page = NULL;
+			}
+			if (index >= end ||
+			    (page && origin == SEEK_DATA) ||
+			    (!page && origin == SEEK_HOLE)) {
+				done = true;
+				break;
+			}
+		}
+		shmem_deswap_pagevec(&pvec);
+		pagevec_release(&pvec);
+		pvec.nr = PAGEVEC_SIZE;
+		cond_resched();
+	}
+	return index;
+}
+
+/*
  * Remove range of pages and swap entries from radix tree, and free them.
  * If !unfalloc, truncate or punch hole; if unfalloc, undo failed fallocate.
  */
@@ -1674,6 +1724,48 @@ static ssize_t shmem_file_splice_read(st
 	return error;
 }
 
+static loff_t shmem_file_llseek(struct file *file, loff_t offset, int origin)
+{
+	struct address_space *mapping;
+	struct inode *inode;
+	pgoff_t start, end;
+	loff_t new_offset;
+
+	if (origin != SEEK_DATA && origin != SEEK_HOLE)
+		return generic_file_llseek_size(file, offset, origin,
+							MAX_LFS_FILESIZE);
+	mapping = file->f_mapping;
+	inode = mapping->host;
+	mutex_lock(&inode->i_mutex);
+	/* We're holding i_mutex so we can access i_size directly */
+
+	if (offset < 0)
+		offset = -EINVAL;
+	else if (offset >= inode->i_size)
+		offset = -ENXIO;
+	else {
+		start = offset >> PAGE_CACHE_SHIFT;
+		end = (inode->i_size + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+		new_offset = shmem_seek_hole_data(mapping, start, end, origin);
+		new_offset <<= PAGE_CACHE_SHIFT;
+		if (new_offset > offset) {
+			if (new_offset < inode->i_size)
+				offset = new_offset;
+			else if (origin == SEEK_DATA)
+				offset = -ENXIO;
+			else
+				offset = inode->i_size;
+		}
+	}
+
+	if (offset >= 0 && offset != file->f_pos) {
+		file->f_pos = offset;
+		file->f_version = 0;
+	}
+	mutex_unlock(&inode->i_mutex);
+	return offset;
+}
+
 static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 							 loff_t len)
 {
@@ -2667,7 +2759,7 @@ static const struct address_space_operat
 static const struct file_operations shmem_file_operations = {
 	.mmap		= shmem_mmap,
 #ifdef CONFIG_TMPFS
-	.llseek		= generic_file_llseek,
+	.llseek		= shmem_file_llseek,
 	.read		= do_sync_read,
 	.write		= do_sync_write,
 	.aio_read	= shmem_file_aio_read,
_
Subject: Subject: tmpfs: support SEEK_DATA and SEEK_HOLE

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

