From: akpm@linux-foundation.org
Subject: - hugetlb-allow-arch-overried-hugepage-allocation.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:23:28 -0700
Message-ID: <200807242323.m6ONNSns010672@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38575 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753097AbYGXXYH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:24:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, agl@us.ibm.com, kniht@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb: allow arch overridden hugepage allocation
has been removed from the -mm tree.  Its filename was
     hugetlb-allow-arch-overried-hugepage-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: allow arch overridden hugepage allocation
From: Nick Piggin <npiggin@suse.de>

Allow alloc_bootmem_huge_page() to be overridden by architectures that
can't always use bootmem.  This requires huge_boot_pages to be available
for use by this function.

This is required for powerpc 16G pages, which have to be reserved prior to
boot-time.  The location of these pages are indicated in the device tree.

Acked-by: Adam Litke <agl@us.ibm.com>
Signed-off-by: Jon Tollefson <kniht@linux.vnet.ibm.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   10 ++++++++++
 mm/hugetlb.c            |   11 +++--------
 2 files changed, 13 insertions(+), 8 deletions(-)

diff -puN include/linux/hugetlb.h~hugetlb-allow-arch-overried-hugepage-allocation include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-allow-arch-overried-hugepage-allocation
+++ a/include/linux/hugetlb.h
@@ -39,6 +39,7 @@ void hugetlb_unreserve_pages(struct inod
 extern unsigned long hugepages_treat_as_movable;
 extern const unsigned long hugetlb_zero, hugetlb_infinity;
 extern int sysctl_hugetlb_shm_group;
+extern struct list_head huge_boot_pages;
 
 /* arch callbacks */
 
@@ -188,6 +189,14 @@ struct hstate {
 	char name[HSTATE_NAME_LEN];
 };
 
+struct huge_bootmem_page {
+	struct list_head list;
+	struct hstate *hstate;
+};
+
+/* arch callback */
+int __init alloc_bootmem_huge_page(struct hstate *h);
+
 void __init hugetlb_add_hstate(unsigned order);
 struct hstate *size_to_hstate(unsigned long size);
 
@@ -256,6 +265,7 @@ static inline struct hstate *page_hstate
 
 #else
 struct hstate {};
+#define alloc_bootmem_huge_page(h) NULL
 #define hstate_file(f) NULL
 #define hstate_vma(v) NULL
 #define hstate_inode(i) NULL
diff -puN mm/hugetlb.c~hugetlb-allow-arch-overried-hugepage-allocation mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-allow-arch-overried-hugepage-allocation
+++ a/mm/hugetlb.c
@@ -31,6 +31,8 @@ static int max_hstate;
 unsigned int default_hstate_idx;
 struct hstate hstates[HUGE_MAX_HSTATE];
 
+__initdata LIST_HEAD(huge_boot_pages);
+
 /* for command line parsing */
 static struct hstate * __initdata parsed_hstate;
 static unsigned long __initdata default_hstate_max_huge_pages;
@@ -925,14 +927,7 @@ static struct page *alloc_huge_page(stru
 	return page;
 }
 
-static __initdata LIST_HEAD(huge_boot_pages);
-
-struct huge_bootmem_page {
-	struct list_head list;
-	struct hstate *hstate;
-};
-
-static int __init alloc_bootmem_huge_page(struct hstate *h)
+__attribute__((weak)) int alloc_bootmem_huge_page(struct hstate *h)
 {
 	struct huge_bootmem_page *m;
 	int nr_nodes = nodes_weight(node_online_map);
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
x86-implement-pte_special.patch
x86-implement-pte_special-fix.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
x86-support-1gb-hugepages-with-get_user_pages_lockless.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-speculative-page-references-fix.patch
mm-speculative-page-references-fix-add_to_page_cache.patch
mm-speculative-page-references-fix-add_to_page_cache-fix.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
powerpc-implement-pte_special-update.patch
powerpc-lockless-get_user_pages.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
vmscan-move-isolate_lru_page-to-vmscanc-fix.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mlock-mlocked-pages-are-unevictable-fix-fix-munlock-page-table-walk-now-requires-mm.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

