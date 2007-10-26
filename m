From: akpm@linux-foundation.org
Subject: - watchdog-fix-if-n-if-cases-missing-semicolons-when-false.patch removed from -mm tree
Date: Fri, 26 Oct 2007 11:48:31 -0700
Message-ID: <200710261848.l9QImVB2009146@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45569 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761166AbXJZSsr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Oct 2007 14:48:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ilpo.jarvinen@helsinki.fi, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     watchdog: fix if (...) \n #if... cases missing semicolons when fal=
se
has been removed from the -mm tree.  Its filename was
     watchdog-fix-if-n-if-cases-missing-semicolons-when-false.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
Subject: watchdog: fix if (...) \n #if... cases missing semicolons when=
 false
=46rom: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>

Signed-off-by: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/wdt.c     |    3 ++-
 drivers/watchdog/wdt_pci.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/osst.c~watchdog-fix-if-n-if-cases-missing-semico=
lons-when-false drivers/scsi/osst.c
diff -puN drivers/watchdog/wdt.c~watchdog-fix-if-n-if-cases-missing-sem=
icolons-when-false drivers/watchdog/wdt.c
--- a/drivers/watchdog/wdt.c~watchdog-fix-if-n-if-cases-missing-semicol=
ons-when-false
+++ a/drivers/watchdog/wdt.c
@@ -253,7 +253,7 @@ static irqreturn_t wdt_interrupt(int irq
 			printk(KERN_CRIT "Possible fan fault.\n");
 	}
 #endif /* CONFIG_WDT_501 */
-	if (!(status & WDC_SR_WCCR))
+	if (!(status & WDC_SR_WCCR)) {
 #ifdef SOFTWARE_REBOOT
 #ifdef ONLY_TESTING
 		printk(KERN_CRIT "Would Reboot.\n");
@@ -264,6 +264,7 @@ static irqreturn_t wdt_interrupt(int irq
 #else
 		printk(KERN_CRIT "Reset in 5ms.\n");
 #endif
+	}
 	return IRQ_HANDLED;
 }
=20
diff -puN drivers/watchdog/wdt_pci.c~watchdog-fix-if-n-if-cases-missing=
-semicolons-when-false drivers/watchdog/wdt_pci.c
--- a/drivers/watchdog/wdt_pci.c~watchdog-fix-if-n-if-cases-missing-sem=
icolons-when-false
+++ a/drivers/watchdog/wdt_pci.c
@@ -298,7 +298,7 @@ static irqreturn_t wdtpci_interrupt(int=20
 			printk(KERN_CRIT PFX "Possible fan fault.\n");
 	}
 #endif /* CONFIG_WDT_501_PCI */
-	if (!(status&WDC_SR_WCCR))
+	if (!(status&WDC_SR_WCCR)) {
 #ifdef SOFTWARE_REBOOT
 #ifdef ONLY_TESTING
 		printk(KERN_CRIT PFX "Would Reboot.\n");
@@ -309,6 +309,7 @@ static irqreturn_t wdtpci_interrupt(int=20
 #else
 		printk(KERN_CRIT PFX "Reset in 5ms.\n");
 #endif
+	}
 	return IRQ_HANDLED;
 }
=20
_

Patches currently in -mm which might be from ilpo.jarvinen@helsinki.fi =
are

origin.patch
scsi-fix-if-n-if-cases-missing-semicolons-when-false.patch
git-watchdog.patch
