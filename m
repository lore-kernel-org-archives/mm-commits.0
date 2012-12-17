From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-rejects-git-rejects.patch removed from -mm tree
Date: Mon, 17 Dec 2012 12:18:27 -0800
Message-ID: <20121217201829.EE06F200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:47312 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab2LQUSf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Dec 2012 15:18:35 -0500
Received: by mail-ee0-f74.google.com with SMTP id t10so348235eei.1
        for <mm-commits@vger.kernel.org>; Mon, 17 Dec 2012 12:18:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/boot/dts/Makefile                  |    7 -
 arch/arm/boot/dts/at91sam9260.dtsi          |    4 
 arch/arm/boot/dts/exynos5250-smdk5250.dts   |    3 
 arch/arm/boot/dts/exynos5250.dtsi           |   15 --
 arch/arm/boot/dts/zynq-7000.dtsi            |    8 -
 arch/arm/mach-exynos/mach-exynos5-dt.c      |    6 -
 arch/arm/mach-kirkwood/Kconfig              |    3 
 arch/arm/mach-nomadik/board-nhk8815.c       |    6 -
 arch/arm/mach-ux500/board-mop500-stuib.c    |    5 
 drivers/media/platform/omap/omap_vout.c     |    3 
 drivers/net/ethernet/mellanox/mlx4/en_rx.c  |    4 
 drivers/net/ethernet/mellanox/mlx4/main.c   |    3 
 drivers/net/tun.c                           |   11 -
 drivers/net/virtio_net.c                    |  105 ------------------
 drivers/power/Kconfig                       |    5 
 drivers/ssb/driver_extif.c                  |    3 
 drivers/ssb/ssb_private.h                   |    3 
 include/linux/bcma/bcma_driver_chipcommon.h |    6 -
 include/linux/mfd/tps65090.h                |   37 ------
 include/net/net_namespace.h                 |    3 
 include/uapi/linux/ethtool.h                |    4 
 kernel/nsproxy.c                            |    4 
 mm/huge_memory.c                            |    9 -
 mm/mprotect.c                               |    5 
 net/bridge/br_multicast.c                   |    8 -
 net/nfc/llcp/sock.c                         |    4 
 26 files changed, 2 insertions(+), 272 deletions(-)

diff -puN drivers/net/ethernet/mellanox/mlx4/en_rx.c~linux-next-rejects-git-rejects drivers/net/ethernet/mellanox/mlx4/en_rx.c
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c~linux-next-rejects-git-rejects
+++ a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -710,11 +710,7 @@ next:
 
 		++cq->mcq.cons_index;
 		index = (cq->mcq.cons_index) & ring->size_mask;
-<<<<<<< HEAD
-		cqe = &cq->buf[index];
-=======
 		cqe = &cq->buf[(index << factor) + factor];
->>>>>>> linux-next/akpm-base
 		if (++polled == budget)
 			goto out;
 	}
diff -puN drivers/net/virtio_net.c~linux-next-rejects-git-rejects drivers/net/virtio_net.c
--- a/drivers/net/virtio_net.c~linux-next-rejects-git-rejects
+++ a/drivers/net/virtio_net.c
@@ -147,11 +147,7 @@ struct padded_vnet_hdr {
  */
 static int vq2txq(struct virtqueue *vq)
 {
-<<<<<<< HEAD
-	return (virtqueue_get_queue_index(vq) - 1) / 2;
-=======
 	return (vq->index - 1) / 2;
->>>>>>> linux-next/akpm-base
 }
 
 static int txq2vq(int txq)
@@ -161,11 +157,7 @@ static int txq2vq(int txq)
 
 static int vq2rxq(struct virtqueue *vq)
 {
-<<<<<<< HEAD
-	return virtqueue_get_queue_index(vq) / 2;
-=======
 	return vq->index / 2;
->>>>>>> linux-next/akpm-base
 }
 
 static int rxq2vq(int rxq)
@@ -540,12 +532,8 @@ static bool try_fill_recv(struct receive
 		if (err)
 			break;
 		++rq->num;
-<<<<<<< HEAD
-	} while (err > 0);
-=======
 	} while (rq->vq->num_free);
 
->>>>>>> linux-next/akpm-base
 	if (unlikely(rq->num > rq->max))
 		rq->max = rq->num;
 	virtqueue_kick(rq->vq);
