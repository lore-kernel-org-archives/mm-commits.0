From: akpm@linux-foundation.org
Subject: - netdev-smc911x-fix-for-driver-resume.patch removed from -mm tree
Date: Thu, 13 Nov 2008 13:28:21 -0800
Message-ID: <200811132128.mADLSLVJ028425@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753394AbYKMV2j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Nov 2008 16:28:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: romit@ti.com, catalin.marinas@arm.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     netdev SMC911x: fix for driver resume
has been removed from the -mm tree.  Its filename was
     netdev-smc911x-fix-for-driver-resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: netdev SMC911x: fix for driver resume
From: "Dasgupta, Romit" <romit@ti.com>

I am trying out suspend, resume on an OMAP3 based board.  What I see
during resume is that the SMC911x driver resume routing gets stuck after
trying to transmit the packet out of the controller.  Some debug messages
below:

--> smc911x_drv_resume
eth0: --> smc911x_reset
eth0: smc911x_reset timeout waiting for PM restore
eth0: --> smc911x_enable
eth0: --> smc911x_phy_configure()
eth0: --> smc911x_phy_reset()
eth0: phy caps=0x782d
eth0: phy advertised caps=0x0de1
eth0: --> smc911x_phy_check_media
smc911x_phy_read: phyaddr=0x1, phyreg=0x01, phydata=0x7809
smc911x_phy_read: phyaddr=0x1, phyreg=0x01, phydata=0x7809
eth0: link down
Restarting tasks ... eth0: --> smc911x_hard_start_xmit
eth0: --> smc911x_hardware_send_pkt
eth0: --> smc911x_hard_start_xmit
eth0: --> smc911x_hardware_send_pkt
eth0: --> smc911x_hard_start_xmit
eth0: --> smc911x_hardware_send_pkt
nfs: server 172.24.190.217 not responding, still trying
nfs: server 172.24.190.217 not responding, still trying

The following change makes it work fine: (The change within
smc911x_drv_probe function was to get rid of a compilation warning).

Additionally, the SMC9211 data sheet says that when we enter D2 sleep
state, we need to set the EDPWRDOWN bit in the PHY Mode control/status
register and clear it when we are back to D0.  This is not done in the
code as far as I can see.  So does it mean that the PHY is not powered
down but the controller is?  I have another patch that fixes it.  I will
send that as well unless I am missing somethi

Signed-off-by: Romit Dasgupta <romit@ti.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/smc911x.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/net/smc911x.c~netdev-smc911x-fix-for-driver-resume drivers/net/smc911x.c
--- a/drivers/net/smc911x.c~netdev-smc911x-fix-for-driver-resume
+++ a/drivers/net/smc911x.c
@@ -2048,7 +2048,9 @@ err_out:
  */
 static int smc911x_drv_probe(struct platform_device *pdev)
 {
+#ifdef SMC_DYNAMIC_BUS_CONFIG
 	struct smc911x_platdata *pd = pdev->dev.platform_data;
+#endif
 	struct net_device *ndev;
 	struct resource *res;
 	struct smc911x_local *lp;
@@ -2180,9 +2182,9 @@ static int smc911x_drv_resume(struct pla
 
 		if (netif_running(ndev)) {
 			smc911x_reset(ndev);
-			smc911x_enable(ndev);
 			if (lp->phy_type != 0)
 				smc911x_phy_configure(&lp->phy_configure);
+			smc911x_enable(ndev);
 			netif_device_attach(ndev);
 		}
 	}
_

Patches currently in -mm which might be from romit@ti.com are

origin.patch
linux-next.patch
netdev-smc911x-fix-for-driver-resume-cleanup.patch

