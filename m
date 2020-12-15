Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 820C9C2BB9A
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:14:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36A7422509
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:14:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbgLODO1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:14:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:42044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728089AbgLODOB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:14:01 -0500
Date:   Mon, 14 Dec 2020 19:13:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608002000;
        bh=C0iZiRqRZXTZQL8sdquGfnsNMNbMHFAuqRndCN9EvcY=;
        h=From:To:Subject:In-Reply-To:From;
        b=xTqsHuS8XspEw83pSGcYZJboUR3Re4t8rM8KNXYmdMfvT4kwbNSUoFFipjYWFl1Oq
         9qgzcCGL3oezVTfbXlj1E0mU7cC8EqM+NnD/R6l5uCjGjYXAVzKax3GeJI6BD70Ddw
         yIPTHWaTKFsPp1UeqQFNIR1ABKpBcW19axuJM/8Q=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, starzhangzsd@gmail.com,
        torvalds@linux-foundation.org
Subject:  [patch 171/200] mm: migrate: remove unused parameter in
 migrate_vma_insert_page()
Message-ID: <20201215031320.W37puaMB3%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Stephen Zhang <starzhangzsd@gmail.com>
Subject: mm: migrate: remove unused parameter in migrate_vma_insert_page()

"dst" parameter to migrate_vma_insert_page() is not used anymore.

Link: https://lkml.kernel.org/r/CANubcdUwCAMuUyamG2dkWP=cqSR9MAS=tHLDc95kQkqU-rEnAg@mail.gmail.com
Signed-off-by: Stephen Zhang <starzhangzsd@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/migrate.c~mm-migrate-remove-unused-parameter-in-migrate_vma_insert_page
+++ a/mm/migrate.c
@@ -2894,8 +2894,7 @@ EXPORT_SYMBOL(migrate_vma_setup);
 static void migrate_vma_insert_page(struct migrate_vma *migrate,
 				    unsigned long addr,
 				    struct page *page,
-				    unsigned long *src,
-				    unsigned long *dst)
+				    unsigned long *src)
 {
 	struct vm_area_struct *vma = migrate->vma;
 	struct mm_struct *mm = vma->vm_mm;
@@ -3056,8 +3055,7 @@ void migrate_vma_pages(struct migrate_vm
 				mmu_notifier_invalidate_range_start(&range);
 			}
 			migrate_vma_insert_page(migrate, addr, newpage,
-						&migrate->src[i],
-						&migrate->dst[i]);
+						&migrate->src[i]);
 			continue;
 		}
 
_
