From: akpm@linux-foundation.org
Subject: + lguest-the-net-driver.patch added to -mm tree
Date: Tue, 10 Apr 2007 15:04:02 -0700
Message-ID: <200704102204.l3AM42QG018748@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48569 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753954AbXDJWEU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 18:04:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, ak@suse.de, jeff@garzik.org


The patch titled
     lguest: the net driver
has been added to the -mm tree.  Its filename is
     lguest-the-net-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lguest: the net driver
From: Rusty Russell <rusty@rustcorp.com.au>

Lguest net driver

A simple net driver for lguest.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/Makefile     |    1 
 drivers/net/lguest_net.c |  355 +++++++++++++++++++++++++++++++++++++
 2 files changed, 356 insertions(+)

diff -puN drivers/net/Makefile~lguest-the-net-driver drivers/net/Makefile
--- a/drivers/net/Makefile~lguest-the-net-driver
+++ a/drivers/net/Makefile
@@ -220,3 +220,4 @@ obj-$(CONFIG_NETCONSOLE) += netconsole.o
 obj-$(CONFIG_FS_ENET) += fs_enet/
 
 obj-$(CONFIG_NETXEN_NIC) += netxen/
+obj-$(CONFIG_LGUEST_GUEST) += lguest_net.o
diff -puN /dev/null drivers/net/lguest_net.c
--- /dev/null
+++ a/drivers/net/lguest_net.c
@@ -0,0 +1,355 @@
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
+#include <linux/lguest_bus.h>
+#include <asm/io.h>
+
+#define SHARED_SIZE		PAGE_SIZE
+#define MAX_LANS		4
+#define NUM_SKBS		8
+
+struct lguestnet_info
+{
+	/* The shared page(s). */
+	struct lguest_net *peer;
+	unsigned long peer_phys;
+	unsigned long mapsize;
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
+static unsigned long peer_key(struct lguestnet_info *info, unsigned peernum)
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
+/* We overload multicast bit to show promiscuous mode. */
+#define PROMISC_BIT		0x01
+
+static void lguestnet_set_multicast(struct net_device *dev)
+{
+	struct lguestnet_info *info = dev->priv;
+
+	if ((dev->flags & (IFF_PROMISC|IFF_ALLMULTI)) || dev->mc_count)
+		info->peer[info->me].mac[0] |= PROMISC_BIT;
+	else
+		info->peer[info->me].mac[0] &= ~PROMISC_BIT;
+}
+
+static int promisc(struct lguestnet_info *info, unsigned int peer)
+{
+	return info->peer[peer].mac[0] & PROMISC_BIT;
+}
+
+static int mac_eq(const unsigned char mac[ETH_ALEN],
+		  struct lguestnet_info *info, unsigned int peer)
+{
+	/* Ignore multicast bit, which peer turns on to mean promisc. */
+	if ((info->peer[peer].mac[0] & (~PROMISC_BIT)) != mac[0])
+		return 0;
+	return memcmp(mac+1, info->peer[peer].mac+1, ETH_ALEN-1) == 0;
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
+	hcall(LHCALL_SEND_DMA, peer_key(info,peernum), __pa(&dma), 0);
+	if (dma.used_len != skb->len) {
+		info->stats.tx_carrier_errors++;
+		pr_debug("Bad xfer to peer %i: %i of %i (dma %p/%i)\n",
+			 peernum, dma.used_len, skb->len,
+			 (void *)dma.addr[0], dma.len[0]);
+	} else {
+		info->stats.tx_bytes += skb->len;
+		info->stats.tx_packets++;
+	}
+}
+
+static int unused_peer(const struct lguest_net peer[], unsigned int num)
+{
+	return peer[num].mac[0] == 0;
+}
+
+static int lguestnet_start_xmit(struct sk_buff *skb, struct net_device *dev)
+{
+	unsigned int i;
+	int broadcast;
+	struct lguestnet_info *info = dev->priv;
+	const unsigned char *dest = ((struct ethhdr *)skb->data)->h_dest;
+
+	pr_debug("%s: xmit %02x:%02x:%02x:%02x:%02x:%02x\n",
+		 dev->name, dest[0],dest[1],dest[2],dest[3],dest[4],dest[5]);
+
+	broadcast = is_multicast_ether_addr(dest);
+	for (i = 0; i < info->mapsize/sizeof(struct lguest_net); i++) {
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
+/* Find a new skb to put in this slot in shared mem. */
+static int fill_slot(struct net_device *dev, unsigned int slot)
+{
+	struct lguestnet_info *info = dev->priv;
+	/* Try to create and register a new one. */
+	info->skb[slot] = netdev_alloc_skb(dev, ETH_HLEN + ETH_DATA_LEN);
+	if (!info->skb[slot]) {
+		printk("%s: could not fill slot %i\n", dev->name, slot);
+		return -ENOMEM;
+	}
+
+	skb_to_dma(info->skb[slot], ETH_HLEN + ETH_DATA_LEN, &info->dma[slot]);
+	wmb();
+	/* Now we tell hypervisor it can use the slot. */
+	info->dma[slot].used_len = 0;
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
+		if (length < ETH_HLEN || length > ETH_HLEN + ETH_DATA_LEN) {
+			pr_debug(KERN_WARNING "%s: unbelievable skb len: %i\n",
+				 dev->name, length);
+			dev_kfree_skb(skb);
+			continue;
+		}
+
+		skb_put(skb, length);
+		skb->protocol = eth_type_trans(skb, dev);
+		/* This is a reliable transport. */
+		if (dev->features & NETIF_F_NO_CSUM)
+			skb->ip_summed = CHECKSUM_UNNECESSARY;
+		pr_debug("Receiving skb proto 0x%04x len %i type %i\n",
+			 ntohs(skb->protocol), skb->len, skb->pkt_type);
+
+		info->stats.rx_bytes += skb->len;
+		info->stats.rx_packets++;
+		netif_rx(skb);
+	}
+	return done ? IRQ_HANDLED : IRQ_NONE;
+}
+
+static int lguestnet_open(struct net_device *dev)
+{
+	int i;
+	struct lguestnet_info *info = dev->priv;
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
+	if (!hcall(LHCALL_BIND_DMA, peer_key(info, info->me), __pa(info->dma),
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
+static int lguestnet_close(struct net_device *dev)
+{
+	unsigned int i;
+	struct lguestnet_info *info = dev->priv;
+
+	/* Clear all trace: others might deliver packets, we'll ignore it. */
+	memset(&info->peer[info->me], 0xFF, sizeof(info->peer[info->me]));
+
+	/* Deregister sg lists. */
+	hcall(LHCALL_BIND_DMA, peer_key(info, info->me), __pa(info->dma), 0);
+	for (i = 0; i < ARRAY_SIZE(info->dma); i++)
+		dev_kfree_skb(info->skb[i]);
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
+static int lguestnet_probe(struct lguest_device *lgdev)
+{
+	int err, irqf = IRQF_SHARED;
+	struct net_device *dev;
+	struct lguestnet_info *info;
+	struct lguest_device_desc *desc = &lguest_devices[lgdev->index];
+
+	pr_debug("lguest_net: probing for device %i\n", lgdev->index);
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
+	dev->mem_end = dev->mem_start + PAGE_SIZE * desc->num_pages;
+	dev->irq = lgdev->index+1;
+	dev->features = NETIF_F_SG;
+	if (desc->features & LGUEST_NET_F_NOCSUM)
+		dev->features |= NETIF_F_NO_CSUM;
+
+	info = dev->priv;
+	info->mapsize = PAGE_SIZE * desc->num_pages;
+	info->peer_phys = ((unsigned long)desc->pfn << PAGE_SHIFT);
+	info->peer = (void *)ioremap(info->peer_phys, info->mapsize);
+	/* This stores our peerid (upper bits reserved for future). */
+	info->me = (desc->features & (info->mapsize-1));
+
+	err = register_netdev(dev);
+	if (err) {
+		pr_debug("lguestnet: registering device failed\n");
+		goto free;
+	}
+
+	if (lguest_devices[lgdev->index].features & LGUEST_DEVICE_F_RANDOMNESS)
+		irqf |= IRQF_SAMPLE_RANDOM;
+	if (request_irq(dev->irq, lguestnet_rcv, irqf, "lguestnet", dev) != 0) {
+		pr_debug("lguestnet: could not get net irq %i\n", dev->irq);
+		goto unregister;
+	}
+
+	pr_debug("lguestnet: registered device %s\n", dev->name);
+	lgdev->private = dev;
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

fix-kernel-oops-with-badly-formatted-module-option.patch
git-kbuild.patch
git-net.patch
paravirt_ops-update-maintainers.patch
paravirt_ops-remove-config_debug_paravirt.patch
paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch
paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure.patch
paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch
paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable.patch
paravirt_ops-document-asm-i386-paravirth.patch
paravirt_ops-add-common-patching-machinery.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others-fix.patch
allow-boot-time-disable-of-paravirt_ops-patching.patch
allow-per-cpu-variables-to-be-page-aligned.patch
xfs-clean-up-shrinker-games.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
extend-print_symbol-capability.patch
extend-print_symbol-capability-fix.patch
array_size-check-for-type.patch
array_size-check-for-type-uml-fix.patch
module-use-krealloc.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-update.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
simplify-module_get_kallsym-by-dropping-length-arg.patch
fix-race-between-rmmod-and-cat-proc-kallsyms.patch
simplify-kallsyms_lookup.patch
fix-race-between-cat-proc-wchan-and-rmmod-et-al.patch
fix-race-between-cat-proc-slab_allocators-and-rmmod.patch
expose-range-checking-functions-from-arch-specific.patch
____call_usermodehelper-dont-flush_signals.patch
lguest-the-guest-code.patch
lguest-the-host-code.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
