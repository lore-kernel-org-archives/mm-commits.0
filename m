From: akpm@linux-foundation.org
Subject: - smc91x-fix-build-error-from-the-smc_get_mac_addr-api-change.patch removed from -mm tree
Date: Thu, 12 Jun 2008 13:37:55 -0700
Message-ID: <200806122037.m5CKbtUj005475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756547AbYFLUiP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 16:38:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cooloney@kernel.org, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     smc91x: fix build error from the SMC_GET_MAC_ADDR API change
has been removed from the -mm tree.  Its filename was
     smc91x-fix-build-error-from-the-smc_get_mac_addr-api-change.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: smc91x: fix build error from the SMC_GET_MAC_ADDR API change
From: Bryan Wu <cooloney@kernel.org>

Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/smc91x.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/net/smc91x.h~smc91x-fix-build-error-from-the-smc_get_mac_addr-api-change drivers/net/smc91x.h
--- a/drivers/net/smc91x.h~smc91x-fix-build-error-from-the-smc_get_mac_addr-api-change
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
linux-next.patch
pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-2.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues.patch
mtd-m25p80-fix-bug-atmel-spi-flash-fails-to-be-copied-to.patch

