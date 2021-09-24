Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 113E8C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 22:43:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F244461260
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 22:43:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbhIXWpF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Sep 2021 18:45:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237268AbhIXWpD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Sep 2021 18:45:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B268161250;
        Fri, 24 Sep 2021 22:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632523410;
        bh=kjyDcCJefQj11doQfipUBefsNYggdbHuXCRn2Gx79C8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=eHJbAdrpADGajtIQk1hD0eiFvfe2qoCqR9RWBLChEQHMV0wbglHqjT68+s1PIifnD
         +0Rf8A3Q9CkRsudsGBvSF2XOK+OdT04OSpeASQjzNdDZZ8frHOcDaxpYXCqUnXsUpq
         +5eV1edaFC/IpUaRkIxKs+e4oUy8a6ESDSBx9SZg=
Date:   Fri, 24 Sep 2021 15:43:29 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris@zankel.net,
        David.Laight@ACULAB.COM, jcmvbkbc@gmail.com, linux-mm@kvack.org,
        linux@roeck-us.net, masahiroy@kernel.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 04/16] xtensa: increase size of gcc stack frame
 check
Message-ID: <20210924224329.W5ZWD-MoS%akpm@linux-foundation.org>
In-Reply-To: <20210924154257.1dbf6699ab8d88c0460f924f@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
