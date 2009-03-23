From: akpm@linux-foundation.org
Subject: + powerpc-4xx-emac-driver-device-name-reported-on-timeout-is-not-correct.patch added to -mm tree
Date: Sun, 22 Mar 2009 17:19:53 -0700
Message-ID: <200903230024.n2N0OBZh026298@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55804 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753332AbZCWA0F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 22 Mar 2009 20:26:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lebon@lebon.org.ua, benh@kernel.crashing.org


The patch titled
     powerpc 4xx EMAC driver: device name reported on timeout is not correct
has been added to the -mm tree.  Its filename is
     powerpc-4xx-emac-driver-device-name-reported-on-timeout-is-not-correct.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

powerpc-4xx-emac-driver-device-name-reported-on-timeout-is-not-correct.patch

