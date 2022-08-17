Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD70BC25B08
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 20:57:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242187AbiHQU54 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 16:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242189AbiHQU5U (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 16:57:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12905AB43B
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 13:57:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A447B81F6F
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 20:57:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0230FC43470;
        Wed, 17 Aug 2022 20:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660769829;
        bh=7j/3SzQ8hryI4BxDjhbj30tWcYcBazHWLjB7Q86BxO4=;
        h=Date:To:From:Subject:From;
        b=x3JFlY3pqhNenoa66keFw6qUJscVlJT1967HkjwKKpXCPrHQwTTyQXNRkOW/jq2Hk
         q7DrHyx4vh/AHEPsI19XytPcqhowJezXuXx7ioM0KiQIWSgDqO9Ay9NO+qPZu0nDv0
         mT0TBMmm/rC33a/Ffs/+AKuWRl8wf8lHp43HYy3Y=
Date:   Wed, 17 Aug 2022 13:57:08 -0700
To:     mm-commits@vger.kernel.org, hannes@cmpxchg.org, david@redhat.com,
        haolee.swjtu@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-add-device_zone-to-for_all_zones.patch removed from -mm tree
Message-Id: <20220817205709.0230FC43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add DEVICE_ZONE to FOR_ALL_ZONES
has been removed from the -mm tree.  Its filename was
     mm-add-device_zone-to-for_all_zones.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hao Lee <haolee.swjtu@gmail.com>
Subject: mm: add DEVICE_ZONE to FOR_ALL_ZONES
Date: Sun, 7 Aug 2022 15:44:42 +0000

FOR_ALL_ZONES should be consistent with enum zone_type.  Otherwise,
__count_zid_vm_events have the potential to add count to wrong item when
zid is ZONE_DEVICE.

Link: https://lkml.kernel.org/r/20220807154442.GA18167@haolee.io
Signed-off-by: Hao Lee <haolee.swjtu@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |   15 +++++++++++----
 mm/vmstat.c                   |    9 ++++++++-
 2 files changed, 19 insertions(+), 5 deletions(-)

--- a/include/linux/vm_event_item.h~mm-add-device_zone-to-for_all_zones
+++ a/include/linux/vm_event_item.h
@@ -20,12 +20,19 @@
 #define HIGHMEM_ZONE(xx)
 #endif
 
-#define FOR_ALL_ZONES(xx) DMA_ZONE(xx) DMA32_ZONE(xx) xx##_NORMAL, HIGHMEM_ZONE(xx) xx##_MOVABLE
+#ifdef CONFIG_ZONE_DEVICE
+#define DEVICE_ZONE(xx) xx##_DEVICE,
+#else
+#define DEVICE_ZONE(xx)
+#endif
+
+#define FOR_ALL_ZONES(xx) DMA_ZONE(xx) DMA32_ZONE(xx) xx##_NORMAL, \
+	HIGHMEM_ZONE(xx) xx##_MOVABLE, DEVICE_ZONE(xx)
 
 enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
-		FOR_ALL_ZONES(PGALLOC),
-		FOR_ALL_ZONES(ALLOCSTALL),
-		FOR_ALL_ZONES(PGSCAN_SKIP),
+		FOR_ALL_ZONES(PGALLOC)
+		FOR_ALL_ZONES(ALLOCSTALL)
+		FOR_ALL_ZONES(PGSCAN_SKIP)
 		PGFREE, PGACTIVATE, PGDEACTIVATE, PGLAZYFREE,
 		PGFAULT, PGMAJFAULT,
 		PGLAZYFREED,
--- a/mm/vmstat.c~mm-add-device_zone-to-for_all_zones
+++ a/mm/vmstat.c
@@ -1168,8 +1168,15 @@ int fragmentation_index(struct zone *zon
 #define TEXT_FOR_HIGHMEM(xx)
 #endif
 
+#ifdef CONFIG_ZONE_DEVICE
+#define TEXT_FOR_DEVICE(xx) xx "_device",
+#else
+#define TEXT_FOR_DEVICE(xx)
+#endif
+
 #define TEXTS_FOR_ZONES(xx) TEXT_FOR_DMA(xx) TEXT_FOR_DMA32(xx) xx "_normal", \
-					TEXT_FOR_HIGHMEM(xx) xx "_movable",
+					TEXT_FOR_HIGHMEM(xx) xx "_movable", \
+					TEXT_FOR_DEVICE(xx)
 
 const char * const vmstat_text[] = {
 	/* enum zone_stat_item counters */
_

Patches currently in -mm which might be from haolee.swjtu@gmail.com are


