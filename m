Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27435C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:56:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5B5622254
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602708980;
	bh=H0eFCPm7fm4DkFyzJwemR0zV21RYZvd7HoTuBVhcSqY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=bw8/dcWpahCujY2A64V2stPHfl5hvkFNOjjuD4U6yP5kb1HzGyJ25aLRI+T3VCZFN
	 8qihz9ILDcn4HIdKQt1Mxk5G+WAN5g6T+4bRHORGCM6kVd/cQM6rjs3OHsA+A9JPpj
	 zJ+l1Dop2G8hpUpHU0+PLJrVc6UWBoNmta17SEMQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388541AbgJNU4U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:56:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:46640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387573AbgJNU4U (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:56:20 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DA222224E;
        Wed, 14 Oct 2020 20:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602708979;
        bh=H0eFCPm7fm4DkFyzJwemR0zV21RYZvd7HoTuBVhcSqY=;
        h=Date:From:To:Subject:From;
        b=YfoOpfRjBFNxrl5Wk14D9ESiH0iWBAm2ELOD8+yy0XlheluYAdm7x2VktLi68XBEJ
         oOMgtLuVM6QIWUhHMazxvaujIyW9mXHMBv3YDalW3iZc2CvDqhjFyCFAzWK12c+IVj
         Da/Ph1QB8kHsyRbTgRb6YEeqP4xoD5BVKo24Smzk=
Date:   Wed, 14 Oct 2020 13:56:19 -0700
From:   akpm@linux-foundation.org
To:     jrdr.linux@gmail.com, mm-commits@vger.kernel.org,
        tangjianqiang@xiaomi.com, wyqt1985@gmail.com
Subject:  [merged]
 include-linux-slabh-fix-a-typo-error-in-comment.patch removed from -mm tree
Message-ID: <20201014205619.zc2cIhQv5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/slab.h: fix a typo error in comment
has been removed from the -mm tree.  Its filename was
     include-linux-slabh-fix-a-typo-error-in-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: tangjianqiang <wyqt1985@gmail.com>
Subject: include/linux/slab.h: fix a typo error in comment

fix a typo error in slab.h
"allocagtor" -> "allocator"

Link: https://lkml.kernel.org/r/1600230053-24303-1-git-send-email-tangjianqiang@xiaomi.com
Signed-off-by: tangjianqiang <tangjianqiang@xiaomi.com>
Acked-by: Souptick Joarder <jrdr.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/slab.h~include-linux-slabh-fix-a-typo-error-in-comment
+++ a/include/linux/slab.h
@@ -279,7 +279,7 @@ static inline void __check_heap_object(c
 #define KMALLOC_MAX_SIZE	(1UL << KMALLOC_SHIFT_MAX)
 /* Maximum size for which we actually use a slab cache */
 #define KMALLOC_MAX_CACHE_SIZE	(1UL << KMALLOC_SHIFT_HIGH)
-/* Maximum order allocatable via the slab allocagtor */
+/* Maximum order allocatable via the slab allocator */
 #define KMALLOC_MAX_ORDER	(KMALLOC_SHIFT_MAX - PAGE_SHIFT)
 
 /*
_

Patches currently in -mm which might be from wyqt1985@gmail.com are


