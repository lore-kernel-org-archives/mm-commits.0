From: akpm@linux-foundation.org
Subject: - sky2-restore-multicast-list-on-resume-and-other-ops.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:27:12 -0700
Message-ID: <200709160927.l8G9RCxd009241@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33050 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751997AbXIPJiZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:38:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@linux-foundation.org, jeff@garzik.org, timo@tiwe.de, mm-commits@vger.kernel.org


The patch titled
     sky2: restore multicast list on resume and other ops
has been removed from the -mm tree.  Its filename was
     sky2-restore-multicast-list-on-resume-and-other-ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sky2: restore multicast list on resume and other ops
From: Stephen Hemminger <shemminger@linux-foundation.org>

Need to restore multicast settings on resume and after 'ethtool -r'.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Timo Weingrtner <timo@tiwe.de>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sky2.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN drivers/net/sky2.c~sky2-restore-multicast-list-on-resume-and-other-ops drivers/net/sky2.c
--- a/drivers/net/sky2.c~sky2-restore-multicast-list-on-resume-and-other-ops
+++ a/drivers/net/sky2.c
@@ -154,6 +154,8 @@ static const char *yukon2_name[] = {
 	"FE+",		/* 0xb8 */
 };
 
+static void sky2_set_multicast(struct net_device *dev);
+
 /* Access to external PHY */
 static int gm_phy_write(struct sky2_hw *hw, unsigned port, u16 reg, u16 val)
 {
@@ -2943,8 +2945,10 @@ static int sky2_set_settings(struct net_
 	sky2->autoneg = ecmd->autoneg;
 	sky2->advertising = ecmd->advertising;
 
-	if (netif_running(dev))
+	if (netif_running(dev)) {
 		sky2_phy_reinit(sky2);
+		sky2_set_multicast(dev);
+	}
 
 	return 0;
 }
@@ -3037,6 +3041,7 @@ static int sky2_nway_reset(struct net_de
 		return -EINVAL;
 
 	sky2_phy_reinit(sky2);
+	sky2_set_multicast(dev);
 
 	return 0;
 }
@@ -4207,6 +4212,8 @@ static int sky2_resume(struct pci_dev *p
 				dev_close(dev);
 				goto out;
 			}
+
+			sky2_set_multicast(dev);
 		}
 	}
 
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

origin.patch
git-infiniband.patch
git-input.patch
git-net.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
export-reciprocal_value-for-modules.patch
sky2-avoid-divide-in-receive-path.patch
sky2-118.patch
skge-remove-broken-and-unused-phy_m_pc_mdi_xmode-macro.patch
