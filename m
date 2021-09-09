Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A73C1C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:04:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88D44611C5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:04:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348719AbhIIVFd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:05:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:54464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346920AbhIIVE1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:04:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84C43611C8;
        Thu,  9 Sep 2021 21:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221397;
        bh=OdWi2EsYZJVNx5DA39DjHHKeTSErUGydBk7btdFp9N4=;
        h=Date:From:To:Subject:From;
        b=Cn0P0gyWhpzzCcC/Vig4vlAx3iGR8PI9UIdiCmrQRC/cmJ9Smk4cFGesQMeanx0hS
         4UXjXwkbo/f4n90gFLQgMM+fOEakQ9gDCwnvgRVx5Fvz5tPXcN4h7vWcHmM/sk7k3G
         SArSdrD8mGL0WRjSUNqxsc31qOXdbnXg2tfaxgDE=
Date:   Thu, 09 Sep 2021 14:03:17 -0700
From:   akpm@linux-foundation.org
To:     airlied@linux.ie, ink@jurassic.park.msu.ru, mattst88@gmail.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org, rth@twiddle.net
Subject:  [merged]
 alpha-agp-make-empty-macros-use-do-while-0-style.patch removed from -mm
 tree
Message-ID: <20210909210317.I1f-fd8S6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: alpha: agp: make empty macros use do-while-0 style
has been removed from the -mm tree.  Its filename was
     alpha-agp-make-empty-macros-use-do-while-0-style.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from rdunlap@infradead.org are


