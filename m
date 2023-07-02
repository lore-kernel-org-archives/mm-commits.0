Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76502EB64D9
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 23:26:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjGBX0s (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 19:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjGBX0s (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 19:26:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B391BE
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 16:26:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7221B60C58
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 23:26:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF034C433C7;
        Sun,  2 Jul 2023 23:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688340405;
        bh=MdXcT8hbKfWJsQomTlqNy9tgL6e7lWu+HBb1hFr5IjA=;
        h=Date:To:From:Subject:From;
        b=bOyX7XnpRiRrRSaZSgs62s5YlfcwdjR+xqtziFvqZfefo/Lp+tTZxt8P9j4wYJFcG
         i5gVHBeeaXe199O3zn3mc0MR9xC6/qz4vlcbkP42ZzTCl+wMu2kNftPzrZzQnTRBYs
         PODCaBord5x21bCAHkoXiHF8vK0De0oa+Ux5wH78=
Date:   Sun, 02 Jul 2023 16:26:45 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        liuq131@chinatelecom.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-fix-min_free_kbytes-calculation-regarding-zone_movable.patch added to mm-unstable branch
Message-Id: <20230702232645.BF034C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: fix min_free_kbytes calculation regarding ZONE_MOVABLE
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-fix-min_free_kbytes-calculation-regarding-zone_movable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-fix-min_free_kbytes-calculation-regarding-zone_movable.patch

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
@@ -5730,9 +5730,9 @@ static void __setup_per_zone_wmarks(void
 	struct zone *zone;
 	unsigned long flags;
 
-	/* Calculate total number of !ZONE_HIGHMEM pages */
+	/* Calculate total number of !ZONE_HIGHMEM and !ZONE_MOVABLE pages */
 	for_each_zone(zone) {
-		if (!is_highmem(zone))
+		if (!is_highmem(zone) && zone_idx(zone) != ZONE_MOVABLE)
 			lowmem_pages += zone_managed_pages(zone);
 	}
 
@@ -5742,15 +5742,15 @@ static void __setup_per_zone_wmarks(void
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

mm-page_alloc-fix-min_free_kbytes-calculation-regarding-zone_movable.patch

