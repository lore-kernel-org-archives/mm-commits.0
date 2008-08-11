From: akpm@linux-foundation.org
Subject: + allocate-structures-for-reservation-tracking-in-hugetlbfs-outside-of-spinlocks-v2.patch added to -mm tree
Date: Mon, 11 Aug 2008 15:52:48 -0700
Message-ID: <200808112252.m7BMqm0B026176@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56620 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751968AbYHKWxI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 18:53:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, gerald.schaefer@de.ibm.com, mel@csn.ul.ie


The patch titled
     allocate structures for reservation tracking in hugetlbfs outside of spinlocks v2
has been added to the -mm tree.  Its filename is
     allocate-structures-for-reservation-tracking-in-hugetlbfs-outside-of-spinlocks-v2.patch

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
Subject: allocate structures for reservation tracking in hugetlbfs outside of spinlocks v2
From: Andy Whitcroft <apw@shadowen.org>

[Andrew this should replace the previous version which did not check
the returns from the region prepare for errors.  This has been tested by
us and Gerald and it looks good.

Bah, while reviewing the locking based on your previous email I spotted
that we need to check the return from the vma_needs_reservation call for
allocation errors.  Here is an updated patch to correct this.  This passes
testing here.]

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Tested-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN mm/hugetlb.c~allocate-structures-for-reservation-tracking-in-hugetlbfs-outside-of-spinlocks-v2 mm/hugetlb.c
--- a/mm/hugetlb.c~allocate-structures-for-reservation-tracking-in-hugetlbfs-outside-of-spinlocks-v2
+++ a/mm/hugetlb.c
@@ -1949,7 +1949,10 @@ retry:
 	 * the spinlock.
 	 */
 	if (write_access && !(vma->vm_flags & VM_SHARED))
-		vma_needs_reservation(h, vma, address);
+		if (vma_needs_reservation(h, vma, address) < 0) {
+			ret = VM_FAULT_OOM;
+			goto backout_unlocked;
+		}
 
 	spin_lock(&mm->page_table_lock);
 	size = i_size_read(mapping->host) >> huge_page_shift(h);
@@ -1976,6 +1979,7 @@ out:
 
 backout:
 	spin_unlock(&mm->page_table_lock);
+backout_unlocked:
 	unlock_page(page);
 	put_page(page);
 	goto out;
@@ -2004,8 +2008,7 @@ int hugetlb_fault(struct mm_struct *mm, 
 	entry = huge_ptep_get(ptep);
 	if (huge_pte_none(entry)) {
 		ret = hugetlb_no_page(mm, vma, address, ptep, write_access);
-		mutex_unlock(&hugetlb_instantiation_mutex);
-		return ret;
+		goto out_unlock;
 	}
 
 	ret = 0;
@@ -2019,7 +2022,10 @@ int hugetlb_fault(struct mm_struct *mm, 
 	 * consumed.
 	 */
 	if (write_access && !pte_write(entry)) {
-		vma_needs_reservation(h, vma, address);
+		if (vma_needs_reservation(h, vma, address) < 0) {
+			ret = VM_FAULT_OOM;
+			goto out_unlock;
+		}
 
 		if (!(vma->vm_flags & VM_SHARED))
 			pagecache_page = hugetlbfs_pagecache_page(h,
@@ -2039,6 +2045,7 @@ int hugetlb_fault(struct mm_struct *mm, 
 		put_page(pagecache_page);
 	}
 
+out_unlock:
 	mutex_unlock(&hugetlb_instantiation_mutex);
 
 	return ret;
_

Patches currently in -mm which might be from apw@shadowen.org are

hugetlbfs-allocate-structures-for-reservation-tracking-outside-of-spinlocks.patch
allocate-structures-for-reservation-tracking-in-hugetlbfs-outside-of-spinlocks-v2.patch
page-owner-tracking-leak-detector.patch

