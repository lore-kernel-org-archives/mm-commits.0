Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EB18C4361A
	for <mm-commits@archiver.kernel.org>; Sat,  5 Dec 2020 01:18:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEBC022D71
	for <mm-commits@archiver.kernel.org>; Sat,  5 Dec 2020 01:18:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgLEBSG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Dec 2020 20:18:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:51750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725300AbgLEBSG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Dec 2020 20:18:06 -0500
Date:   Fri, 04 Dec 2020 17:17:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607131039;
        bh=BU04+M5S5gKvP6zacZ3dk2/HBzYtgrmN7S7s0h6sur4=;
        h=From:To:Subject:From;
        b=TqsN9d84iH6Hqd5jOUuOHlcMeUCWVzwT/nPSFpHlAcmGjbUVdns7bUT8cJ1bzplKx
         Qe95fss5mLQyHgiwPvXK00HyfGDqAyKjwFJV1Yx6hQeK5XIMOFyt31ICCmSOqKmVDN
         41HO6nryIOaWeCJAeFOMRMf+/k8FmA0cw0H+XLik=
From:   akpm@linux-foundation.org
To:     david@redhat.com, mm-commits@vger.kernel.org,
        starzhangzsd@gmail.com
Subject:  +
 mm-migrate-remove-unused-parameter-in-migrate_vma_insert_page.patch added
 to -mm tree
Message-ID: <20201205011719.jaFr3qlEX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: remove unused parameter in migrate_vma_insert_page()
has been added to the -mm tree.  Its filename is
     mm-migrate-remove-unused-parameter-in-migrate_vma_insert_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-remove-unused-parameter-in-migrate_vma_insert_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-remove-unused-parameter-in-migrate_vma_insert_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-migrate-remove-unused-parameter-in-migrate_vma_insert_page.patch

