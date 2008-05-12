From: akpm@linux-foundation.org
Subject: + atl1-add-shutdown-callback.patch added to -mm tree
Date: Mon, 12 May 2008 15:23:33 -0700
Message-ID: <200805122223.m4CMNX1S012126@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56235 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754340AbYELWYN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 18:24:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jacliburn@bellsouth.net, pelle@dsv.su.se


The patch titled
     atl1: add shutdown callback
has been added to the -mm tree.  Its filename is
     atl1-add-shutdown-callback.patch

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

atl1-add-phy-power-save-mode.patch
atl1-fix-broken-suspend-and-resume.patch
atl1-add-shutdown-callback.patch
atl1-bump-version-number.patch

