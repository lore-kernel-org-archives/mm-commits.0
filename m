From: akpm@linux-foundation.org
Subject: + iommu-amd-use-handle_mm_fault-directly-v2.patch added to -mm
 tree
Date: Thu, 13 Nov 2014 13:58:27 -0800
Message-ID: <54652983.T/MXKn98jVwoUymq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40698 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934261AbaKMV62 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Nov 2014 16:58:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbarnes@virtuousgeek.org, jroedel@suse.de, oded.gabbay@amd.com, mm-commits@vger.kernel.org


The patch titled
     Subject: iommu/amd: use handle_mm_fault directly
has been added to the -mm tree.  Its filename is
     iommu-amd-use-handle_mm_fault-directly-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/iommu-amd-use-handle_mm_fault-directly-v2.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/iommu-amd-use-handle_mm_fault-directly-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: iommu/amd: use handle_mm_fault directly

This could be useful for debug in the future if we want to track
major/minor faults more closely, and also avoids the put_page trick we
used with gup.

In order to do this, we also track the task struct in the PASID state
structure.  This lets us update the appropriate task stats after the fault
has been handled, and may aid with debug in the future as well.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Tested-by: Oded Gabbay <oded.gabbay@amd.com>
Cc: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iommu/amd_iommu_v2.c |   84 ++++++++++++++++++++-------------
 1 file changed, 53 insertions(+), 31 deletions(-)

diff -puN drivers/iommu/amd_iommu_v2.c~iommu-amd-use-handle_mm_fault-directly-v2 drivers/iommu/amd_iommu_v2.c
--- a/drivers/iommu/amd_iommu_v2.c~iommu-amd-use-handle_mm_fault-directly-v2
+++ a/drivers/iommu/amd_iommu_v2.c
@@ -480,45 +480,67 @@ static void finish_pri_tag(struct device
 	spin_unlock_irqrestore(&pasid_state->lock, flags);
 }
 
+static void handle_fault_error(struct fault *fault)
+{
+	int status;
+
+	if (!fault->dev_state->inv_ppr_cb) {
+		set_pri_tag_status(fault->state, fault->tag, PPR_INVALID);
+		return;
+	}
+
+	status = fault->dev_state->inv_ppr_cb(fault->dev_state->pdev,
+					      fault->pasid,
+					      fault->address,
+					      fault->flags);
+	switch (status) {
+	case AMD_IOMMU_INV_PRI_RSP_SUCCESS:
+		set_pri_tag_status(fault->state, fault->tag, PPR_SUCCESS);
+		break;
+	case AMD_IOMMU_INV_PRI_RSP_INVALID:
+		set_pri_tag_status(fault->state, fault->tag, PPR_INVALID);
+		break;
+	case AMD_IOMMU_INV_PRI_RSP_FAIL:
+		set_pri_tag_status(fault->state, fault->tag, PPR_FAILURE);
+		break;
+	default:
+		BUG();
+	}
+}
+
 static void do_fault(struct work_struct *work)
 {
 	struct fault *fault = container_of(work, struct fault, work);
-	int npages, write;
-	struct page *page;
+	struct mm_struct *mm;
+	struct vm_area_struct *vma;
+	u64 address;
+	int ret, write;
 
 	write = !!(fault->flags & PPR_FAULT_WRITE);
 
-	down_read(&fault->state->mm->mmap_sem);
-	npages = get_user_pages(NULL, fault->state->mm,
-				fault->address, 1, write, 0, &page, NULL);
-	up_read(&fault->state->mm->mmap_sem);
-
-	if (npages == 1) {
-		put_page(page);
-	} else if (fault->dev_state->inv_ppr_cb) {
-		int status;
-
-		status = fault->dev_state->inv_ppr_cb(fault->dev_state->pdev,
-						      fault->pasid,
-						      fault->address,
-						      fault->flags);
-		switch (status) {
-		case AMD_IOMMU_INV_PRI_RSP_SUCCESS:
-			set_pri_tag_status(fault->state, fault->tag, PPR_SUCCESS);
-			break;
-		case AMD_IOMMU_INV_PRI_RSP_INVALID:
-			set_pri_tag_status(fault->state, fault->tag, PPR_INVALID);
-			break;
-		case AMD_IOMMU_INV_PRI_RSP_FAIL:
-			set_pri_tag_status(fault->state, fault->tag, PPR_FAILURE);
-			break;
-		default:
-			BUG();
-		}
-	} else {
-		set_pri_tag_status(fault->state, fault->tag, PPR_INVALID);
+	mm = fault->state->mm;
+	address = fault->address;
+
+	down_read(&mm->mmap_sem);
+	vma = find_extend_vma(mm, address);
+	if (!vma || address < vma->vm_start) {
+		/* failed to get a vma in the right range */
+		up_read(&mm->mmap_sem);
+		handle_fault_error(fault);
+		goto out;
 	}
 
+	ret = handle_mm_fault(mm, vma, address, write);
+	if (ret & VM_FAULT_ERROR) {
+		/* failed to service fault */
+		up_read(&mm->mmap_sem);
+		handle_fault_error(fault);
+		goto out;
+	}
+
+	up_read(&mm->mmap_sem);
+
+out:
 	finish_pri_tag(fault->dev_state, fault->state, fault->tag);
 
 	put_pasid_state(fault->state);
_

Patches currently in -mm which might be from jbarnes@virtuousgeek.org are

mmu_notifier-add-mmu_notifier_invalidate_range.patch
mmu_notifier-call-mmu_notifier_invalidate_range-from-vmm.patch
mmu_notifier-add-the-call-back-for-mmu_notifier_invalidate_range.patch
iommu-amd-use-new-invalidate_range-mmu-notifier.patch
mm-export-find_extend_vma-and-handle_mm_fault-for-driver-use.patch
iommu-amd-use-handle_mm_fault-directly-v2.patch
linux-next.patch

