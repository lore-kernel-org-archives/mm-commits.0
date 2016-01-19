From: akpm@linux-foundation.org
Subject: [merged] s390-mm-enable-fixup_user_fault-retrying.patch removed
 from -mm tree
Date: Tue, 19 Jan 2016 12:13:58 -0800
Message-ID: <569e9906.JaWOro5toq+DbYfM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44407 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933143AbcASUN7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:13:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dingel@linux.vnet.ibm.com, aarcange@redhat.com, borntraeger@de.ibm.com, emunson@akamai.com, heiko.carstens@de.ibm.com, jjherne@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, n-horiguchi@ah.jp.nec.com, pbonzini@redhat.com, rientjes@google.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: s390/mm: enable fixup_user_fault retrying
has been removed from the -mm tree.  Its filename was
     s390-mm-enable-fixup_user_fault-retrying.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dominik Dingel <dingel@linux.vnet.ibm.com>
Subject: s390/mm: enable fixup_user_fault retrying

By passing a non-null flag we allow fixup_user_fault to retry, which
enables userfaultfd.  As during these retries we might drop the mmap_sem
we need to check if that happened and redo the complete chain of actions.

Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: "Jason J. Herne" <jjherne@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric B Munson <emunson@akamai.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Dominik Dingel <dingel@linux.vnet.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/pgtable.c |   29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff -puN arch/s390/mm/pgtable.c~s390-mm-enable-fixup_user_fault-retrying arch/s390/mm/pgtable.c
--- a/arch/s390/mm/pgtable.c~s390-mm-enable-fixup_user_fault-retrying
+++ a/arch/s390/mm/pgtable.c
@@ -578,17 +578,29 @@ int gmap_fault(struct gmap *gmap, unsign
 {
 	unsigned long vmaddr;
 	int rc;
+	bool unlocked;
 
 	down_read(&gmap->mm->mmap_sem);
+
+retry:
+	unlocked = false;
 	vmaddr = __gmap_translate(gmap, gaddr);
 	if (IS_ERR_VALUE(vmaddr)) {
 		rc = vmaddr;
 		goto out_up;
 	}
-	if (fixup_user_fault(current, gmap->mm, vmaddr, fault_flags, NULL)) {
+	if (fixup_user_fault(current, gmap->mm, vmaddr, fault_flags,
+			     &unlocked)) {
 		rc = -EFAULT;
 		goto out_up;
 	}
+	/*
+	 * In the case that fixup_user_fault unlocked the mmap_sem during
+	 * faultin redo __gmap_translate to not race with a map/unmap_segment.
+	 */
+	if (unlocked)
+		goto retry;
+
 	rc = __gmap_link(gmap, gaddr, vmaddr);
 out_up:
 	up_read(&gmap->mm->mmap_sem);
@@ -714,12 +726,14 @@ int gmap_ipte_notify(struct gmap *gmap,
 	spinlock_t *ptl;
 	pte_t *ptep, entry;
 	pgste_t pgste;
+	bool unlocked;
 	int rc = 0;
 
 	if ((gaddr & ~PAGE_MASK) || (len & ~PAGE_MASK))
 		return -EINVAL;
 	down_read(&gmap->mm->mmap_sem);
 	while (len) {
+		unlocked = false;
 		/* Convert gmap address and connect the page tables */
 		addr = __gmap_translate(gmap, gaddr);
 		if (IS_ERR_VALUE(addr)) {
@@ -728,10 +742,13 @@ int gmap_ipte_notify(struct gmap *gmap,
 		}
 		/* Get the page mapped */
 		if (fixup_user_fault(current, gmap->mm, addr, FAULT_FLAG_WRITE,
-				     NULL)) {
+				     &unlocked)) {
 			rc = -EFAULT;
 			break;
 		}
+		/* While trying to map mmap_sem got unlocked. Let us retry */
+		if (unlocked)
+			continue;
 		rc = __gmap_link(gmap, gaddr, addr);
 		if (rc)
 			break;
@@ -792,9 +809,11 @@ int set_guest_storage_key(struct mm_stru
 	spinlock_t *ptl;
 	pgste_t old, new;
 	pte_t *ptep;
+	bool unlocked;
 
 	down_read(&mm->mmap_sem);
 retry:
+	unlocked = false;
 	ptep = get_locked_pte(mm, addr, &ptl);
 	if (unlikely(!ptep)) {
 		up_read(&mm->mmap_sem);
@@ -803,8 +822,12 @@ retry:
 	if (!(pte_val(*ptep) & _PAGE_INVALID) &&
 	     (pte_val(*ptep) & _PAGE_PROTECT)) {
 		pte_unmap_unlock(ptep, ptl);
+		/*
+		 * We do not really care about unlocked. We will retry either
+		 * way. But this allows fixup_user_fault to enable userfaultfd.
+		 */
 		if (fixup_user_fault(current, mm, addr, FAULT_FLAG_WRITE,
-				     NULL)) {
+				     &unlocked)) {
 			up_read(&mm->mmap_sem);
 			return -EFAULT;
 		}
_

Patches currently in -mm which might be from dingel@linux.vnet.ibm.com are


