Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B16DFC00140
	for <mm-commits@archiver.kernel.org>; Thu, 11 Aug 2022 01:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbiHKBWJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Aug 2022 21:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbiHKBWI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 10 Aug 2022 21:22:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50FA476949
        for <mm-commits@vger.kernel.org>; Wed, 10 Aug 2022 18:22:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 061CAB81ED4
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 01:22:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F3CC433C1;
        Thu, 11 Aug 2022 01:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660180924;
        bh=3iBWj4JoqWRr2zBQS0gUJPlufHQ4KL5eXYuWD9EUjOY=;
        h=Date:To:From:Subject:From;
        b=QUr2IiO1eAcCm985P6WEPYNJdIDSEWpOb3eDD4LPZRfLPAiWdWH4HIdgvAahuZ+3z
         GyY8fhUAQvgSXMWUH09AdApWl9+BvK5flg8EVE/a2fgyjHNHBD08/SnRWRvB7bT+cB
         sdf3bG2eXhGUIPwg8ERwVZrD0po9kFWb3C7wsw+8=
Date:   Wed, 10 Aug 2022 18:22:04 -0700
To:     mm-commits@vger.kernel.org, hannes@cmpxchg.org, david@redhat.com,
        haolee.swjtu@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-device_zone-to-for_all_zones.patch added to mm-hotfixes-unstable branch
Message-Id: <20220811012204.A4F3CC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add DEVICE_ZONE to FOR_ALL_ZONES
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-add-device_zone-to-for_all_zones.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-device_zone-to-for_all_zones.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-add-device_zone-to-for_all_zones.patch

