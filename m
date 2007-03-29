From: akpm@linux-foundation.org
Subject: - lguest-trivial-guest-network-driver.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:14:51 -0700
Message-ID: <200703292314.l2TNEp6S014728@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42368 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934368AbXC2XPH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:15:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, ak@suse.de, herbert@gondor.apana.org.au, mm-commits@vger.kernel.org


The patch titled
     lguest: trivial guest network driver
has been removed from the -mm tree.  Its filename was
     lguest-trivial-guest-network-driver.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: lguest: trivial guest network driver
From: Rusty Russell <rusty@rustcorp.com.au>

This network driver operates both to the host process, and to other guests. 
It's pretty trivial.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/Makefile     |    1 
 drivers/net/lguest_net.c |  400 +++++++++++++++++++++++++++++++++++++
 2 files changed, 401 insertions(+)

diff -puN drivers/net/Makefile~lguest-trivial-guest-network-driver drivers/net/Makefile
--- a/drivers/net/Makefile~lguest-trivial-guest-network-driver
+++ a/drivers/net/Makefile
@@ -219,3 +219,4 @@ obj-$(CONFIG_NETCONSOLE) += netconsole.o
 obj-$(CONFIG_FS_ENET) += fs_enet/
 
 obj-$(CONFIG_NETXEN_NIC) += netxen/
