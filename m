From: akpm@linux-foundation.org
Subject: + save-restore-device-configuration-space.patch added to -mm tree
Date: Tue, 20 May 2008 00:25:47 -0700
Message-ID: <200805200725.m4K7PlD9010888@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47572 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754000AbYETHZy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 03:25:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ranma+kernel@tdiedrich.de, aabdulla@nvidia.com


The patch titled
     forcedeth: save/restore device configuration space
has been added to the -mm tree.  Its filename is
     save-restore-device-configuration-space.patch

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
Subject: forcedeth: save/restore device configuration space
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>

The memory mapped device configuration space is lost during hibernate. 
Save and restore it (fixes 'swapped mac' problem).

Signed-off-by: TTobias Diedrich <ranma+kernel@tdiedrich.de>
Cc: Ayaz Abdulla <aabdulla@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/forcedeth.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff -puN drivers/net/forcedeth.c~save-restore-device-configuration-space drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~save-restore-device-configuration-space
+++ a/drivers/net/forcedeth.c
@@ -426,6 +426,7 @@ union ring_type {
 #define NV_PCI_REGSZ_VER1      	0x270
 #define NV_PCI_REGSZ_VER2      	0x2d4
 #define NV_PCI_REGSZ_VER3      	0x604
+#define NV_PCI_REGSZ_MAX       	0x604
 
 /* various timeout delays: all in usec */
 #define NV_TXRX_RESET_DELAY	4
@@ -784,6 +785,9 @@ struct fe_priv {
 
 	/* flow control */
 	u32 pause_flags;
+
+	/* power saved state */
+	u32 saved_config_space[NV_PCI_REGSZ_MAX/4];
 };
 
 /*
@@ -5793,6 +5797,8 @@ static int nv_suspend(struct pci_dev *pd
 {
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct fe_priv *np = netdev_priv(dev);
+	u8 __iomem *base = get_hwbase(dev);
+	int i;
 
 	if (!netif_running(dev))
 		goto out;
@@ -5802,6 +5808,10 @@ static int nv_suspend(struct pci_dev *pd
 	// Gross.
 	nv_close(dev);
 
+	/* save non-pci configuration space */
+	for (i = 0;i <= np->register_size/sizeof(u32); i++)
+		np->saved_config_space[i] = readl(base + i*sizeof(u32));
+
 	pci_save_state(pdev);
 	pci_enable_wake(pdev, pci_choose_state(pdev, state), np->wolenabled);
 	pci_set_power_state(pdev, pci_choose_state(pdev, state));
@@ -5812,9 +5822,9 @@ out:
 static int nv_resume(struct pci_dev *pdev)
 {
 	struct net_device *dev = pci_get_drvdata(pdev);
+	struct fe_priv *np = netdev_priv(dev);
 	u8 __iomem *base = get_hwbase(dev);
-	int rc = 0;
-	u32 txreg;
+	int i, rc = 0;
 
 	if (!netif_running(dev))
 		goto out;
@@ -5825,10 +5835,9 @@ static int nv_resume(struct pci_dev *pde
 	pci_restore_state(pdev);
 	pci_enable_wake(pdev, PCI_D0, 0);
 
-	/* restore mac address reverse flag */
-	txreg = readl(base + NvRegTransmitPoll);
-	txreg |= NVREG_TRANSMITPOLL_MAC_ADDR_REV;
-	writel(txreg, base + NvRegTransmitPoll);
+	/* restore non-pci configuration space */
+	for (i = 0;i <= np->register_size/sizeof(u32); i++)
+		writel(np->saved_config_space[i], base+i*sizeof(u32));
 
 	rc = nv_open(dev);
 	nv_set_multicast(dev);
_

Patches currently in -mm which might be from ranma+kernel@tdiedrich.de are

restore-multicast-settings-on-resume.patch
setup-wake-on-lan-before-shutting-down.patch
save-restore-device-configuration-space.patch
reorder-suspend-resume-code.patch

