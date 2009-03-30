From: akpm@linux-foundation.org
Subject: [merged] powerpc-4xx-emac-driver-device-name-reported-on-timeout-is-not-correct.patch removed from -mm tree
Date: Mon, 30 Mar 2009 12:06:18 -0700
Message-ID: <200903301906.n2UJ6I4g019015@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759782AbZC3TTb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 15:19:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lebon@lebon.org.ua, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     powerpc 4xx EMAC driver: device name reported on timeout is not correct
has been removed from the -mm tree.  Its filename was
     powerpc-4xx-emac-driver-device-name-reported-on-timeout-is-not-correct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc 4xx EMAC driver: device name reported on timeout is not correct
From: Mikhail Zolotaryov <lebon@lebon.org.ua>

IBM EMAC driver performs device reset (drivers/net/ibm_newemac/core.c:
emac_probe() -> emac_init_phy() -> emac_reset()) before registering
appropriate net_device (emac_probe() -> register_netdev()), so net_device name
contains raw format string during EMAC reset ("eth%d").

If the case of reset timeout, emac_report_timeout_error() function is called
to report an error.  The problem is this function uses net_device name to
report device related, which is not correct, as a result in the kernel log
buffer we see:

eth%d: reset timeout

The solution is to print device_node full_name instead. After applying
the patch proposed, error string is like the following:

/plb/opb/ethernet@ef600e00: reset timeout

Signed-off-by: Mikhail Zolotaryov <lebon@lebon.org.ua>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ibm_newemac/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/ibm_newemac/core.c~powerpc-4xx-emac-driver-device-name-reported-on-timeout-is-not-correct drivers/net/ibm_newemac/core.c
--- a/drivers/net/ibm_newemac/core.c~powerpc-4xx-emac-driver-device-name-reported-on-timeout-is-not-correct
+++ a/drivers/net/ibm_newemac/core.c
@@ -134,7 +134,7 @@ static inline void emac_report_timeout_e
 				  EMAC_FTR_440EP_PHY_CLK_FIX))
 		DBG(dev, "%s" NL, error);
 	else if (net_ratelimit())
-		printk(KERN_ERR "%s: %s\n", dev->ndev->name, error);
+		printk(KERN_ERR "%s: %s\n", dev->ofdev->node->full_name, error);
 }
 
 /* EMAC PHY clock workaround:
_

Patches currently in -mm which might be from lebon@lebon.org.ua are

origin.patch

