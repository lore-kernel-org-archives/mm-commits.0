From: akpm@linux-foundation.org
Subject: + drivers-net-rionetc-fix-ethernet-address-macros-for-le-platforms.patch added to -mm tree
Date: Tue, 06 Sep 2011 12:33:44 -0700
Message-ID: <201109061933.p86JXiKj024100@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53329 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754732Ab1IFTeI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2011 15:34:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, chul.kim@idt.com, galak@kernel.crashing.org, leoli@freescale.com, mporter@kernel.crashing.org, stable@kernel.org


The patch titled
     drivers/net/rionet.c: fix ethernet address macros for LE platforms
has been added to the -mm tree.  Its filename is
     drivers-net-rionetc-fix-ethernet-address-macros-for-le-platforms.patch

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
Subject: drivers/net/rionet.c: fix ethernet address macros for LE platforms
From: Alexandre Bounine <alexandre.bounine@idt.com>

Modify Ethernet addess macros to be compatible with BE/LE platforms

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Chul Kim <chul.kim@idt.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: <stable@kernel.org>		[2.6.39+]
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

drivers-rapidio-rio-scanc-use-discovered-bit-to-test-if-enumeration-is-complete.patch
arch-powerpc-sysdev-fsl_rioc-release-rapidio-port-i-o-region-resource-if-port-failed-to-initialize.patch
rapidio-add-mport-driver-for-tsi721-bridge.patch
rapidio-add-mport-driver-for-tsi721-bridge-update.patch
rapidio-fix-potential-null-deref-in-rio_setup_device.patch
drivers-net-rionetc-fix-ethernet-address-macros-for-le-platforms.patch

