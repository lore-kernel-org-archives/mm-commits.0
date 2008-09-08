From: akpm@linux-foundation.org
Subject: - forcedeth-fix-kexec-regression.patch removed from -mm tree
Date: Mon, 08 Sep 2008 12:07:00 -0700
Message-ID: <200809081907.m88J70hs005505@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59400 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753805AbYIHTJ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Sep 2008 15:09:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, aabdulla@nvidia.com, jeff@garzik.org, yhlu.kernel@gmail.com, mm-commits@vger.kernel.org


The patch titled
     forcedeth: fix kexec regression
has been removed from the -mm tree.  Its filename was
     forcedeth-fix-kexec-regression.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: forcedeth: fix kexec regression
From: Rafael J. Wysocki <rjw@sisk.pl>

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
Acked-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/forcedeth.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/net/forcedeth.c~forcedeth-fix-kexec-regression drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcedeth-fix-kexec-regression
+++ a/drivers/net/forcedeth.c
@@ -5975,10 +5975,12 @@ static void nv_shutdown(struct pci_dev *
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
linux-next.patch
skge-adapt-skge-to-use-reworked-pci-pm.patch
skty2-adapt-to-the-reworked-pci-pm.patch
e100-adapt-to-the-reworked-pci-pm.patch
net-forcedeth-call-restore-mac-addr-in-nv_shutdown-path-v2.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation-cleanup.patch
container-freezer-add-tif_freeze-flag-to-all-architectures.patch
container-freezer-add-tif_freeze-flag-to-all-architectures-fix.patch
container-freezer-make-refrigerator-always-available.patch
container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process-fix.patch
container-freezer-implement-freezer-cgroup-subsystem-cleanup-comment.patch
container-freezer-skip-frozen-cgroups-during-power-management-resume.patch
vsprintf-use-new-vsprintf-symbolic-function-pointer-format.patch
vsprintf-use-new-vsprintf-symbolic-function-pointer-format-cleanup.patch
shrink_slab-handle-bad-shrinkers.patch

