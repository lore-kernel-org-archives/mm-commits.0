From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-hmm-mirror-mirror-process-address-space-on-device-with-hmm-helpers-v3-fix.patch removed from -mm tree
Date: Fri, 08 Sep 2017 15:56:49 -0700
Message-ID: <59b32031.KBzOQS0Ie7TyAcAy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47894 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752952AbdIHW4v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 18:56:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jglisse@redhat.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hmm-mirror-mirror-process-address-space-on-device-with-hmm-helpers-v3-fix
has been removed from the -mm tree.  Its filename was
     mm-hmm-mirror-mirror-process-address-space-on-device-with-hmm-helpers-v3-fix.patch

This patch was dropped because it was folded into mm-hmm-mirror-mirror-process-address-space-on-device-with-hmm-helpers-v3.patch

------------------------------------------------------
From: Jerome Glisse <jglisse@redhat.com>
Subject: mm-hmm-mirror-mirror-process-address-space-on-device-with-hmm-helpers-v3-fix

fix hmm for "mmu_notifier kill invalidate_page callback"

Link: http://lkml.kernel.org/r/20170830231955.GD9445@redhat.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hmm.c |   15 ---------------
 1 file changed, 15 deletions(-)

diff -puN mm/hmm.c~mm-hmm-mirror-mirror-process-address-space-on-device-with-hmm-helpers-v3-fix mm/hmm.c
--- a/mm/hmm.c~mm-hmm-mirror-mirror-process-address-space-on-device-with-hmm-helpers-v3-fix
+++ a/mm/hmm.c
@@ -120,20 +120,6 @@ static void hmm_invalidate_range(struct
 	up_read(&hmm->mirrors_sem);
 }
 
-static void hmm_invalidate_page(struct mmu_notifier *mn,
-				struct mm_struct *mm,
-				unsigned long addr)
-{
-	unsigned long start = addr & PAGE_MASK;
-	unsigned long end = start + PAGE_SIZE;
-	struct hmm *hmm = mm->hmm;
-
-	VM_BUG_ON(!hmm);
-
-	atomic_inc(&hmm->sequence);
-	hmm_invalidate_range(mm->hmm, HMM_UPDATE_INVALIDATE, start, end);
-}
-
 static void hmm_invalidate_range_start(struct mmu_notifier *mn,
 				       struct mm_struct *mm,
 				       unsigned long start,
@@ -159,7 +145,6 @@ static void hmm_invalidate_range_end(str
 }
 
 static const struct mmu_notifier_ops hmm_mmu_notifier_ops = {
-	.invalidate_page	= hmm_invalidate_page,
 	.invalidate_range_start	= hmm_invalidate_range_start,
 	.invalidate_range_end	= hmm_invalidate_range_end,
 };
_

Patches currently in -mm which might be from jglisse@redhat.com are

hmm-heterogeneous-memory-management-documentation-v3.patch
mm-hmm-heterogeneous-memory-management-hmm-for-short-v5.patch
mm-hmm-mirror-mirror-process-address-space-on-device-with-hmm-helpers-v3.patch
mm-hmm-mirror-helper-to-snapshot-cpu-page-table-v4.patch
mm-hmm-mirror-device-page-fault-handler.patch
mm-zone_device-new-type-of-zone_device-for-unaddressable-memory-v5.patch
mm-zone_device-special-case-put_page-for-device-private-pages-v4.patch
mm-memcontrol-allow-to-uncharge-page-without-using-page-lru-field.patch
mm-memcontrol-support-memory_device_private-v4.patch
mm-hmm-devmem-device-memory-hotplug-using-zone_device-v7.patch
mm-hmm-devmem-dummy-hmm-device-for-zone_device-memory-v3.patch
mm-migrate-new-migrate-mode-migrate_sync_no_copy.patch
mm-migrate-new-memory-migration-helper-for-use-with-device-memory-v5.patch
mm-migrate-migrate_vma-unmap-page-from-vma-while-collecting-pages.patch
mm-migrate-support-un-addressable-zone_device-page-in-migration-v3.patch
mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry-v4.patch
mm-device-public-memory-device-memory-cache-coherent-with-cpu-v5.patch
mm-hmm-add-new-helper-to-hotplug-cdm-memory-region-v3.patch
mm-hmm-avoid-bloating-arch-that-do-not-make-use-of-hmm.patch
mm-hmm-struct-hmm-is-only-use-by-hmm-mirror-functionality-v2.patch
mm-hmm-fix-build-when-hmm-is-disabled.patch
lib-interval_tree-fast-overlap-detection-fix.patch

