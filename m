Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA541C3527A
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8594822D73
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726886AbgLOX7u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:34576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729236AbgLOX0H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:26:07 -0500
Date:   Tue, 15 Dec 2020 15:23:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074617;
        bh=1ti4u4Vk8hP1J5TRipXXuy6ZhnaxMEGt0z307njtZPY=;
        h=From:To:Subject:From;
        b=iVraKWYK4C+B4ddYNY+e5EsPoI3lMwyhtkRMlal0iMGKFb6awPLNyc8nknVwkWZ5Z
         wG9nVAPIBYQ21CU2VWdtQ6W5oa4vvOHrw+WC6+UcjOQFpm5GZVrQmp9DZMG6gnuVGz
         +krFcR2DbOaqSzFIWpnZYnSHY5sZjkxeuswG9oms=
From:   akpm@linux-foundation.org
To:     david@redhat.com, mm-commits@vger.kernel.org,
        starzhangzsd@gmail.com
Subject:  [merged]
 mm-migrate-remove-unused-parameter-in-migrate_vma_insert_page.patch removed
 from -mm tree
Message-ID: <20201215232337.SPslL0iKB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: remove unused parameter in migrate_vma_insert_page()
has been removed from the -mm tree.  Its filename was
     mm-migrate-remove-unused-parameter-in-migrate_vma_insert_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from starzhangzsd@gmail.com are


