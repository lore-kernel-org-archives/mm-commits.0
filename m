From: akpm@linux-foundation.org
Subject: + forcedeth-fix-kexec-regression.patch added to -mm tree
Date: Tue, 19 Aug 2008 13:35:33 -0700
Message-ID: <200808192035.m7JKZXCO005049@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36090 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753678AbYHSUhC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Aug 2008 16:37:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, aabdulla@nvidia.com, jeff@garzik.org, yhlu.kernel@gmail.com


The patch titled
     forcedeth: fix kexec regression
has been added to the -mm tree.  Its filename is
     forcedeth-fix-kexec-regression.patch

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
Subject: forcedeth: fix kexec regression
From: Rafael J. Wysocki <rjw@sisk.pl>

forcedeth: Fix kexec regression

Fix regression tracked as http://bugzilla.kernel.org/show_bug.cgi?id=11361
and caused by commit f735a2a1a4f2a0f5cd823ce323e82675990469e2 ("[netdrvr]
forcedeth: setup wake-on-lan before shutting down") that makes network
adapters integrated into the NVidia MCP55 chipsets fail to work in kexeced
kernels.  The problem appears to be that if the adapter is put into D3_hot
during ->shutdown(), it cannot be brought back into D0 after kexec (ref. 
http://marc.info/?l=linux-kernel&m=121900062814967&w=4).  Therefore, only
put forcedeth into D3 during ->shutdown() if the system is to be powered
off.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Tested-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ayaz Abdulla <aabdulla@nvidia.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/forcedeth.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/net/forcedeth.c~forcedeth-fix-kexec-regression drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcedeth-fix-kexec-regression
+++ a/drivers/net/forcedeth.c
@@ -5990,10 +5990,12 @@ static void nv_shutdown(struct pci_dev *
 	if (netif_running(dev))
 		nv_close(dev);
 
-	pci_enable_wake(pdev, PCI_D3hot, np->wolenabled);
-	pci_enable_wake(pdev, PCI_D3cold, np->wolenabled);
 	pci_disable_device(pdev);
-	pci_set_power_state(pdev, PCI_D3hot);
+	if (system_state == SYSTEM_POWER_OFF) {
+		if (pci_enable_wake(pdev, PCI_D3cold, np->wolenabled))
+			pci_enable_wake(pdev, PCI_D3hot, np->wolenabled);
+		pci_set_power_state(pdev, PCI_D3hot);
+	}
 }
 #else
 #define nv_suspend NULL
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
revert-preregister-support-for-powernow-k8.patch
linux-next.patch
skge-adapt-skge-to-use-reworked-pci-pm.patch
skty2-adapt-to-the-reworked-pci-pm.patch
e100-adapt-to-the-reworked-pci-pm.patch
forcedeth-fix-kexec-regression.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation.patch
container-freezer-add-tif_freeze-flag-to-all-architectures.patch
container-freezer-make-refrigerator-always-available.patch
container-freezer-skip-frozen-cgroups-during-power-management-resume.patch
shrink_slab-handle-bad-shrinkers.patch