+obj-$(CONFIG_LGUEST_GUEST) += lguest_net.o
diff -puN /dev/null drivers/net/lguest_net.c
--- /dev/null
+++ a/drivers/net/lguest_net.c
@@ -0,0 +1,400 @@
+/* A simple network driver for lguest.
+ *
+ * Copyright 2006 Rusty Russell <rusty@rustcorp.com.au> IBM Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+//#define DEBUG
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/module.h>
+#include <linux/mm_types.h>
+#include <asm/io.h>
+#include <asm/lguest_device.h>
+
+#define SHARED_SIZE		PAGE_SIZE
+#define DATA_SIZE		1500
+#define MAX_LANS		4
+#define NUM_SKBS		8
+/* We overload multicast bit to show promiscuous mode. */
+#define PROMISC_BIT		0x80
+
+struct lguestnet_info
+{
+	/* The shared page. */
+	struct lguest_net *peer;
+	unsigned long peer_phys;
+
+	/* My peerid. */
+	unsigned int me;
+
+	struct net_device_stats stats;
+
+	/* Receive queue. */
+	struct sk_buff *skb[NUM_SKBS];
+	struct lguest_dma dma[NUM_SKBS];
+};
+
+/* How many bytes left in this page. */
+static unsigned int rest_of_page(void *data)
+{
+	return PAGE_SIZE - ((unsigned long)data % PAGE_SIZE);
+}
+
+/* Simple convention: offset 4 * peernum. */
+static unsigned long peer_addr(struct lguestnet_info *info, unsigned peernum)
+{
+	return info->peer_phys + 4 * peernum;
+}
+
+static void skb_to_dma(const struct sk_buff *skb, unsigned int headlen,
+		       struct lguest_dma *dma)
+{
+	unsigned int i, seg;
+
+	for (i = seg = 0; i < headlen; seg++, i += rest_of_page(skb->data+i)) {
+		dma->addr[seg] = virt_to_phys(skb->data + i);
+		dma->len[seg] = min((unsigned)(headlen - i),
+				    rest_of_page(skb->data + i));
+	}
+	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++, seg++) {
+		const skb_frag_t *f = &skb_shinfo(skb)->frags[i];
+		/* Should not happen with MTU less than 64k - 2 * PAGE_SIZE. */
+		if (seg == LGUEST_MAX_DMA_SECTIONS) {
+			printk("Woah dude!  Megapacket!\n");
+			break;
+		}
+		dma->addr[seg] = page_to_phys(f->page) + f->page_offset;
+		dma->len[seg] = f->size;
+	}
+	if (seg < LGUEST_MAX_DMA_SECTIONS)
+		dma->len[seg] = 0;
+}
+
+static void transfer_packet(struct net_device *dev,
+			    struct sk_buff *skb,
+			    unsigned int peernum)
+{
+	struct lguestnet_info *info = dev->priv;
+	struct lguest_dma dma;
+
+	skb_to_dma(skb, skb_headlen(skb), &dma);
+	pr_debug("xfer length %04x (%u)\n", htons(skb->len), skb->len);
+
+	hcall(LHCALL_SEND_DMA, peer_addr(info,peernum), __pa(&dma),0);
+	if (dma.used_len != skb->len) {
+		info->stats.tx_carrier_errors++;
+		pr_debug("Bad xfer to peer %i: %i of %i (dma %p/%i)\n",
+			 peernum, dma.used_len, skb->len,
+			 (void *)dma.addr[0], dma.len[0]);
+	} else {
+		pr_debug("lguestnet: sent %u bytes\n", skb->len);
+		info->stats.tx_bytes += skb->len;
+		info->stats.tx_packets++;
+	}
+}
+
+static int mac_eq(const unsigned char mac[ETH_ALEN],
+		  struct lguestnet_info *info, unsigned int peer)
+{
+	/* Ignore multicast bit, which peer turns on to mean promisc. */
+	if ((info->peer[peer].promisc & (~PROMISC_BIT)) != mac[0])
+		return 0;
+	return memcmp(mac+1, info->peer[peer].mac+1, ETH_ALEN-1) == 0;
+}
+
+static int unused_peer(const struct lguest_net peer[], unsigned int num)
+{
+	return peer[num].guestid == 0xFFFF;
+}
+
+static int is_broadcast(const unsigned char dest[ETH_ALEN])
+{
+	return dest[0] == 0xFF && dest[1] == 0xFF && dest[2] == 0xFF
+		&& dest[3] == 0xFF && dest[4] == 0xFF && dest[5] == 0xFF;
+}
+
+static int promisc(struct lguestnet_info *info, unsigned int peer)
+{
+	return info->peer[peer].promisc & PROMISC_BIT;
+}
+
+static void lguestnet_set_multicast(struct net_device *dev)
+{
+	struct lguestnet_info *info = dev->priv;
+
+	if (dev->flags & IFF_PROMISC)
+		info->peer[info->me].promisc |= PROMISC_BIT;
+	else
+		info->peer[info->me].promisc &= ~PROMISC_BIT;
+}
+
+static int lguestnet_start_xmit(struct sk_buff *skb, struct net_device *dev)
+{
+	unsigned int i;
+	int broadcast;
+	struct lguestnet_info *info = dev->priv;
+	const unsigned char *dest = ((struct ethhdr *)skb->data)->h_dest;
+
+	broadcast = is_broadcast(dest);
+
+	pr_debug("lguestnet %s: xmit broadcast=%i\n",
+		 dev->name, broadcast);
+	pr_debug("dest: %02x:%02x:%02x:%02x:%02x:%02x\n",
+		 dest[0], dest[1], dest[2], dest[3], dest[4], dest[5]);
+
+	for (i = 0; i < SHARED_SIZE/sizeof(struct lguest_net); i++) {
+		if (i == info->me || unused_peer(info->peer, i))
+			continue;
+
+		if (!broadcast && !promisc(info, i) && !mac_eq(dest, info, i))
+			continue;
+
+		pr_debug("lguestnet %s: sending from %i to %i\n",
+			 dev->name, info->me, i);
+		transfer_packet(dev, skb, i);
+	}
+	dev_kfree_skb(skb);
+	return 0;
+}
+
+static struct sk_buff *lguestnet_alloc_skb(struct net_device *dev, int gfpflags)
+{
+	struct sk_buff *skb;
+
+	skb = alloc_skb(16 + ETH_HLEN + DATA_SIZE, gfpflags);
+	if (!skb)
+		return NULL;
+
+	skb->dev = dev;
+	skb_reserve(skb, 16);
+	return skb;
+}
+
+/* Find a new skb to put in this slot in shared mem. */
+static int fill_slot(struct net_device *dev, unsigned int slot)
+{
+	struct lguestnet_info *info = dev->priv;
+	/* Try to create and register a new one. */
+	info->skb[slot] = lguestnet_alloc_skb(dev, GFP_ATOMIC);
+	if (!info->skb[slot]) {
+		printk("%s: could not fill slot %i\n", dev->name, slot);
+		return -ENOMEM;
+	}
+
+	skb_to_dma(info->skb[slot], ETH_HLEN + DATA_SIZE, &info->dma[slot]);
+	wmb();
+	/* Now we tell hypervisor it can use the slot. */
+	info->dma[slot].used_len = 0;
+
+	pr_debug("lguestnet: %s populating slot %i with %p\n",
+		 dev->name, slot, info->skb[slot]);
+	return 0;
+}
+
+static irqreturn_t lguestnet_rcv(int irq, void *dev_id)
+{
+	struct net_device *dev = dev_id;
+	struct lguestnet_info *info = dev->priv;
+	unsigned int i, done = 0;
+
+	for (i = 0; i < ARRAY_SIZE(info->dma); i++) {
+		unsigned int length;
+		struct sk_buff *skb;
+
+		length = info->dma[i].used_len;
+		if (length == 0)
+			continue;
+
+		done++;
+		skb = info->skb[i];
+		fill_slot(dev, i);
+
+		pr_debug("Received skb %p\n", skb);
+		if (length < 14 || length > 1514) {
+			pr_debug(KERN_WARNING "%s: unbelievable skb len: %i\n",
+				 dev->name, length);
+			dev_kfree_skb(skb);
+			continue;
+		}
+
+		skb_put(skb, length);
+		skb->protocol = eth_type_trans(skb, dev);
+		/* This is a reliable transport. */
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+		pr_debug("Receiving skb proto 0x%04x len %i type %i\n",
+			 ntohs(skb->protocol), skb->len,skb->pkt_type);
+
+		info->stats.rx_bytes += skb->len;
+		info->stats.rx_packets++;
+		netif_rx(skb);
+	}
+	return done ? IRQ_HANDLED : IRQ_NONE;
+}
+
+static int populate_page(struct net_device *dev)
+{
+	int i;
+	struct lguestnet_info *info = dev->priv;
+
+	pr_debug("lguestnet: peer %i shared page %p me %p\n",
+	         info->me, info->peer, &info->peer[info->me]);
+
+	/* Set up our MAC address */
+	memcpy(info->peer[info->me].mac, dev->dev_addr, ETH_ALEN);
+
+	/* Turn on promisc mode if needed */
+	lguestnet_set_multicast(dev);
+
+	for (i = 0; i < ARRAY_SIZE(info->dma); i++) {
+		if (fill_slot(dev, i) != 0)
+			goto cleanup;
+	}
+	pr_debug("lguestnet: allocated %i dma recv buffers\n", i);
+	if (!hcall(LHCALL_BIND_DMA, peer_addr(info, info->me), __pa(info->dma),
+		   (NUM_SKBS << 8) | dev->irq))
+		goto cleanup;
+	return 0;
+
+cleanup:
+	while (--i >= 0)
+		dev_kfree_skb(info->skb[i]);
+	return -ENOMEM;
+}
+
+static void unpopulate_page(struct lguestnet_info *info)
+{
+	unsigned int i;
+	struct lguest_net *me = &info->peer[info->me];
+
+	/* Clear all trace: others might deliver packets, we'll ignore it. */
+	memset(me, 0, sizeof(*me));
+
+	/* Deregister sg lists. */
+	hcall(LHCALL_BIND_DMA, peer_addr(info, info->me), __pa(info->dma), 0);
+	for (i = 0; i < ARRAY_SIZE(info->dma); i++)
+		dev_kfree_skb(info->skb[i]);
+}
+
+static int lguestnet_open(struct net_device *dev)
+{
+	return populate_page(dev);
+}
+
+static int lguestnet_close(struct net_device *dev)
+{
+	unpopulate_page(dev->priv);
+	return 0;
+}
+
+static struct net_device_stats *lguestnet_get_stats(struct net_device *dev)
+{
+	struct lguestnet_info *info = dev->priv;
+
+	return &info->stats;
+}
+
+static int lguestnet_probe(struct lguest_device *lhdev)
+{
+	int err, irqf = IRQF_SHARED;
+	unsigned long mapsize;
+	struct net_device *dev;
+	struct lguestnet_info *info;
+	struct lguest_device_desc *desc = &lguest_devices[lhdev->index];
+
+	pr_debug("lguest_net: probing for device %i\n", lhdev->index);
+	mapsize = PAGE_SIZE * desc->num_pages;
+
+	dev = alloc_etherdev(sizeof(struct lguestnet_info));
+	if (!dev)
+		return -ENOMEM;
+
+	SET_MODULE_OWNER(dev);
+
+	/* Ethernet defaults with some changes */
+	ether_setup(dev);
+	dev->set_mac_address = NULL;
+	dev->mtu = DATA_SIZE;
+
+	dev->dev_addr[0] = 0x02; /* set local assignment bit (IEEE802) */
+	dev->dev_addr[1] = 0x00;
+	memcpy(&dev->dev_addr[2], &lguest_data.guestid, 2);
+	dev->dev_addr[4] = 0x00;
+	dev->dev_addr[5] = 0x00;
+
+	dev->open = lguestnet_open;
+	dev->stop = lguestnet_close;
+	dev->hard_start_xmit = lguestnet_start_xmit;
+	dev->get_stats = lguestnet_get_stats;
+
+	/* Turning on/off promisc will call dev->set_multicast_list.
+	 * We don't actually support multicast yet */
+	dev->set_multicast_list = lguestnet_set_multicast;
+	dev->mem_start = ((unsigned long)desc->pfn << PAGE_SHIFT);
+	dev->mem_end = dev->mem_start + mapsize;
+	dev->irq = lhdev->index+1;
+	dev->dma = 0;
+	dev->features = NETIF_F_SG;
+	if (desc->features & LGUEST_NET_F_NOCSUM)
+		dev->features |= NETIF_F_NO_CSUM;
+
+	info = dev->priv;
+	info->peer_phys = ((unsigned long)desc->pfn << PAGE_SHIFT);
+	info->peer = (void *)ioremap(info->peer_phys, mapsize);
+	/* This stores our peerid (upper bits reserved for future). */
+	info->me = (desc->features & (mapsize-1));
+
+	/* skbs allocated on open */
+	memset(info->skb, 0, sizeof(info->skb));
+
+	err = register_netdev(dev);
+	if (err) {
+		pr_debug("lguestnet: registering device failed\n");
+		goto free;
+	}
+
+	if (lguest_devices[lhdev->index].features & LGUEST_DEVICE_F_RANDOMNESS)
+		irqf |= IRQF_SAMPLE_RANDOM;
+	if (request_irq(dev->irq, lguestnet_rcv, irqf, "lguestnet", dev) != 0) {
+		pr_debug("lguestnet: could not get net irq %i\n", dev->irq);
+		goto unregister;
+	}
+
+	pr_debug("lguestnet: registered device %s\n", dev->name);
+	lhdev->private = dev;
+	return 0;
+
+unregister:
+	unregister_netdev(dev);
+free:
+	free_netdev(dev);
+	return err;
+}
+
+static struct lguest_driver lguestnet_drv = {
+	.name = "lguestnet",
+	.owner = THIS_MODULE,
+	.device_type = LGUEST_DEVICE_T_NET,
+	.probe = lguestnet_probe,
+};
+
+static __init int lguestnet_init(void)
+{
+	return register_lguest_driver(&lguestnet_drv);
+}
+module_init(lguestnet_init);
+
+MODULE_DESCRIPTION("Lguest network driver");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

git-kbuild.patch
git-net.patch
lguest-preparation-export_symbol_gpl-5-functions.patch
lguest-preparation-expose-futex-infrastructure.patch
lguest-trivial-guest-network-driver.patch
lguest-trivial-guest-console-driver.patch
lguest-trivial-guest-block-driver.patch
lguest-documentatation-and-example-launcher.patch
introduce-load_tls-to-the-for-loop.patch
remove-unused-set_seg_base.patch
clarify-config_reorder-explanation.patch
allow-per-cpu-variables-to-be-page-aligned.patch
i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda.patch
i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot.patch
i386-gdt-cleanups-clean-up-cpu_init.patch
i386-gdt-cleanups-cleanup-gdt-access.patch
i386-gdt-cleanups-rename-boot_gdt_table-to-boot_gdt.patch
i386-account-for-module-percpu-space-separately-from-kernel.patch
array_size-check-for-type.patch
array_size-check-for-type-uml-fix.patch
module-use-krealloc.patch
extend-print_symbol-capability.patch
extend-print_symbol-capability-fix.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-update.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
____call_usermodehelper-dont-flush_signals.patch
ignore-vgacon-if-hardware-not-present.patch
