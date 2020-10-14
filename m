Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60A18C35265
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1950422248
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709318;
	bh=F+0OmBci4WLyyfWI23zpikYvr23rINgBZETMLn+Crm8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=i+nNVphVviNvTjKLytRwBrG4jNn8CQ3DWyp8vDdWXYAXdBjfra90zdS9IfBFXi5w3
	 pifhGllG/N0IbLvdgy8sfPXMmdkYk3kvOjRvOENSN2BYTl792Sdh0tC3mPrrY7lPLR
	 tgVoyiyFh4+AcgVPcna3GVx2G7LaEy4M++EqyRSw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730609AbgJNVBz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:01:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730599AbgJNVBz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:01:55 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A118F20725;
        Wed, 14 Oct 2020 21:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709314;
        bh=F+0OmBci4WLyyfWI23zpikYvr23rINgBZETMLn+Crm8=;
        h=Date:From:To:Subject:From;
        b=SbTZzMTgPKqn8O+6uhDm2Hm+wRXcmGAIOudDJ2E+Cdt3LGyJ5Fcyl3LkwPAz377vf
         vcgpChIounDIxYOpEsB+iUNzIpTPrBreNfLk/9iGaSxPUSpOYMrpv0TPyK41akIM4f
         LxHvRZuWtzi5e3Vkaf7SeYQEC2gCrHb+1bOiPiD8=
Date:   Wed, 14 Oct 2020 14:01:54 -0700
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com
Subject:  [merged] mm-remove-unused-marco-writeback.patch removed
 from -mm tree
Message-ID: <20201014210154.xM_Y4i1RR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: remove unused macro `writeback'
has been removed from the -mm tree.  Its filename was
     mm-remove-unused-marco-writeback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/memory-failure.c: remove unused macro `writeback'

Unlike others we don't use the marco writeback.  so let's remove it to
tame gcc warning:

mm/memory-failure.c:827: warning: macro "writeback" is not used
[-Wunused-macros]

Link: https://lkml.kernel.org/r/1599715096-20369-1-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/memory-failure.c~mm-remove-unused-marco-writeback
+++ a/mm/memory-failure.c
@@ -825,7 +825,6 @@ static int me_huge_page(struct page *p,
 #define sc		((1UL << PG_swapcache) | (1UL << PG_swapbacked))
 #define unevict		(1UL << PG_unevictable)
 #define mlock		(1UL << PG_mlocked)
-#define writeback	(1UL << PG_writeback)
 #define lru		(1UL << PG_lru)
 #define head		(1UL << PG_head)
 #define slab		(1UL << PG_slab)
@@ -874,7 +873,6 @@ static struct page_state {
 #undef sc
 #undef unevict
 #undef mlock
-#undef writeback
 #undef lru
 #undef head
 #undef slab
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are


