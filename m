From: akpm@linux-foundation.org
Subject: + mmc-omap-using-setup_timer-instead-of-init_timer.patch added to -mm tree
Date: Mon, 17 Mar 2008 15:27:31 -0700
Message-ID: <200803172227.m2HMRV2o001549@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753547AbYCQW1p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 18:27:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: carlos.aguiar@indt.org.br, drzeus-list@drzeus.cx, tony@atomide.com


The patch titled
     mmc: omap: using setup_timer instead of init_timer
has been added to the -mm tree.  Its filename is
     mmc-omap-using-setup_timer-instead-of-init_timer.patch

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
Subject: mmc: omap: using setup_timer instead of init_timer
From: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>

Using setup_timer() instead of init_timer() on omap.c file.

Signed-off-by: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff -puN drivers/mmc/host/omap.c~mmc-omap-using-setup_timer-instead-of-init_timer drivers/mmc/host/omap.c
--- a/drivers/mmc/host/omap.c~mmc-omap-using-setup_timer-instead-of-init_timer
+++ a/drivers/mmc/host/omap.c
@@ -1245,9 +1245,8 @@ static int __init mmc_omap_new_slot(stru
 			goto err_remove_slot_name;
 
 		INIT_WORK(&slot->switch_work, mmc_omap_cover_handler);
-		init_timer(&slot->switch_timer);
-		slot->switch_timer.function = mmc_omap_switch_timer;
-		slot->switch_timer.data = (unsigned long) slot;
+		setup_timer(&slot->switch_timer, mmc_omap_switch_timer,
+			    (unsigned long) slot);
 		schedule_work(&slot->switch_work);
 	}
 
@@ -1324,18 +1323,13 @@ static int __init mmc_omap_probe(struct 
 	}
 
 	INIT_WORK(&host->cmd_abort, mmc_omap_abort_command);
-	init_timer(&host->cmd_timer);
-	host->cmd_timer.function = mmc_omap_cmd_timer;
-	host->cmd_timer.data = (unsigned long) host;
+	setup_timer(&host->cmd_timer, mmc_omap_cmd_timer, (unsigned long) host);
 
 	spin_lock_init(&host->dma_lock);
-	init_timer(&host->dma_timer);
+	setup_timer(&host->dma_timer, mmc_omap_dma_timer, (unsigned long) host);
 	spin_lock_init(&host->slot_lock);
 	init_waitqueue_head(&host->slot_wq);
 
-	host->dma_timer.function = mmc_omap_dma_timer;
-	host->dma_timer.data = (unsigned long) host;
