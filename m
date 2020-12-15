Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFCC9C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:14:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8345C224B2
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:14:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbgLODOG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:14:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:41656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728085AbgLODNm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:13:42 -0500
Date:   Mon, 14 Dec 2020 19:12:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001976;
        bh=t/bd141POhUnPd5FDmkqapbaJU1Xc9Ym6ihwFUMCibY=;
        h=From:To:Subject:In-Reply-To:From;
        b=I2Zlzkaqko1P6T3drrrG0Eh9//8KTqiOZ8JtuPHqVLDpbiM5T0olaVAYFhizWBF6F
         1eRnB9EUP4ecbMu2yvTOvS4IX7RSYSB4WiEx/TSk5UP1SuRhsZMqXxWMBzoijLg26r
         YOLDH0J+Xahz4iUy7rsY00VEY/ud9/Df6Xn3BECo=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, apopple@nvidia.com, hch@lst.de,
        jgg@nvidia.com, jglisse@redhat.com, jhubbard@nvidia.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com, torvalds@linux-foundation.org
Subject:  [patch 164/200] mm/migrate.c: optimize
 migrate_vma_pages() mmu notifier
Message-ID: <20201215031255.JOIcQ-YOL%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm/migrate.c: optimize migrate_vma_pages() mmu notifier

When migrating a zero page or pte_none() anonymous page to device private
memory, migrate_vma_setup() will initialize the src[] array with a NULL
PFN.  This lets the device driver allocate device private memory and clear
it instead of DMAing a page of zeros over the device bus.

Since the source page didn't exist at the time, no struct page was locked
nor a migration PTE inserted into the CPU page tables.  The actual PTE
insertion happens in migrate_vma_pages() when it tries to insert the
device private struct page PTE into the CPU page tables. 
migrate_vma_pages() has to call the mmu notifiers again since another
device could fault on the same page before the page table locks are
acquired.

Allow device drivers to optimize the invalidation similar to
migrate_vma_setup() by calling mmu_notifier_range_init() which sets struct
mmu_notifier_range event type to MMU_NOTIFY_MIGRATE and the
migrate_pgmap_owner field.

Link: https://lkml.kernel.org/r/20201021191335.10916-1-rcampbell@nvidia.com
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/migrate.c~mm-optimize-migrate_vma_pages-mmu-notifier
+++ a/mm/migrate.c
@@ -3001,11 +3001,10 @@ void migrate_vma_pages(struct migrate_vm
 			if (!notified) {
 				notified = true;
 
-				mmu_notifier_range_init(&range,
-							MMU_NOTIFY_CLEAR, 0,
-							NULL,
-							migrate->vma->vm_mm,
-							addr, migrate->end);
+				mmu_notifier_range_init_migrate(&range, 0,
+					migrate->vma, migrate->vma->vm_mm,
+					addr, migrate->end,
+					migrate->pgmap_owner);
 				mmu_notifier_invalidate_range_start(&range);
 			}
 			migrate_vma_insert_page(migrate, addr, newpage,
_
