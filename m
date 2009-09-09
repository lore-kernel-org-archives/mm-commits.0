From: akpm@linux-foundation.org
Subject: + tmpfs-depend-on-shmem.patch added to -mm tree
Date: Wed, 09 Sep 2009 15:14:22 -0700
Message-ID: <200909092214.n89MEMZl001537@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751434AbZIIWOe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2009 18:14:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, mpm@selenic.com


The patch titled
     tmpfs: depend on shmem
has been added to the -mm tree.  Its filename is
     tmpfs-depend-on-shmem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tmpfs: depend on shmem
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

CONFIG_SHMEM off gives you (ramfs masquerading as) tmpfs, even when
CONFIG_TMPFS is off: that's a little anomalous, and I'd intended to make
more sense of it by removing CONFIG_TMPFS altogether, always enabling its
code when CONFIG_SHMEM; but so many defconfigs have CONFIG_SHMEM on
CONFIG_TMPFS off that we'd better leave that as is.

But there is no point in asking for CONFIG_TMPFS if CONFIG_SHMEM is off:
make TMPFS depend on SHMEM, which also prevents TMPFS_POSIX_ACL
shmem_acl.o being pointlessly built into the kernel when SHMEM is off.

And a selfish change, to prevent the world from being rebuilt when I
switch between CONFIG_SHMEM on and off: the only CONFIG_SHMEM in the
header files is mm.h shmem_lock() - give that a shmem.c stub instead.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Acked-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig         |    1 +
 include/linux/mm.h |   11 +----------
 mm/shmem.c         |    5 +++++
 3 files changed, 7 insertions(+), 10 deletions(-)

diff -puN fs/Kconfig~tmpfs-depend-on-shmem fs/Kconfig
--- a/fs/Kconfig~tmpfs-depend-on-shmem
+++ a/fs/Kconfig
@@ -109,6 +109,7 @@ source "fs/sysfs/Kconfig"
 
 config TMPFS
 	bool "Virtual memory file system support (former shm fs)"
+	depends on SHMEM
 	help
 	  Tmpfs is a file system which keeps all files in virtual memory.
 
diff -puN include/linux/mm.h~tmpfs-depend-on-shmem include/linux/mm.h
--- a/include/linux/mm.h~tmpfs-depend-on-shmem
+++ a/include/linux/mm.h
@@ -703,17 +703,8 @@ extern void pagefault_out_of_memory(void
 
 extern void show_free_areas(void);
 
-#ifdef CONFIG_SHMEM
-extern int shmem_lock(struct file *file, int lock, struct user_struct *user);
-#else
-static inline int shmem_lock(struct file *file, int lock,
-			    struct user_struct *user)
-{
-	return 0;
-}
-#endif
+int shmem_lock(struct file *file, int lock, struct user_struct *user);
 struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags);
-
 int shmem_zero_setup(struct vm_area_struct *);
 
 #ifndef CONFIG_MMU
diff -puN mm/shmem.c~tmpfs-depend-on-shmem mm/shmem.c
--- a/mm/shmem.c~tmpfs-depend-on-shmem
+++ a/mm/shmem.c
@@ -2596,6 +2596,11 @@ int shmem_unuse(swp_entry_t entry, struc
 	return 0;
 }
 
+int shmem_lock(struct file *file, int lock, struct user_struct *user)
+{
+	return 0;
+}
+
 #define shmem_vm_ops				generic_file_vm_ops
 #define shmem_file_operations			ramfs_file_operations
 #define shmem_get_inode(sb, mode, dev, flags)	ramfs_get_inode(sb, mode, dev)
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

linux-next.patch
acpi-fix-null-bug-for-hid-uid-string-2.patch
vfs-optimize-touch_time-too-fix.patch
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
vfs-seq_file-add-helpers-for-data-filling.patch
vfs-revert-proc-mounts-to-old-behavior-for-unreachable-mountpoints.patch
vfs-no-unreachable-prefix-for-sysvipc-maps-in-proc-pid-maps.patch
mm-oom-analysis-add-shmem-vmstat.patch
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
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch
hugetlb-add-map_hugetlb-example.patch
mm-munlock-use-follow_page.patch
mm-remove-unused-gup-flags.patch
mm-add-get_dump_page.patch
mm-foll_dump-replace-foll_anon.patch
mm-follow_hugetlb_page-flags.patch
mm-fix-anonymous-dirtying.patch
mm-reinstate-zero_page.patch
mm-foll-flags-for-gup-flags.patch
mmap-remove-unnecessary-code.patch
tmpfs-depend-on-shmem.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
prio_tree-debugging-patch.patch

