From: akpm@linux-foundation.org
Subject: [folded] vfs-optimize-touch_time-too-fix.patch removed from -mm tree
Date: Fri, 18 Sep 2009 13:02:32 -0700
Message-ID: <200909182002.n8IK2Wo3012747@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753975AbZIRUDL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Sep 2009 16:03:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, ak@linux.intel.com, haveblue@us.ibm.com, hch@infradead.org, vaurora@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: optimize touch_time too fix
has been removed from the -mm tree.  Its filename was
     vfs-optimize-touch_time-too-fix.patch

This patch was dropped because it was folded into vfs-optimize-touch_time-too.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: optimize touch_time too fix
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Recent mmotms give me WARNING: at fs/namespace.c:612 mntput_no_expire()+...
when unmounting: __mntput()'s WARN_ON(count_mnt_writers(mnt)).

That's because vfs-optimize-touch_time-too.patch inverted the sense
of mnt_want_write_file(), which is error-returning, not a boolean.

Presumably filetime updates went missing too, but I didn't notice those.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Valerie Aurora <vaurora@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/inode.c~vfs-optimize-touch_time-too-fix fs/inode.c
--- a/fs/inode.c~vfs-optimize-touch_time-too-fix
+++ a/fs/inode.c
@@ -1476,7 +1476,7 @@ void file_update_time(struct file *file)
 		return;
 
 	/* Finally allowed to write? Takes lock. */
-	if (!mnt_want_write_file(file))
+	if (mnt_want_write_file(file))
 		return;
 
 	/* Only change inode inside the lock region */
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
linux-next.patch
vfs-optimize-touch_time-too.patch
vfs-optimize-touch_time-too-fix.patch
vfs-seq_file-add-helpers-for-data-filling.patch
vfs-revert-proc-mounts-to-old-behavior-for-unreachable-mountpoints.patch
vfs-no-unreachable-prefix-for-sysvipc-maps-in-proc-pid-maps.patch
fs-new-truncate-helpers.patch
fs-use-new-truncate-helpers.patch
fs-introduce-new-truncate-sequence.patch
fs-convert-simple-fs-to-new-truncate.patch
tmpfs-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention.patch
fat-convert-to-use-the-new-truncate-convention.patch
btrfs-convert-to-use-the-new-truncate-convention.patch
jfs-convert-to-use-the-new-truncate-convention.patch
udf-convert-to-use-the-new-truncate-convention.patch
minix-convert-to-use-the-new-truncate-convention.patch
mm-oom-analysis-add-shmem-vmstat.patch
mm-vmstat-add-isolate-pages.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch
ksm-rename-kernel_pages_allocated.patch
ksm-move-pages_sharing-updates.patch
ksm-pages_unshared-and-pages_volatile.patch
ksm-break-cow-once-unshared.patch
ksm-keep-quiet-while-list-empty.patch
ksm-five-little-cleanups.patch
ksm-fix-endless-loop-on-oom.patch
ksm-distribute-remove_mm_from_lists.patch
ksm-fix-oom-deadlock.patch
ksm-fix-deadlock-with-munlock-in-exit_mmap.patch
ksm-sysfs-and-defaults.patch
ksm-add-some-documentation.patch
ksm-remove-vm_mergeable_flags.patch
ksm-clean-up-obsolete-references.patch
ksm-unmerge-is-an-origin-of-ooms.patch
ksm-mremap-use-err-from-ksm_madvise.patch
mm-add_to_swap_cache-must-not-sleep.patch
mm-add_to_swap_cache-does-not-return-eexist.patch
mm-includecheck-fix-for-mm-shmemc.patch
mm-introduce-page_lru_base_type-fix.patch
mm-replace-various-uses-of-num_physpages-by-totalram_pages.patch
hugetlbfs-allow-the-creation-of-files-suitable-for-map_private-on-the-vfs-internal-mount.patch
mm-munlock-use-follow_page.patch
mm-remove-unused-gup-flags.patch
mm-add-get_dump_page.patch
mm-foll_dump-replace-foll_anon.patch
mm-follow_hugetlb_page-flags.patch
mm-fix-anonymous-dirtying.patch
mm-reinstate-zero_page.patch
mm-foll-flags-for-gup-flags.patch
mm-munlock-avoid-zero_page.patch
mm-hugetlbfs_pagecache_present.patch
mm-zero_page-without-pte_special.patch
mm-zero_page-without-pte_special-mips-fix.patch
mm-move-highest_memmap_pfn.patch
mmap-remove-unnecessary-code.patch
tmpfs-depend-on-shmem.patch
mmap-avoid-unnecessary-anon_vma-lock-acquisition-in-vma_adjust.patch
mmap-avoid-unnecessary-anon_vma-lock-acquisition-in-vma_adjust-tweak.patch
mmap-save-some-cycles-for-the-shared-anonymous-mapping.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
walk-system-ram-range-fix.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
prio_tree-debugging-patch.patch

