Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFC0DC433FE
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:57:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B26661153
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:57:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347430AbhIHC6e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:58:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:55858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347292AbhIHC62 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:58:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90F8661102;
        Wed,  8 Sep 2021 02:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069841;
        bh=VdX/F/NPcdZDmtGugMVclQIqByz7MQTRlOc5frVNqMo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xUbalY1P1M/7820hF+hMjyjuVHOyVRlHapV6ChPM0itjx24v0DFh2VX/NJuiepyrd
         /ASmRflwlJkPdNw2utwYsMS2KSWcoE+aXrClOgEh/7nePQvC0Vd5aFpQQ2BT15kq7O
         sX2+5+xKAM1LsCjGk5YNQacLjprOQRfRWW93icuM=
Date:   Tue, 07 Sep 2021 19:57:21 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     airlied@linux.ie, akpm@linux-foundation.org,
        ink@jurassic.park.msu.ru, linux-mm@kvack.org, mattst88@gmail.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org, rth@twiddle.net,
        torvalds@linux-foundation.org
Subject:  [patch 076/147] alpha: agp: make empty macros use
 do-while-0 style
Message-ID: <20210908025721.5A-OcGSCs%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: alpha: agp: make empty macros use do-while-0 style

Copy these macros from ia64/include/asm/agp.h to avoid the
"empty-body" in 'if' statment warning.

drivers/char/agp/generic.c: In function 'agp_generic_destroy_page':
../drivers/char/agp/generic.c:1265:42: warning: suggest braces around empty body in an 'if' statement [-Wempty-body]
 1265 |                 unmap_page_from_agp(page);

Link: https://lkml.kernel.org/r/20210809030822.20658-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/agp.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/alpha/include/asm/agp.h~alpha-agp-make-empty-macros-use-do-while-0-style
+++ a/arch/alpha/include/asm/agp.h
@@ -6,8 +6,8 @@
 
 /* dummy for now */
 
-#define map_page_into_agp(page) 
-#define unmap_page_from_agp(page) 
+#define map_page_into_agp(page)		do { } while (0)
+#define unmap_page_from_agp(page)	do { } while (0)
 #define flush_agp_cache() mb()
 
 /* GATT allocation. Returns/accepts GATT kernel virtual address. */
_
