From: akpm@linux-foundation.org
Subject: + e100-do-suspend-shutdown-like-e1000.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:31:48 -0800
Message-ID: <200802230732.m1N7Wb0f018085@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42738 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752545AbYBWHyD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:54:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: auke-jan.h.kok@intel.com, arvidjaar@mail.ru


The patch titled
     e100: Do suspend/shutdown like e1000
has been added to the -mm tree.  Its filename is
     e100-do-suspend-shutdown-like-e1000.patch

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
Subject: e100: Do suspend/shutdown like e1000
From: "Kok, Auke" <auke-jan.h.kok@intel.com>

This fixes a "trying to free already free IRQ" message and simplifies the
shutdown/suspend code by re-using already existing code when going to
suspend.  The code is now symmetric with e100_resume.

Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
Tested-by: Andrey Borzenkov <arvidjaar@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e100.c |   29 +++--------------------------
 1 file changed, 3 insertions(+), 26 deletions(-)

diff -puN drivers/net/e100.c~e100-do-suspend-shutdown-like-e1000 drivers/net/e100.c
--- a/drivers/net/e100.c~e100-do-suspend-shutdown-like-e1000
+++ a/drivers/net/e100.c
@@ -2782,16 +2782,13 @@ static void __devexit e100_remove(struct
 	}
 }
 
-#ifdef CONFIG_PM
 static int e100_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct nic *nic = netdev_priv(netdev);
 
 	if (netif_running(netdev))
-		napi_disable(&nic->napi);
-	del_timer_sync(&nic->watchdog);
-	netif_carrier_off(nic->netdev);
+		e100_down(nic);
 	netif_device_detach(netdev);
 
 	pci_save_state(pdev);
@@ -2804,14 +2801,13 @@ static int e100_suspend(struct pci_dev *
 		pci_enable_wake(pdev, PCI_D3cold, 0);
 	}
 
-	free_irq(pdev->irq, netdev);
-
 	pci_disable_device(pdev);
 	pci_set_power_state(pdev, PCI_D3hot);
 
 	return 0;
 }
 
+#ifdef CONFIG_PM
 static int e100_resume(struct pci_dev *pdev)
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
@@ -2832,26 +2828,7 @@ static int e100_resume(struct pci_dev *p
 
 static void e100_shutdown(struct pci_dev *pdev)
 {
-	struct net_device *netdev = pci_get_drvdata(pdev);
-	struct nic *nic = netdev_priv(netdev);
-
-	if (netif_running(netdev))
-		napi_disable(&nic->napi);
-	del_timer_sync(&nic->watchdog);
-	netif_carrier_off(nic->netdev);
-
-	if ((nic->flags & wol_magic) | e100_asf(nic)) {
-		pci_enable_wake(pdev, PCI_D3hot, 1);
-		pci_enable_wake(pdev, PCI_D3cold, 1);
-	} else {
-		pci_enable_wake(pdev, PCI_D3hot, 0);
-		pci_enable_wake(pdev, PCI_D3cold, 0);
-	}
-
-	free_irq(pdev->irq, netdev);
-
-	pci_disable_device(pdev);
-	pci_set_power_state(pdev, PCI_D3hot);
+	e100_suspend(pdev, PMSG_SUSPEND);
 }
 
 /* ------------------ PCI Error Recovery infrastructure  -------------- */
_

Patches currently in -mm which might be from auke-jan.h.kok@intel.com are

git-net.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
e100-do-suspend-shutdown-like-e1000.patch
