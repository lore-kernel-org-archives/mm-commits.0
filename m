Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCA4CC433ED
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:02:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A975A611ED
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:02:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233638AbhEGBDE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:03:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229637AbhEGBDD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:03:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DE9B61041;
        Fri,  7 May 2021 01:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349324;
        bh=9BPq/+B1MoGQCQqhnHGgW6YoQS2Bga+79l1nmOiveZA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=jpP2bYes8ScZUdEWFPB3htjWKIF1gyCqG4+ufmMfT1jSfPGfakxP1N/Ed/6b5mQ2u
         2ef3n5LqKCDtzVRonk/ZsSAnf95Uvn8KLYlKRLUKmkWkoPj7fVBqF+gzv5ivheGon7
         xhqkaJjfo8iXjT/lRfgMDOgy8NTsvkPNM2PwuwyY=
Date:   Thu, 06 May 2021 18:02:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ink@jurassic.park.msu.ru,
        linux-mm@kvack.org, mattst88@gmail.com, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, rth@twiddle.net,
        torvalds@linux-foundation.org
Subject:  [patch 01/91] alpha: eliminate old-style function
 definitions
Message-ID: <20210507010204.2a9Uo2prm%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: alpha: eliminate old-style function definitions

'make ARCH=alpha W=1' reports a couple of old-style function
definitions with missing parameter list, so fix those.

../arch/alpha/kernel/pc873xx.c: In function 'pc873xx_get_base':
../arch/alpha/kernel/pc873xx.c:16:21: warning: old-style function definition [-Wold-style-definition]
   16 | unsigned int __init pc873xx_get_base()

../arch/alpha/kernel/pc873xx.c: In function 'pc873xx_get_model':
../arch/alpha/kernel/pc873xx.c:21:14: warning: old-style function definition [-Wold-style-definition]
   21 | char *__init pc873xx_get_model()

Link: https://lkml.kernel.org/r/20210421061312.30097-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/pc873xx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/alpha/kernel/pc873xx.c~alpha-eliminate-old-style-function-definitions
+++ a/arch/alpha/kernel/pc873xx.c
@@ -13,12 +13,12 @@ static char *pc873xx_names[] = {
 static unsigned int base, model;
 
 
-unsigned int __init pc873xx_get_base()
+unsigned int __init pc873xx_get_base(void)
 {
 	return base;
 }
 
-char *__init pc873xx_get_model()
+char *__init pc873xx_get_model(void)
 {
 	return pc873xx_names[model];
 }
_
