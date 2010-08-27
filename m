From: akpm@linux-foundation.org
Subject: + mmc-sdhci-make-consistent-use-of-config_mmc_debug-for-debugging.patch added to -mm tree
Date: Fri, 27 Aug 2010 12:29:59 -0700
Message-ID: <201008271929.o7RJTxFF011390__29692.5838375047$1282937430$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40908 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752338Ab0H0TaZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Aug 2010 15:30:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gdavis@mvista.com, ben-linux@fluff.org, cjb@laptop.org, linux-mmc@vger.kernel.org


The patch titled
     mmc: sdhci: make consistent use of CONFIG_MMC_DEBUG for "DEBUG"ging
has been added to the -mm tree.  Its filename is
     mmc-sdhci-make-consistent-use-of-config_mmc_debug-for-debugging.patch

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
Subject: mmc: sdhci: make consistent use of CONFIG_MMC_DEBUG for "DEBUG"ging
From: "George G. Davis" <gdavis@mvista.com>

The "6882a8c sdhci: Add better ADMA error reporting" commit added
sdhci_show_adma_error() which is built when DEBUG is defined.  Since we
already have CONFIG_MMC_DEBUG used elsewhere in this driver, may as well
make consistent use of that config knob instead.

Signed-off-by: George G. Davis <gdavis@mvista.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/host/sdhci.c~mmc-sdhci-make-consistent-use-of-config_mmc_debug-for-debugging drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~mmc-sdhci-make-consistent-use-of-config_mmc_debug-for-debugging
+++ a/drivers/mmc/host/sdhci.c
@@ -1440,7 +1440,7 @@ static void sdhci_cmd_irq(struct sdhci_h
 		sdhci_finish_command(host);
 }
 
-#ifdef DEBUG
+#ifdef CONFIG_MMC_DEBUG
 static void sdhci_show_adma_error(struct sdhci_host *host)
 {
 	const char *name = mmc_hostname(host->mmc);
_

Patches currently in -mm which might be from gdavis@mvista.com are

mmc-sdhci-make-consistent-use-of-config_mmc_debug-for-debugging.patch

