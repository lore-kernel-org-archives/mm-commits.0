Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 590C0C48BD1
	for <mm-commits@archiver.kernel.org>; Thu, 10 Jun 2021 22:16:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 424836142F
	for <mm-commits@archiver.kernel.org>; Thu, 10 Jun 2021 22:16:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhFJWSU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Jun 2021 18:18:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230248AbhFJWST (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 10 Jun 2021 18:18:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB28761403;
        Thu, 10 Jun 2021 22:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623363369;
        bh=YvqvxWhNSMf8nHdiFeI98Od3PgIwXzo78YoddNi/eHM=;
        h=Date:From:To:Subject:From;
        b=vnsUBeZ9xwZ/Bm+ZP8pbKiiUFB59aXQfPOtuuMKATOy2KXK22yV2ufwZ4UiH5wJYF
         neY6QyuB94dd/vMGtFBkQVz4WjnWomhIbhMgapt1Sxq3bKGR66QRFa/1xvI96ilyZk
         AoCAp8o7WATSRqNgdevPSlWAQ6eY+/lSBYdG8/2k=
Date:   Thu, 10 Jun 2021 15:16:08 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, bsingharora@gmail.com, bskeggs@redhat.com,
        hch@lst.de, hughd@google.com, jgg@nvidia.com, jglisse@redhat.com,
        jhubbard@nvidia.com, mm-commits@vger.kernel.org, peterx@redhat.com,
        rcampbell@nvidia.com, willy@infradead.org
Subject:  [to-be-updated] mm-rename-migrate_pgmap_owner.patch
 removed from -mm tree
Message-ID: <20210610221608.mW3-5hSAz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rename migrate_pgmap_owner
has been removed from the -mm tree.  Its filename was
     mm-rename-migrate_pgmap_owner.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm: rename migrate_pgmap_owner

MMU notifier ranges have a migrate_pgmap_owner field which is used by
drivers to store a pointer.  This is subsequently used by the driver
callback to filter MMU_NOTIFY_MIGRATE events.  Other notifier event types
can also benefit from this filtering, so rename the 'migrate_pgmap_owner'
field to 'owner' and create a new notifier initialisation function to
initialise this field.

Link: https://lkml.kernel.org/r/20210524132725.12697-6-apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Suggested-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/hmm.rst              |    2 +-
 drivers/gpu/drm/nouveau/nouveau_svm.c |    2 +-
 include/linux/mmu_notifier.h          |   20 ++++++++++----------
 lib/test_hmm.c                        |    2 +-
 mm/migrate.c                          |   10 +++++-----
 5 files changed, 18 insertions(+), 18 deletions(-)

--- a/Documentation/vm/hmm.rst~mm-rename-migrate_pgmap_owner
+++ a/Documentation/vm/hmm.rst
@@ -332,7 +332,7 @@ between device driver specific code and
    walks to fill in the ``args->src`` array with PFNs to be migrated.
    The ``invalidate_range_start()`` callback is passed a
    ``struct mmu_notifier_range`` with the ``event`` field set to
-   ``MMU_NOTIFY_MIGRATE`` and the ``migrate_pgmap_owner`` field set to
+   ``MMU_NOTIFY_MIGRATE`` and the ``owner`` field set to
    the ``args->pgmap_owner`` field passed to migrate_vma_setup(). This is
    allows the device driver to skip the invalidation callback and only
    invalidate device private MMU mappings that are actually migrating.
--- a/drivers/gpu/drm/nouveau/nouveau_svm.c~mm-rename-migrate_pgmap_owner
+++ a/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -265,7 +265,7 @@ nouveau_svmm_invalidate_range_start(stru
 	 * the invalidation is handled as part of the migration process.
 	 */
 	if (update->event == MMU_NOTIFY_MIGRATE &&
-	    update->migrate_pgmap_owner == svmm->vmm->cli->drm->dev)
+	    update->owner == svmm->vmm->cli->drm->dev)
 		goto out;
 
 	if (limit > svmm->unmanaged.start && start < svmm->unmanaged.limit) {
--- a/include/linux/mmu_notifier.h~mm-rename-migrate_pgmap_owner
+++ a/include/linux/mmu_notifier.h
@@ -41,7 +41,7 @@ struct mmu_interval_notifier;
  *
  * @MMU_NOTIFY_MIGRATE: used during migrate_vma_collect() invalidate to signal
  * a device driver to possibly ignore the invalidation if the
- * migrate_pgmap_owner field matches the driver's device private pgmap owner.
+ * owner field matches the driver's device private pgmap owner.
  */
 enum mmu_notifier_event {
 	MMU_NOTIFY_UNMAP = 0,
@@ -269,7 +269,7 @@ struct mmu_notifier_range {
 	unsigned long end;
 	unsigned flags;
 	enum mmu_notifier_event event;
-	void *migrate_pgmap_owner;
+	void *owner;
 };
 
 static inline int mm_has_notifiers(struct mm_struct *mm)
@@ -521,14 +521,14 @@ static inline void mmu_notifier_range_in
 	range->flags = flags;
 }
 
-static inline void mmu_notifier_range_init_migrate(
-			struct mmu_notifier_range *range, unsigned int flags,
+static inline void mmu_notifier_range_init_owner(
+			struct mmu_notifier_range *range,
+			enum mmu_notifier_event event, unsigned int flags,
 			struct vm_area_struct *vma, struct mm_struct *mm,
-			unsigned long start, unsigned long end, void *pgmap)
+			unsigned long start, unsigned long end, void *owner)
 {
-	mmu_notifier_range_init(range, MMU_NOTIFY_MIGRATE, flags, vma, mm,
-				start, end);
-	range->migrate_pgmap_owner = pgmap;
+	mmu_notifier_range_init(range, event, flags, vma, mm, start, end);
+	range->owner = owner;
 }
 
 #define ptep_clear_flush_young_notify(__vma, __address, __ptep)		\
@@ -655,8 +655,8 @@ static inline void _mmu_notifier_range_i
 
 #define mmu_notifier_range_init(range,event,flags,vma,mm,start,end)  \
 	_mmu_notifier_range_init(range, start, end)
-#define mmu_notifier_range_init_migrate(range, flags, vma, mm, start, end, \
-					pgmap) \
+#define mmu_notifier_range_init_owner(range, event, flags, vma, mm, start, \
+					end, owner) \
 	_mmu_notifier_range_init(range, start, end)
 
 static inline bool
