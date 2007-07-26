From: akpm@linux-foundation.org
Subject: + ioc3-switch-hw-checksumming-to-ethtool-configurable.patch added to -mm tree
Date: Thu, 26 Jul 2007 01:06:43 -0700
Message-ID: <200707260806.l6Q86hSZ021663@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49110 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758282AbXGZIHF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 04:07:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org


The patch titled
     IOC3: Switch hw checksumming to ethtool configurable.
has been added to the -mm tree.  Its filename is
     ioc3-switch-hw-checksumming-to-ethtool-configurable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: IOC3: Switch hw checksumming to ethtool configurable.
From: Ralf Baechle <ralf@linux-mips.org>

I've previously sent out this patch a long time ago.  At that time I was
told NETIF_F_IP_CSUM wouldn't make any sense without NETIF_F_SG.  IOC3's
S/G abilities are very limited; it can do up to three segments of which the
first one is up to 104 bytes and part of the packet's TX ring entry, the
second and 3rd ones can be anywhere in the 64-bit PCI address space but may
not cross a 16kB page boundary.  So setting NETIF_F_SG isn't really an
option unless the IOC3 was going to linearize any packet it can't cope with
itself.

So the big question, does NETIF_F_IP_CSUM without NETIF_F_SG make sense?

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/Kconfig    |   20 ----------------
 drivers/net/ioc3-eth.c |   48 ++++++++++++++++++++++++++-------------
 2 files changed, 32 insertions(+), 36 deletions(-)

diff -puN drivers/net/ioc3-eth.c~ioc3-switch-hw-checksumming-to-ethtool-configurable drivers/net/ioc3-eth.c
--- a/drivers/net/ioc3-eth.c~ioc3-switch-hw-checksumming-to-ethtool-configurable
+++ a/drivers/net/ioc3-eth.c
@@ -5,7 +5,7 @@
  *
  * Driver for SGI's IOC3 based Ethernet cards as found in the PCI card.
  *
- * Copyright (C) 1999, 2000, 2001, 2003 Ralf Baechle
+ * Copyright (C) 1999, 2000, 01, 03, 06 Ralf Baechle
  * Copyright (C) 1995, 1999, 2000, 2001 by Silicon Graphics, Inc.
  *
  * References:
@@ -61,12 +61,7 @@
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
 #include <asm/sn/types.h>
-#include <asm/sn/sn0/addrs.h>
-#include <asm/sn/sn0/hubni.h>
-#include <asm/sn/sn0/hubio.h>
-#include <asm/sn/klconfig.h>
 #include <asm/sn/ioc3.h>
-#include <asm/sn/sn0/ip27.h>
 #include <asm/pci/bridge.h>
 
 /*
@@ -94,6 +89,9 @@ struct ioc3_private {
 	u32 emcr, ehar_h, ehar_l;
 	spinlock_t ioc3_lock;
 	struct mii_if_info mii;
+	unsigned long flags;
+#define IOC3_FLAG_RX_CHECKSUMS	1
+
 	struct pci_dev *pdev;
 
 	/* Members used by autonegotiation  */
@@ -520,8 +518,6 @@ static struct net_device_stats *ioc3_get
 	return &ip->stats;
 }
 
