Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5D3BC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 20:46:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C61DB61250
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 20:46:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237738AbhIXUrk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Sep 2021 16:47:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237268AbhIXUrk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Sep 2021 16:47:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95A9F61242;
        Fri, 24 Sep 2021 20:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632516366;
        bh=UeVpeu0iVkvKriBh5XYXf165yQlJZLrYHxOSAsOM/Bg=;
        h=Date:From:To:Subject:From;
        b=D+ZB7YO49zMwmPbMIu8M8e9IhzdweG0T/5PzhtoEHQOcReuIgml4mnHbrTdP2eGHR
         lvJdRF5TuXHN/eL3D5TJ1m9FtD6M909mT1N5kuGZss5s/HITXAtSizqemOmjttyVjT
         8Yd/5sEMdz4qaMGbg4ylr4xQffL+dP9ITN0jz5Ro=
Date:   Fri, 24 Sep 2021 13:46:06 -0700
From:   akpm@linux-foundation.org
To:     liangcaifan19@gmail.com, mm-commits@vger.kernel.org,
        zhang.lyra@gmail.com
Subject:  + mm-show-watermark_boost-of-zone-in-zoneinfo.patch added
 to -mm tree
Message-ID: <20210924204606.hWMzEzMB8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: show watermark_boost of zone in zoneinfo
has been added to the -mm tree.  Its filename is
     mm-show-watermark_boost-of-zone-in-zoneinfo.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-show-watermark_boost-of-zone-in-zoneinfo.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-show-watermark_boost-of-zone-in-zoneinfo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -5987,6 +5987,7 @@ void show_free_areas(unsigned int filter
 		printk(KERN_CONT
 			"%s"
 			" free:%lukB"
+			" boost:%lukB"
 			" min:%lukB"
 			" low:%lukB"
 			" high:%lukB"
@@ -6007,6 +6008,7 @@ void show_free_areas(unsigned int filter
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

mm-show-watermark_boost-of-zone-in-zoneinfo.patch

