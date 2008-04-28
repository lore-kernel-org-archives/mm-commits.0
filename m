From: akpm@linux-foundation.org
Subject: + atmel_lcdfb-adjust-fifo-size-for-at91sam9rl-fix.patch added to -mm tree
Date: Sun, 27 Apr 2008 23:21:27 -0700
Message-ID: <200804280621.m3S6LQPM011468@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753314AbYD1GYb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 02:24:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bn@niasdigital.com, adaplas@pol.net, andrew@sanpeople.com, nicolas.ferre@atmel.com, nicolas.ferre@rfo.atmel.com


The patch titled
     Fix build breakage in atmel_lcdfb
has been added to the -mm tree.  Its filename is
     atmel_lcdfb-adjust-fifo-size-for-at91sam9rl-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix build breakage in atmel_lcdfb
From: Ben Nizette <bn@niasdigital.com>

mm patch atmel_lcdfb-adjust-fifo-size-for-at91sam9rl.patch introduces a
build breakage; someone forgot to release shift ;-)

Signed-off-by: Ben Nizette <bn@niasdigital.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Nicolas FERRE <nicolas.ferre@rfo.atmel.com>
Cc: Andrew Victor <andrew@sanpeople.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/atmel_lcdfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/atmel_lcdfb.c~atmel_lcdfb-adjust-fifo-size-for-at91sam9rl-fix drivers/video/atmel_lcdfb.c
--- a/drivers/video/atmel_lcdfb.c~atmel_lcdfb-adjust-fifo-size-for-at91sam9rl-fix
+++ a/drivers/video/atmel_lcdfb.c
@@ -31,7 +31,7 @@
 #define ATMEL_LCDC_CVAL_DEFAULT		0xc8
 #define ATMEL_LCDC_DMA_BURST_LEN	8
 
-#if defined(CONFIG_ARCH_AT91SAM9263) || defined(CONFIG_ARCH_AT91CAP9) || |
+#if defined(CONFIG_ARCH_AT91SAM9263) || defined(CONFIG_ARCH_AT91CAP9) || \
 	defined(CONFIG_ARCH_AT91SAM9RL)
 #define ATMEL_LCDC_FIFO_SIZE		2048
 #else
_

Patches currently in -mm which might be from bn@niasdigital.com are

origin.patch
atmel_lcdfb-adjust-fifo-size-for-at91sam9rl-fix.patch

