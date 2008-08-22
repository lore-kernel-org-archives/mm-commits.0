From: akpm@linux-foundation.org
Subject: + hugetlb-handle-updating-of-accessed-and-dirty-in-hugetlb_fault.patch added to -mm tree
Date: Fri, 22 Aug 2008 13:51:33 -0700
Message-ID: <200808222051.m7MKpYiX015925@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758592AbYHVU5s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Aug 2008 16:57:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david@gibson.dropbear.id.au, agl@us.ibm.com, hugh@veritas.com, wli@holomorphy.com


The patch titled
     hugetlb: handle updating of ACCESSED and DIRTY in hugetlb_fault()
has been added to the -mm tree.  Its filename is
     hugetlb-handle-updating-of-accessed-and-dirty-in-hugetlb_fault.patch

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
Subject: hugetlb: handle updating of ACCESSED and DIRTY in hugetlb_fault()
From: David Gibson <david@gibson.dropbear.id.au>

The page fault path for normal pages, if the fault is neither a no-page
fault nor a write-protect fault, will update the DIRTY and ACCESSED bits
in the page table appropriately.

The hugepage fault path, however, does not do this, handling only no-page
or write-protect type faults.  It assumes that either the ACCESSED and
DIRTY bits are irrelevant for hugepages (usually true, since they are
never swapped) or that they are handled by the arch code.

This is inconvenient for some software-loaded TLB architectures, where the
_PAGE_ACCESSED (_PAGE_DIRTY) bits need to be set to enable read (write)
access to the page at the TLB miss.  This could be worked around in the
arch TLB miss code, but the TLB miss fast path can be made simple more
easily if the hugetlb_fault() path handles this, as the normal page fault
path does.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Adam Litke <agl@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-handle-updating-of-accessed-and-dirty-in-hugetlb_fault mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-handle-updating-of-accessed-and-dirty-in-hugetlb_fault
+++ a/mm/hugetlb.c
@@ -2008,7 +2008,7 @@ int hugetlb_fault(struct mm_struct *mm, 
 	entry = huge_ptep_get(ptep);
 	if (huge_pte_none(entry)) {
 		ret = hugetlb_no_page(mm, vma, address, ptep, write_access);
-		goto out_unlock;
+		goto out_mutex;
 	}
 
 	ret = 0;
@@ -2024,7 +2024,7 @@ int hugetlb_fault(struct mm_struct *mm, 
 	if (write_access && !pte_write(entry)) {
 		if (vma_needs_reservation(h, vma, address) < 0) {
 			ret = VM_FAULT_OOM;
-			goto out_unlock;
+			goto out_mutex;
 		}
 
 		if (!(vma->vm_flags & VM_SHARED))
@@ -2034,10 +2034,23 @@ int hugetlb_fault(struct mm_struct *mm, 
 
 	spin_lock(&mm->page_table_lock);
 	/* Check for a racing update before calling hugetlb_cow */
-	if (likely(pte_same(entry, huge_ptep_get(ptep))))
-		if (write_access && !pte_write(entry))
+	if (unlikely(!pte_same(entry, huge_ptep_get(ptep))))
+		goto out_page_table_lock;
+
+
+	if (write_access) {
+		if (!pte_write(entry)) {
 			ret = hugetlb_cow(mm, vma, address, ptep, entry,
 							pagecache_page);
+			goto out_page_table_lock;
+		}
+		entry = pte_mkdirty(entry);
+	}
+	entry = pte_mkyoung(entry);
+	if (huge_ptep_set_access_flags(vma, address, ptep, entry, write_access))
+		update_mmu_cache(vma, address, entry);
+
+out_page_table_lock:
 	spin_unlock(&mm->page_table_lock);
 
 	if (pagecache_page) {
@@ -2045,7 +2058,7 @@ int hugetlb_fault(struct mm_struct *mm, 
 		put_page(pagecache_page);
 	}
 
-out_unlock:
+out_mutex:
 	mutex_unlock(&hugetlb_instantiation_mutex);
 
 	return ret;
_

Patches currently in -mm which might be from david@gibson.dropbear.id.au are

linux-next.patch
hugetlb-handle-updating-of-accessed-and-dirty-in-hugetlb_fault.patch

