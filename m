From: akpm@linux-foundation.org
Subject: + atmel_lcdfb-adjust-fifo-size-for-at91sam9rl.patch added to -mm tree
Date: Mon, 10 Mar 2008 22:50:25 -0700
Message-ID: <200803110550.m2B5oPgl025001@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40883 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753336AbYCKFwW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Mar 2008 01:52:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nicolas.ferre@atmel.com, adaplas@pol.net, andrew@sanpeople.com, nicolas.ferre@rfo.atmel.com


The patch titled
     atmel_lcdfb: adjust fifo size for at91sam9rl
has been added to the -mm tree.  Its filename is
     atmel_lcdfb-adjust-fifo-size-for-at91sam9rl.patch

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
Subject: atmel_lcdfb: adjust fifo size for at91sam9rl
From: Nicolas Ferre <nicolas.ferre@atmel.com>

AT91SAM9RL soc has a 2048 bytes deep FIFO, like AT91SAM9263.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Nicolas FERRE <nicolas.ferre@rfo.atmel.com>
Cc: Andrew Victor <andrew@sanpeople.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/atmel_lcdfb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/video/atmel_lcdfb.c~atmel_lcdfb-adjust-fifo-size-for-at91sam9rl drivers/video/atmel_lcdfb.c
--- a/drivers/video/atmel_lcdfb.c~atmel_lcdfb-adjust-fifo-size-for-at91sam9rl
+++ a/drivers/video/atmel_lcdfb.c
@@ -31,7 +31,8 @@
 #define ATMEL_LCDC_CVAL_DEFAULT		0xc8
 #define ATMEL_LCDC_DMA_BURST_LEN	8
 
-#if defined(CONFIG_ARCH_AT91SAM9263) || defined(CONFIG_ARCH_AT91CAP9)
+#if defined(CONFIG_ARCH_AT91SAM9263) || defined(CONFIG_ARCH_AT91CAP9) || |
+	defined(CONFIG_ARCH_AT91SAM9RL)
 #define ATMEL_LCDC_FIFO_SIZE		2048
 #else
 #define ATMEL_LCDC_FIFO_SIZE		512
_

Patches currently in -mm which might be from nicolas.ferre@atmel.com are

git-arm-master.patch
atmel_lcdfb-suspend-resume-support.patch
atmel_lcdfb-wiring-bgr-to-rgb-color-mode.patch
atmel_lcdfb-adjust-fifo-size-for-at91sam9rl.patch

