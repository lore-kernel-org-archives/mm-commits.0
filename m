Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6F60C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 00:36:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DB0C2173E
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 00:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596760610;
	bh=OYwC3RFIeOV6IZ6zH7jzUQqE7fAwOvCpzkTPKKT/9wg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=OSQHjQa+031DEa67Z3rTOM491X7M33j55b0eyFcq1B518FKlW39sytDRLGBsxdNd9
	 KkhAmMTQUrUlbeHb7pH+O6AH9cfMgBfzID4IzPdFT8yjkvTM6u0xyoKSHWDFab6FrZ
	 nbUoYaL+IMgS8Cc3DrK5u33XR8H03KHt5ZeQ00ts=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgHGAgu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Aug 2020 20:36:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725998AbgHGAgt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 Aug 2020 20:36:49 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 841B2206B5;
        Fri,  7 Aug 2020 00:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596760608;
        bh=OYwC3RFIeOV6IZ6zH7jzUQqE7fAwOvCpzkTPKKT/9wg=;
        h=Date:From:To:Subject:From;
        b=uPh7LofHkAh+lWHRJb39hLxKRCr7TPf+Mn8JQUdfpj8up0V8tbs/nVnl9bGIQA7FP
         ug6vJoUPR3Pizo0pm4PSMceiegTt3qtsYGr6dAm3nBpKsnTXv21Z6k35CggwLVxtXv
         c0msuBMQcLOXYuXx2QcBYBZCIEu+TPsV97DnscG4=
Date:   Thu, 06 Aug 2020 17:36:47 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, jgg@mellanox.com, jglisse@redhat.com,
        jhubbard@nvidia.com, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com, rdunlap@infradead.org
Subject:  +
 mm-migrate-fix-migrate_pgmap_owner-w-o-config_mmu_notifier.patch added to
 -mm tree
Message-ID: <20200807003647.2kYmh8kVp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: fix migrate_pgmap_owner w/o CONFIG_MMU_NOTIFIER
has been added to the -mm tree.  Its filename is
     mm-migrate-fix-migrate_pgmap_owner-w-o-config_mmu_notifier.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-fix-migrate_pgmap_owner-w-o-config_mmu_notifier.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-fix-migrate_pgmap_owner-w-o-config_mmu_notifier.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm/migrate: fix migrate_pgmap_owner w/o CONFIG_MMU_NOTIFIER

On x86_64, when CONFIG_MMU_NOTIFIER is not set/enabled, there is a
compiler error:

../mm/migrate.c: In function 'migrate_vma_collect':
../mm/migrate.c:2481:7: error: 'struct mmu_notifier_range' has no member
named 'migrate_pgmap_owner'
  range.migrate_pgmap_owner = migrate->pgmap_owner;
       ^

Link: http://lkml.kernel.org/r/20200806193353.7124-1-rcampbell@nvidia.com
Fixes: 998427b3ad2c ("mm/notifier: add migration invalidation type")
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "Jason Gunthorpe" <jgg@mellanox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmu_notifier.h |   13 +++++++++++++
 mm/migrate.c                 |    6 +++---
 2 files changed, 16 insertions(+), 3 deletions(-)

--- a/include/linux/mmu_notifier.h~mm-migrate-fix-migrate_pgmap_owner-w-o-config_mmu_notifier
+++ a/include/linux/mmu_notifier.h
@@ -521,6 +521,16 @@ static inline void mmu_notifier_range_in
 	range->flags = flags;
 }
 
+static inline void mmu_notifier_range_init_migrate(
+			struct mmu_notifier_range *range, unsigned int flags,
+			struct vm_area_struct *vma, struct mm_struct *mm,
+			unsigned long start, unsigned long end, void *pgmap)
+{
+	mmu_notifier_range_init(range, MMU_NOTIFY_MIGRATE, flags, vma, mm,
+				start, end);
+	range->migrate_pgmap_owner = pgmap;
+}
+
 #define ptep_clear_flush_young_notify(__vma, __address, __ptep)		\
 ({									\
 	int __young;							\
@@ -645,6 +655,9 @@ static inline void _mmu_notifier_range_i
 
 #define mmu_notifier_range_init(range,event,flags,vma,mm,start,end)  \
 	_mmu_notifier_range_init(range, start, end)
+#define mmu_notifier_range_init_migrate(range, flags, vma, mm, start, end, \
+					pgmap) \
+	_mmu_notifier_range_init(range, start, end)
 
 static inline bool
 mmu_notifier_range_blockable(const struct mmu_notifier_range *range)
--- a/mm/migrate.c~mm-migrate-fix-migrate_pgmap_owner-w-o-config_mmu_notifier
+++ a/mm/migrate.c
@@ -2429,9 +2429,9 @@ static void migrate_vma_collect(struct m
 	 * that the registered device driver can skip invalidating device
 	 * private page mappings that won't be migrated.
 	 */
-	mmu_notifier_range_init(&range, MMU_NOTIFY_MIGRATE, 0, migrate->vma,
-			migrate->vma->vm_mm, migrate->start, migrate->end);
-	range.migrate_pgmap_owner = migrate->pgmap_owner;
+	mmu_notifier_range_init_migrate(&range, 0, migrate->vma,
+		migrate->vma->vm_mm, migrate->start, migrate->end,
+		migrate->pgmap_owner);
 	mmu_notifier_invalidate_range_start(&range);
 
 	walk_page_range(migrate->vma->vm_mm, migrate->start, migrate->end,
_

Patches currently in -mm which might be from rcampbell@nvidia.com are

mm-remove-redundant-check-non_swap_entry.patch
mm-migrate-optimize-migrate_vma_setup-for-holes.patch
mm-migrate-optimize-migrate_vma_setup-for-holes-v2.patch
mm-migrate-add-migrate-shared-test-for-migrate_vma_.patch
mm-migrate-fix-migrate_pgmap_owner-w-o-config_mmu_notifier.patch

