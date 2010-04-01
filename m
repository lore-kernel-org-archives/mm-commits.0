From: akpm@linux-foundation.org
Subject: + omap-hsmmc-fix-a-bug-in-card-remove-scenario.patch added to -mm tree
Date: Thu, 01 Apr 2010 16:27:24 -0700
Message-ID: <201004012327.o31NROAf015472__40158.5676278502$1270164499$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57534 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753175Ab0DAX2G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Apr 2010 19:28:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: madhu.cr@ti.com, adrian.hunter@nokia.com, linux-mmc@vger.kernel.org


The patch titled
     omap hsmmc: fix a bug in card remove scenario
has been added to the -mm tree.  Its filename is
     omap-hsmmc-fix-a-bug-in-card-remove-scenario.patch

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
Subject: omap hsmmc: fix a bug in card remove scenario
From: Madhusudhan Chikkature <madhu.cr@ti.com>

The reset of data lines when the card is removed from the cage results in
a failure.The failure is seen if the card is removed from the cage when TC
is pending after a CMD with data received CC.The reset logic leaves the
controller in a state where niether a TC is received nor DTO.

The rest code can be safely removed here since it is taken care in the IRQ
handler.

Signed-off-by: Madhusudhan Chikkature <madhu.cr@ti.com>
Cc: Adrian Hunter <adrian.hunter@nokia.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap_hsmmc.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN drivers/mmc/host/omap_hsmmc.c~omap-hsmmc-fix-a-bug-in-card-remove-scenario drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~omap-hsmmc-fix-a-bug-in-card-remove-scenario
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -1179,15 +1179,10 @@ static void omap_hsmmc_detect(struct wor
 		carddetect = -ENOSYS;
 	}
 
-	if (carddetect) {
+	if (carddetect)
 		mmc_detect_change(host->mmc, (HZ * 200) / 1000);
-	} else {
-		mmc_host_enable(host->mmc);
-		omap_hsmmc_reset_controller_fsm(host, SRD);
-		mmc_host_lazy_disable(host->mmc);
