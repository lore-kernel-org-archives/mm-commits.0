Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EB39C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:44:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D8A461247
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234311AbhKKCrH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:47:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:52154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234032AbhKKCrE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:47:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C95360F46;
        Thu, 11 Nov 2021 02:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598655;
        bh=LuqHYFuI5/09He0a1V+OAqPprhBrlBuRyLXqKkooNqM=;
        h=Date:From:To:Subject:From;
        b=YB+khrwY507NdyOzF0PO8FKm3E6CmrZY5brMwUaenCoELP3j4giD8MW9Aw6H8mrfg
         eO1kwrCofy7R+d9XwpAWRDawzFIXsVKRBOxegmW2ZIFU+ulKjyt7pDJJgRZKNhEbR4
         YnkVJQUPNb5lMw+I+jJvqrPJk1wLMd1zaWnukmcE=
Date:   Wed, 10 Nov 2021 18:44:15 -0800
From:   akpm@linux-foundation.org
To:     liangcaifan19@gmail.com, mm-commits@vger.kernel.org,
        zhang.lyra@gmail.com
Subject:  [merged]
 mm-show-watermark_boost-of-zone-in-zoneinfo.patch removed from -mm tree
Message-ID: <20211111024415.BCGaJBJZr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: show watermark_boost of zone in zoneinfo
has been removed from the -mm tree.  Its filename was
     mm-show-watermark_boost-of-zone-in-zoneinfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Liangcai Fan <liangcaifan19@gmail.com>
Subject: mm/page_alloc.c: show watermark_boost of zone in zoneinfo

min/low/high_wmark_pages(z) is defined as
(z->_watermark[WMARK_MIN/LOW/HIGH] + z->watermark_boost).
If kswapd is frequently waked up due to the increase of
min/low/high_wmark_pages, printing watermark_boost can quickly locate
whether watermark_boost or _watermark[WMARK_MIN/LOW/HIGH] caused
min/low/high_wmark_pages to increase.

Link: https://lkml.kernel.org/r/1632472566-12246-1-git-send-email-liangcaifan19@gmail.com
Signed-off-by: Liangcai Fan <liangcaifan19@gmail.com>
Cc: Chunyan Zhang <zhang.lyra@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 ++
 mm/vmstat.c     |    2 ++
 2 files changed, 4 insertions(+)

--- a/mm/page_alloc.c~mm-show-watermark_boost-of-zone-in-zoneinfo
+++ a/mm/page_alloc.c
@@ -5993,6 +5993,7 @@ void show_free_areas(unsigned int filter
 		printk(KERN_CONT
 			"%s"
 			" free:%lukB"
+			" boost:%lukB"
 			" min:%lukB"
 			" low:%lukB"
 			" high:%lukB"
@@ -6013,6 +6014,7 @@ void show_free_areas(unsigned int filter
 			"\n",
 			zone->name,
 			K(zone_page_state(zone, NR_FREE_PAGES)),
+			K(zone->watermark_boost),
 			K(min_wmark_pages(zone)),
 			K(low_wmark_pages(zone)),
 			K(high_wmark_pages(zone)),
--- a/mm/vmstat.c~mm-show-watermark_boost-of-zone-in-zoneinfo
+++ a/mm/vmstat.c
@@ -1656,6 +1656,7 @@ static void zoneinfo_show_print(struct s
 	}
 	seq_printf(m,
 		   "\n  pages free     %lu"
+		   "\n        boost    %lu"
 		   "\n        min      %lu"
 		   "\n        low      %lu"
 		   "\n        high     %lu"
@@ -1664,6 +1665,7 @@ static void zoneinfo_show_print(struct s
 		   "\n        managed  %lu"
 		   "\n        cma      %lu",
 		   zone_page_state(zone, NR_FREE_PAGES),
+		   zone->watermark_boost,
 		   min_wmark_pages(zone),
 		   low_wmark_pages(zone),
 		   high_wmark_pages(zone),
_

Patches currently in -mm which might be from liangcaifan19@gmail.com are


