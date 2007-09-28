From: akpm@linux-foundation.org
Subject: + ipgc-doesnt-compile-with-with-config_highmem64g.patch added to -mm tree
Date: Thu, 27 Sep 2007 17:16:38 -0700
Message-ID: <200709280016.l8S0Gcup002501@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33577 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751992AbXI1AQy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Sep 2007 20:16:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tremyfr@yahoo.fr, davem@davemloft.net, jeff@garzik.org, jesse@icplus.com.tw, sorbica@icplus.com.tw


The patch titled
     ipg.c doesn't compile with with CONFIG_HIGHMEM64G
has been added to the -mm tree.  Its filename is
     ipgc-doesnt-compile-with-with-config_highmem64g.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Cc: Sorbica Shieh <sorbica@icplus.com.tw>
Cc: Jesse Huang <jesse@icplus.com.tw>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/net/ipg.c~ipgc-doesnt-compile-with-with-config_highmem64g drivers/net/ipg.c
--- a/drivers/net/ipg.c~ipgc-doesnt-compile-with-with-config_highmem64g
+++ a/drivers/net/ipg.c
@@ -837,7 +837,7 @@ static void ipg_nic_txfree(struct net_de
 	struct ipg_nic_private *sp = netdev_priv(dev);
 	void __iomem *ioaddr = sp->ioaddr;
 	const unsigned int curr = ipg_r32(TFD_LIST_PTR_0) -
-		(sp->txd_map / sizeof(struct ipg_tx)) - 1;
+		do_div(sp->txd_map, sizeof(struct ipg_tx)) - 1;
 	unsigned int released, pending;
 
 	IPG_DEBUG_MSG("_nic_txfree\n");
_

Patches currently in -mm which might be from tremyfr@yahoo.fr are

ipgc-doesnt-compile-with-with-config_highmem64g.patch
ipgc-doesnt-compile-with-with-config_highmem64g-fix.patch
