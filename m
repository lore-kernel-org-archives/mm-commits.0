Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49654C433ED
	for <mm-commits@archiver.kernel.org>; Thu, 22 Apr 2021 04:31:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 260DA61404
	for <mm-commits@archiver.kernel.org>; Thu, 22 Apr 2021 04:31:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbhDVEbe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Apr 2021 00:31:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:53292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229468AbhDVEbd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Apr 2021 00:31:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A29C4613F5;
        Thu, 22 Apr 2021 04:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619065859;
        bh=hyfqOQTyAoGVt3hdSVZYpIGygcTkrQpN2hvkSu8DiGw=;
        h=Date:From:To:Subject:From;
        b=izDCxVpak0EQdBbUFY+T15miSmiVomd6ZPfUsGm3++RSkYny8crQ3Yuzsv/Lmh12I
         4uIp9+nZ0bhUXJgY8WvmP02ZBDdL6hz2q3f77RtlwRts2pKZ911ceVxhixCmqoOSX1
         z65Glirh0YjjceejAydF5P94u3Mjsea8PJW/vKSc=
Date:   Wed, 21 Apr 2021 21:30:59 -0700
From:   akpm@linux-foundation.org
To:     ink@jurassic.park.msu.ru, mattst88@gmail.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org, rth@twiddle.net
Subject:  + alpha-eliminate-old-style-function-definitions.patch
 added to -mm tree
Message-ID: <20210422043059.h4rZJ3uKS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: alpha: eliminate old-style function definitions
has been added to the -mm tree.  Its filename is
     alpha-eliminate-old-style-function-definitions.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/alpha-eliminate-old-style-function-definitions.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/alpha-eliminate-old-style-function-definitions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from rdunlap@infradead.org are

vfs-fs_parser-clean-up-kernel-doc-warnings.patch
alpha-eliminate-old-style-function-definitions.patch
lib-parser-clean-up-kernel-doc.patch

