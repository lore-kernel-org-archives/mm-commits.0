From: akpm@linux-foundation.org
Subject: + introduce-__get_user_pages.patch added to -mm tree
Date: Sun, 20 Jul 2008 22:20:57 -0700
Message-ID: <200807210520.m6L5KvEi018933@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760621AbYGUFWH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jul 2008 01:22:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, Lee.Schermerhorn@hp.com, hugh@veritas.com, lizf@cn.fujitsu.com, riel@redhat.com


The patch titled
     splitlru: introduce __get_user_pages()
has been added to the -mm tree.  Its filename is
     introduce-__get_user_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: splitlru: introduce __get_user_pages()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

New munlock processing need to GUP_FLAGS_IGNORE_VMA_PERMISSIONS.  because
current get_user_pages() can't grab PROT_NONE pages theresore it cause
PROT_NONE pages can't munlock.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    8 ++++++++
 mm/memory.c   |   37 +++++++++++++++++++++++++++++++------
 mm/nommu.c    |   42 +++++++++++++++++++++++++++++++-----------
 3 files changed, 70 insertions(+), 17 deletions(-)

diff -puN mm/internal.h~introduce-__get_user_pages mm/internal.h
--- a/mm/internal.h~introduce-__get_user_pages
+++ a/mm/internal.h
@@ -216,4 +216,12 @@ static inline void mminit_validate_memmo
 }
 #endif /* CONFIG_SPARSEMEM */
 
+#define GUP_FLAGS_WRITE                  0x1
+#define GUP_FLAGS_FORCE                  0x2
+#define GUP_FLAGS_IGNORE_VMA_PERMISSIONS 0x4
+
+int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
+		     unsigned long start, int len, int flags,
+		     struct page **pages, struct vm_area_struct **vmas);
+
 #endif
diff -puN mm/memory.c~introduce-__get_user_pages mm/memory.c
--- a/mm/memory.c~introduce-__get_user_pages
+++ a/mm/memory.c
@@ -1132,12 +1132,17 @@ static inline int use_zero_page(struct v
 	return !vma->vm_ops || !vma->vm_ops->fault;
 }
 
-int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
-		unsigned long start, int len, int write, int force,
+
+
+int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
+		     unsigned long start, int len, int flags,
 		struct page **pages, struct vm_area_struct **vmas)
 {
 	int i;
-	unsigned int vm_flags;
+	unsigned int vm_flags = 0;
+	int write = !!(flags & GUP_FLAGS_WRITE);
+	int force = !!(flags & GUP_FLAGS_FORCE);
+	int ignore = !!(flags & GUP_FLAGS_IGNORE_VMA_PERMISSIONS);
 
 	if (len <= 0)
 		return 0;
@@ -1161,7 +1166,9 @@ int get_user_pages(struct task_struct *t
 			pud_t *pud;
 			pmd_t *pmd;
 			pte_t *pte;
-			if (write) /* user gate pages are read-only */
+
+			/* user gate pages are read-only */
+			if (!ignore && write)
 				return i ? : -EFAULT;
 			if (pg > TASK_SIZE)
 				pgd = pgd_offset_k(pg);
@@ -1193,8 +1200,9 @@ int get_user_pages(struct task_struct *t
 			continue;
 		}
 
-		if (!vma || (vma->vm_flags & (VM_IO | VM_PFNMAP))
-				|| !(vm_flags & vma->vm_flags))
+		if (!vma ||
+		    (vma->vm_flags & (VM_IO | VM_PFNMAP)) ||
+		    (!ignore && !(vm_flags & vma->vm_flags)))
 			return i ? : -EFAULT;
 
 		if (is_vm_hugetlb_page(vma)) {
@@ -1269,6 +1277,23 @@ int get_user_pages(struct task_struct *t
 	} while (len);
 	return i;
 }
+
+int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
+		unsigned long start, int len, int write, int force,
+		struct page **pages, struct vm_area_struct **vmas)
+{
+	int flags = 0;
+
+	if (write)
+		flags |= GUP_FLAGS_WRITE;
+	if (force)
+		flags |= GUP_FLAGS_FORCE;
+
+	return __get_user_pages(tsk, mm,
+				start, len, flags,
+				pages, vmas);
+}
+
 EXPORT_SYMBOL(get_user_pages);
 
 pte_t *get_locked_pte(struct mm_struct *mm, unsigned long addr,
diff -puN mm/nommu.c~introduce-__get_user_pages mm/nommu.c
--- a/mm/nommu.c~introduce-__get_user_pages
+++ a/mm/nommu.c
@@ -128,20 +128,16 @@ unsigned int kobjsize(const void *objp)
 	return PAGE_SIZE << compound_order(page);
 }
 
-/*
- * get a list of pages in an address range belonging to the specified process
- * and indicate the VMA that covers each page
- * - this is potentially dodgy as we may end incrementing the page count of a
- *   slab page or a secondary page from a compound page
- * - don't permit access to VMAs that don't support it, such as I/O mappings
- */
-int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
-	unsigned long start, int len, int write, int force,
-	struct page **pages, struct vm_area_struct **vmas)
+int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
+		     unsigned long start, int len, int flags,
+		struct page **pages, struct vm_area_struct **vmas)
 {
 	struct vm_area_struct *vma;
 	unsigned long vm_flags;
 	int i;
+	int write = !!(flags & GUP_FLAGS_WRITE);
+	int force = !!(flags & GUP_FLAGS_FORCE);
+	int ignore = !!(flags & GUP_FLAGS_IGNORE_VMA_PERMISSIONS);
 
 	/* calculate required read or write permissions.
 	 * - if 'force' is set, we only require the "MAY" flags.
@@ -156,7 +152,7 @@ int get_user_pages(struct task_struct *t
 
 		/* protect what we can, including chardevs */
 		if (vma->vm_flags & (VM_IO | VM_PFNMAP) ||
-		    !(vm_flags & vma->vm_flags))
+		    (!ignore && !(vm_flags & vma->vm_flags)))
 			goto finish_or_fault;
 
 		if (pages) {
@@ -174,6 +170,30 @@ int get_user_pages(struct task_struct *t
 finish_or_fault:
 	return i ? : -EFAULT;
 }
+
+
+/*
+ * get a list of pages in an address range belonging to the specified process
+ * and indicate the VMA that covers each page
+ * - this is potentially dodgy as we may end incrementing the page count of a
+ *   slab page or a secondary page from a compound page
+ * - don't permit access to VMAs that don't support it, such as I/O mappings
+ */
+int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
+	unsigned long start, int len, int write, int force,
+	struct page **pages, struct vm_area_struct **vmas)
+{
+	int flags = 0;
+
+	if (write)
+		flags |= GUP_FLAGS_WRITE;
+	if (force)
+		flags |= GUP_FLAGS_FORCE;
+
+	return __get_user_pages(tsk, mm,
+				start, len, flags,
+				pages, vmas);
+}
 EXPORT_SYMBOL(get_user_pages);
 
 DEFINE_RWLOCK(vmlist_lock);
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

