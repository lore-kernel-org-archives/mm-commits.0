Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC63CC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 03:44:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DE996108F
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 03:44:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236143AbhIODqJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Sep 2021 23:46:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:36830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234150AbhIODqJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Sep 2021 23:46:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2BD961211;
        Wed, 15 Sep 2021 03:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631677490;
        bh=ikaQKoMFlDNeS7eiVEnJxC7O7Eq4J4Fc0yYByAJS8i4=;
        h=Date:From:To:Subject:From;
        b=BQZULYbUyIikCtxT+MJChPG3PyXFMg6LW4tgJxaJaJktvsQMGVE8IOR3/awTe6tBC
         PPPsTIVWCINOWhfbVhRE+Ye+NI4iUO+zudwnitHox0Ei2uwfXp4EECs9MjNBzVPJWu
         N2Jp10XrJBB8/0m1FIKp3C6Di1xc71QDe8Q2FRYw=
Date:   Tue, 14 Sep 2021 20:44:50 -0700
From:   akpm@linux-foundation.org
To:     chris@zankel.net, David.Laight@ACULAB.COM, jcmvbkbc@gmail.com,
        linux@roeck-us.net, masahiroy@kernel.org,
        mm-commits@vger.kernel.org
Subject:  + xtensa-increase-size-of-gcc-stack-frame-check.patch
 added to -mm tree
Message-ID: <20210915034450.2lTKHl304%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: xtensa: increase size of gcc stack frame check
has been added to the -mm tree.  Its filename is
     xtensa-increase-size-of-gcc-stack-frame-check.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/xtensa-increase-size-of-gcc-stack-frame-check.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/xtensa-increase-size-of-gcc-stack-frame-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Guenter Roeck <linux@roeck-us.net>
Subject: xtensa: increase size of gcc stack frame check

xtensa frame size is larger than the frame size for almost all other
architectures.  This results in more than 50 "the frame size of <n> is
larger than 1024 bytes" errors when trying to build xtensa:allmodconfig.

Increase frame size for xtensa to 1536 bytes to avoid compile errors
due to frame size limits.

Link: https://lkml.kernel.org/r/20210912025235.3514761-1-linux@roeck-us.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Max Filippov <jcmvbkbc@gmail.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/Kconfig.debug~xtensa-increase-size-of-gcc-stack-frame-check
+++ a/lib/Kconfig.debug
@@ -346,7 +346,7 @@ config FRAME_WARN
 	int "Warn for stack frames larger than"
 	range 0 8192
 	default 2048 if GCC_PLUGIN_LATENT_ENTROPY
-	default 1536 if (!64BIT && PARISC)
+	default 1536 if (!64BIT && (PARISC || XTENSA))
 	default 1024 if (!64BIT && !PARISC)
 	default 2048 if 64BIT
 	help
_

Patches currently in -mm which might be from linux@roeck-us.net are

xtensa-increase-size-of-gcc-stack-frame-check.patch

