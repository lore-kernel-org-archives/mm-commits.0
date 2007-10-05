From: akpm@linux-foundation.org
Subject: - ipgc-doesnt-compile-with-with-config_highmem64g.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:57:16 -0700
Message-ID: <200710051957.l95JvGJ6022455@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48529 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763521AbXJEUBq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 16:01:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tremyfr@yahoo.fr, davem@davemloft.net, jeff@garzik.org, jesse@icplus.com.tw, sorbica@icplus.com.tw, mm-commits@vger.kernel.org


The patch titled
     ipg.c doesn't compile with with CONFIG_HIGHMEM64G
has been removed from the -mm tree.  Its filename was
     ipgc-doesnt-compile-with-with-config_highmem64g.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ipg.c doesn't compile with with CONFIG_HIGHMEM64G
From: trem <tremyfr@yahoo.fr>

I've tried to compile 2.6.23-rc8-mm2, but it fails on ipg.c with the
error : ERROR: "__udivdi3" [drivers/net/ipg.ko] undefined!

I've instigated a bit, and I've found this code in ipg.c :

static void ipg_nic_txfree(struct net_device *dev)
{
       struct ipg_nic_private *sp = netdev_priv(dev);
       void __iomem *ioaddr = sp->ioaddr;
       const unsigned int curr = ipg_r32(TFD_LIST_PTR_0) -
               (sp->txd_map / sizeof(struct ipg_tx)) - 1;
       unsigned int released, pending;

sp->txd_map is an u64
because :
	dma_addr_t txd_map;

And in asm-i386/types.h, I see :
#ifdef CONFIG_HIGHMEM64G
typedef u64 dma_addr_t;
#else
typedef u32 dma_addr_t;
#endif
I my config, I use CONFIG_HIGHMEM64G

sizeof(struct ipg_tx) is an u32
So the div failed on i386 because of u64 / u32.

[akpm@linux-foundation.org: cleanups]
Cc: Sorbica Shieh <sorbica@icplus.com.tw>
Cc: Jesse Huang <jesse@icplus.com.tw>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ipg.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN drivers/net/ipg.c~ipgc-doesnt-compile-with-with-config_highmem64g drivers/net/ipg.c
--- a/drivers/net/ipg.c~ipgc-doesnt-compile-with-with-config_highmem64g
+++ a/drivers/net/ipg.c
@@ -25,6 +25,8 @@
 #include <linux/mii.h>
 #include <linux/mutex.h>
 
+#include <asm/div64.h>
+
 #define IPG_RX_RING_BYTES	(sizeof(struct ipg_rx) * IPG_RFDLIST_LENGTH)
 #define IPG_TX_RING_BYTES	(sizeof(struct ipg_tx) * IPG_TFDLIST_LENGTH)
 #define IPG_RESET_MASK \
@@ -836,10 +838,14 @@ static void ipg_nic_txfree(struct net_de
 {
 	struct ipg_nic_private *sp = netdev_priv(dev);
 	void __iomem *ioaddr = sp->ioaddr;
-	const unsigned int curr = ipg_r32(TFD_LIST_PTR_0) -
-		(sp->txd_map / sizeof(struct ipg_tx)) - 1;
+	unsigned int curr;
+	u64 txd_map;
 	unsigned int released, pending;
 
+	txd_map = (u64)sp->txd_map;
+	curr = ipg_r32(TFD_LIST_PTR_0) -
+		do_div(txd_map, sizeof(struct ipg_tx)) - 1;
+
 	IPG_DEBUG_MSG("_nic_txfree\n");
 
 	pending = sp->tx_current - sp->tx_dirty;
_

Patches currently in -mm which might be from tremyfr@yahoo.fr are

git-net.patch
