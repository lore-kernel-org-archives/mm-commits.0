From: akpm@linux-foundation.org
Subject: + omap-hsmmc-fix-a-racing-case-between-kmmcd-and-omap_hsmmc_suspend.patch added to -mm tree
Date: Fri, 27 Aug 2010 13:58:40 -0700
Message-ID: <201008272058.o7RKweAH015685@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751034Ab0H0U6q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Aug 2010 16:58:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ethan.too@gmail.com, adrian.hunter@nokia.com, cjb@laptop.org, linux-mmc@vger.kernel.org, madhu.cr@ti.com


The patch titled
     omap hsmmc: fix a racing case between kmmcd and omap_hsmmc_suspend
has been added to the -mm tree.  Its filename is
     omap-hsmmc-fix-a-racing-case-between-kmmcd-and-omap_hsmmc_suspend.patch

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
Subject: omap hsmmc: fix a racing case between kmmcd and omap_hsmmc_suspend
From: Ethan Du <ethan.too@gmail.com>

If suspend called when kmmcd is doing host->ops->disable, as kmmcd already
increased host->en_dis_recurs to 1, the mmc_host_enable in suspend
function will return directly without increase the nesting_cnt, which will
cause the followed register access carried out to the disabled host.

mmc_suspend_host will enable host itself.  No need to enable host before
it.  Also works on kmmcd will get flushed in mmc_suspend_host, enable host
after it will be safe.  So make the mmc_host_enable after it.

[cjb: rebase against current Linus]
Signed-off-by: Ethan <ethan.too@gmail.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Acked-by: Adrian Hunter <adrian.hunter@nokia.com>
Acked-by: Madhusudhan Chikkature <madhu.cr@ti.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap_hsmmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/host/omap_hsmmc.c~omap-hsmmc-fix-a-racing-case-between-kmmcd-and-omap_hsmmc_suspend drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~omap-hsmmc-fix-a-racing-case-between-kmmcd-and-omap_hsmmc_suspend
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -2323,8 +2323,8 @@ static int omap_hsmmc_suspend(struct dev
 			}
 		}
 		cancel_work_sync(&host->mmc_carddetect_work);
-		mmc_host_enable(host->mmc);
 		ret = mmc_suspend_host(host->mmc);
+		mmc_host_enable(host->mmc);
 		if (ret == 0) {
 			omap_hsmmc_disable_irq(host);
 			OMAP_HSMMC_WRITE(host->base, HCTL,
_

Patches currently in -mm which might be from ethan.too@gmail.com are

omap-hsmmc-fix-a-racing-case-between-kmmcd-and-omap_hsmmc_suspend.patch