@@ -586,7 +574,6 @@ static void refill_work(struct work_stru
 		container_of(work, struct virtnet_info, refill.work);
 	bool still_empty;
 	int i;
-<<<<<<< HEAD
 
 	for (i = 0; i < vi->max_queue_pairs; i++) {
 		struct receive_queue *rq = &vi->rq[i];
@@ -595,16 +582,6 @@ static void refill_work(struct work_stru
 		still_empty = !try_fill_recv(rq, GFP_KERNEL);
 		virtnet_napi_enable(rq);
 
-=======
-
-	for (i = 0; i < vi->max_queue_pairs; i++) {
-		struct receive_queue *rq = &vi->rq[i];
-
-		napi_disable(&rq->napi);
-		still_empty = !try_fill_recv(rq, GFP_KERNEL);
-		virtnet_napi_enable(rq);
-
->>>>>>> linux-next/akpm-base
 		/* In theory, this can happen: if we don't get any buffers in
 		 * we will *never* try to fill again.
 		 */
@@ -663,17 +640,10 @@ static int virtnet_open(struct net_devic
 	return 0;
 }
 
-<<<<<<< HEAD
-static unsigned int free_old_xmit_skbs(struct send_queue *sq)
-{
-	struct sk_buff *skb;
-	unsigned int len, tot_sgs = 0;
-=======
 static void free_old_xmit_skbs(struct send_queue *sq)
 {
 	struct sk_buff *skb;
 	unsigned int len;
->>>>>>> linux-next/akpm-base
 	struct virtnet_info *vi = sq->vq->vdev->priv;
 	struct virtnet_stats *stats = this_cpu_ptr(vi->stats);
 
@@ -693,10 +663,7 @@ static int xmit_skb(struct send_queue *s
 {
 	struct skb_vnet_hdr *hdr = skb_vnet_hdr(skb);
 	const unsigned char *dest = ((struct ethhdr *)skb->data)->h_dest;
-<<<<<<< HEAD
-=======
 	unsigned num_sg;
->>>>>>> linux-next/akpm-base
 	struct virtnet_info *vi = sq->vq->vdev->priv;
 
 	pr_debug("%s: xmit %p %pM\n", vi->dev->name, skb, dest);
@@ -736,13 +703,8 @@ static int xmit_skb(struct send_queue *s
 	else
 		sg_set_buf(sq->sg, &hdr->hdr, sizeof hdr->hdr);
 
-<<<<<<< HEAD
-	hdr->num_sg = skb_to_sgvec(skb, sq->sg + 1, 0, skb->len) + 1;
-	return virtqueue_add_buf(sq->vq, sq->sg, hdr->num_sg,
-=======
 	num_sg = skb_to_sgvec(skb, sq->sg + 1, 0, skb->len) + 1;
 	return virtqueue_add_buf(sq->vq, sq->sg, num_sg,
->>>>>>> linux-next/akpm-base
 				 0, skb, GFP_ATOMIC);
 }
 
@@ -751,34 +713,12 @@ static netdev_tx_t start_xmit(struct sk_
 	struct virtnet_info *vi = netdev_priv(dev);
 	int qnum = skb_get_queue_mapping(skb);
 	struct send_queue *sq = &vi->sq[qnum];
-<<<<<<< HEAD
-	int capacity;
-=======
 	int err;
->>>>>>> linux-next/akpm-base
 
 	/* Free up any pending old buffers before queueing new ones. */
 	free_old_xmit_skbs(sq);
 
 	/* Try to transmit */
-<<<<<<< HEAD
-	capacity = xmit_skb(sq, skb);
-
-	/* This can happen with OOM and indirect buffers. */
-	if (unlikely(capacity < 0)) {
-		if (likely(capacity == -ENOMEM)) {
-			if (net_ratelimit())
-				dev_warn(&dev->dev,
-					 "TXQ (%d) failure: out of memory\n",
-					 qnum);
-		} else {
-			dev->stats.tx_fifo_errors++;
-			if (net_ratelimit())
-				dev_warn(&dev->dev,
-					 "Unexpected TXQ (%d) failure: %d\n",
-					 qnum, capacity);
-		}
-=======
 	err = xmit_skb(sq, skb);
 
 	/* This should not happen! */
@@ -788,7 +728,6 @@ static netdev_tx_t start_xmit(struct sk_
 			dev_warn(&dev->dev,
 				 "Unexpected TXQ (%d) failure: %d\n",
 				 qnum, err);
->>>>>>> linux-next/akpm-base
 		dev->stats.tx_dropped++;
 		kfree_skb(skb);
 		return NETDEV_TX_OK;
@@ -801,20 +740,11 @@ static netdev_tx_t start_xmit(struct sk_
 
 	/* Apparently nice girls don't return TX_BUSY; stop the queue
 	 * before it gets out of hand.  Naturally, this wastes entries. */
-<<<<<<< HEAD
-	if (capacity < 2+MAX_SKB_FRAGS) {
-		netif_stop_subqueue(dev, qnum);
-		if (unlikely(!virtqueue_enable_cb_delayed(sq->vq))) {
-			/* More just got used, free them then recheck. */
-			capacity += free_old_xmit_skbs(sq);
-			if (capacity >= 2+MAX_SKB_FRAGS) {
-=======
 	if (sq->vq->num_free < 2+MAX_SKB_FRAGS) {
 		netif_stop_subqueue(dev, qnum);
 		if (unlikely(!virtqueue_enable_cb_delayed(sq->vq))) {
 			/* More just got used, free them then recheck. */
 			if (sq->vq->num_free >= 2+MAX_SKB_FRAGS) {
->>>>>>> linux-next/akpm-base
 				netif_start_subqueue(dev, qnum);
 				virtqueue_disable_cb(sq->vq);
 			}
@@ -1289,40 +1219,6 @@ static void free_receive_bufs(struct vir
 			__free_pages(get_a_page(&vi->rq[i], GFP_KERNEL), 0);
 	}
 }
-<<<<<<< HEAD
-
-static void free_unused_bufs(struct virtnet_info *vi)
-{
-	void *buf;
-	int i;
-
-	for (i = 0; i < vi->max_queue_pairs; i++) {
-		struct virtqueue *vq = vi->sq[i].vq;
-		while ((buf = virtqueue_detach_unused_buf(vq)) != NULL)
-			dev_kfree_skb(buf);
-	}
-
-	for (i = 0; i < vi->max_queue_pairs; i++) {
-		struct virtqueue *vq = vi->rq[i].vq;
-
-		while ((buf = virtqueue_detach_unused_buf(vq)) != NULL) {
-			if (vi->mergeable_rx_bufs || vi->big_packets)
-				give_pages(&vi->rq[i], buf);
-			else
-				dev_kfree_skb(buf);
-			--vi->rq[i].num;
-		}
-		BUG_ON(vi->rq[i].num != 0);
-	}
-}
-
-static void virtnet_del_vqs(struct virtnet_info *vi)
-{
-	struct virtio_device *vdev = vi->vdev;
-
-	virtnet_set_affinity(vi, false);
-
-=======
 
 static void free_unused_bufs(struct virtnet_info *vi)
 {
@@ -1355,7 +1251,6 @@ static void virtnet_del_vqs(struct virtn
 
 	virtnet_set_affinity(vi, false);
 
->>>>>>> linux-next/akpm-base
 	vdev->config->del_vqs(vdev);
 
 	virtnet_free_queues(vi);
diff -puN drivers/net/wireless/iwlwifi/pcie/trans.c~linux-next-rejects-git-rejects drivers/net/wireless/iwlwifi/pcie/trans.c
diff -puN drivers/ssb/driver_extif.c~linux-next-rejects-git-rejects drivers/ssb/driver_extif.c
--- a/drivers/ssb/driver_extif.c~linux-next-rejects-git-rejects
+++ a/drivers/ssb/driver_extif.c
@@ -136,8 +136,6 @@ u32 ssb_extif_watchdog_timer_set(struct 
 	extif_write32(extif, SSB_EXTIF_WATCHDOG, ticks);
 
 	return ticks;
-<<<<<<< HEAD
-=======
 }
 
 void ssb_extif_init(struct ssb_extif *extif)
@@ -145,7 +143,6 @@ void ssb_extif_init(struct ssb_extif *ex
 	if (!extif->dev)
 		return; /* We don't have a Extif core */
 	spin_lock_init(&extif->gpio_lock);
->>>>>>> linux-next/akpm-base
 }
 
 u32 ssb_extif_gpio_in(struct ssb_extif *extif, u32 mask)
diff -puN drivers/ssb/ssb_private.h~linux-next-rejects-git-rejects drivers/ssb/ssb_private.h
--- a/drivers/ssb/ssb_private.h~linux-next-rejects-git-rejects
+++ a/drivers/ssb/ssb_private.h
@@ -241,8 +241,6 @@ static inline int ssb_watchdog_register(
 	return 0;
 }
 #endif /* CONFIG_SSB_EMBEDDED */
-<<<<<<< HEAD
-=======
 
 #ifdef CONFIG_SSB_DRIVER_EXTIF
 extern void ssb_extif_init(struct ssb_extif *extif);
@@ -260,6 +258,5 @@ static inline int ssb_gpio_init(struct s
 	return -ENOTSUPP;
 }
 #endif /* CONFIG_SSB_DRIVER_GPIO */
->>>>>>> linux-next/akpm-base
 
 #endif /* LINUX_SSB_PRIVATE_H_ */
diff -puN include/linux/bcma/bcma_driver_chipcommon.h~linux-next-rejects-git-rejects include/linux/bcma/bcma_driver_chipcommon.h
--- a/include/linux/bcma/bcma_driver_chipcommon.h~linux-next-rejects-git-rejects
+++ a/include/linux/bcma/bcma_driver_chipcommon.h
@@ -1,10 +1,7 @@
 #ifndef LINUX_BCMA_DRIVER_CC_H_
 #define LINUX_BCMA_DRIVER_CC_H_
 
-<<<<<<< HEAD
-=======
 #include <linux/gpio.h>
->>>>>>> linux-next/akpm-base
 #include <linux/platform_device.h>
 
 /** ChipCommon core registers. **/
@@ -578,15 +575,12 @@ struct bcma_drv_cc {
 #endif /* CONFIG_BCMA_DRIVER_MIPS */
 	u32 ticks_per_ms;
 	struct platform_device *watchdog;
-<<<<<<< HEAD
-=======
 
 	/* Lock for GPIO register access. */
 	spinlock_t gpio_lock;
 #ifdef CONFIG_BCMA_DRIVER_GPIO
 	struct gpio_chip gpio;
 #endif
->>>>>>> linux-next/akpm-base
 };
 
 /* Register access */
diff -puN drivers/net/ethernet/mellanox/mlx4/main.c~linux-next-rejects-git-rejects drivers/net/ethernet/mellanox/mlx4/main.c
--- a/drivers/net/ethernet/mellanox/mlx4/main.c~linux-next-rejects-git-rejects
+++ a/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -102,11 +102,8 @@ MODULE_PARM_DESC(enable_64b_cqe_eqe,
 
 #define HCA_GLOBAL_CAP_MASK            0
 
-<<<<<<< HEAD
-=======
 #define PF_CONTEXT_BEHAVIOUR_MASK	MLX4_FUNC_CAP_64B_EQE_CQE
 
->>>>>>> linux-next/akpm-base
 static char mlx4_version[] =
 	DRV_NAME ": Mellanox ConnectX core driver v"
 	DRV_VERSION " (" DRV_RELDATE ")\n";
diff -puN include/net/net_namespace.h~linux-next-rejects-git-rejects include/net/net_namespace.h
--- a/include/net/net_namespace.h~linux-next-rejects-git-rejects
+++ a/include/net/net_namespace.h
@@ -56,11 +56,8 @@ struct net {
 
 	struct user_namespace   *user_ns;	/* Owning user namespace */
 
-<<<<<<< HEAD
-=======
 	unsigned int		proc_inum;
 
->>>>>>> linux-next/akpm-base
 	struct proc_dir_entry 	*proc_net;
 	struct proc_dir_entry 	*proc_net_stat;
 
diff -puN kernel/nsproxy.c~linux-next-rejects-git-rejects kernel/nsproxy.c
--- a/kernel/nsproxy.c~linux-next-rejects-git-rejects
+++ a/kernel/nsproxy.c
@@ -91,11 +91,7 @@ static struct nsproxy *create_new_namesp
 		goto out_pid;
 	}
 
-<<<<<<< HEAD
-	new_nsp->net_ns = copy_net_ns(flags, task_cred_xxx(tsk, user_ns), tsk->nsproxy->net_ns);
-=======
 	new_nsp->net_ns = copy_net_ns(flags, user_ns, tsk->nsproxy->net_ns);
->>>>>>> linux-next/akpm-base
 	if (IS_ERR(new_nsp->net_ns)) {
 		err = PTR_ERR(new_nsp->net_ns);
 		goto out_net;
diff -puN arch/arm/boot/dts/Makefile~linux-next-rejects-git-rejects arch/arm/boot/dts/Makefile
--- a/arch/arm/boot/dts/Makefile~linux-next-rejects-git-rejects
+++ a/arch/arm/boot/dts/Makefile
@@ -33,10 +33,7 @@ dtb-$(CONFIG_ARCH_AT91) += at91sam9x25ek
 dtb-$(CONFIG_ARCH_AT91) += at91sam9x35ek.dtb
 
 dtb-$(CONFIG_ARCH_BCM) += bcm11351-brt.dtb
-<<<<<<< HEAD
-=======
 dtb-$(CONFIG_ARCH_BCM2835) += bcm2835-rpi-b.dtb
->>>>>>> linux-next/akpm-base
 dtb-$(CONFIG_ARCH_DAVINCI) += da850-enbw-cmc.dtb \
 	da850-evm.dtb
 dtb-$(CONFIG_ARCH_DOVE) += dove-cm-a510.dtb \
@@ -47,15 +44,11 @@ dtb-$(CONFIG_ARCH_EXYNOS) += exynos4210-
 	exynos4210-trats.dtb \
 	exynos4412-smdk4412.dtb \
 	exynos5250-smdk5250.dtb \
-<<<<<<< HEAD
 	exynos5440-ssdk5440.dtb \
 	exynos4412-smdk4412.dtb \
 	exynos5250-smdk5250.dtb \
 	exynos5250-snow.dtb
-=======
-	exynos5250-snow.dtb \
 	exynos5440-ssdk5440.dtb
->>>>>>> linux-next/akpm-base
 dtb-$(CONFIG_ARCH_HIGHBANK) += highbank.dtb \
 	ecx-2000.dtb
 dtb-$(CONFIG_ARCH_INTEGRATOR) += integratorap.dtb \
diff -puN arch/arm/boot/dts/at91sam9260.dtsi~linux-next-rejects-git-rejects arch/arm/boot/dts/at91sam9260.dtsi
--- a/arch/arm/boot/dts/at91sam9260.dtsi~linux-next-rejects-git-rejects
+++ a/arch/arm/boot/dts/at91sam9260.dtsi
@@ -450,11 +450,7 @@
 				compatible = "atmel,at91rm9200-ssc";
 				reg = <0xfffbc000 0x4000>;
 				interrupts = <14 4 5>;
-<<<<<<< HEAD
-				status = "disabled";
-=======
 				status = "disable";
->>>>>>> linux-next/akpm-base
 			};
 
 			adc0: adc@fffe0000 {
diff -puN arch/arm/boot/dts/exynos5250-smdk5250.dts~linux-next-rejects-git-rejects arch/arm/boot/dts/exynos5250-smdk5250.dts
--- a/arch/arm/boot/dts/exynos5250-smdk5250.dts~linux-next-rejects-git-rejects
+++ a/arch/arm/boot/dts/exynos5250-smdk5250.dts
@@ -204,8 +204,6 @@
 		samsung,mfc-r = <0x43000000 0x800000>;
 		samsung,mfc-l = <0x51000000 0x800000>;
 	};
-<<<<<<< HEAD
-=======
 
 	i2s_0: i2s@03830000 {
 		gpios = <&gpz 0 2 0 0>, <&gpz 1 2 0 0>, <&gpz 2 2 0 0>,
@@ -220,5 +218,4 @@
 	i2s_2: i2s@12D70000 {
 		status = "disabled";
 	};
->>>>>>> linux-next/akpm-base
 };
diff -puN arch/arm/boot/dts/exynos5250.dtsi~linux-next-rejects-git-rejects arch/arm/boot/dts/exynos5250.dtsi
--- a/arch/arm/boot/dts/exynos5250.dtsi~linux-next-rejects-git-rejects
+++ a/arch/arm/boot/dts/exynos5250.dtsi
@@ -31,8 +31,6 @@
 		gsc1 = &gsc_1;
 		gsc2 = &gsc_2;
 		gsc3 = &gsc_3;
-<<<<<<< HEAD
-=======
 		i2c0 = &i2c_0;
 		i2c1 = &i2c_1;
 		i2c2 = &i2c_2;
@@ -46,7 +44,6 @@
 		i2s0 = &i2s_0;
 		i2s1 = &i2s_1;
 		i2s2 = &i2s_2;
->>>>>>> linux-next/akpm-base
 		mshc0 = &dwmmc_0;
 		mshc1 = &dwmmc_1;
 		mshc2 = &dwmmc_2;
@@ -135,11 +132,7 @@
 		reg = <0x12170000 0x1ff>;
 	};
 
-<<<<<<< HEAD
-	i2c@12C60000 {
-=======
 	i2c_0: i2c@12C60000 {
->>>>>>> linux-next/akpm-base
 		compatible = "samsung,s3c2440-i2c";
 		reg = <0x12C60000 0x100>;
 		interrupts = <0 56 0>;
@@ -203,11 +196,7 @@
 		#size-cells = <0>;
 	};
 
-<<<<<<< HEAD
-	i2c@12CE0000 {
-=======
 	i2c_8: i2c@12CE0000 {
->>>>>>> linux-next/akpm-base
 		compatible = "samsung,s3c2440-hdmiphy-i2c";
 		reg = <0x12CE0000 0x1000>;
 		interrupts = <0 64 0>;
@@ -215,11 +204,7 @@
 		#size-cells = <0>;
 	};
 
-<<<<<<< HEAD
-	i2c@121D0000 {
-=======
 	i2c_9: i2c@121D0000 {
->>>>>>> linux-next/akpm-base
                 compatible = "samsung,exynos5-sata-phy-i2c";
                 reg = <0x121D0000 0x100>;
                 #address-cells = <1>;
diff -puN arch/arm/boot/dts/zynq-7000.dtsi~linux-next-rejects-git-rejects arch/arm/boot/dts/zynq-7000.dtsi
--- a/arch/arm/boot/dts/zynq-7000.dtsi~linux-next-rejects-git-rejects
+++ a/arch/arm/boot/dts/zynq-7000.dtsi
@@ -44,22 +44,14 @@
 			compatible = "xlnx,xuartps";
 			reg = <0xE0000000 0x1000>;
 			interrupts = <0 27 4>;
-<<<<<<< HEAD
-			clock = <50000000>;
-=======
 			clocks = <&uart_clk 0>;
->>>>>>> linux-next/akpm-base
 		};
 
 		uart1: uart@e0001000 {
 			compatible = "xlnx,xuartps";
 			reg = <0xE0001000 0x1000>;
 			interrupts = <0 50 4>;
-<<<<<<< HEAD
-			clock = <50000000>;
-=======
 			clocks = <&uart_clk 1>;
->>>>>>> linux-next/akpm-base
 		};
 
 		slcr: slcr@f8000000 {
diff -puN arch/arm/mach-exynos/mach-exynos5-dt.c~linux-next-rejects-git-rejects arch/arm/mach-exynos/mach-exynos5-dt.c
--- a/arch/arm/mach-exynos/mach-exynos5-dt.c~linux-next-rejects-git-rejects
+++ a/arch/arm/mach-exynos/mach-exynos5-dt.c
@@ -12,10 +12,7 @@
 #include <linux/of_platform.h>
 #include <linux/of_fdt.h>
 #include <linux/serial_core.h>
-<<<<<<< HEAD
-=======
 #include <linux/io.h>
->>>>>>> linux-next/akpm-base
 #include <linux/memblock.h>
 #include <linux/of_fdt.h>
 
@@ -108,15 +105,12 @@ static const struct of_dev_auxdata exyno
 	OF_DEV_AUXDATA("samsung,mfc-v6", 0x11000000, "s5p-mfc-v6", NULL),
 	OF_DEV_AUXDATA("samsung,exynos5250-tmu", 0x10060000,
 				"exynos-tmu", NULL),
-<<<<<<< HEAD
-=======
 	OF_DEV_AUXDATA("samsung,samsung-i2s", 0x03830000,
 				"samsung-i2s.0", NULL),
 	OF_DEV_AUXDATA("samsung,samsung-i2s", 0x12D60000,
 				"samsung-i2s.1", NULL),
 	OF_DEV_AUXDATA("samsung,samsung-i2s", 0x12D70000,
 				"samsung-i2s.2", NULL),
->>>>>>> linux-next/akpm-base
 	{},
 };
 
diff -puN arch/arm/mach-kirkwood/Kconfig~linux-next-rejects-git-rejects arch/arm/mach-kirkwood/Kconfig
--- a/arch/arm/mach-kirkwood/Kconfig~linux-next-rejects-git-rejects
+++ a/arch/arm/mach-kirkwood/Kconfig
@@ -51,11 +51,8 @@ config ARCH_KIRKWOOD_DT
 	select POWER_RESET_GPIO
 	select REGULATOR
 	select REGULATOR_FIXED_VOLTAGE
-<<<<<<< HEAD
-=======
 	select MVEBU_CLK_CORE
 	select MVEBU_CLK_GATING
->>>>>>> linux-next/akpm-base
 	select USE_OF
 	help
 	  Say 'Y' here if you want your kernel to support the
diff -puN arch/arm/mach-nomadik/board-nhk8815.c~linux-next-rejects-git-rejects arch/arm/mach-nomadik/board-nhk8815.c
--- a/arch/arm/mach-nomadik/board-nhk8815.c~linux-next-rejects-git-rejects
+++ a/arch/arm/mach-nomadik/board-nhk8815.c
@@ -27,20 +27,14 @@
 #include <linux/pinctrl/machine.h>
 #include <linux/platform_data/pinctrl-nomadik.h>
 #include <linux/platform_data/clocksource-nomadik-mtu.h>
-<<<<<<< HEAD
 #include <linux/platform_data/mtd-nomadik-nand.h>
-=======
->>>>>>> linux-next/akpm-base
 #include <asm/hardware/vic.h>
 #include <asm/sizes.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/flash.h>
 #include <asm/mach/time.h>
-<<<<<<< HEAD
 #include <mach/fsmc.h>
-=======
->>>>>>> linux-next/akpm-base
 #include <mach/irqs.h>
 
 #include "cpu-8815.h"
diff -puN arch/arm/mach-ux500/board-mop500-stuib.c~linux-next-rejects-git-rejects arch/arm/mach-ux500/board-mop500-stuib.c
--- a/arch/arm/mach-ux500/board-mop500-stuib.c~linux-next-rejects-git-rejects
+++ a/arch/arm/mach-ux500/board-mop500-stuib.c
@@ -1,4 +1,4 @@
-/*
+q/*
  * Copyright (C) ST-Ericsson SA 2010
  *
  * License terms: GNU General Public License (GPL), version 2
@@ -86,14 +86,11 @@ static struct i2c_board_info __initdata 
 #define TSC_EXT_CLOCK_9_6MHZ	0x840000
 
 static struct bu21013_platform_device tsc_plat_device = {
-<<<<<<< HEAD
 	.cs_en = bu21013_gpio_board_init,
 	.cs_dis = bu21013_gpio_board_exit,
 	.irq_read_val = bu21013_read_pin_val,
 	.irq = NOMADIK_GPIO_TO_IRQ(TOUCH_GPIO_PIN),
-=======
 	.touch_pin = TOUCH_GPIO_PIN,
->>>>>>> linux-next/akpm-base
 	.touch_x_max = TOUCH_XMAX,
 	.touch_y_max = TOUCH_YMAX,
 	.ext_clk = false,
diff -puN drivers/media/platform/omap/omap_vout.c~linux-next-rejects-git-rejects drivers/media/platform/omap/omap_vout.c
--- a/drivers/media/platform/omap/omap_vout.c~linux-next-rejects-git-rejects
+++ a/drivers/media/platform/omap/omap_vout.c
@@ -44,10 +44,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 
-<<<<<<< HEAD
 #include <plat/cpu.h>
-=======
->>>>>>> linux-next/akpm-base
 #include <linux/omap-dma.h>
 #include <video/omapvrfb.h>
 #include <video/omapdss.h>
diff -puN drivers/net/tun.c~linux-next-rejects-git-rejects drivers/net/tun.c
--- a/drivers/net/tun.c~linux-next-rejects-git-rejects
+++ a/drivers/net/tun.c
@@ -297,20 +297,13 @@ static void tun_flow_cleanup(unsigned lo
 	spin_unlock_bh(&tun->lock);
 }
 
-<<<<<<< HEAD
-static void tun_flow_update(struct tun_struct *tun, u32 rxhash,
-=======
 static void tun_flow_update(struct tun_struct *tun, struct sk_buff *skb,
->>>>>>> linux-next/akpm-base
 			    u16 queue_index)
 {
 	struct hlist_head *head;
 	struct tun_flow_entry *e;
 	unsigned long delay = tun->ageing_time;
-<<<<<<< HEAD
-=======
 	u32 rxhash = skb_get_rxhash(skb);
->>>>>>> linux-next/akpm-base
 
 	if (!rxhash)
 		return;
@@ -1176,11 +1169,7 @@ static ssize_t tun_get_user(struct tun_s
 	tun->dev->stats.rx_packets++;
 	tun->dev->stats.rx_bytes += len;
 
-<<<<<<< HEAD
-	tun_flow_update(tun, rxhash, tfile->queue_index);
-=======
 	tun_flow_update(tun, skb, tfile->queue_index);
->>>>>>> linux-next/akpm-base
 	return total_len;
 }
 
diff -puN drivers/power/Kconfig~linux-next-rejects-git-rejects drivers/power/Kconfig
--- a/drivers/power/Kconfig~linux-next-rejects-git-rejects
+++ a/drivers/power/Kconfig
@@ -48,7 +48,7 @@ config WM831X_BACKUP
 	depends on MFD_WM831X
 	help
 	  Say Y here to enable support for the backup battery charger
-	  in the Wolfson Microelectronics WM831x PMICs.
+	  in the Wolfson Microelectronics WM831x PMICs.q
 
 config WM831X_POWER
 	tristate "WM831X PMU support"
@@ -346,7 +346,6 @@ config AB8500_BM
 	help
 	  Say Y to include support for AB8500 battery management.
 
-<<<<<<< HEAD
 config AB8500_BATTERY_THERM_ON_BATCTRL
 	bool "Thermistor connected on BATCTRL ADC"
 	depends on AB8500_BM
@@ -354,8 +353,6 @@ config AB8500_BATTERY_THERM_ON_BATCTRL
 	  Say Y to enable battery temperature measurements using
 	  thermistor connected on BATCTRL ADC.
 
-=======
->>>>>>> linux-next/akpm-base
 source "drivers/power/reset/Kconfig"
 
 endif # POWER_SUPPLY
diff -puN include/linux/mfd/tps65090.h~linux-next-rejects-git-rejects include/linux/mfd/tps65090.h
--- a/include/linux/mfd/tps65090.h~linux-next-rejects-git-rejects
+++ a/include/linux/mfd/tps65090.h
@@ -63,25 +63,6 @@ enum {
 	TPS65090_REGULATOR_MAX,
 };
 
-/* TPS65090 Regulator ID */
-enum {
-	TPS65090_REGULATOR_DCDC1,
-	TPS65090_REGULATOR_DCDC2,
-	TPS65090_REGULATOR_DCDC3,
-	TPS65090_REGULATOR_FET1,
-	TPS65090_REGULATOR_FET2,
-	TPS65090_REGULATOR_FET3,
-	TPS65090_REGULATOR_FET4,
-	TPS65090_REGULATOR_FET5,
-	TPS65090_REGULATOR_FET6,
-	TPS65090_REGULATOR_FET7,
-	TPS65090_REGULATOR_LDO1,
-	TPS65090_REGULATOR_LDO2,
-
-	/* Last entry for maximum ID */
-	TPS65090_REGULATOR_MAX,
-};
-
 struct tps65090 {
 	struct device		*dev;
 	struct regmap		*rmap;
@@ -103,28 +84,10 @@ struct tps65090_regulator_plat_data {
 	int gpio;
 };
 
-/*
- * struct tps65090_regulator_plat_data
- *
- * @reg_init_data: The regulator init data.
- * @enable_ext_control: Enable extrenal control or not. Only available for
- *     DCDC1, DCDC2 and DCDC3.
- * @gpio: Gpio number if external control is enabled and controlled through
- *     gpio.
- */
-struct tps65090_regulator_plat_data {
-	struct regulator_init_data *reg_init_data;
-	bool enable_ext_control;
-	int gpio;
-};
-
 struct tps65090_platform_data {
 	int irq_base;
-<<<<<<< HEAD
 	int num_subdevs;
 	struct tps65090_subdev_info *subdevs;
-=======
->>>>>>> linux-next/akpm-base
 	struct tps65090_regulator_plat_data *reg_pdata[TPS65090_REGULATOR_MAX];
 };
 
diff -puN include/uapi/linux/ethtool.h~linux-next-rejects-git-rejects include/uapi/linux/ethtool.h
--- a/include/uapi/linux/ethtool.h~linux-next-rejects-git-rejects
+++ a/include/uapi/linux/ethtool.h
@@ -516,11 +516,7 @@ union ethtool_flow_union {
  */
 struct ethtool_flow_ext {
 	__u8		padding[2];
-<<<<<<< HEAD
-	unsigned char	h_dest[ETH_ALEN];
-=======
 	unsigned char	h_dest[ETH_ALEN];	/* destination eth addr	*/
->>>>>>> linux-next/akpm-base
 	__be16		vlan_etype;
 	__be16		vlan_tci;
 	__be32		data[2];
diff -puN mm/huge_memory.c~linux-next-rejects-git-rejects mm/huge_memory.c
--- a/mm/huge_memory.c~linux-next-rejects-git-rejects
+++ a/mm/huge_memory.c
@@ -19,11 +19,7 @@
 #include <linux/freezer.h>
 #include <linux/mman.h>
 #include <linux/pagemap.h>
-<<<<<<< HEAD
-
-=======
 #include <linux/migrate.h>
->>>>>>> linux-next/akpm-base
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
 #include "internal.h"
@@ -1466,10 +1462,6 @@ int change_huge_pmd(struct vm_area_struc
 	if (__pmd_trans_huge_lock(pmd, vma) == 1) {
 		pmd_t entry;
 		entry = pmdp_get_and_clear(mm, addr, pmd);
-<<<<<<< HEAD
-		entry = pmd_modify(entry, newprot);
-		BUG_ON(pmd_write(entry));
-=======
 		if (!prot_numa)
 			entry = pmd_modify(entry, newprot);
 		else {
@@ -1481,7 +1473,6 @@ int change_huge_pmd(struct vm_area_struc
 				entry = pmd_mknuma(entry);
 			}
 		}
->>>>>>> linux-next/akpm-base
 		set_pmd_at(mm, addr, pmd, entry);
 		spin_unlock(&vma->vm_mm->page_table_lock);
 		ret = 1;
diff -puN mm/mprotect.c~linux-next-rejects-git-rejects mm/mprotect.c
--- a/mm/mprotect.c~linux-next-rejects-git-rejects
+++ a/mm/mprotect.c
@@ -126,14 +126,9 @@ static inline unsigned long change_pmd_r
 		next = pmd_addr_end(addr, end);
 		if (pmd_trans_huge(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE)
-<<<<<<< HEAD
 				split_huge_page_pmd(vma, addr, pmd);
-			else if (change_huge_pmd(vma, pmd, addr, newprot))
-=======
-				split_huge_page_pmd(vma->vm_mm, pmd);
 			else if (change_huge_pmd(vma, pmd, addr, newprot, prot_numa)) {
 				pages += HPAGE_PMD_NR;
->>>>>>> linux-next/akpm-base
 				continue;
 			}
 			/* fall through */
diff -puN net/bridge/br_multicast.c~linux-next-rejects-git-rejects net/bridge/br_multicast.c
--- a/net/bridge/br_multicast.c~linux-next-rejects-git-rejects
+++ a/net/bridge/br_multicast.c
@@ -622,11 +622,7 @@ out:
 struct net_bridge_port_group *br_multicast_new_port_group(
 			struct net_bridge_port *port,
 			struct br_ip *group,
-<<<<<<< HEAD
-			struct net_bridge_port_group __rcu *next)
-=======
 			struct net_bridge_port_group *next)
->>>>>>> linux-next/akpm-base
 {
 	struct net_bridge_port_group *p;
 
@@ -636,11 +632,7 @@ struct net_bridge_port_group *br_multica
 
 	p->addr = *group;
 	p->port = port;
-<<<<<<< HEAD
-	rcu_assign_pointer(p->next, next);
-=======
 	p->next = next;
->>>>>>> linux-next/akpm-base
 	hlist_add_head(&p->mglist, &port->mglist);
 	setup_timer(&p->timer, br_multicast_port_group_expired,
 		    (unsigned long)p);
diff -puN net/nfc/llcp/sock.c~linux-next-rejects-git-rejects net/nfc/llcp/sock.c
--- a/net/nfc/llcp/sock.c~linux-next-rejects-git-rejects
+++ a/net/nfc/llcp/sock.c
@@ -614,13 +614,9 @@ static int llcp_sock_sendmsg(struct kioc
 
 		if (msg->msg_namelen < sizeof(*addr)) {
 			release_sock(sk);
-<<<<<<< HEAD
-=======
-
 			pr_err("Invalid socket address length %d\n",
 			       msg->msg_namelen);
 
->>>>>>> linux-next/akpm-base
 			return -EINVAL;
 		}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
make-my-i386-build-work.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
irq-tsk-comm-is-an-array.patch
block-remove-deadlock-in-disk_clear_events-fix.patch
block-prevent-race-cleanup-fix.patch
mm.patch
memory-hotplug-document-and-enable-config_movable_node-fix.patch
memcg-kmem-accounting-basic-infrastructure-fix.patch
slub-slub-specific-propagation-changes-fix.patch
mm-mprotectc-coding-style-cleanups.patch
mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix.patch
mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix-2.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
lseek-the-whence-argument-is-called-whence.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
backlight-add-of_find_backlight_by_node-function-fix.patch
backlight-88pm860x_bl-remove-an-unnecessary-line-continuation-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-avoid-calling-platform_device_put-twice-in-test_init-fix.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes-checkpatch-fixes.patch
hfsplus-rework-processing-of-hfs_btree_write-returned-error-fix.patch
core_pattern-set-core-helpers-root-and-namespace-to-crashing-process-fix.patch
core_pattern-set-core-helpers-root-and-namespace-to-crashing-process-fix-checkpatch-fixes.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
ipc-convert-prepare_copy-from-macro-to-function-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix.patch
fs-notify-add-procfs-fdinfo-helper-v7-fix.patch
scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

