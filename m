Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2DF7C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 18:23:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCC8E63326
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 18:23:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241320AbhKOS0O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 13:26:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:60612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241333AbhKOST2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 13:19:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29E1A63402;
        Mon, 15 Nov 2021 17:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636998698;
        bh=LLEoedAUxo+x6uH8/Bj2u67fTeG0jN4oydUq5vfcdSo=;
        h=Date:From:To:Subject:From;
        b=YCuEFqw3Wi9VE3wZxgz+mdnK0pRMxhViDfkb3ZZcXgnWEYv5dhJaWHLj+Vru9yVdq
         xu/PYv5wLqOXYf89OQuOo2wEQ4bD63MQy+arqB4TPhNhxWwvGcaGi1wEvOm1Imb+zv
         ZXO9/hDiRuPTSIDA9LzEYQIm2uPz665+1cKKZHNo=
Date:   Mon, 15 Nov 2021 09:51:37 -0800
From:   akpm@linux-foundation.org
To:     bcain@codeaurora.org, mm-commits@vger.kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, stable@vger.kernel.org
Subject:  + hexagon-export-raw-i-o-routines-for-modules.patch added
 to -mm tree
Message-ID: <20211115175137.msDLz__IY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hexagon: export raw I/O routines for modules
has been added to the -mm tree.  Its filename is
     hexagon-export-raw-i-o-routines-for-modules.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hexagon-export-raw-i-o-routines-for-modules.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hexagon-export-raw-i-o-routines-for-modules.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: hexagon: export raw I/O routines for modules

Patch series "Fixes for ARCH=hexagon allmodconfig", v2.

This series fixes some issues noticed with ARCH=hexagon allmodconfig.


This patch (of 3):

When building ARCH=hexagon allmodconfig, the following errors occur:

ERROR: modpost: "__raw_readsl" [drivers/i3c/master/svc-i3c-master.ko] undefined!
ERROR: modpost: "__raw_writesl" [drivers/i3c/master/dw-i3c-master.ko] undefined!
ERROR: modpost: "__raw_readsl" [drivers/i3c/master/dw-i3c-master.ko] undefined!
ERROR: modpost: "__raw_writesl" [drivers/i3c/master/i3c-master-cdns.ko] undefined!
ERROR: modpost: "__raw_readsl" [drivers/i3c/master/i3c-master-cdns.ko] undefined!

Export these symbols so that modules can use them without any errors.

Link: https://lkml.kernel.org/r/20211115174250.1994179-1-nathan@kernel.org
Link: https://lkml.kernel.org/r/20211115174250.1994179-2-nathan@kernel.org
Fixes: 013bf24c3829 ("Hexagon: Provide basic implementation and/or stubs for I/O routines.")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Brian Cain <bcain@codeaurora.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/lib/io.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/hexagon/lib/io.c~hexagon-export-raw-i-o-routines-for-modules
+++ a/arch/hexagon/lib/io.c
@@ -27,6 +27,7 @@ void __raw_readsw(const void __iomem *ad
 		*dst++ = *src;
 
 }
+EXPORT_SYMBOL(__raw_readsw);
 
 /*
  * __raw_writesw - read words a short at a time
@@ -47,6 +48,7 @@ void __raw_writesw(void __iomem *addr, c
 
 
 }
+EXPORT_SYMBOL(__raw_writesw);
 
 /*  Pretty sure len is pre-adjusted for the length of the access already */
 void __raw_readsl(const void __iomem *addr, void *data, int len)
@@ -62,6 +64,7 @@ void __raw_readsl(const void __iomem *ad
 
 
 }
+EXPORT_SYMBOL(__raw_readsl);
 
 void __raw_writesl(void __iomem *addr, const void *data, int len)
 {
@@ -76,3 +79,4 @@ void __raw_writesl(void __iomem *addr, c
 
 
 }
+EXPORT_SYMBOL(__raw_writesl);
_

Patches currently in -mm which might be from nathan@kernel.org are

hexagon-export-raw-i-o-routines-for-modules.patch
hexagon-clean-up-timer-regsh.patch
hexagon-ignore-vmlinuxlds.patch

