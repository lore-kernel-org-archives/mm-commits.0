Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EB4CC11F68
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:54:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43AF36146D
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:54:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238532AbhGAB4t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:56:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238429AbhGAB4t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:56:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B605C61469;
        Thu,  1 Jul 2021 01:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104460;
        bh=vqaGm00wTqjI9ezwYLUFsDzCwVDvHVyGbUBbSFxL6fU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=cpliDzJ+tB4Mm6N0RaJuh70ZqbbObU3ysu5Dh/YstlDZA7KMnEXKim1tHpM+Wd34U
         8Sn8mATm2vr/DS8AOu4+kvAm8tW2LUgVcIUzCI1S7z60a3a+heBpLwHRbsm8GMmsKX
         v5jUjogjrbb5/BhNPK9mRJari9oTaE8LgPp5jDOg=
Date:   Wed, 30 Jun 2021 18:54:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, apopple@nvidia.com, bskeggs@redhat.com,
        hch@lst.de, hughd@google.com, jgg@nvidia.com, jhubbard@nvidia.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, peterx@redhat.com,
        rcampbell@nvidia.com, shakeelb@google.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 134/192] mm: rename migrate_pgmap_owner
Message-ID: <20210701015419.pNG4jYiLs%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Alistair Popple <apopple@nvidia.com>
Subject: mm: rename migrate_pgmap_owner

MMU notifier ranges have a migrate_pgmap_owner field which is used by
drivers to store a pointer.  This is subsequently used by the driver
callback to filter MMU_NOTIFY_MIGRATE events.  Other notifier event types
can also benefit from this filtering, so rename the 'migrate_pgmap_owner'
field to 'owner' and create a new notifier initialisation function to
initialise this field.

Link: https://lkml.kernel.org/r/20210616105937.23201-6-apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Suggested-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Shakeel Butt <shakeelb@google.com>
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
@@ -2416,8 +2416,8 @@ static void migrate_vma_collect(struct m
 	 * that the registered device driver can skip invalidating device
 	 * private page mappings that won't be migrated.
 	 */
-	mmu_notifier_range_init_migrate(&range, 0, migrate->vma,
-		migrate->vma->vm_mm, migrate->start, migrate->end,
+	mmu_notifier_range_init_owner(&range, MMU_NOTIFY_MIGRATE, 0,
+		migrate->vma, migrate->vma->vm_mm, migrate->start, migrate->end,
 		migrate->pgmap_owner);
 	mmu_notifier_invalidate_range_start(&range);
 
@@ -2927,9 +2927,9 @@ void migrate_vma_pages(struct migrate_vm
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
