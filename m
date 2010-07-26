From: akpm@linux-foundation.org
Subject: + tmio_mmc-make-ack_mmc_irqs-write-only.patch added to -mm tree
Date: Mon, 26 Jul 2010 16:05:56 -0700
Message-ID: <201007262305.o6QN5ugY015175@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52978 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751874Ab0GZXGe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jul 2010 19:06:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yusuke.goda.sx@renesas.com, damm@opensource.se, ian@mnementh.co.uk, lethal@linux-sh.org


The patch titled
     tmio_mmc: make ack_mmc_irqs() write-only
has been added to the -mm tree.  Its filename is
     tmio_mmc-make-ack_mmc_irqs-write-only.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tmio_mmc: make ack_mmc_irqs() write-only
From: Yusuke Goda <yusuke.goda.sx@renesas.com>

Update ack_mmc_irqs() to acknowledge using write instead of
read-modify-write.  Without this fix the old read-modify-write
implementation may acknowledge interrupt sources by mistake.  The driver
may if so lock-up waiting forever for an interrupt that will never come. 
Observed with the TMIO_STAT_RXRDY bit together with CMD53 on AR6002 and
BCM4318 SDIO cards in polled mode.

Signed-off-by: Yusuke Goda <yusuke.goda.sx@renesas.com>
Tested-by: Magnus Damm <damm@opensource.se>
Acked-by: Magnus Damm <damm@opensource.se>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/tmio_mmc.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/mmc/host/tmio_mmc.h~tmio_mmc-make-ack_mmc_irqs-write-only drivers/mmc/host/tmio_mmc.h
--- a/drivers/mmc/host/tmio_mmc.h~tmio_mmc-make-ack_mmc_irqs-write-only
+++ a/drivers/mmc/host/tmio_mmc.h
@@ -82,10 +82,7 @@
 
 #define ack_mmc_irqs(host, i) \
 	do { \
-		u32 mask;\
-		mask  = sd_ctrl_read32((host), CTL_STATUS); \
-		mask &= ~((i) & TMIO_MASK_IRQ); \
-		sd_ctrl_write32((host), CTL_STATUS, mask); \
+		sd_ctrl_write32((host), CTL_STATUS, ~(i)); \
 	} while (0)
 
 
_

Patches currently in -mm which might be from yusuke.goda.sx@renesas.com are

tmio_mmc-make-ack_mmc_irqs-write-only.patch
tmio_mmc-prevent-unexpected-status-clear.patch
tmio_mmc-allow-2-byte-requests-in-4-bit-mode.patch

