Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D5ACC001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:59:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236803AbjHKW7f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236932AbjHKW7H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:59:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E775C35A0
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:59:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F0606784A
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:59:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8901C433C8;
        Fri, 11 Aug 2023 22:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794741;
        bh=brFbmhIfzQsy+yaCMMzZxd5PEhIJD2U/L7hBI1Nj+Qc=;
        h=Date:To:From:Subject:From;
        b=VN6Peg4TLZu59EcUnaxAhK7Nq/wZ11JOsN9ahgrbFGfVM5ldPE51zuZizM63OVOM5
         Mc+Ew/bP5pm6/RfpR3TEslUXxGmWmksUvfGiIg4auKsKZVQHHm0wupwzAnLrsEkH4D
         srPCsD+eFTj40oRskicZbPkhBWDnly1ERIKPyzns=
Date:   Fri, 11 Aug 2023 15:59:01 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        liuq131@chinatelecom.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-fix-min_free_kbytes-calculation-regarding-zone_movable.patch removed from -mm tree
Message-Id: <20230811225901.D8901C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: fix min_free_kbytes calculation regarding ZONE_MOVABLE
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-min_free_kbytes-calculation-regarding-zone_movable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: liuq <liuq131@chinatelecom.cn>
Subject: mm/page_alloc: fix min_free_kbytes calculation regarding ZONE_MOVABLE
Date: Sun, 25 Jun 2023 11:16:56 +0800

The current calculation of min_free_kbytes only uses ZONE_DMA and
ZONE_NORMAL pages,but the ZONE_MOVABLE zone->_watermark[WMARK_MIN] will
also divide part of min_free_kbytes.This will cause the min watermark of
ZONE_NORMAL to be too small in the presence of ZONE_MOVEABLE.

__GFP_HIGH and PF_MEMALLOC allocations usually don't need movable zone
pages, so just like ZONE_HIGHMEM, cap pages_min to a small value in
__setup_per_zone_wmarks().

On my testing machine with 16GB of memory (transparent hugepage is turned
off by default, and movablecore=12G is configured) The following is a
comparative test data of watermark_min

		no patch	add patch
ZONE_DMA	1		8
ZONE_DMA32	151		709
ZONE_NORMAL	233		1113
ZONE_MOVABLE	1434		128
min_free_kbytes	7288		7326

Link: https://lkml.kernel.org/r/20230625031656.23941-1-liuq131@chinatelecom.cn
Signed-off-by: liuq <liuq131@chinatelecom.cn>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-min_free_kbytes-calculation-regarding-zone_movable
+++ a/mm/page_alloc.c
@@ -5694,9 +5694,9 @@ static void __setup_per_zone_wmarks(void
 	struct zone *zone;
 	unsigned long flags;
 
-	/* Calculate total number of !ZONE_HIGHMEM pages */
+	/* Calculate total number of !ZONE_HIGHMEM and !ZONE_MOVABLE pages */
 	for_each_zone(zone) {
-		if (!is_highmem(zone))
+		if (!is_highmem(zone) && zone_idx(zone) != ZONE_MOVABLE)
 			lowmem_pages += zone_managed_pages(zone);
 	}
 
@@ -5706,15 +5706,15 @@ static void __setup_per_zone_wmarks(void
 		spin_lock_irqsave(&zone->lock, flags);
 		tmp = (u64)pages_min * zone_managed_pages(zone);
 		do_div(tmp, lowmem_pages);
-		if (is_highmem(zone)) {
+		if (is_highmem(zone) || zone_idx(zone) == ZONE_MOVABLE) {
 			/*
 			 * __GFP_HIGH and PF_MEMALLOC allocations usually don't
-			 * need highmem pages, so cap pages_min to a small
-			 * value here.
+			 * need highmem and movable zones pages, so cap pages_min
+			 * to a small  value here.
 			 *
 			 * The WMARK_HIGH-WMARK_LOW and (WMARK_LOW-WMARK_MIN)
 			 * deltas control async page reclaim, and so should
-			 * not be capped for highmem.
+			 * not be capped for highmem and movable zones.
 			 */
 			unsigned long min_pages;
 
_

Patches currently in -mm which might be from liuq131@chinatelecom.cn are


