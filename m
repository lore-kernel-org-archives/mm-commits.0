From: akpm@linux-foundation.org
Subject: + tmio_mmc-keep-card-detect-interrupts-enabled.patch added to -mm tree
Date: Tue, 16 Feb 2010 13:52:03 -0800
Message-ID: <201002162152.o1GLq3Wj007162@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43382 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933341Ab0BPVwx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Feb 2010 16:52:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: g.liakhovetski@gmx.de, a.beregalov@gmail.com, damm@opensource.se, ian@mnementh.co.uk, lethal@linux-sh.org, linux-mmc@vger.kernel.org, pierre@ossman.eu


The patch titled
     tmio_mmc: keep card-detect interrupts enabled
has been added to the -mm tree.  Its filename is
     tmio_mmc-keep-card-detect-interrupts-enabled.patch

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
Subject: tmio_mmc: keep card-detect interrupts enabled
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

On SuperH platforms the SDHI controller does not produce any command IRQs after
a completed IO. This leads to card-detect interrupts staying disabled. Do not
disable card-detect interrupts on DATA IRQs.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: Magnus Damm <damm@opensource.se>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/tmio_mmc.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/mmc/host/tmio_mmc.h~tmio_mmc-keep-card-detect-interrupts-enabled drivers/mmc/host/tmio_mmc.h
--- a/drivers/mmc/host/tmio_mmc.h~tmio_mmc-keep-card-detect-interrupts-enabled
+++ a/drivers/mmc/host/tmio_mmc.h
@@ -55,10 +55,8 @@
 /* Define some IRQ masks */
 /* This is the mask used at reset by the chip */
 #define TMIO_MASK_ALL           0x837f031d
-#define TMIO_MASK_READOP  (TMIO_STAT_RXRDY | TMIO_STAT_DATAEND | \
-		TMIO_STAT_CARD_REMOVE | TMIO_STAT_CARD_INSERT)
-#define TMIO_MASK_WRITEOP (TMIO_STAT_TXRQ | TMIO_STAT_DATAEND | \
-		TMIO_STAT_CARD_REMOVE | TMIO_STAT_CARD_INSERT)
+#define TMIO_MASK_READOP  (TMIO_STAT_RXRDY | TMIO_STAT_DATAEND)
+#define TMIO_MASK_WRITEOP (TMIO_STAT_TXRQ | TMIO_STAT_DATAEND)
 #define TMIO_MASK_CMD     (TMIO_STAT_CMDRESPEND | TMIO_STAT_CMDTIMEOUT | \
 		TMIO_STAT_CARD_REMOVE | TMIO_STAT_CARD_INSERT)
 #define TMIO_MASK_IRQ     (TMIO_MASK_READOP | TMIO_MASK_WRITEOP | TMIO_MASK_CMD)
_

Patches currently in -mm which might be from g.liakhovetski@gmx.de are

linux-next.patch
tmio_mmc-keep-card-detect-interrupts-enabled.patch

