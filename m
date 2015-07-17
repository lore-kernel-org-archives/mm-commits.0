From: akpm@linux-foundation.org
Subject: +
 fs-file-table-reinit-files_statmax_files-after-deferred-memory-initialisation.patch added to -mm tree
Date: Fri, 17 Jul 2015 13:25:32 -0700
Message-ID: <55a964bc.UYT6UZ0VpPhXhCB0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38582 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbbGQUZd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 17 Jul 2015 16:25:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, alexng@microsoft.com, dave.hansen@intel.com, fengguang.wu@intel.com, nicstange@gmail.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs, file table: reinit files_stat.max_files after deferred memory initialisation
has been added to the -mm tree.  Its filename is
     fs-file-table-reinit-files_statmax_files-after-deferred-memory-initialisation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-file-table-reinit-files_statmax_files-after-deferred-memory-initialisation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-file-table-reinit-files_statmax_files-after-deferred-memory-initialisation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: fs, file table: reinit files_stat.max_files after deferred memory initialisation

Dave Hansen reported the following;

	My laptop has been behaving strangely with 4.2-rc2.  Once I log
	in to my X session, I start getting all kinds of strange errors
	from applications and see this in my dmesg:

        	VFS: file-max limit 8192 reached

The problem is that the file-max is calculated before memory is fully
initialised and miscalculates how much memory the kernel is using.  This
patch recalculates file-max after deferred memory initialisation.  Note
that using memory hotplug infrastructure would not have avoided this
problem as the value is not recalculated after memory hot-add.

4.1:             files_stat.max_files = 6582781
4.2-rc2:         files_stat.max_files = 8192
4.2-rc2 patched: files_stat.max_files = 6562467

Small differences with the patch applied and 4.1 but not enough to matter.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-by: Dave Hansen <dave.hansen@intel.com>
Cc: Nicolai Stange <nicstange@gmail.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Alex Ng <alexng@microsoft.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c        |   13 +++----------
 fs/file_table.c    |   24 +++++++++++++++---------
 include/linux/fs.h |    5 +++--
 init/main.c        |    2 +-
 mm/page_alloc.c    |    3 +++
 5 files changed, 25 insertions(+), 22 deletions(-)

diff -puN fs/dcache.c~fs-file-table-reinit-files_statmax_files-after-deferred-memory-initialisation fs/dcache.c
--- a/fs/dcache.c~fs-file-table-reinit-files_statmax_files-after-deferred-memory-initialisation
+++ a/fs/dcache.c
@@ -3442,22 +3442,15 @@ void __init vfs_caches_init_early(void)
 	inode_init_early();
 }
 
-void __init vfs_caches_init(unsigned long mempages)
+void __init vfs_caches_init(void)
 {
-	unsigned long reserve;
-
-	/* Base hash sizes on available memory, with a reserve equal to
-           150% of current kernel size */
-
-	reserve = min((mempages - nr_free_pages()) * 3/2, mempages - 1);
-	mempages -= reserve;
-
 	names_cachep = kmem_cache_create("names_cache", PATH_MAX, 0,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
 
 	dcache_init();
 	inode_init();
-	files_init(mempages);
+	files_init();
+	files_maxfiles_init();
 	mnt_init();
 	bdev_cache_init();
 	chrdev_init();
diff -puN fs/file_table.c~fs-file-table-reinit-files_statmax_files-after-deferred-memory-initialisation fs/file_table.c
--- a/fs/file_table.c~fs-file-table-reinit-files_statmax_files-after-deferred-memory-initialisation
+++ a/fs/file_table.c
@@ -25,6 +25,7 @@
 #include <linux/hardirq.h>
 #include <linux/task_work.h>
 #include <linux/ima.h>
+#include <linux/swap.h>
 
 #include <linux/atomic.h>
 
@@ -308,19 +309,24 @@ void put_filp(struct file *file)
 	}
 }
 
