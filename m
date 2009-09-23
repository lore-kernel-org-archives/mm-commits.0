From: akpm@linux-foundation.org
Subject: [merged] omap_hsmmc-cater-for-weird-cmd6-behaviour.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:55:09 -0700
Message-ID: <200909231955.n8NJt9NG002223@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60568 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753643AbZIWTzx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:55:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adrian.hunter@nokia.com, ext-denis.2.karpov@nokia.com, ian@mnementh.co.uk, jarkko.lavinen@nokia.com, linux-mmc@vger.kernel.org, madhu.cr@ti.com, matt@console-pimps.org, philipl@overt.


The patch titled
     omap_hsmmc: cater for weird CMD6 behaviour
has been removed from the -mm tree.  Its filename was
     omap_hsmmc-cater-for-weird-cmd6-behaviour.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: omap_hsmmc: cater for weird CMD6 behaviour
From: Adrian Hunter <adrian.hunter@nokia.com>

Sometimes the controller unexpectedly produces a TC (transfer complete)
interrupt before the CC (command complete) interrupt for command 6
(SWITCH).  This is a problem because the CC interrupt can get mixed up
with the next request.  Add a hack for CMD6.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
Acked-by: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Denis Karpov <ext-denis.2.karpov@nokia.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Philip Langdale <philipl@overt.org>
Cc: "Madhusudhan" <madhu.cr@ti.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap_hsmmc.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-cater-for-weird-cmd6-behaviour drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-cater-for-weird-cmd6-behaviour
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -481,6 +481,13 @@ mmc_omap_xfer_done(struct mmc_omap_host 
 	if (!data) {
 		struct mmc_request *mrq = host->mrq;
 
+		/* TC before CC from CMD6 - don't know why, but it happens */
+		if (host->cmd && host->cmd->opcode == 6 &&
+		    host->response_busy) {
+			host->response_busy = 0;
+			return;
+		}
+
 		host->mrq = NULL;
 		mmc_request_done(host->mmc, mrq);
 		return;
_

Patches currently in -mm which might be from adrian.hunter@nokia.com are

origin.patch

