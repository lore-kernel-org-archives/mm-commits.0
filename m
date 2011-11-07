From: akpm@linux-foundation.org
Subject: [merged] drivers-net-rionetc-fix-ethernet-address-macros-for-le-platforms.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:28:41 -0800
Message-ID: <201111072028.pA7KSffA028496@hpaq7.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:47701 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab1KGU3Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:29:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, chul.kim@idt.com, galak@kernel.crashing.org, leoli@freescale.com, mporter@kernel.crashing.org, stable@kernel.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/net/rionet.c: fix ethernet address macros for LE platforms
has been removed from the -mm tree.  Its filename was
     drivers-net-rionetc-fix-ethernet-address-macros-for-le-platforms.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: drivers/net/rionet.c: fix ethernet address macros for LE platforms

Modify Ethernet addess macros to be compatible with BE/LE platforms

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Chul Kim <chul.kim@idt.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: <stable@kernel.org>		[2.6.39+]
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/rionet.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/rionet.c~drivers-net-rionetc-fix-ethernet-address-macros-for-le-platforms drivers/net/rionet.c
--- a/drivers/net/rionet.c~drivers-net-rionetc-fix-ethernet-address-macros-for-le-platforms
+++ a/drivers/net/rionet.c
@@ -88,8 +88,8 @@ static struct rio_dev **rionet_active;
 #define dev_rionet_capable(dev) \
 	is_rionet_capable(dev->src_ops, dev->dst_ops)
 
-#define RIONET_MAC_MATCH(x)	(*(u32 *)x == 0x00010001)
-#define RIONET_GET_DESTID(x)	(*(u16 *)(x + 4))
+#define RIONET_MAC_MATCH(x)	(!memcmp((x), "\00\01\00\01", 4))
+#define RIONET_GET_DESTID(x)	((*((u8 *)x + 4) << 8) | *((u8 *)x + 5))
 
 static int rionet_rx_clean(struct net_device *ndev)
 {
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

origin.patch

