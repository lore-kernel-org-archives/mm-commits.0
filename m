Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5D0FC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:51:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8427610FA
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:51:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhEHWwn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:52:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229552AbhEHWwm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:52:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3982613EA;
        Sat,  8 May 2021 22:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514299;
        bh=dVhgxURy56jXm2Q52JgBqrFrYm2BLhfL/Brcg+PKMJU=;
        h=Date:From:To:Subject:From;
        b=eGLJ4SbuOkBEK3TDug0Squp9+QANF8X+7fz++0nCtO5+UpN2pmat9/nIDT+N3S3qL
         iQenvZjKT3KJOdZrXoifaQKuwyxCSIvwxsZjhB99rI9abDLn3a210wZg0JCieId6CP
         K4+FfFy9FYqEcCV7DG2rrgVrEqqGEAwGIDZxv4fk=
Date:   Sat, 08 May 2021 15:51:39 -0700
From:   akpm@linux-foundation.org
To:     ink@jurassic.park.msu.ru, mattst88@gmail.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org, rth@twiddle.net
Subject:  [merged]
 alpha-eliminate-old-style-function-definitions.patch removed from -mm tree
Message-ID: <20210508225139.Wy9W4DvX1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: alpha: eliminate old-style function definitions
has been removed from the -mm tree.  Its filename was
     alpha-eliminate-old-style-function-definitions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