-void __init files_init(unsigned long mempages)
+void __init files_init(void)
 { 
-	unsigned long n;
-
 	filp_cachep = kmem_cache_create("filp", sizeof(struct file), 0,
 			SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
+	percpu_counter_init(&nr_files, 0, GFP_KERNEL);
+}
 
-	/*
-	 * One file with associated inode and dcache is very roughly 1K.
-	 * Per default don't use more than 10% of our memory for files. 
-	 */ 
+/*
+ * One file with associated inode and dcache is very roughly 1K. Per default
+ * do not use more than 10% of our memory for files.
+ */
+void __init files_maxfiles_init(void)
+{
+	unsigned long n;
+	unsigned long memreserve = (totalram_pages - nr_free_pages()) * 3/2;
+
+	memreserve = min(memreserve, totalram_pages - 1);
+	n = ((totalram_pages - memreserve) * (PAGE_SIZE / 1024)) / 10;
 
-	n = (mempages * (PAGE_SIZE / 1024)) / 10;
 	files_stat.max_files = max_t(unsigned long, n, NR_FILE);
-	percpu_counter_init(&nr_files, 0, GFP_KERNEL);
 } 
diff -puN include/linux/fs.h~fs-file-table-reinit-files_statmax_files-after-deferred-memory-initialisation include/linux/fs.h
--- a/include/linux/fs.h~fs-file-table-reinit-files_statmax_files-after-deferred-memory-initialisation
+++ a/include/linux/fs.h
@@ -55,7 +55,8 @@ struct vm_fault;
 
 extern void __init inode_init(void);
 extern void __init inode_init_early(void);
-extern void __init files_init(unsigned long);
+extern void __init files_init(void);
+extern void __init files_maxfiles_init(void);
 
 extern struct files_stat_struct files_stat;
 extern unsigned long get_max_files(void);
@@ -2245,7 +2246,7 @@ extern int ioctl_preallocate(struct file
 
 /* fs/dcache.c */
 extern void __init vfs_caches_init_early(void);
-extern void __init vfs_caches_init(unsigned long);
+extern void __init vfs_caches_init(void);
 
 extern struct kmem_cache *names_cachep;
 
diff -puN init/main.c~fs-file-table-reinit-files_statmax_files-after-deferred-memory-initialisation init/main.c
--- a/init/main.c~fs-file-table-reinit-files_statmax_files-after-deferred-memory-initialisation
+++ a/init/main.c
@@ -656,7 +656,7 @@ asmlinkage __visible void __init start_k
 	key_init();
 	security_init();
 	dbg_late_init();
-	vfs_caches_init(totalram_pages);
+	vfs_caches_init();
 	signals_init();
 	/* rootfs populating might need page-writeback */
 	page_writeback_init();
diff -puN mm/page_alloc.c~fs-file-table-reinit-files_statmax_files-after-deferred-memory-initialisation mm/page_alloc.c
--- a/mm/page_alloc.c~fs-file-table-reinit-files_statmax_files-after-deferred-memory-initialisation
+++ a/mm/page_alloc.c
@@ -1201,6 +1201,9 @@ void __init page_alloc_init_late(void)
 
 	/* Block until all are initialised */
 	wait_for_completion(&pgdat_init_all_done_comp);
+
+	/* Reinit limits that are based on free pages after the kernel is up */
+	files_maxfiles_init();
 }
 #endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
 
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-meminit-suppress-unused-memory-variable-warning.patch
mm-page_owner-fix-possible-access-violation.patch
mm-page_owner-set-correct-gfp_mask-on-page_owner.patch
mm-meminit-allow-early_pfn_to_nid-to-be-used-during-runtime.patch
mm-meminit-replace-rwsem-with-completion.patch
fs-file-table-reinit-files_statmax_files-after-deferred-memory-initialisation.patch
userfaultfd-linux-documentation-vm-userfaultfdtxt.patch
userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key.patch
userfaultfd-uapi.patch
userfaultfd-linux-userfaultfd_kh.patch
userfaultfd-add-vm_userfaultfd_ctx-to-the-vm_area_struct.patch
userfaultfd-add-vm_uffd_missing-and-vm_uffd_wp.patch
userfaultfd-call-handle_userfault-for-userfaultfd_missing-faults.patch
userfaultfd-teach-vma_merge-to-merge-across-vma-vm_userfaultfd_ctx.patch
userfaultfd-prevent-khugepaged-to-merge-if-userfaultfd-is-armed.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization.patch
userfaultfd-rename-uffd_apibits-into-features.patch
userfaultfd-rename-uffd_apibits-into-features-fixup.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg.patch
userfaultfd-wake-pending-userfaults.patch
userfaultfd-optimize-read-and-poll-to-be-o1.patch
userfaultfd-allocate-the-userfaultfd_ctx-cacheline-aligned.patch
userfaultfd-solve-the-race-between-uffdio_copyzeropage-and-read.patch
userfaultfd-buildsystem-activation.patch
userfaultfd-activate-syscall.patch
userfaultfd-uffdio_copyuffdio_zeropage-uapi.patch
userfaultfd-mcopy_atomicmfill_zeropage-uffdio_copyuffdio_zeropage-preparation.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic.patch
userfaultfd-uffdio_copy-and-uffdio_zeropage.patch
x86-mm-trace-when-an-ipi-is-about-to-be-sent.patch
mm-send-one-ipi-per-cpu-to-tlb-flush-all-entries-after-unmapping-pages.patch
mm-send-one-ipi-per-cpu-to-tlb-flush-all-entries-after-unmapping-pages-fix.patch
mm-defer-flush-of-writable-tlb-entries.patch
documentation-features-vm-add-feature-description-and-arch-support-status-for-batched-tlb-flush-after-unmap.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

