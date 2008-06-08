From: akpm@linux-foundation.org
Subject: + mm-introduce-non-panic-alloc_bootmem.patch added to -mm tree
Date: Sun, 08 Jun 2008 12:11:43 -0700
Message-ID: <200806081911.m58JBhbw016152@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41992 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753902AbYFHTLs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:11:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, ak@suse.de


The patch titled
     mm: introduce non panic alloc_bootmem
has been added to the -mm tree.  Its filename is
     mm-introduce-non-panic-alloc_bootmem.patch

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
Subject: mm: introduce non panic alloc_bootmem
From: Nick Piggin <npiggin@suse.de>

Straight forward variant of the existing __alloc_bootmem_node, only
subsequent patch when allocating giant hugepages at boot -- don't want to
panic if we can't allocate as many as the user asked for.

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem.h |    4 ++++
 mm/bootmem.c            |   12 ++++++++++++
 2 files changed, 16 insertions(+)

diff -puN include/linux/bootmem.h~mm-introduce-non-panic-alloc_bootmem include/linux/bootmem.h
--- a/include/linux/bootmem.h~mm-introduce-non-panic-alloc_bootmem
+++ a/include/linux/bootmem.h
@@ -87,6 +87,10 @@ extern void *__alloc_bootmem_node(pg_dat
 				  unsigned long size,
 				  unsigned long align,
 				  unsigned long goal);
+extern void *__alloc_bootmem_node_nopanic(pg_data_t *pgdat,
+				  unsigned long size,
+				  unsigned long align,
+				  unsigned long goal);
 extern unsigned long init_bootmem_node(pg_data_t *pgdat,
 				       unsigned long freepfn,
 				       unsigned long startpfn,
diff -puN mm/bootmem.c~mm-introduce-non-panic-alloc_bootmem mm/bootmem.c
--- a/mm/bootmem.c~mm-introduce-non-panic-alloc_bootmem
+++ a/mm/bootmem.c
@@ -576,6 +576,18 @@ void * __init alloc_bootmem_section(unsi
 }
 #endif
 
+void * __init __alloc_bootmem_node_nopanic(pg_data_t *pgdat, unsigned long size,
+				   unsigned long align, unsigned long goal)
+{
+	void *ptr;
+
+	ptr = alloc_bootmem_core(pgdat->bdata, size, align, goal, 0);
+	if (ptr)
+		return ptr;
+
+	return __alloc_bootmem_nopanic(size, align, goal);
+}
+
 #ifndef ARCH_LOW_ADDRESS_LIMIT
 #define ARCH_LOW_ADDRESS_LIMIT	0xffffffffUL
 #endif
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

