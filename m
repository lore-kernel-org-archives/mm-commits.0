Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0BD2C7EE23
	for <mm-commits@archiver.kernel.org>; Wed, 31 May 2023 22:20:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbjEaWUC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 May 2023 18:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbjEaWT6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 May 2023 18:19:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A203C121
        for <mm-commits@vger.kernel.org>; Wed, 31 May 2023 15:19:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32F1363966
        for <mm-commits@vger.kernel.org>; Wed, 31 May 2023 22:19:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E086C433D2;
        Wed, 31 May 2023 22:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685571595;
        bh=n41qPq4LB/0bMT8XlXT0YTZSwUPp0990E8mVRzLSQGE=;
        h=Date:To:From:Subject:From;
        b=ipmGa3LoGw3YQ4XyvxptwVpfWNPZRxPaNYUX1mqebEJ/k4Z4unstmPvPRI7yPtYaE
         mDzuhqfWtmmiIP6NS/NUaht6CicYm8a7uqZp/D/wjT7Bj2sbCa5HJp+5KhqlIT9B84
         BrgAqsLv1PnsvNQRIio03icB0fVAntb9ls95WDCo=
Date:   Wed, 31 May 2023 15:19:54 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        minchan@kernel.org, ke.wang@unisoc.com, zhaoyang.huang@unisoc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-skip-cma-pages-when-they-are-not-available.patch added to mm-unstable branch
Message-Id: <20230531221955.7E086C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: skip CMA pages when they are not available
has been added to the -mm mm-unstable branch.  Its filename is
     mm-skip-cma-pages-when-they-are-not-available.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-skip-cma-pages-when-they-are-not-available.patch

This patch will later appear in the mm-unstable branch at
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
From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Subject: mm: skip CMA pages when they are not available
Date: Wed, 31 May 2023 10:51:01 +0800

This patch fixes unproductive reclaiming of CMA pages by skipping them
when they are not available for current context.  It arises from the below
OOM issue, which was caused by a large proportion of MIGRATE_CMA pages
among free pages.

[   36.172486] [03-19 10:05:52.172] ActivityManager: page allocation failure: order:0, mode:0xc00(GFP_NOIO), nodemask=(null),cpuset=foreground,mems_allowed=0
[   36.189447] [03-19 10:05:52.189] DMA32: 0*4kB 447*8kB (C) 217*16kB (C) 124*32kB (C) 136*64kB (C) 70*128kB (C) 22*256kB (C) 3*512kB (C) 0*1024kB 0*2048kB 0*4096kB = 35848kB
[   36.193125] [03-19 10:05:52.193] Normal: 231*4kB (UMEH) 49*8kB (MEH) 14*16kB (H) 13*32kB (H) 8*64kB (H) 2*128kB (H) 0*256kB 1*512kB (H) 0*1024kB 0*2048kB 0*4096kB = 3236kB
...
[   36.234447] [03-19 10:05:52.234] SLUB: Unable to allocate memory on node -1, gfp=0xa20(GFP_ATOMIC)
[   36.234455] [03-19 10:05:52.234] cache: ext4_io_end, object size: 64, buffer size: 64, default order: 0, min order: 0
[   36.234459] [03-19 10:05:52.234] node 0: slabs: 53,objs: 3392, free: 0

Link: https://lkml.kernel.org/r/1685501461-19290-1-git-send-email-zhaoyang.huang@unisoc.com
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Cc: ke.wang <ke.wang@unisoc.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-skip-cma-pages-when-they-are-not-available
+++ a/mm/vmscan.c
@@ -2271,6 +2271,25 @@ static __always_inline void update_lru_s
 
 }
 
+#ifdef CONFIG_CMA
+/*
+ * It is waste of effort to scan and reclaim CMA pages if it is not available
+ * for current allocation context. Kswapd can not be enrolled as it can not
+ * distinguish this scenario by using sc->gfp_mask = GFP_KERNEL
+ */
+static bool skip_cma(struct folio *folio, struct scan_control *sc)
+{
+	return !current_is_kswapd() &&
+			gfp_migratetype(sc->gfp_mask) != MIGRATE_MOVABLE &&
+			get_pageblock_migratetype(&folio->page) == MIGRATE_CMA;
+}
+#else
+static bool skip_cma(struct folio *folio, struct scan_control *sc)
+{
+	return false;
+}
+#endif
+
 /*
  * Isolating page from the lruvec to fill in @dst list by nr_to_scan times.
  *
@@ -2317,7 +2336,8 @@ static unsigned long isolate_lru_folios(
 		nr_pages = folio_nr_pages(folio);
 		total_scan += nr_pages;
 
-		if (folio_zonenum(folio) > sc->reclaim_idx) {
+		if (folio_zonenum(folio) > sc->reclaim_idx ||
+				skip_cma(folio, sc)) {
 			nr_skipped[folio_zonenum(folio)] += nr_pages;
 			move_to = &folios_skipped;
 			goto move;
_

Patches currently in -mm which might be from zhaoyang.huang@unisoc.com are

mm-optimization-on-page-allocation-when-cma-enabled.patch
mm-skip-cma-pages-when-they-are-not-available.patch

