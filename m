From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix.patch removed
 from -mm tree
Date: Thu, 16 Jun 2016 15:05:02 -0700
Message-ID: <5763228e.OxtI78kQHonkjytr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38107 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbcFPWFD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2016 18:05:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, ebru.akagunduz@gmail.com, hughd@google.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix
has been removed from the -mm tree.  Its filename was
     mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix.patch

This patch was dropped because it was folded into mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix

Passing 'vma' to hugepage_vma_revlidate() is useless.  It doesn't make use
of it anyway.

Link: http://lkml.kernel.org/r/20160530095058.GA53044@black.fi.intel.com

Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix
+++ a/mm/huge_memory.c
@@ -2385,10 +2385,9 @@ static bool hugepage_vma_check(struct vm
  * value (scan code).
  */
 
-static int hugepage_vma_revalidate(struct mm_struct *mm,
-				   struct vm_area_struct *vma,
-				   unsigned long address)
+static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address)
 {
+	struct vm_area_struct *vma;
 	unsigned long hstart, hend;
 
 	if (unlikely(khugepaged_test_exit(mm)))
@@ -2437,7 +2436,7 @@ static bool __collapse_huge_page_swapin(
 		if (ret & VM_FAULT_RETRY) {
 			down_read(&mm->mmap_sem);
 			/* vma is no longer available, don't continue to swapin */
-			if (hugepage_vma_revalidate(mm, vma, address))
+			if (hugepage_vma_revalidate(mm, address))
 				return false;
 		}
 		if (ret & VM_FAULT_ERROR) {
@@ -2491,7 +2490,7 @@ static void collapse_huge_page(struct mm
 	swap = get_mm_counter(mm, MM_SWAPENTS);
 	curr_allocstall = sum_vm_event(ALLOCSTALL);
 	down_read(&mm->mmap_sem);
-	result = hugepage_vma_revalidate(mm, vma, address);
+	result = hugepage_vma_revalidate(mm, address);
 	if (result)
 		goto out;
 
@@ -2524,7 +2523,7 @@ static void collapse_huge_page(struct mm
 	 * handled by the anon_vma lock + PG_lock.
 	 */
 	down_write(&mm->mmap_sem);
-	result = hugepage_vma_revalidate(mm, vma, address);
+	result = hugepage_vma_revalidate(mm, address);
 	if (result)
 		goto out;
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

revert-mm-make-faultaround-produce-old-ptes.patch
revert-mm-disable-fault-around-on-emulated-access-bit-architecture.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem.patch

