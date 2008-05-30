From: akpm@linux-foundation.org
Subject: + huge-page-private-reservation-review-cleanups.patch added to -mm tree
Date: Fri, 30 May 2008 13:29:15 -0700
Message-ID: <200805302029.m4UKTFhR009999@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35648 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753014AbYE3Uab (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 16:30:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, agl@us.ibm.com, hannes@saeurebad.de, hugh@veritas.com, mel@csn.ul.ie, mtk.manpages@googlemail.com, wli@holomorphy.com


The patch titled
     huge page private reservation review cleanups
has been added to the -mm tree.  Its filename is
     huge-page-private-reservation-review-cleanups.patch

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
Subject: huge page private reservation review cleanups
From: Andy Whitcroft <apw@shadowen.org>

Create some new accessors for vma private data to cut down on and contain
the casts.  Encapsulates the huge and small page offset calculations. 
Also adds a couple of VM_BUG_ONs for consistency.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Johannes Weiner <hannes@saeurebad.de>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   56 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 43 insertions(+), 13 deletions(-)

diff -puN mm/hugetlb.c~huge-page-private-reservation-review-cleanups mm/hugetlb.c
--- a/mm/hugetlb.c~huge-page-private-reservation-review-cleanups
+++ a/mm/hugetlb.c
@@ -40,6 +40,26 @@ static int hugetlb_next_nid;
  */
 static DEFINE_SPINLOCK(hugetlb_lock);
 
+/*
+ * Convert the address within this vma to the page offset within
+ * the mapping, in base page units.
+ */
+pgoff_t vma_page_offset(struct vm_area_struct *vma, unsigned long address)
+{
+	return ((address - vma->vm_start) >> PAGE_SHIFT) +
+					(vma->vm_pgoff >> PAGE_SHIFT);
+}
+
+/*
+ * Convert the address within this vma to the page offset within
+ * the mapping, in pagecache page units; huge pages here.
+ */
+pgoff_t vma_pagecache_offset(struct vm_area_struct *vma, unsigned long address)
+{
+	return ((address - vma->vm_start) >> HPAGE_SHIFT) +
+			(vma->vm_pgoff >> (HPAGE_SHIFT - PAGE_SHIFT));
+}
+
 #define HPAGE_RESV_OWNER    (1UL << (BITS_PER_LONG - 1))
 #define HPAGE_RESV_UNMAPPED (1UL << (BITS_PER_LONG - 2))
 #define HPAGE_RESV_MASK (HPAGE_RESV_OWNER | HPAGE_RESV_UNMAPPED)
@@ -53,36 +73,48 @@ static DEFINE_SPINLOCK(hugetlb_lock);
  * to reset the VMA at fork() time as it is not in use yet and there is no
  * chance of the global counters getting corrupted as a result of the values.
  */
+static unsigned long get_vma_private_data(struct vm_area_struct *vma)
+{
+	return (unsigned long)vma->vm_private_data;
+}
+
+static void set_vma_private_data(struct vm_area_struct *vma,
+							unsigned long value)
+{
+	vma->vm_private_data = (void *)value;
+}
+
 static unsigned long vma_resv_huge_pages(struct vm_area_struct *vma)
 {
 	VM_BUG_ON(!is_vm_hugetlb_page(vma));
 	if (!(vma->vm_flags & VM_SHARED))
-		return (unsigned long)vma->vm_private_data & ~HPAGE_RESV_MASK;
+		return get_vma_private_data(vma) & ~HPAGE_RESV_MASK;
 	return 0;
 }
 
 static void set_vma_resv_huge_pages(struct vm_area_struct *vma,
 							unsigned long reserve)
 {
-	unsigned long flags;
 	VM_BUG_ON(!is_vm_hugetlb_page(vma));
 	VM_BUG_ON(vma->vm_flags & VM_SHARED);
 
-	flags = (unsigned long)vma->vm_private_data & HPAGE_RESV_MASK;
-	vma->vm_private_data = (void *)(reserve | flags);
+	set_vma_private_data(vma,
+		(get_vma_private_data(vma) & HPAGE_RESV_MASK) | reserve);
 }
 
 static void set_vma_resv_flags(struct vm_area_struct *vma, unsigned long flags)
 {
-	unsigned long reserveflags = (unsigned long)vma->vm_private_data;
 	VM_BUG_ON(!is_vm_hugetlb_page(vma));
-	vma->vm_private_data = (void *)(reserveflags | flags);
+	VM_BUG_ON(vma->vm_flags & VM_SHARED);
+
+	set_vma_private_data(vma, get_vma_private_data(vma) | flags);
 }
 
 static int is_vma_resv_set(struct vm_area_struct *vma, unsigned long flag)
 {
 	VM_BUG_ON(!is_vm_hugetlb_page(vma));
-	return ((unsigned long)vma->vm_private_data & flag) != 0;
+
+	return (get_vma_private_data(vma) & flag) != 0;
 }
 
 /* Decrement the reserved pages in the hugepage pool by one */
@@ -1150,11 +1182,10 @@ static struct page *hugetlbfs_pagecache_
 			unsigned long address)
 {
 	struct address_space *mapping;
-	unsigned long idx;
+	pgoff_t idx;
 
 	mapping = vma->vm_file->f_mapping;
-	idx = ((address - vma->vm_start) >> HPAGE_SHIFT)
-		+ (vma->vm_pgoff >> (HPAGE_SHIFT - PAGE_SHIFT));
+	idx = vma_pagecache_offset(vma, address);
 
 	return find_lock_page(mapping, idx);
 }
@@ -1163,7 +1194,7 @@ static int hugetlb_no_page(struct mm_str
 			unsigned long address, pte_t *ptep, int write_access)
 {
 	int ret = VM_FAULT_SIGBUS;
-	unsigned long idx;
+	pgoff_t idx;
 	unsigned long size;
 	struct page *page;
 	struct address_space *mapping;
@@ -1182,8 +1213,7 @@ static int hugetlb_no_page(struct mm_str
 	}
 
 	mapping = vma->vm_file->f_mapping;
-	idx = ((address - vma->vm_start) >> HPAGE_SHIFT)
-		+ (vma->vm_pgoff >> (HPAGE_SHIFT - PAGE_SHIFT));
+	idx = vma_pagecache_offset(vma, address);
 
 	/*
 	 * Use page lock to guard against racing truncation
_

Patches currently in -mm which might be from apw@shadowen.org are

update-checkpatchpl-to-version-019.patch
update-checkpatchpl-to-version-019-fix.patch
linux-next.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation-fix.patch
mm-verify-the-page-links-and-memory-model.patch
mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage.patch
mm-print-out-the-zonelists-on-request-for-manual-verification.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch
buddy-clarify-comments-describing-buddy-merge.patch
page-flags-record-page-flag-overlays-explicitly.patch
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch
hugetlb-move-hugetlb_acct_memory.patch
hugetlb-reserve-huge-pages-for-reliable-map_private-hugetlbfs-mappings-until-fork.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-fix.patch
huge-page-private-reservation-review-cleanups.patch
mm-record-map_noreserve-status-on-vmas-and-fix-small-page-mprotect-reservations.patch
hugetlb-move-reservation-region-support-earlier.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations.patch
huge-page-map_noreserve-review-cleanups.patch
page-owner-tracking-leak-detector.patch

