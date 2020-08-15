Return-Path: <SRS0=U74d=BZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7673CC433E1
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 00:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46FBE207DA
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 00:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597450432;
	bh=XG/BT3yrAu7IHGtMCqwuFt2JiDPu/FXexJxkGDW4yBo=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Zprqz3EuGnyGLK4qXKA7LIPUkUshdMmlic0DXfBRER2L/idffJ/zkWzFXnTuHV38V
	 /gN9sjjhn0zg/IcEFaugCQej7xjGld4UGxf3Tdiww4/BtZK2W/T+WHtrh9Td5b8Uik
	 HWr2QRPP+eMj0N0IDhfuIWOlVT0cOgR03KFq/a6Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgHOANw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Aug 2020 20:13:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:50212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726213AbgHOANv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 Aug 2020 20:13:51 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31EE820781;
        Sat, 15 Aug 2020 00:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597450431;
        bh=XG/BT3yrAu7IHGtMCqwuFt2JiDPu/FXexJxkGDW4yBo=;
        h=Date:From:To:Subject:From;
        b=OXhSyZV5aW/q0dZ05jHYGLXsGLDC9aAhkBJ6myAELHXgxLQo9l9JGAOIxi6ZZ1jjf
         NwrRhkrzTQtzm79/VzdnNiZ4KX2LPSU2c+r9hjjDCVBoHAR/WIa5cwD1x+k4Un1oZJ
         GAaHN1WVHLsAPRWf2pV40FIGdywRy4p3SvZEtpeA=
Date:   Fri, 14 Aug 2020 17:13:50 -0700
From:   akpm@linux-foundation.org
To:     cai@lca.pw, elver@google.com, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 mm-page_io-mark-various-intentional-data-races-v2.patch removed from -mm
 tree
Message-ID: <20200815001350.Pbufvrv2o%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_io-mark-various-intentional-data-races-v2
has been removed from the -mm tree.  Its filename was
     mm-page_io-mark-various-intentional-data-races-v2.patch

This patch was dropped because it was folded into mm-page_io-mark-various-intentional-data-races.patch

------------------------------------------------------
From: Qian Cai <cai@lca.pw>
Subject: mm-page_io-mark-various-intentional-data-races-v2

add a missing annotation

Link: http://lkml.kernel.org/r/1581612585-5812-1-git-send-email-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_io.c~mm-page_io-mark-various-intentional-data-races-v2
+++ a/mm/page_io.c
@@ -85,7 +85,7 @@ static void swap_slot_free_notify(struct
 		return;
 
 	sis = page_swap_info(page);
-	if (!(sis->flags & SWP_BLKDEV))
+	if (data_race(!(sis->flags & SWP_BLKDEV)))
 		return;
 
 	/*
_

Patches currently in -mm which might be from cai@lca.pw are

mm-kmemleak-silence-kcsan-splats-in-checksum.patch
mm-frontswap-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races.patch
mm-swap_state-mark-various-intentional-data-races.patch
mm-swapfile-fix-and-annotate-various-data-races.patch
mm-swapfile-fix-and-annotate-various-data-races-v2.patch
mm-page_counter-fix-various-data-races-at-memsw.patch
mm-memcontrol-fix-a-data-race-in-scan-count.patch
mm-list_lru-fix-a-data-race-in-list_lru_count_one.patch
mm-mempool-fix-a-data-race-in-mempool_free.patch
mm-rmap-annotate-a-data-race-at-tlb_flush_batched.patch
mm-swap-annotate-data-races-for-lru_rotate_pvecs.patch
mm-annotate-a-data-race-in-page_zonenum.patch
fork-silence-a-false-postive-warning-in-__mmdrop.patch

