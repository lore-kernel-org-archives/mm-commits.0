From: akpm@linux-foundation.org
Subject: + tmio_mmc-use-100ms-mmc_detect_change-delay.patch added to -mm tree
Date: Tue, 16 Feb 2010 14:51:34 -0800
Message-ID: <201002162251.o1GMpYsV009935@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52185 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933312Ab0BPWvo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Feb 2010 17:51:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: damm@opensource.se, ian@mnementh.co.uk, lethal@linux-sh.org, linux-mmc@vger.kernel.org, philipp.zabel@gmail.com, pierre@ossman.eu


The patch titled
     tmio_mmc: use 100ms mmc_detect_change() delay
has been added to the -mm tree.  Its filename is
     tmio_mmc-use-100ms-mmc_detect_change-delay.patch

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
Subject: tmio_mmc: use 100ms mmc_detect_change() delay
From: Magnus Damm <damm@opensource.se>

Change the tmio_mmc driver to wait 100ms before checking the card detect
status.  This type of delay is quite common among mmc drivers, it seems
that most hardware platforms need to give the hardware some time to settle
before checking card availabilty.

Hotplug is half-broken without this patch on the sh7724 Ecovec board.  Hot
plugging seems ok but eject is never detected without this patch.

Signed-off-by: Magnus Damm <damm@opensource.se>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Philipp Zabel <philipp.zabel@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/tmio_mmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/host/tmio_mmc.c~tmio_mmc-use-100ms-mmc_detect_change-delay drivers/mmc/host/tmio_mmc.c
--- a/drivers/mmc/host/tmio_mmc.c~tmio_mmc-use-100ms-mmc_detect_change-delay
+++ a/drivers/mmc/host/tmio_mmc.c
@@ -332,7 +332,7 @@ static irqreturn_t tmio_mmc_irq(int irq,
 		if (ireg & (TMIO_STAT_CARD_INSERT | TMIO_STAT_CARD_REMOVE)) {
 			ack_mmc_irqs(host, TMIO_STAT_CARD_INSERT |
 				TMIO_STAT_CARD_REMOVE);
-			mmc_detect_change(host->mmc, 0);
+			mmc_detect_change(host->mmc, msecs_to_jiffies(100));
 		}
 
 		/* CRC and other errors */
_

Patches currently in -mm which might be from damm@opensource.se are

linux-next.patch
clocksource-add-argument-to-resume-callback.patch
clocksource-start-cmt-at-clocksource-resume.patch
clocksource-add-suspend-callback.patch
mmc-remove-const-from-tmio-mmc-platform-data-v2.patch
mmc-balance-tmio-mmc-cell-enable-disable-calls.patch
tmio_mmc-use-100ms-mmc_detect_change-delay.patch
tmio_mmc-keep-card-detect-interrupts-enabled.patch

