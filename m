From: akpm@linux-foundation.org
Subject: + mmc-omap-remove-some-opcodes-from-host-driver.patch added to -mm tree
Date: Mon, 17 Mar 2008 15:27:07 -0700
Message-ID: <200803172227.m2HMR7qg001516@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39852 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752542AbYCQW1Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 18:27:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: carlos.aguiar@indt.org.br, drzeus-list@drzeus.cx, tony@atomide.com


The patch titled
     mmc: omap: remove some opcodes from host driver
has been added to the -mm tree.  Its filename is
     mmc-omap-remove-some-opcodes-from-host-driver.patch

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
Subject: mmc: omap: remove some opcodes from host driver
From: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>

This patch removes some opcodes from host driver so there's no need on putting
'#include <linux/mmc/mmc.h>', that should not be needed in host drivers.

Signed-off-by: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN drivers/mmc/host/omap.c~mmc-omap-remove-some-opcodes-from-host-driver drivers/mmc/host/omap.c
--- a/drivers/mmc/host/omap.c~mmc-omap-remove-some-opcodes-from-host-driver
+++ a/drivers/mmc/host/omap.c
@@ -495,15 +495,10 @@ static irqreturn_t mmc_omap_irq(int irq,
 		if (status & OMAP_MMC_STAT_CMD_TOUT) {
 			/* Timeouts are routine with some commands */
 			if (host->cmd) {
-				if (host->cmd->opcode != MMC_ALL_SEND_CID &&
-						host->cmd->opcode !=
-						MMC_SEND_OP_COND &&
-						host->cmd->opcode !=
-						MMC_APP_CMD &&
-						!mmc_omap_cover_is_open(host))
+				if (!mmc_omap_cover_is_open(host))
 					dev_err(mmc_dev(host->mmc),
-						"command timeout, CMD %d\n",
-						host->cmd->opcode);
+					"command timeout, CMD %d\n",
+					host->cmd->opcode);
 				host->cmd->error = -ETIMEDOUT;
 				end_command = 1;
 			}
_

Patches currently in -mm which might be from carlos.aguiar@indt.org.br are

mmc-omap-remove-some-opcodes-from-host-driver.patch
mmc-omap-remove-extra-divisor-increase.patch
mmc-omap-fix-the-byteblock-capability-removal.patch
mmc-omap-remove-cover-switch-handling-to-allow-adding-multislot-support.patch
mmc-omap-introduce-new-multislot-structure-and-change-driver-to-use-it.patch
mmc-omap-add-back-cover-switch-support.patch
mmc-omap-new-release-dma-and-abort-xfer-functions.patch
mmc-omap-fix-timeout-calculation-for-mmc-multislot-support.patch
mmc-omap-power-functions-modified-to-mmc-multislot-support.patch
mmc-omap-general-cleanup-for-mmc-multislot-support.patch
mmc-omap-abort-stuck-commands.patch
mmc-omap-using-setup_timer-instead-of-init_timer.patch

