From: akpm@linux-foundation.org
Subject: - atl1-add-shutdown-callback.patch removed from -mm tree
Date: Tue, 13 May 2008 14:34:51 -0700
Message-ID: <200805132134.m4DLYp2E000962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58916 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760778AbYEMVe6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:34:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jacliburn@bellsouth.net, pelle@dsv.su.se, mm-commits@vger.kernel.org


The patch titled
     atl1: add shutdown callback
has been removed from the -mm tree.  Its filename was
     atl1-add-shutdown-callback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atl1: add shutdown callback
From: Jay Cliburn <jacliburn@bellsouth.net>

Add a shutdown callback that points to atl1_suspend().  This, along with a
working suspend function, fixes wake-on-lan.

Tested-by: Per Olofsson <pelle@dsv.su.se>
Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/atlx/atl1.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN drivers/net/atlx/atl1.c~atl1-add-shutdown-callback drivers/net/atlx/atl1.c
--- a/drivers/net/atlx/atl1.c~atl1-add-shutdown-callback
+++ a/drivers/net/atlx/atl1.c
@@ -36,7 +36,6 @@
  * A very incomplete list of things that need to be dealt with:
  *
  * TODO:
- * Wake on LAN.
  * Add more ethtool functions.
  * Fix abstruse irq enable/disable condition described here:
  *	http://marc.theaimsgroup.com/?l=linux-netdev&m=116398508500553&w=2
@@ -2908,6 +2907,13 @@ static int atl1_resume(struct pci_dev *p
 #define atl1_resume NULL
 #endif
 
+static void atl1_shutdown(struct pci_dev *pdev)
+{
+#ifdef CONFIG_PM
+	atl1_suspend(pdev, PMSG_SUSPEND);
+#endif
+}
+
 #ifdef CONFIG_NET_POLL_CONTROLLER
 static void atl1_poll_controller(struct net_device *netdev)
 {
@@ -3154,7 +3160,8 @@ static struct pci_driver atl1_driver = {
 	.probe = atl1_probe,
 	.remove = __devexit_p(atl1_remove),
 	.suspend = atl1_suspend,
-	.resume = atl1_resume
+	.resume = atl1_resume,
+	.shutdown = atl1_shutdown
 };
 
 /*
_

Patches currently in -mm which might be from jacliburn@bellsouth.net are

git-net.patch

