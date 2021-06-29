Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C15AC11F65
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:42:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3587161D0E
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:42:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbhF2CpC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:45:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231700AbhF2CpB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:45:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2167F61D0B;
        Tue, 29 Jun 2021 02:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934554;
        bh=dOCOwUnP+VdvbYSWobaiaUu6UfzoZCaMArOF50FNW+Q=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Ju4CTL69edC5UEYvPQY3RCWa+agNgsCf0f36wILFBP76uiKbCAI6P7v0dpG4m+fiS
         +LB9W3kOPG/Azxr7u9hXa/b8t7CUFlEncuL8y8IcDpLe1JhgCEv9uO5uE/qmr6O4u0
         CNpflWlTfNwK/0/Iy/vExTJdqjNhZix2v0pfhVl0=
Date:   Mon, 28 Jun 2021 19:42:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com, david@redhat.com,
        linux-mm@kvack.org, liushixin2@huawei.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        yangerkun@huawei.com
Subject:  [patch 178/192] mm/page_alloc: fix counting of
 managed_pages
Message-ID: <20210629024233.oOfWWchYA%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
