From: akpm@linux-foundation.org
Subject: + atyfb-properly-save-pci-state-before-changing-pci-pm-level.patch added to -mm tree
Date: Thu, 05 Feb 2009 13:34:09 -0800
Message-ID: <200902052134.n15LYARN005625@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37711 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754743AbZBEVfX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2009 16:35:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benh@kernel.crashing.org, geert@linux-m68k.org, khc@pm.waw.pl, rjw@sisk.pl


The patch titled
     atyfb: properly save PCI state before changing PCI PM level
has been added to the -mm tree.  Its filename is
     atyfb-properly-save-pci-state-before-changing-pci-pm-level.patch

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
Subject: atyfb: properly save PCI state before changing PCI PM level
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

This fixes atyfb to properly save the PCI config space -before- it
potentially switches the PM state of the chip.  This avoids a warning with
the new PM core and is the right thing to do anyway.

I also slightly cleaned up the code that checks whether we are running on
a PowerMac to do a runtime check instead of a compile check only, and
replaced a deprecated number with the proper symbolic constant.

Finally, I removed the useless switch to D0 from resume since the core
does it for us.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/atyfb_base.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff -puN drivers/video/aty/atyfb_base.c~atyfb-properly-save-pci-state-before-changing-pci-pm-level drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~atyfb-properly-save-pci-state-before-changing-pci-pm-level
+++ a/drivers/video/aty/atyfb_base.c
@@ -1978,7 +1978,7 @@ static int aty_power_mgmt(int sleep, str
 
 	return timeout ? 0 : -EIO;
 }
-#endif
+#endif /* CONFIG_PPC_PMAC */
 
 static int atyfb_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 {
@@ -2002,9 +2002,15 @@ static int atyfb_pci_suspend(struct pci_
 	par->asleep = 1;
 	par->lock_blank = 1;
 
+	/* Because we may change PCI D state ourselves, we need to
+	 * first save the config space content so the core can
+	 * restore it properly on resume.
+	 */
+	pci_save_state(pdev);
+
 #ifdef CONFIG_PPC_PMAC
 	/* Set chip to "suspend" mode */
-	if (aty_power_mgmt(1, par)) {
+	if (machine_is(powermac) && aty_power_mgmt(1, par)) {
 		par->asleep = 0;
 		par->lock_blank = 0;
 		atyfb_blank(FB_BLANK_UNBLANK, info);
@@ -2047,11 +2053,15 @@ static int atyfb_pci_resume(struct pci_d
 
 	acquire_console_sem();
 
+	/* PCI state will have been restored by the core, so
+	 * we should be in D0 now with our config space fully
+	 * restored
+	 */
+
 #ifdef CONFIG_PPC_PMAC
-	if (pdev->dev.power.power_state.event == 2)
+	if (machine_is(powermac) &&
+	    pdev->dev.power.power_state.event == PM_EVENT_SUSPEND)
 		aty_power_mgmt(0, par);
-#else
-	pci_set_power_state(pdev, PCI_D0);
 #endif
 
 	aty_resume_chip(info);
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

origin.patch
atyfb-fix-config_-namespace-violations.patch
linux-next.patch
arch-powerpc-eliminate-double-sizeof.patch
arch-powerpc-eliminate-double-sizeof-checkpatch-fixes.patch
atyfb-properly-save-pci-state-before-changing-pci-pm-level.patch
aty128fb-properly-save-pci-state-before-changing-pci-pm-level.patch
radeonfb-fix-resume-from-d3cold-on-some-platforms.patch
powerpc-fix-code-for-reserved-memory-spanning-across-nodes.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
spi_mpc83xx-fix-sparse-warnings.patch
spi_mpc83xx-rework-chip-selects-handling.patch
spi_mpc83xx-add-of-platform-driver-bindings.patch
powerpc-add-mmc-spi-slot-bindings.patch
powerpc-83xx-add-mmc-spi-support-via-the-device-tree-for-mpc8323e-rdb.patch
powerpc-fsl_soc-isolate-legacy-fsl_spi-support-to-mpc832x_rdb-boards.patch
atyfb-fix-header-file-trailing-whitespace.patch
edac-new-ppc4xx-driver-module.patch

