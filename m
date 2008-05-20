From: akpm@linux-foundation.org
Subject: + setup-wake-on-lan-before-shutting-down.patch added to -mm tree
Date: Tue, 20 May 2008 00:25:45 -0700
Message-ID: <200805200725.m4K7Pja8010885@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752837AbYETHZx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 03:25:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ranma+kernel@tdiedrich.de, aabdulla@nvidia.com


The patch titled
     forcedeth: setup wake-on-lan before shutting down
has been added to the -mm tree.  Its filename is
     setup-wake-on-lan-before-shutting-down.patch

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
Subject: forcedeth: setup wake-on-lan before shutting down
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>

When hibernating in 'shutdown' mode, after saving the image the suspend
hook is not called again.  However, if the device is in promiscous mode,
wake-on-lan will not work.  This adds a shutdown hook to setup wake-on-lan
before the final shutdown.

Signed-off-by: Tobias Diedrich <ranma+kernel@tdiedrich.de>
Cc: Ayaz Abdulla <aabdulla@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/forcedeth.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN drivers/net/forcedeth.c~setup-wake-on-lan-before-shutting-down drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~setup-wake-on-lan-before-shutting-down
+++ a/drivers/net/forcedeth.c
@@ -5835,8 +5835,23 @@ static int nv_resume(struct pci_dev *pde
 out:
 	return rc;
 }
+
+static void nv_shutdown(struct pci_dev *pdev)
+{
+	struct net_device *dev = pci_get_drvdata(pdev);
+	struct fe_priv *np = netdev_priv(dev);
+
+	if (netif_running(dev))
+		nv_close(dev);
+
+	pci_enable_wake(pdev, PCI_D3hot, np->wolenabled);
+	pci_enable_wake(pdev, PCI_D3cold, np->wolenabled);
+	pci_disable_device(pdev);
+	pci_set_power_state(pdev, PCI_D3hot);
+}
 #else
 #define nv_suspend NULL
+#define nv_shutdown NULL
 #define nv_resume NULL
 #endif /* CONFIG_PM */
 
@@ -6007,6 +6022,7 @@ static struct pci_driver driver = {
 	.remove		= __devexit_p(nv_remove),
 	.suspend	= nv_suspend,
 	.resume		= nv_resume,
+	.shutdown	= nv_shutdown,
 };
 
 static int __init init_nic(void)
_

Patches currently in -mm which might be from ranma+kernel@tdiedrich.de are

restore-multicast-settings-on-resume.patch
setup-wake-on-lan-before-shutting-down.patch
save-restore-device-configuration-space.patch
reorder-suspend-resume-code.patch