adapt-drivers-base-topologyc-to-new-sysfs-api.patch
ahci-use-correct-type-for-cpu-flags.patch
page-allocator-inlnie-some-__alloc_pages-wrappers.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
mm-hugetlbc-fix-duplicate-variable.patch
page-flags-record-page-flag-overlays-explicitly.patch
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch
mm-create-sys-kernel-mm-fix.patch
mm-make-config_migration-available-w-o-config_numa-fix.patch
pm-schedule-sysrq-poweroff-on-boot-cpu-fix.patch
call_usermodehelper-increase-reliability.patch
cgroup-list_for_each-cleanup-v2.patch
cgroup-anotate-two-variables-with-__read_mostly.patch
devcgroup-code-cleanup-fix-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-memcg-fix-mem_cgroup_end_migration-race.patch
memcg-remove-refcnt-from-page_cgroup-memcg-fix-shmem_unuse_inode-charging.patch
memcg-clean-up-checking-of-the-disabled-flag.patch
memcg-clean-up-checking-of-the-disabled-flag-memcg-further-checking-of-disabled-flag.patch
per-task-delay-accounting-update-document-and-getdelaysc-for-memory-reclaim.patch
full-conversion-to-early_initcall-interface-remove-old-interface-fix-fix.patch
full-conversion-to-early_initcall-interface-remove-old-interface-fix-fix-fix.patch
relay-add-buffer-only-channels-useful-for-early-logging-fix.patch
mm-speculative-page-references-fix-migration_entry_wait-for-speculative-page-cache.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
swap-use-an-array-for-the-lru-pagevecs.patch
define-page_file_cache-function-fix-splitlru-shmem_getpage-setpageswapbacked-sooner.patch
vmscan-split-lru-lists-into-anon-file-sets-collect-lru-meminfo-statistics-from-correct-offset.patch
vmscan-split-lru-lists-into-anon-file-sets-prevent-incorrect-oom-under-split_lru.patch
vmscan-split-lru-lists-into-anon-file-sets-split_lru-fix-pagevec_move_tail-doesnt-treat-unevictable-page.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-memcg-swapbacked-pages-active.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
vmscan-second-chance-replacement-for-anonymous-pages-fix.patch
unevictable-lru-infrastructure.patch
unevictable-lru-infrastructure-fix.patch
unevictable-lru-infrastructure-remove-redundant-page-mapping-check.patch
unevictable-lru-infrastructure-putback_lru_page-unevictable-page-handling-rework.patch
unevictable-lru-infrastructure-kill-unnecessary-lock_page-in-vmscanc.patch
unevictable-lru-infrastructure-revert-migration-change-of-unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
unevictable-lru-page-statistics-fix-printk-in-show_free_areas.patch
unevictable-lru-page-statistics-units-fix.patch
shm_locked-pages-are-unevictable.patch
shm_locked-pages-are-unevictable-revert-shm-change-of-shm_locked-pages-are-unevictable-patch.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mlock-mlocked-pages-are-unevictable-fix-fix-munlock-page-table-walk-now-requires-mm.patch
mlock-mlocked-pages-are-unevictable-restore-patch-failure-hunk-of-mlock-mlocked-pages-are-unevictablepatch.patch
mlock-mlocked-pages-are-unevictable-fix-truncate-race-and-sevaral-comments.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
introduce-__get_user_pages.patch
split-lru-munlock-rework.patch
revert-to-unevictable-lru-infrastructure-kconfig-fixpatch.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
vmstat-mlocked-pages-statistics-fix.patch
swap-cull-unevictable-pages-in-fault-path-fix.patch
vmstat-unevictable-and-mlocked-pages-vm-events.patch
restore-patch-failure-of-vmstat-unevictable-and-mlocked-pages-vm-eventspatch.patch
vmscan-unevictable-lru-scan-sysctl.patch
vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch
vmscan-unevictable-lru-scan-sysctl-add-sys_device-parameter.patch
vmscam-kill-unused-lru-functions.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch

