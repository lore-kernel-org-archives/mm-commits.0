From: akpm@linux-foundation.org
Subject: + bitops-rename-for_each_bit-to-for_each_set_bit.patch added to -mm tree
Date: Mon, 01 Feb 2010 14:25:34 -0800
Message-ID: <201002012225.o11MPYxV016282@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41364 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753556Ab0BAW0F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 17:26:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, adobriyan@gmail.com, akpm@linux-foundation.org


The patch titled
     bitops: rename for_each_bit() to for_each_set_bit()
has been added to the -mm tree.  Its filename is
     bitops-rename-for_each_bit-to-for_each_set_bit.patch

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
Subject: bitops: rename for_each_bit() to for_each_set_bit()
From: Akinobu Mita <akinobu.mita@gmail.com>

Rename for_each_bit to for_each_set_bit in the kernel source tree.

Suggested-by: Alexey Dobriyan <adobriyan@gmail.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/perf_event.c            |    4 ++--
 drivers/dma/ioat/dma.c                      |    2 +-
 drivers/gpio/pl061.c                        |    2 +-
 drivers/gpio/timbgpio.c                     |    2 +-
 drivers/i2c/busses/i2c-designware.c         |    4 ++--
 drivers/mfd/htc-egpio.c                     |    2 +-
 drivers/misc/sgi-xp/xpnet.c                 |    2 +-
 drivers/net/gianfar.c                       |   12 ++++++------
 drivers/net/ixgbe/ixgbe_main.c              |    2 +-
 drivers/net/wireless/ath/ar9170/main.c      |    2 +-
 drivers/net/wireless/iwmc3200wifi/debugfs.c |    2 +-
 drivers/net/wireless/iwmc3200wifi/rx.c      |    2 +-
 fs/ocfs2/quota_local.c                      |    2 +-
 include/linux/bitops.h                      |    2 +-
 sound/soc/codecs/uda1380.c                  |    2 +-
 15 files changed, 22 insertions(+), 22 deletions(-)

diff -puN arch/x86/kernel/cpu/perf_event.c~bitops-rename-for_each_bit-to-for_each_set_bit arch/x86/kernel/cpu/perf_event.c
--- a/arch/x86/kernel/cpu/perf_event.c~bitops-rename-for_each_bit-to-for_each_set_bit
+++ a/arch/x86/kernel/cpu/perf_event.c
@@ -1377,7 +1377,7 @@ static int x86_schedule_events(struct cp
 			if (c->weight != w)
 				continue;
 
-			for_each_bit(j, c->idxmsk, X86_PMC_IDX_MAX) {
+			for_each_set_bit(j, c->idxmsk, X86_PMC_IDX_MAX) {
 				if (!test_bit(j, used_mask))
 					break;
 			}
@@ -2068,7 +2068,7 @@ again:
 
 	inc_irq_stat(apic_perf_irqs);
 	ack = status;
-	for_each_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
+	for_each_set_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
 		struct perf_event *event = cpuc->events[bit];
 
 		clear_bit(bit, (unsigned long *) &status);
diff -puN drivers/dma/ioat/dma.c~bitops-rename-for_each_bit-to-for_each_set_bit drivers/dma/ioat/dma.c
--- a/drivers/dma/ioat/dma.c~bitops-rename-for_each_bit-to-for_each_set_bit
+++ a/drivers/dma/ioat/dma.c
@@ -71,7 +71,7 @@ static irqreturn_t ioat_dma_do_interrupt
 	}
 
 	attnstatus = readl(instance->reg_base + IOAT_ATTNSTATUS_OFFSET);
-	for_each_bit(bit, &attnstatus, BITS_PER_LONG) {
+	for_each_set_bit(bit, &attnstatus, BITS_PER_LONG) {
 		chan = ioat_chan_by_index(instance, bit);
 		tasklet_schedule(&chan->cleanup_task);
 	}
diff -puN drivers/gpio/pl061.c~bitops-rename-for_each_bit-to-for_each_set_bit drivers/gpio/pl061.c
--- a/drivers/gpio/pl061.c~bitops-rename-for_each_bit-to-for_each_set_bit
+++ a/drivers/gpio/pl061.c
@@ -219,7 +219,7 @@ static void pl061_irq_handler(unsigned i
 		if (pending == 0)
 			continue;
 
-		for_each_bit(offset, &pending, PL061_GPIO_NR)
+		for_each_set_bit(offset, &pending, PL061_GPIO_NR)
 			generic_handle_irq(pl061_to_irq(&chip->gc, offset));
 	}
 	desc->chip->unmask(irq);
diff -puN drivers/gpio/timbgpio.c~bitops-rename-for_each_bit-to-for_each_set_bit drivers/gpio/timbgpio.c
--- a/drivers/gpio/timbgpio.c~bitops-rename-for_each_bit-to-for_each_set_bit
+++ a/drivers/gpio/timbgpio.c
@@ -174,7 +174,7 @@ static void timbgpio_irq(unsigned int ir
 	ipr = ioread32(tgpio->membase + TGPIO_IPR);
 	iowrite32(ipr, tgpio->membase + TGPIO_ICR);
 
-	for_each_bit(offset, &ipr, tgpio->gpio.ngpio)
+	for_each_set_bit(offset, &ipr, tgpio->gpio.ngpio)
 		generic_handle_irq(timbgpio_to_irq(&tgpio->gpio, offset));
 }
 
diff -puN drivers/i2c/busses/i2c-designware.c~bitops-rename-for_each_bit-to-for_each_set_bit drivers/i2c/busses/i2c-designware.c
--- a/drivers/i2c/busses/i2c-designware.c~bitops-rename-for_each_bit-to-for_each_set_bit
+++ a/drivers/i2c/busses/i2c-designware.c
@@ -497,13 +497,13 @@ static int i2c_dw_handle_tx_abort(struct
 	int i;
 
 	if (abort_source & DW_IC_TX_ABRT_NOACK) {
-		for_each_bit(i, &abort_source, ARRAY_SIZE(abort_sources))
+		for_each_set_bit(i, &abort_source, ARRAY_SIZE(abort_sources))
 			dev_dbg(dev->dev,
 				"%s: %s\n", __func__, abort_sources[i]);
 		return -EREMOTEIO;
 	}
 
-	for_each_bit(i, &abort_source, ARRAY_SIZE(abort_sources))
+	for_each_set_bit(i, &abort_source, ARRAY_SIZE(abort_sources))
 		dev_err(dev->dev, "%s: %s\n", __func__, abort_sources[i]);
 
 	if (abort_source & DW_IC_TX_ARB_LOST)
diff -puN drivers/mfd/htc-egpio.c~bitops-rename-for_each_bit-to-for_each_set_bit drivers/mfd/htc-egpio.c
--- a/drivers/mfd/htc-egpio.c~bitops-rename-for_each_bit-to-for_each_set_bit
+++ a/drivers/mfd/htc-egpio.c
@@ -108,7 +108,7 @@ static void egpio_handler(unsigned int i
 	ack_irqs(ei);
 	/* Process all set pins. */
 	readval &= ei->irqs_enabled;
-	for_each_bit(irqpin, &readval, ei->nirqs) {
+	for_each_set_bit(irqpin, &readval, ei->nirqs) {
 		/* Run irq handler */
 		pr_debug("got IRQ %d\n", irqpin);
 		irq = ei->irq_start + irqpin;
diff -puN drivers/misc/sgi-xp/xpnet.c~bitops-rename-for_each_bit-to-for_each_set_bit drivers/misc/sgi-xp/xpnet.c
--- a/drivers/misc/sgi-xp/xpnet.c~bitops-rename-for_each_bit-to-for_each_set_bit
+++ a/drivers/misc/sgi-xp/xpnet.c
@@ -475,7 +475,7 @@ xpnet_dev_hard_start_xmit(struct sk_buff
 
 	if (skb->data[0] == 0xff) {
 		/* we are being asked to broadcast to all partitions */
-		for_each_bit(dest_partid, xpnet_broadcast_partitions,
+		for_each_set_bit(dest_partid, xpnet_broadcast_partitions,
 			     xp_max_npartitions) {
 
 			xpnet_send(skb, queued_msg, start_addr, end_addr,
diff -puN drivers/net/gianfar.c~bitops-rename-for_each_bit-to-for_each_set_bit drivers/net/gianfar.c
--- a/drivers/net/gianfar.c~bitops-rename-for_each_bit-to-for_each_set_bit
+++ a/drivers/net/gianfar.c
@@ -998,7 +998,7 @@ static int gfar_probe(struct of_device *
 	}
 
 	/* Need to reverse the bit maps as  bit_map's MSB is q0
-	 * but, for_each_bit parses from right to left, which
+	 * but, for_each_set_bit parses from right to left, which
 	 * basically reverses the queue numbers */
 	for (i = 0; i< priv->num_grps; i++) {
 		priv->gfargrp[i].tx_bit_map = reverse_bitmap(
@@ -1011,7 +1011,7 @@ static int gfar_probe(struct of_device *
 	 * also assign queues to groups */
 	for (grp_idx = 0; grp_idx < priv->num_grps; grp_idx++) {
 		priv->gfargrp[grp_idx].num_rx_queues = 0x0;
-		for_each_bit(i, &priv->gfargrp[grp_idx].rx_bit_map,
+		for_each_set_bit(i, &priv->gfargrp[grp_idx].rx_bit_map,
 				priv->num_rx_queues) {
 			priv->gfargrp[grp_idx].num_rx_queues++;
 			priv->rx_queue[i]->grp = &priv->gfargrp[grp_idx];
@@ -1019,7 +1019,7 @@ static int gfar_probe(struct of_device *
 			rqueue = rqueue | ((RQUEUE_EN0 | RQUEUE_EX0) >> i);
 		}
 		priv->gfargrp[grp_idx].num_tx_queues = 0x0;
-		for_each_bit (i, &priv->gfargrp[grp_idx].tx_bit_map,
+		for_each_set_bit(i, &priv->gfargrp[grp_idx].tx_bit_map,
 				priv->num_tx_queues) {
 			priv->gfargrp[grp_idx].num_tx_queues++;
 			priv->tx_queue[i]->grp = &priv->gfargrp[grp_idx];
@@ -1709,7 +1709,7 @@ void gfar_configure_coalescing(struct gf
 
 	if (priv->mode == MQ_MG_MODE) {
 		baddr = &regs->txic0;
-		for_each_bit (i, &tx_mask, priv->num_tx_queues) {
+		for_each_set_bit(i, &tx_mask, priv->num_tx_queues) {
 			if (likely(priv->tx_queue[i]->txcoalescing)) {
 				gfar_write(baddr + i, 0);
 				gfar_write(baddr + i, priv->tx_queue[i]->txic);
@@ -1717,7 +1717,7 @@ void gfar_configure_coalescing(struct gf
 		}
 
 		baddr = &regs->rxic0;
-		for_each_bit (i, &rx_mask, priv->num_rx_queues) {
+		for_each_set_bit(i, &rx_mask, priv->num_rx_queues) {
 			if (likely(priv->rx_queue[i]->rxcoalescing)) {
 				gfar_write(baddr + i, 0);
 				gfar_write(baddr + i, priv->rx_queue[i]->rxic);
@@ -2607,7 +2607,7 @@ static int gfar_poll(struct napi_struct 
 		budget_per_queue = left_over_budget/num_queues;
 		left_over_budget = 0;
 
-		for_each_bit(i, &gfargrp->rx_bit_map, priv->num_rx_queues) {
+		for_each_set_bit(i, &gfargrp->rx_bit_map, priv->num_rx_queues) {
 			if (test_bit(i, &serviced_queues))
 				continue;
 			rx_queue = priv->rx_queue[i];
diff -puN drivers/net/ixgbe/ixgbe_main.c~bitops-rename-for_each_bit-to-for_each_set_bit drivers/net/ixgbe/ixgbe_main.c
--- a/drivers/net/ixgbe/ixgbe_main.c~bitops-rename-for_each_bit-to-for_each_set_bit
+++ a/drivers/net/ixgbe/ixgbe_main.c
@@ -1027,7 +1027,7 @@ static void ixgbe_configure_msix(struct 
 	 */
 	for (v_idx = 0; v_idx < q_vectors; v_idx++) {
 		q_vector = adapter->q_vector[v_idx];
-		/* XXX for_each_bit(...) */
+		/* XXX for_each_set_bit(...) */
 		r_idx = find_first_bit(q_vector->rxr_idx,
 		                       adapter->num_rx_queues);
 
diff -puN drivers/net/wireless/ath/ar9170/main.c~bitops-rename-for_each_bit-to-for_each_set_bit drivers/net/wireless/ath/ar9170/main.c
--- a/drivers/net/wireless/ath/ar9170/main.c~bitops-rename-for_each_bit-to-for_each_set_bit
+++ a/drivers/net/wireless/ath/ar9170/main.c
@@ -394,7 +394,7 @@ static void ar9170_tx_fake_ampdu_status(
 		ieee80211_tx_status_irqsafe(ar->hw, skb);
 	}
 
-	for_each_bit(i, &queue_bitmap, BITS_PER_BYTE) {
+	for_each_set_bit(i, &queue_bitmap, BITS_PER_BYTE) {
 #ifdef AR9170_QUEUE_STOP_DEBUG
 		printk(KERN_DEBUG "%s: wake queue %d\n",
 		       wiphy_name(ar->hw->wiphy), i);
diff -puN drivers/net/wireless/iwmc3200wifi/debugfs.c~bitops-rename-for_each_bit-to-for_each_set_bit drivers/net/wireless/iwmc3200wifi/debugfs.c
--- a/drivers/net/wireless/iwmc3200wifi/debugfs.c~bitops-rename-for_each_bit-to-for_each_set_bit
+++ a/drivers/net/wireless/iwmc3200wifi/debugfs.c
@@ -89,7 +89,7 @@ static int iwm_debugfs_dbg_modules_write
 	for (i = 0; i < __IWM_DM_NR; i++)
 		iwm->dbg.dbg_module[i] = 0;
 
-	for_each_bit(bit, &iwm->dbg.dbg_modules, __IWM_DM_NR)
+	for_each_set_bit(bit, &iwm->dbg.dbg_modules, __IWM_DM_NR)
 		iwm->dbg.dbg_module[bit] = iwm->dbg.dbg_level;
 
 	return 0;
diff -puN drivers/net/wireless/iwmc3200wifi/rx.c~bitops-rename-for_each_bit-to-for_each_set_bit drivers/net/wireless/iwmc3200wifi/rx.c
--- a/drivers/net/wireless/iwmc3200wifi/rx.c~bitops-rename-for_each_bit-to-for_each_set_bit
+++ a/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -1116,7 +1116,7 @@ static int iwm_ntf_stop_resume_tx(struct
 		return -EINVAL;
 	}
 
-	for_each_bit(bit, (unsigned long *)&tid_msk, IWM_UMAC_TID_NR) {
+	for_each_set_bit(bit, (unsigned long *)&tid_msk, IWM_UMAC_TID_NR) {
 		tid_info = &sta_info->tid_info[bit];
 
 		mutex_lock(&tid_info->mutex);
diff -puN fs/ocfs2/quota_local.c~bitops-rename-for_each_bit-to-for_each_set_bit fs/ocfs2/quota_local.c
--- a/fs/ocfs2/quota_local.c~bitops-rename-for_each_bit-to-for_each_set_bit
+++ a/fs/ocfs2/quota_local.c
@@ -457,7 +457,7 @@ static int ocfs2_recover_local_quota_fil
 			break;
 		}
 		dchunk = (struct ocfs2_local_disk_chunk *)hbh->b_data;
-		for_each_bit(bit, rchunk->rc_bitmap, ol_chunk_entries(sb)) {
+		for_each_set_bit(bit, rchunk->rc_bitmap, ol_chunk_entries(sb)) {
 			qbh = NULL;
 			status = ocfs2_read_quota_block(lqinode,
 						ol_dqblk_block(sb, chunk, bit),
diff -puN include/linux/bitops.h~bitops-rename-for_each_bit-to-for_each_set_bit include/linux/bitops.h
--- a/include/linux/bitops.h~bitops-rename-for_each_bit-to-for_each_set_bit
+++ a/include/linux/bitops.h
@@ -16,7 +16,7 @@
  */
 #include <asm/bitops.h>
 
-#define for_each_bit(bit, addr, size) \
+#define for_each_set_bit(bit, addr, size) \
 	for ((bit) = find_first_bit((addr), (size)); \
 	     (bit) < (size); \
 	     (bit) = find_next_bit((addr), (size), (bit) + 1))
diff -puN sound/soc/codecs/uda1380.c~bitops-rename-for_each_bit-to-for_each_set_bit sound/soc/codecs/uda1380.c
--- a/sound/soc/codecs/uda1380.c~bitops-rename-for_each_bit-to-for_each_set_bit
+++ a/sound/soc/codecs/uda1380.c
@@ -137,7 +137,7 @@ static void uda1380_flush_work(struct wo
 {
 	int bit, reg;
 
-	for_each_bit(bit, &uda1380_cache_dirty, UDA1380_CACHEREGNUM - 0x10) {
+	for_each_set_bit(bit, &uda1380_cache_dirty, UDA1380_CACHEREGNUM - 0x10) {
 		reg = 0x10 + bit;
 		pr_debug("uda1380: flush reg %x val %x:\n", reg,
 				uda1380_read_reg_cache(uda1380_codec, reg));
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
fault-injection-correct-function-names-in-documentation.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
bitmap-use-for_each_set_bit.patch
hpet-use-for_each_set_bit.patch
intel-iommu-use-for_each_set_bit.patch
infiniband-use-for_each_set_bit.patch
ntfs-use-bitmap_weight.patch
phonet-use-for_each_set_bit.patch
atm-use-for_each_set_bit.patch
sched-use-for_each_set_bit.patch
sgi-gru-use-for_each_set_bit.patch

