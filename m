From: akpm@linux-foundation.org
Subject: - smc91x-fix-build-breakage-from-the-smc_get_mac_addr-api-upgrade.patch removed from -mm tree
Date: Thu, 27 Mar 2008 15:45:40 -0700
Message-ID: <200803272245.m2RMjeGt025712@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32992 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751154AbYC0WrL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Mar 2008 18:47:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cooloney@kernel.org, dsaxena@plexity.net, jeff@garzik.org, lethal@linux-sh.org, nico@cam.org, rmk+kernel@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     smc91x: fix build breakage from the SMC_GET_MAC_ADDR API upgrade
has been removed from the -mm tree.  Its filename was
     smc91x-fix-build-breakage-from-the-smc_get_mac_addr-api-upgrade.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: smc91x: fix build breakage from the SMC_GET_MAC_ADDR API upgrade
From: Bryan Wu <cooloney@kernel.org>

Cc: Jeff Garzik <jeff@garzik.org>
Cc: Deepak Saxena <dsaxena@plexity.net>
Cc: Nicolas Pitre <nico@cam.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/smc91x.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/net/smc91x.h~smc91x-fix-build-breakage-from-the-smc_get_mac_addr-api-upgrade drivers/net/smc91x.h
--- a/drivers/net/smc91x.h~smc91x-fix-build-breakage-from-the-smc_get_mac_addr-api-upgrade
+++ a/drivers/net/smc91x.h
@@ -93,14 +93,14 @@
 #define SMC_insw(a, r, p, l) 	insw ((unsigned long *)((a) + (r)), p, l)
 # endif
 /* check if the mac in reg is valid */
-#define SMC_GET_MAC_ADDR(addr)					\
+#define SMC_GET_MAC_ADDR(lp, addr)				\
 	do {							\
 		unsigned int __v;				\
-		__v = SMC_inw(ioaddr, ADDR0_REG);		\
+		__v = SMC_inw(ioaddr, ADDR0_REG(lp));		\
 		addr[0] = __v; addr[1] = __v >> 8;		\
-		__v = SMC_inw(ioaddr, ADDR1_REG);		\
+		__v = SMC_inw(ioaddr, ADDR1_REG(lp));		\
 		addr[2] = __v; addr[3] = __v >> 8;		\
-		__v = SMC_inw(ioaddr, ADDR2_REG);		\
+		__v = SMC_inw(ioaddr, ADDR2_REG(lp));		\
 		addr[4] = __v; addr[5] = __v >> 8;		\
 		if (*(u32 *)(&addr[0]) == 0xFFFFFFFF) {		\
 			random_ether_addr(addr);		\
_

Patches currently in -mm which might be from cooloney@kernel.org are

origin.patch
blackfin-video-driver-update-the-bf52x-ezkit-video-framebuffer-driver-according-to-lkml-review.patch
blackfin-video-driver-update-the-bf52x-ezkit-video-framebuffer-driver-according-to-lkml-review-fix.patch
blackfin-video-driver-fix-bug-when-opening-reading-mmaping-bf54x-and-bf52x-framebuffer-simultaneously.patch
git-watchdog.patch
smc91x-driver-fix-bug-print-warning-only-in-interrupt-mode.patch

