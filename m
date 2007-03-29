From: akpm@linux-foundation.org
Subject: - ehea-strlcpy-is-smart-enough.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:37:47 -0700
Message-ID: <200703292337.l2TNblhf015152@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43025 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945929AbXC2XiH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:38:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, osstklei@de.ibm.com, themann@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     strlcpy is smart enough
has been removed from the -mm tree.  Its filename was
     ehea-strlcpy-is-smart-enough.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: strlcpy is smart enough
From: Jean Delvare <khali@linux-fr.org>

strlcpy already accounts for the trailing zero in its length
computation, so there is no need to substract one to the buffer size.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Jan-Bernd Themann <themann@de.ibm.com>
Cc: Thomas Klein <osstklei@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ehea/ehea_ethtool.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/ehea/ehea_ethtool.c~ehea-strlcpy-is-smart-enough drivers/net/ehea/ehea_ethtool.c
--- a/drivers/net/ehea/ehea_ethtool.c~ehea-strlcpy-is-smart-enough
+++ a/drivers/net/ehea/ehea_ethtool.c
@@ -144,8 +144,8 @@ static int ehea_nway_reset(struct net_de
 static void ehea_get_drvinfo(struct net_device *dev,
 			       struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver) - 1);
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version) - 1);
+	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 }
 
 static u32 ehea_get_msglevel(struct net_device *dev)
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
x86-msr-add-support-for-safe-variants.patch
git-alsa.patch
git-dvb.patch
apple-smc-driver-hardware-monitoring-and-control.patch
git-netdev-all.patch
git-net.patch
xtensa-strlcpy-is-smart-enough.patch
oss-strlcpy-is-smart-enough.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900.patch
legacy-pc-parports-support-parport-dev.patch
layered-parport-code-uses-parport-dev.patch