-#ifdef CONFIG_SGI_IOC3_ETH_HW_RX_CSUM
-
 static void ioc3_tcpudp_checksum(struct sk_buff *skb, uint32_t hwsum, int len)
 {
 	struct ethhdr *eh = eth_hdr(skb);
@@ -589,7 +585,6 @@ static void ioc3_tcpudp_checksum(struct 
 	if (csum == 0xffff)
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 }
-#endif /* CONFIG_SGI_IOC3_ETH_HW_RX_CSUM */
 
 static inline void ioc3_rx(struct ioc3_private *ip)
 {
@@ -624,9 +619,9 @@ static inline void ioc3_rx(struct ioc3_p
 				goto next;
 			}
 
-#ifdef CONFIG_SGI_IOC3_ETH_HW_RX_CSUM
-			ioc3_tcpudp_checksum(skb, w0 & ERXBUF_IPCKSUM_MASK,len);
-#endif
+			if (likely(ip->flags & IOC3_FLAG_RX_CHECKSUMS))
+				ioc3_tcpudp_checksum(skb,
+					w0 & ERXBUF_IPCKSUM_MASK, len);
 
 			netif_rx(skb);
 
@@ -1298,9 +1293,7 @@ static int ioc3_probe(struct pci_dev *pd
 	dev->set_multicast_list	= ioc3_set_multicast_list;
 	dev->set_mac_address	= ioc3_set_mac_address;
 	dev->ethtool_ops	= &ioc3_ethtool_ops;
-#ifdef CONFIG_SGI_IOC3_ETH_HW_TX_CSUM
 	dev->features		= NETIF_F_IP_CSUM;
-#endif
 
 	sw_physid1 = ioc3_mdio_read(dev, ip->mii.phy_id, MII_PHYSID1);
 	sw_physid2 = ioc3_mdio_read(dev, ip->mii.phy_id, MII_PHYSID2);
@@ -1390,7 +1383,6 @@ static int ioc3_start_xmit(struct sk_buf
 	uint32_t w0 = 0;
 	int produce;
 
-#ifdef CONFIG_SGI_IOC3_ETH_HW_TX_CSUM
 	/*
 	 * IOC3 has a fairly simple minded checksumming hardware which simply
 	 * adds up the 1's complement checksum for the entire packet and
@@ -1438,7 +1430,6 @@ static int ioc3_start_xmit(struct sk_buf
 
 		w0 = ETXD_DOCHECKSUM | (csoff << ETXD_CHKOFF_SHIFT);
 	}
-#endif /* CONFIG_SGI_IOC3_ETH_HW_TX_CSUM */
 
 	spin_lock_irq(&ip->ioc3_lock);
 
@@ -1593,12 +1584,37 @@ static u32 ioc3_get_link(struct net_devi
 	return rc;
 }
 
+static u32 ioc3_get_rx_csum(struct net_device *dev)
+{
+	struct ioc3_private *ip = netdev_priv(dev);
+
+	return ip->flags & IOC3_FLAG_RX_CHECKSUMS;
+}
+
+static int ioc3_set_rx_csum(struct net_device *dev, u32 data)
+{
+	struct ioc3_private *ip = netdev_priv(dev);
+
+	spin_lock_bh(&ip->ioc3_lock);
+	if (data)
+		ip->flags |= IOC3_FLAG_RX_CHECKSUMS;
+	else
+		ip->flags &= ~IOC3_FLAG_RX_CHECKSUMS;
+	spin_unlock_bh(&ip->ioc3_lock);
+
+	return 0;
+}
+
 static const struct ethtool_ops ioc3_ethtool_ops = {
 	.get_drvinfo		= ioc3_get_drvinfo,
 	.get_settings		= ioc3_get_settings,
 	.set_settings		= ioc3_set_settings,
 	.nway_reset		= ioc3_nway_reset,
 	.get_link		= ioc3_get_link,
+	.get_rx_csum		= ioc3_get_rx_csum,
+	.set_rx_csum		= ioc3_set_rx_csum,
+	.get_tx_csum		= ethtool_op_get_tx_csum,
+	.set_tx_csum		= ethtool_op_set_tx_csum
 };
 
 static int ioc3_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
diff -puN drivers/net/Kconfig~ioc3-switch-hw-checksumming-to-ethtool-configurable drivers/net/Kconfig
--- a/drivers/net/Kconfig~ioc3-switch-hw-checksumming-to-ethtool-configurable
+++ a/drivers/net/Kconfig
@@ -480,26 +480,6 @@ config SGI_IOC3_ETH
 	  the Ethernet-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-config SGI_IOC3_ETH_HW_RX_CSUM
-	bool "Receive hardware checksums"
-	depends on SGI_IOC3_ETH && INET
-	default y
-	help
-	  The SGI IOC3 network adapter supports TCP and UDP checksums in
-	  hardware to offload processing of these checksums from the CPU.  At
-	  the moment only acceleration of IPv4 is supported.  This option
-	  enables offloading for checksums on receive.  If unsure, say Y.
-
-config SGI_IOC3_ETH_HW_TX_CSUM
-	bool "Transmit hardware checksums"
-	depends on SGI_IOC3_ETH && INET
-	default y
-	help
-	  The SGI IOC3 network adapter supports TCP and UDP checksums in
-	  hardware to offload processing of these checksums from the CPU.  At
-	  the moment only acceleration of IPv4 is supported.  This option
-	  enables offloading for checksums on transmit.  If unsure, say Y.
-
 config MIPS_SIM_NET
 	tristate "MIPS simulator Network device"
 	depends on MIPS_SIM
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
edac-is-bust-on-mips.patch
include-asm-mips-add-missing-edac-h-file.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
git-mtd.patch
ioc3-switch-hw-checksumming-to-ethtool-configurable.patch
serial_txx9-fix-modem-control-line-handling.patch
serial_txx9-cleanup-includes.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
whitelist-references-from-__dbe_table-to-init.patch
bpqether-fix-rcu-usage.patch
serial-fix-section-mismatch-vr41xx_siu.patch
serial-fix-vr41xx_siu-interface-select.patch
serial-fix-vr41xx_siu-serial-console-support.patch
remove-tx3912fb.patch
sb1250-duart-__maybe_unused-etc-fixes.patch
clean-up-duplicate-includes-in-drivers-char.patch
