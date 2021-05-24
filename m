Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36444C04FF3
	for <mm-commits@archiver.kernel.org>; Mon, 24 May 2021 22:16:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D5A66142C
	for <mm-commits@archiver.kernel.org>; Mon, 24 May 2021 22:16:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233912AbhEXWRl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 May 2021 18:17:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233869AbhEXWRk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 May 2021 18:17:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7C7E6142A;
        Mon, 24 May 2021 22:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621894571;
        bh=bqif5/GbwOD3/FeEPfthBj+84eaiDqEytW9qhDRoNaM=;
        h=Date:From:To:Subject:From;
        b=I1lC/3Y5yk4uE5WTigE0dwAeaf+cXMHlcbA2vkGsWXhUlGuN3IqMICeYt5AIR5cwQ
         a2n8iM+7v0gRnOXZuQc6bLEiHA6x1vWBRSOx5fG4Keavwgl8V2G2LlywKlEMnDkthE
         s9i3QH5rHu+78qQFZZFthDqfIZ7xfFoW4vna7NDs=
Date:   Mon, 24 May 2021 15:16:10 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, bsingharora@gmail.com, bskeggs@redhat.com,
        hch@lst.de, hughd@google.com, jgg@nvidia.com, jglisse@redhat.com,
        jhubbard@nvidia.com, mm-commits@vger.kernel.org, peterx@redhat.com,
        rcampbell@nvidia.com, willy@infradead.org
Subject:  + mm-rename-migrate_pgmap_owner.patch added to -mm tree
Message-ID: <20210524221610.HjpAxwNUU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rename migrate_pgmap_owner
has been added to the -mm tree.  Its filename is
     mm-rename-migrate_pgmap_owner.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rename-migrate_pgmap_owner.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rename-migrate_pgmap_owner.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2499,8 +2499,8 @@ static void migrate_vma_collect(struct m
 	 * that the registered device driver can skip invalidating device
 	 * private page mappings that won't be migrated.
 	 */
-	mmu_notifier_range_init_migrate(&range, 0, migrate->vma,
-		migrate->vma->vm_mm, migrate->start, migrate->end,
+	mmu_notifier_range_init_owner(&range, MMU_NOTIFY_MIGRATE, 0,
+		migrate->vma, migrate->vma->vm_mm, migrate->start, migrate->end,
 		migrate->pgmap_owner);
 	mmu_notifier_invalidate_range_start(&range);
 
@@ -3010,9 +3010,9 @@ void migrate_vma_pages(struct migrate_vm
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

mm-remove-special-swap-entry-functions.patch
mm-swapops-rework-swap-entry-manipulation-code.patch
mm-rmap-split-try_to_munlock-from-try_to_unmap.patch
mm-rmap-split-migration-into-its-own-function.patch
mm-rename-migrate_pgmap_owner.patch
mm-memoryc-allow-different-return-codes-for-copy_nonpresent_pte.patch
mm-device-exclusive-memory-access.patch
mm-selftests-for-exclusive-device-memory.patch
nouveau-svm-refactor-nouveau_range_fault.patch
nouveau-svm-implement-atomic-svm-access.patch

