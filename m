Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98CF0C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:15:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 848B960FDB
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:15:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbhGFTR4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:17:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231749AbhGFTR4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:17:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 937016008E;
        Tue,  6 Jul 2021 19:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598917;
        bh=tudDolCRXLIOV4uikKh/Ygkded0G5atvSPk9qygDfvc=;
        h=Date:From:To:Subject:From;
        b=WymcmePnRDQoEJHhJ65vcNzyW0fIvmDVDqcx5jCWWx/jHGniwEOruhgcpoINFvQg8
         FNJfBlXhgGBjp9esz6NYfunoufmhewmwe9c8QosAtug+4AeD2O4RGHT28QA+xJa9cd
         JllVbo6SO1a8A6P/0iQiLteyJqTvFxHyf3h9c7B0=
Date:   Tue, 06 Jul 2021 12:15:17 -0700
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, david@redhat.com, liushixin2@huawei.com,
        mm-commits@vger.kernel.org, yangerkun@huawei.com
Subject:  [merged]
 mm-page_alloc-fix-counting-of-managed_pages.patch removed from -mm tree
Message-ID: <20210706191517.CAhFRR9c_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: fix counting of managed_pages
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-counting-of-managed_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm/page_alloc: fix counting of managed_pages

commit f63661566fad ("mm/page_alloc.c: clear out zone->lowmem_reserve[] if
the zone is empty") clears out zone->lowmem_reserve[] if zone is empty. 
But when zone is not empty and sysctl_lowmem_reserve_ratio[i] is set to
zero, zone_managed_pages(zone) is not counted in the managed_pages either.
This is inconsistent with the description of lowmem_reserve, so fix it.

Link: https://lkml.kernel.org/r/20210527125707.3760259-1-liushixin2@huawei.com
Fixes: f63661566fad ("mm/page_alloc.c: clear out zone->lowmem_reserve[] if the zone is empty")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Reported-by: yangerkun <yangerkun@huawei.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-counting-of-managed_pages
+++ a/mm/page_alloc.c
@@ -8240,14 +8240,14 @@ static void setup_per_zone_lowmem_reserv
 			unsigned long managed_pages = 0;
 
 			for (j = i + 1; j < MAX_NR_ZONES; j++) {
-				if (clear) {
-					zone->lowmem_reserve[j] = 0;
-				} else {
-					struct zone *upper_zone = &pgdat->node_zones[j];
+				struct zone *upper_zone = &pgdat->node_zones[j];
+
+				managed_pages += zone_managed_pages(upper_zone);
 
-					managed_pages += zone_managed_pages(upper_zone);
+				if (clear)
+					zone->lowmem_reserve[j] = 0;
+				else
 					zone->lowmem_reserve[j] = managed_pages / ratio;
-				}
 			}
 		}
 	}
_

Patches currently in -mm which might be from liushixin2@huawei.com are


