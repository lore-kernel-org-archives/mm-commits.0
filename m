Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24AB4C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:40:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D78E61279
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:40:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232258AbhKEUnT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:43:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232708AbhKEUnS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:43:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED23D6126A;
        Fri,  5 Nov 2021 20:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144838;
        bh=3FgqD949W3pnE6WwT33oOxGUVWU25dyD4e9aK8K98rk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=sRL8ipK2akfBj2RPlmrdLBIsrAumU6LpgzzM/R6OgsaJLwlI9jSdtvg5Sw2UeMkns
         bp/PFltqb3jky0exsp0GecHKAnBNCCECEt/oiWdZ01qDTwkqdyBaU4KfnMsT7DzeOj
         BjqX/ruMZLGqZfuf3q/zpnw8UbpF2c3GJcmcH9fU=
Date:   Fri, 05 Nov 2021 13:40:37 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, liangcaifan19@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, zhang.lyra@gmail.com
Subject:  [patch 114/262] mm/page_alloc.c: show watermark_boost of
 zone in zoneinfo
Message-ID: <20211105204037.aNvfZGhYc%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
