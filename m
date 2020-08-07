Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BC53C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:17:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3355D22C9F
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781032;
	bh=5G2wDP9QWKyn+JHhF726/Cc2UeOzBeoGwYmuq4sUMGI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=puIEIXeW1Gee/0B4Ac+uN3JhQLDIcN9FzX4LUvOvHQtExKcuZ9Jrnlmik7trChBLs
	 FFQpqaPahXjoAI1uSd8+Bmq2OTljhX6nhyC7yBRg0lVw7xGOHT3gsgd/RtDoDUEv7f
	 YGPQWc/F03B2KDEoKJLWbOWTGu+wnslSYl1aV9Cw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgHGGRL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:17:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGRL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:17:11 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AF4B22CAF;
        Fri,  7 Aug 2020 06:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781030;
        bh=5G2wDP9QWKyn+JHhF726/Cc2UeOzBeoGwYmuq4sUMGI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Zc/68k2ibppvB0quoP+wRl+bclFk0Vro/2RW02m9XLtdZS6IsgD9mPN0I2u0f7XZe
         dw4qz161GCnZa/2/zC3uTC8xZdOIgtQUm+wc3WTfU29VgUPaXtjrsKKECdGK2Iw79I
         4SmVl4tRbVyxXSJutS8+XCAFs5ROdqKttjsRxKnM=
Date:   Thu, 06 Aug 2020 23:17:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, jgg@mellanox.com,
        jglisse@redhat.com, jhubbard@nvidia.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com,
        rdunlap@infradead.org, torvalds@linux-foundation.org
Subject:  [patch 002/163] mm/migrate: fix migrate_pgmap_owner w/o
 CONFIG_MMU_NOTIFIER
Message-ID: <20200807061709.xu5tflYEQ%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -2386,9 +2386,9 @@ static void migrate_vma_collect(struct m
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
