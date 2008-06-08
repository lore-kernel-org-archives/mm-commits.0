From: akpm@linux-foundation.org
Subject: + hugetlb-allow-arch-overried-hugepage-allocation.patch added to -mm tree
Date: Sun, 08 Jun 2008 12:12:07 -0700
Message-ID: <200806081912.m58JC7CL016198@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754511AbYFHTMn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:12:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, agl@us.ibm.com, kniht@linux.vnet.ibm.com


The patch titled
     hugetlb: allow arch overried hugepage allocation
has been added to the -mm tree.  Its filename is
     hugetlb-allow-arch-overried-hugepage-allocation.patch

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
Subject: hugetlb: allow arch overried hugepage allocation
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
@@ -849,14 +851,7 @@ static struct page *alloc_huge_page(stru
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

hugetlb-fix-lockdep-error.patch
vt-fix-vc_resize-locking.patch
linux-next.patch
spufs-convert-nopfn-to-fault.patch
mspec-convert-nopfn-to-fault.patch
mspec-convert-nopfn-to-fault-fix.patch
mm-remove-nopfn.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-build-fix.patch
hugetlb-factor-out-prep_new_huge_page.patch
hugetlb-modular-state-for-hugetlb-page-size.patch
hugetlb-modular-state-for-hugetlb-page-size-checkpatch-fixes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes-checkpatch-fixes.patch
hugetlbfs-per-mount-huge-page-sizes.patch
hugetlb-new-sysfs-interface.patch
hugetlb-abstract-numa-round-robin-selection.patch
mm-introduce-non-panic-alloc_bootmem.patch
mm-export-prep_compound_page-to-mm.patch
hugetlb-support-larger-than-max_order.patch
hugetlb-support-boot-allocate-different-sizes.patch
hugetlb-printk-cleanup.patch
hugetlb-introduce-pud_huge.patch
x86-support-gb-hugepages-on-64-bit.patch
x86-add-hugepagesz-option-on-64-bit.patch
hugetlb-override-default-huge-page-size.patch
hugetlb-allow-arch-overried-hugepage-allocation.patch
powerpc-function-to-allocate-gigantic-hugepages.patch
powerpc-scan-device-tree-for-gigantic-pages.patch
powerpc-define-support-for-16g-hugepages.patch
fs-check-for-statfs-overflow.patch
powerpc-support-multiple-hugepage-sizes.patch
x86-implement-pte_special.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
powerpc-lockless-get_user_pages_fast.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
vmscan-mlocked-pages-are-non-reclaimable.patch
vmscan-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-mlocked-pages-statistics.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

