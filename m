From: akpm@linux-foundation.org
Subject: [merged] iommu-amd-use-new-invalidate_range-mmu-notifier.patch
 removed from -mm tree
Date: Fri, 21 Nov 2014 12:33:27 -0800
Message-ID: <546fa197.qd5jX4lgtINoZCfQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57090 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaKUUd2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Nov 2014 15:33:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jroedel@suse.de, Jay.Cornwall@amd.com, Suravee.Suthikulpanit@amd.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, dwmw2@infradead.org, hughd@google.com, jbarnes@virtuousgeek.org, jglisse@redhat.com, jweiner@redhat.com, mgorman@suse.de, oded.gabbay@amd.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: iommu/amd: use new invalidate_range mmu-notifier
has been removed from the -mm tree.  Its filename was
     iommu-amd-use-new-invalidate_range-mmu-notifier.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Joerg Roedel <jroedel@suse.de>
Subject: iommu/amd: use new invalidate_range mmu-notifier

Make use of the new invalidate_range mmu_notifier call-back and remove =
the
old logic of assigning an empty page-table between invalidate_range_sta=
rt
and invalidate_range_end.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Tested-by: Oded Gabbay <oded.gabbay@amd.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: J=E9r=F4me Glisse <jglisse@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Jay Cornwall <Jay.Cornwall@amd.com>
Cc: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iommu/amd_iommu_v2.c |   61 ++++-----------------------------
 1 file changed, 9 insertions(+), 52 deletions(-)

diff -puN drivers/iommu/amd_iommu_v2.c~iommu-amd-use-new-invalidate_ran=
ge-mmu-notifier drivers/iommu/amd_iommu_v2.c
--- a/drivers/iommu/amd_iommu_v2.c~iommu-amd-use-new-invalidate_range-m=
mu-notifier
+++ a/drivers/iommu/amd_iommu_v2.c
@@ -92,13 +92,6 @@ static spinlock_t state_lock;
=20
 static struct workqueue_struct *iommu_wq;
=20
-/*
- * Empty page table - Used between
- * mmu_notifier_invalidate_range_start and
- * mmu_notifier_invalidate_range_end
- */
-static u64 *empty_page_table;
-
 static void free_pasid_states(struct device_state *dev_state);
=20
 static u16 device_id(struct pci_dev *pdev)
@@ -418,46 +411,21 @@ static void mn_invalidate_page(struct mm
 	__mn_flush_page(mn, address);
 }
=20
-static void mn_invalidate_range_start(struct mmu_notifier *mn,
-				      struct mm_struct *mm,
-				      unsigned long start, unsigned long end)
-{
-	struct pasid_state *pasid_state;
-	struct device_state *dev_state;
-	unsigned long flags;
-
-	pasid_state =3D mn_to_state(mn);
-	dev_state   =3D pasid_state->device_state;
-
-	spin_lock_irqsave(&pasid_state->lock, flags);
-	if (pasid_state->mmu_notifier_count =3D=3D 0) {
-		amd_iommu_domain_set_gcr3(dev_state->domain,
-					  pasid_state->pasid,
-					  __pa(empty_page_table));
-	}
-	pasid_state->mmu_notifier_count +=3D 1;
-	spin_unlock_irqrestore(&pasid_state->lock, flags);
-}
-
-static void mn_invalidate_range_end(struct mmu_notifier *mn,
-				    struct mm_struct *mm,
-				    unsigned long start, unsigned long end)
+static void mn_invalidate_range(struct mmu_notifier *mn,
+				struct mm_struct *mm,
+				unsigned long start, unsigned long end)
 {
 	struct pasid_state *pasid_state;
 	struct device_state *dev_state;
-	unsigned long flags;
=20
 	pasid_state =3D mn_to_state(mn);
 	dev_state   =3D pasid_state->device_state;
=20
-	spin_lock_irqsave(&pasid_state->lock, flags);
-	pasid_state->mmu_notifier_count -=3D 1;
-	if (pasid_state->mmu_notifier_count =3D=3D 0) {
-		amd_iommu_domain_set_gcr3(dev_state->domain,
-					  pasid_state->pasid,
-					  __pa(pasid_state->mm->pgd));
-	}
-	spin_unlock_irqrestore(&pasid_state->lock, flags);
+	if ((start ^ (end - 1)) < PAGE_SIZE)
+		amd_iommu_flush_page(dev_state->domain, pasid_state->pasid,
+				     start);
+	else
+		amd_iommu_flush_tlb(dev_state->domain, pasid_state->pasid);
 }
=20
 static void mn_release(struct mmu_notifier *mn, struct mm_struct *mm)
@@ -482,8 +450,7 @@ static struct mmu_notifier_ops iommu_mn
 	.release		=3D mn_release,
 	.clear_flush_young      =3D mn_clear_flush_young,
 	.invalidate_page        =3D mn_invalidate_page,
-	.invalidate_range_start =3D mn_invalidate_range_start,
-	.invalidate_range_end   =3D mn_invalidate_range_end,
+	.invalidate_range       =3D mn_invalidate_range,
 };
=20
 static void set_pri_tag_status(struct pasid_state *pasid_state,
@@ -954,18 +921,10 @@ static int __init amd_iommu_v2_init(void
 	if (iommu_wq =3D=3D NULL)
 		goto out;
=20
-	ret =3D -ENOMEM;
-	empty_page_table =3D (u64 *)get_zeroed_page(GFP_KERNEL);
-	if (empty_page_table =3D=3D NULL)
-		goto out_destroy_wq;
-
 	amd_iommu_register_ppr_notifier(&ppr_nb);
=20
 	return 0;
=20
-out_destroy_wq:
-	destroy_workqueue(iommu_wq);
-
 out:
 	return ret;
 }
@@ -999,8 +958,6 @@ static void __exit amd_iommu_v2_exit(voi
 	}
=20
 	destroy_workqueue(iommu_wq);