--- a/lib/test_hmm.c~mm-rename-migrate_pgmap_owner
+++ a/lib/test_hmm.c
@@ -218,7 +218,7 @@ static bool dmirror_interval_invalidate(
 	 * the invalidation is handled as part of the migration process.
 	 */
 	if (range->event == MMU_NOTIFY_MIGRATE &&
-	    range->migrate_pgmap_owner == dmirror->mdevice)
+	    range->owner == dmirror->mdevice)
 		return true;
 
 	if (mmu_notifier_range_blockable(range))
--- a/mm/migrate.c~mm-rename-migrate_pgmap_owner
+++ a/mm/migrate.c
@@ -2526,8 +2526,8 @@ static void migrate_vma_collect(struct m
 	 * that the registered device driver can skip invalidating device
 	 * private page mappings that won't be migrated.
 	 */
-	mmu_notifier_range_init_migrate(&range, 0, migrate->vma,
-		migrate->vma->vm_mm, migrate->start, migrate->end,
+	mmu_notifier_range_init_owner(&range, MMU_NOTIFY_MIGRATE, 0,
+		migrate->vma, migrate->vma->vm_mm, migrate->start, migrate->end,
 		migrate->pgmap_owner);
 	mmu_notifier_invalidate_range_start(&range);
 
@@ -3037,9 +3037,9 @@ void migrate_vma_pages(struct migrate_vm
 			if (!notified) {
 				notified = true;
 
-				mmu_notifier_range_init_migrate(&range, 0,
-					migrate->vma, migrate->vma->vm_mm,
-					addr, migrate->end,
+				mmu_notifier_range_init_owner(&range,
+					MMU_NOTIFY_MIGRATE, 0, migrate->vma,
+					migrate->vma->vm_mm, addr, migrate->end,
 					migrate->pgmap_owner);
 				mmu_notifier_invalidate_range_start(&range);
 			}
_

Patches currently in -mm which might be from apopple@nvidia.com are

mm-memoryc-allow-different-return-codes-for-copy_nonpresent_pte.patch
mm-device-exclusive-memory-access.patch
mm-selftests-for-exclusive-device-memory.patch
nouveau-svm-refactor-nouveau_range_fault.patch
nouveau-svm-implement-atomic-svm-access.patch

