From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-rejects.patch removed from -mm tree
Date: Wed, 06 Nov 2013 12:58:28 -0800
Message-ID: <527aad74.YUUqR8zP/oNK22xg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38313 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610Ab3KFU63 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Nov 2013 15:58:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: [obsolete] linux-next-rejects.patch removed from -mm tree
To: akpm@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 06 Nov 2013 12:58:28 -0800


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init.c                      |   20 
 drivers/net/wireless/rt2x00/rt2800pci.c |  468 ----------------------
 2 files changed, 19 insertions(+), 469 deletions(-)

diff -puN arch/x86/mm/init.c~linux-next-rejects arch/x86/mm/init.c
--- a/arch/x86/mm/init.c~linux-next-rejects
+++ a/arch/x86/mm/init.c
@@ -399,8 +399,24 @@ static unsigned long __init init_range_m
 	return mapped_ram_size;
 }
 
-/* (PUD_SHIFT-PMD_SHIFT)/2 */
-#define STEP_SIZE_SHIFT 5
+static unsigned long __init get_new_step_size(unsigned long step_size)
+{
+	/*
+	 * Explain why we shift by 5 and why we don't have to worry about
+	 * 'step_size << 5' overflowing:
+	 *
+	 * initial mapped size is PMD_SIZE (2M).
+	 * We can not set step_size to be PUD_SIZE (1G) yet.
+	 * In worse case, when we cross the 1G boundary, and
+	 * PG_LEVEL_2M is not set, we will need 1+1+512 pages (2M + 8k)
+	 * to map 1G range with PTE. Use 5 as shift for now.
+	 *
+	 * Don't need to worry about overflow, on 32bit, when step_size
+	 * is 0, round_down() returns 0 for start, and that turns it
+	 * into 0x100000000ULL.
+	 */
+	return step_size << 5;
+}
 
 /**
  * memory_map_top_down - Map [map_start, map_end) top down
diff -puN drivers/net/wireless/rt2x00/rt2800pci.c~linux-next-rejects drivers/net/wireless/rt2x00/rt2800pci.c
--- a/drivers/net/wireless/rt2x00/rt2800pci.c~linux-next-rejects
+++ a/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -285,479 +285,13 @@ static int rt2800pci_set_device_state(st
 }
 
 /*
- * TX descriptor initialization
- */
-static __le32 *rt2800pci_get_txwi(struct queue_entry *entry)
-{
-	return (__le32 *) entry->skb->data;
-}
-
-static void rt2800pci_write_tx_desc(struct queue_entry *entry,
-				    struct txentry_desc *txdesc)
-{
-	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
-	struct queue_entry_priv_mmio *entry_priv = entry->priv_data;
-	__le32 *txd = entry_priv->desc;
-	u32 word;
-	const unsigned int txwi_size = entry->queue->winfo_size;
-
-	/*
-	 * The buffers pointed by SD_PTR0/SD_LEN0 and SD_PTR1/SD_LEN1
-	 * must contains a TXWI structure + 802.11 header + padding + 802.11
-	 * data. We choose to have SD_PTR0/SD_LEN0 only contains TXWI and
-	 * SD_PTR1/SD_LEN1 contains 802.11 header + padding + 802.11
-	 * data. It means that LAST_SEC0 is always 0.
-	 */
-
-	/*
-	 * Initialize TX descriptor
-	 */
-	word = 0;
-	rt2x00_set_field32(&word, TXD_W0_SD_PTR0, skbdesc->skb_dma);
-	rt2x00_desc_write(txd, 0, word);
-
-	word = 0;
-	rt2x00_set_field32(&word, TXD_W1_SD_LEN1, entry->skb->len);
-	rt2x00_set_field32(&word, TXD_W1_LAST_SEC1,
-			   !test_bit(ENTRY_TXD_MORE_FRAG, &txdesc->flags));
-	rt2x00_set_field32(&word, TXD_W1_BURST,
-			   test_bit(ENTRY_TXD_BURST, &txdesc->flags));
-	rt2x00_set_field32(&word, TXD_W1_SD_LEN0, txwi_size);
-	rt2x00_set_field32(&word, TXD_W1_LAST_SEC0, 0);
-	rt2x00_set_field32(&word, TXD_W1_DMA_DONE, 0);
-	rt2x00_desc_write(txd, 1, word);
-
-	word = 0;
-	rt2x00_set_field32(&word, TXD_W2_SD_PTR1,
-			   skbdesc->skb_dma + txwi_size);
-	rt2x00_desc_write(txd, 2, word);
-
-	word = 0;
-	rt2x00_set_field32(&word, TXD_W3_WIV,
-			   !test_bit(ENTRY_TXD_ENCRYPT_IV, &txdesc->flags));
-	rt2x00_set_field32(&word, TXD_W3_QSEL, 2);
-	rt2x00_desc_write(txd, 3, word);
-
-	/*
-	 * Register descriptor details in skb frame descriptor.
-	 */
-	skbdesc->desc = txd;
-	skbdesc->desc_len = TXD_DESC_SIZE;
-}
-
-/*
- * RX control handlers
- */
-static void rt2800pci_fill_rxdone(struct queue_entry *entry,
-				  struct rxdone_entry_desc *rxdesc)
-{
-	struct queue_entry_priv_mmio *entry_priv = entry->priv_data;
-	__le32 *rxd = entry_priv->desc;
-	u32 word;
-
-	rt2x00_desc_read(rxd, 3, &word);
-
-	if (rt2x00_get_field32(word, RXD_W3_CRC_ERROR))
-		rxdesc->flags |= RX_FLAG_FAILED_FCS_CRC;
-
-	/*
-	 * Unfortunately we don't know the cipher type used during
-	 * decryption. This prevents us from correct providing
-	 * correct statistics through debugfs.
-	 */
-	rxdesc->cipher_status = rt2x00_get_field32(word, RXD_W3_CIPHER_ERROR);
-
-	if (rt2x00_get_field32(word, RXD_W3_DECRYPTED)) {
-		/*
-		 * Hardware has stripped IV/EIV data from 802.11 frame during
-		 * decryption. Unfortunately the descriptor doesn't contain
-		 * any fields with the EIV/IV data either, so they can't
-		 * be restored by rt2x00lib.
-		 */
-		rxdesc->flags |= RX_FLAG_IV_STRIPPED;
-
-		/*
-		 * The hardware has already checked the Michael Mic and has
-		 * stripped it from the frame. Signal this to mac80211.
-		 */
-		rxdesc->flags |= RX_FLAG_MMIC_STRIPPED;
-
-		if (rxdesc->cipher_status == RX_CRYPTO_SUCCESS)
-			rxdesc->flags |= RX_FLAG_DECRYPTED;
-		else if (rxdesc->cipher_status == RX_CRYPTO_FAIL_MIC)
-			rxdesc->flags |= RX_FLAG_MMIC_ERROR;
-	}
-
-	if (rt2x00_get_field32(word, RXD_W3_MY_BSS))
-		rxdesc->dev_flags |= RXDONE_MY_BSS;
-
-	if (rt2x00_get_field32(word, RXD_W3_L2PAD))
-		rxdesc->dev_flags |= RXDONE_L2PAD;
-
-	/*
-	 * Process the RXWI structure that is at the start of the buffer.
-	 */
-	rt2800_process_rxwi(entry, rxdesc);
-}
-
-/*
- * Interrupt functions.
- */
-static void rt2800pci_wakeup(struct rt2x00_dev *rt2x00dev)
-{
-	struct ieee80211_conf conf = { .flags = 0 };
-	struct rt2x00lib_conf libconf = { .conf = &conf };
-
-	rt2800_config(rt2x00dev, &libconf, IEEE80211_CONF_CHANGE_PS);
-}
-
-static bool rt2800pci_txdone_entry_check(struct queue_entry *entry, u32 status)
-{
-	__le32 *txwi;
-	u32 word;
-	int wcid, tx_wcid;
-
-	wcid = rt2x00_get_field32(status, TX_STA_FIFO_WCID);
-
-	txwi = rt2800_drv_get_txwi(entry);
-	rt2x00_desc_read(txwi, 1, &word);
-	tx_wcid = rt2x00_get_field32(word, TXWI_W1_WIRELESS_CLI_ID);
-
-	return (tx_wcid == wcid);
-}
-
-static bool rt2800pci_txdone_find_entry(struct queue_entry *entry, void *data)
-{
-	u32 status = *(u32 *)data;
-
-	/*
-	 * rt2800pci hardware might reorder frames when exchanging traffic
-	 * with multiple BA enabled STAs.
-	 *
-	 * For example, a tx queue
-	 *    [ STA1 | STA2 | STA1 | STA2 ]
-	 * can result in tx status reports
-	 *    [ STA1 | STA1 | STA2 | STA2 ]
-	 * when the hw decides to aggregate the frames for STA1 into one AMPDU.
-	 *
-	 * To mitigate this effect, associate the tx status to the first frame
-	 * in the tx queue with a matching wcid.
-	 */
-	if (rt2800pci_txdone_entry_check(entry, status) &&
-	    !test_bit(ENTRY_DATA_STATUS_SET, &entry->flags)) {
-		/*
-		 * Got a matching frame, associate the tx status with
-		 * the frame
-		 */
-		entry->status = status;
-		set_bit(ENTRY_DATA_STATUS_SET, &entry->flags);
-		return true;
-	}
-
-	/* Check the next frame */
-	return false;
-}
-
-static bool rt2800pci_txdone_match_first(struct queue_entry *entry, void *data)
-{
-	u32 status = *(u32 *)data;
-
-	/*
-	 * Find the first frame without tx status and assign this status to it
-	 * regardless if it matches or not.
-	 */
-	if (!test_bit(ENTRY_DATA_STATUS_SET, &entry->flags)) {
-		/*
-		 * Got a matching frame, associate the tx status with
-		 * the frame
-		 */
-		entry->status = status;
-		set_bit(ENTRY_DATA_STATUS_SET, &entry->flags);
-		return true;
-	}
-
-	/* Check the next frame */
-	return false;
-}
-static bool rt2800pci_txdone_release_entries(struct queue_entry *entry,
-					     void *data)
-{
-	if (test_bit(ENTRY_DATA_STATUS_SET, &entry->flags)) {
-		rt2800_txdone_entry(entry, entry->status,
-				    rt2800pci_get_txwi(entry));
-		return false;
-	}
-
-	/* No more frames to release */
-	return true;
-}
-
-static bool rt2800pci_txdone(struct rt2x00_dev *rt2x00dev)
-{
-	struct data_queue *queue;
-	u32 status;
-	u8 qid;
-	int max_tx_done = 16;
-
-	while (kfifo_get(&rt2x00dev->txstatus_fifo, &status)) {
-		qid = rt2x00_get_field32(status, TX_STA_FIFO_PID_QUEUE);
-		if (unlikely(qid >= QID_RX)) {
-			/*
-			 * Unknown queue, this shouldn't happen. Just drop
-			 * this tx status.
-			 */
-			rt2x00_warn(rt2x00dev, "Got TX status report with unexpected pid %u, dropping\n",
-				    qid);
-			break;
-		}
-
-		queue = rt2x00queue_get_tx_queue(rt2x00dev, qid);
-		if (unlikely(queue == NULL)) {
-			/*
-			 * The queue is NULL, this shouldn't happen. Stop
-			 * processing here and drop the tx status
-			 */
-			rt2x00_warn(rt2x00dev, "Got TX status for an unavailable queue %u, dropping\n",
-				    qid);
-			break;
-		}
-
-		if (unlikely(rt2x00queue_empty(queue))) {
-			/*
-			 * The queue is empty. Stop processing here
-			 * and drop the tx status.
-			 */
-			rt2x00_warn(rt2x00dev, "Got TX status for an empty queue %u, dropping\n",
-				    qid);
-			break;
-		}
-
-		/*
-		 * Let's associate this tx status with the first
-		 * matching frame.
-		 */
-		if (!rt2x00queue_for_each_entry(queue, Q_INDEX_DONE,
-						Q_INDEX, &status,
-						rt2800pci_txdone_find_entry)) {
-			/*
-			 * We cannot match the tx status to any frame, so just
-			 * use the first one.
-			 */
-			if (!rt2x00queue_for_each_entry(queue, Q_INDEX_DONE,
-							Q_INDEX, &status,
-							rt2800pci_txdone_match_first)) {
-				rt2x00_warn(rt2x00dev, "No frame found for TX status on queue %u, dropping\n",
-					    qid);
-				break;
-			}
-		}
-
-		/*
-		 * Release all frames with a valid tx status.
-		 */
-		rt2x00queue_for_each_entry(queue, Q_INDEX_DONE,
-					   Q_INDEX, NULL,
-					   rt2800pci_txdone_release_entries);
-
-		if (--max_tx_done == 0)
-			break;
-	}
-
-	return !max_tx_done;
-}
-
-static inline void rt2800pci_enable_interrupt(struct rt2x00_dev *rt2x00dev,
-					      struct rt2x00_field32 irq_field)
-{
-	u32 reg;
-
-	/*
-	 * Enable a single interrupt. The interrupt mask register
-	 * access needs locking.
-	 */
-	spin_lock_irq(&rt2x00dev->irqmask_lock);
-	rt2x00mmio_register_read(rt2x00dev, INT_MASK_CSR, &reg);
-	rt2x00_set_field32(&reg, irq_field, 1);
-	rt2x00mmio_register_write(rt2x00dev, INT_MASK_CSR, reg);
-	spin_unlock_irq(&rt2x00dev->irqmask_lock);
-}
-
-static void rt2800pci_txstatus_tasklet(unsigned long data)
-{
-	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
-	if (rt2800pci_txdone(rt2x00dev))
-		tasklet_schedule(&rt2x00dev->txstatus_tasklet);
-
-	/*
-	 * No need to enable the tx status interrupt here as we always
-	 * leave it enabled to minimize the possibility of a tx status
-	 * register overflow. See comment in interrupt handler.
-	 */
-}
-
-static void rt2800pci_pretbtt_tasklet(unsigned long data)
-{
-	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
-	rt2x00lib_pretbtt(rt2x00dev);
-	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
-		rt2800pci_enable_interrupt(rt2x00dev, INT_MASK_CSR_PRE_TBTT);
-}
-
-static void rt2800pci_tbtt_tasklet(unsigned long data)
-{
-	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
-	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
-	u32 reg;
-
-	rt2x00lib_beacondone(rt2x00dev);
-
-	if (rt2x00dev->intf_ap_count) {
-		/*
-		 * The rt2800pci hardware tbtt timer is off by 1us per tbtt
-		 * causing beacon skew and as a result causing problems with
-		 * some powersaving clients over time. Shorten the beacon
-		 * interval every 64 beacons by 64us to mitigate this effect.
-		 */
-		if (drv_data->tbtt_tick == (BCN_TBTT_OFFSET - 2)) {
-			rt2x00mmio_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
-			rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_INTERVAL,
-					   (rt2x00dev->beacon_int * 16) - 1);
-			rt2x00mmio_register_write(rt2x00dev, BCN_TIME_CFG, reg);
-		} else if (drv_data->tbtt_tick == (BCN_TBTT_OFFSET - 1)) {
-			rt2x00mmio_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
-			rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_INTERVAL,
-					   (rt2x00dev->beacon_int * 16));
-			rt2x00mmio_register_write(rt2x00dev, BCN_TIME_CFG, reg);
-		}
-		drv_data->tbtt_tick++;
-		drv_data->tbtt_tick %= BCN_TBTT_OFFSET;
-	}
-
-	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
-		rt2800pci_enable_interrupt(rt2x00dev, INT_MASK_CSR_TBTT);
-}
-
-static void rt2800pci_rxdone_tasklet(unsigned long data)
-{
-	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
-	if (rt2x00mmio_rxdone(rt2x00dev))
-		tasklet_schedule(&rt2x00dev->rxdone_tasklet);
-	else if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
-		rt2800pci_enable_interrupt(rt2x00dev, INT_MASK_CSR_RX_DONE);
-}
-
-static void rt2800pci_autowake_tasklet(unsigned long data)
-{
-	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
-	rt2800pci_wakeup(rt2x00dev);
-	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
-		rt2800pci_enable_interrupt(rt2x00dev, INT_MASK_CSR_AUTO_WAKEUP);
-}
-
-static void rt2800pci_txstatus_interrupt(struct rt2x00_dev *rt2x00dev)
-{
-	u32 status;
-	int i;
-
-	/*
-	 * The TX_FIFO_STATUS interrupt needs special care. We should
-	 * read TX_STA_FIFO but we should do it immediately as otherwise
-	 * the register can overflow and we would lose status reports.
-	 *
-	 * Hence, read the TX_STA_FIFO register and copy all tx status
-	 * reports into a kernel FIFO which is handled in the txstatus
-	 * tasklet. We use a tasklet to process the tx status reports
-	 * because we can schedule the tasklet multiple times (when the
-	 * interrupt fires again during tx status processing).
-	 *
-	 * Furthermore we don't disable the TX_FIFO_STATUS
-	 * interrupt here but leave it enabled so that the TX_STA_FIFO
-	 * can also be read while the tx status tasklet gets executed.
-	 *
-	 * Since we have only one producer and one consumer we don't
-	 * need to lock the kfifo.
-	 */
-	for (i = 0; i < rt2x00dev->tx->limit; i++) {
-		rt2x00mmio_register_read(rt2x00dev, TX_STA_FIFO, &status);
-
-		if (!rt2x00_get_field32(status, TX_STA_FIFO_VALID))
-			break;
-
-		if (!kfifo_put(&rt2x00dev->txstatus_fifo, status)) {
-			rt2x00_warn(rt2x00dev, "TX status FIFO overrun, drop tx status report\n");
-			break;
-		}
-	}
-
-	/* Schedule the tasklet for processing the tx status. */
-	tasklet_schedule(&rt2x00dev->txstatus_tasklet);
-}
-
-static irqreturn_t rt2800pci_interrupt(int irq, void *dev_instance)
-{
-	struct rt2x00_dev *rt2x00dev = dev_instance;
-	u32 reg, mask;
-
-	/* Read status and ACK all interrupts */
-	rt2x00mmio_register_read(rt2x00dev, INT_SOURCE_CSR, &reg);
-	rt2x00mmio_register_write(rt2x00dev, INT_SOURCE_CSR, reg);
-
-	if (!reg)
-		return IRQ_NONE;
-
-	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
-		return IRQ_HANDLED;
-
-	/*
-	 * Since INT_MASK_CSR and INT_SOURCE_CSR use the same bits
-	 * for interrupts and interrupt masks we can just use the value of
-	 * INT_SOURCE_CSR to create the interrupt mask.
-	 */
-	mask = ~reg;
-
-	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_TX_FIFO_STATUS)) {
-		rt2800pci_txstatus_interrupt(rt2x00dev);
-		/*
-		 * Never disable the TX_FIFO_STATUS interrupt.
-		 */
-		rt2x00_set_field32(&mask, INT_MASK_CSR_TX_FIFO_STATUS, 1);
-	}
-
-	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_PRE_TBTT))
-		tasklet_hi_schedule(&rt2x00dev->pretbtt_tasklet);
-
-	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_TBTT))
-		tasklet_hi_schedule(&rt2x00dev->tbtt_tasklet);
-
-	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_RX_DONE))
-		tasklet_schedule(&rt2x00dev->rxdone_tasklet);
-
-	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_AUTO_WAKEUP))
-		tasklet_schedule(&rt2x00dev->autowake_tasklet);
-
-	/*
-	 * Disable all interrupts for which a tasklet was scheduled right now,
-	 * the tasklet will reenable the appropriate interrupts.
-	 */
-	spin_lock(&rt2x00dev->irqmask_lock);
-	rt2x00mmio_register_read(rt2x00dev, INT_MASK_CSR, &reg);
-	reg &= mask;
-	rt2x00mmio_register_write(rt2x00dev, INT_MASK_CSR, reg);
-	spin_unlock(&rt2x00dev->irqmask_lock);
-
-	return IRQ_HANDLED;
-}
-
-/*
  * Device probe functions.
  */
 static int rt2800pci_read_eeprom(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
 
-	if (rt2x00_is_soc(rt2x00dev))
-		retval = rt2800pci_read_eeprom_soc(rt2x00dev);
-	else if (rt2800pci_efuse_detect(rt2x00dev))
+	if (rt2800pci_efuse_detect(rt2x00dev))
 		retval = rt2800pci_read_eeprom_efuse(rt2x00dev);
 	else
 		retval = rt2800pci_read_eeprom_pci(rt2x00dev);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
posix_acl-uninlining.patch
mm.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
mm-factor-commit-limit-calculation-fix.patch
kernel-printk-printkc-convert-to-pr_foo.patch
maintainers-remove-richard-purdie-as-backlight-maintainer-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch
drivers-rtc-rtc-as3722-add-rtc-driver-checkpatch-fixes.patch
fs-hfs-btreeh-remove-duplicate-defines-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
ipc-msg-fix-message-length-check-for-negative-values-fix.patch
linux-next.patch
x86-mem-hotplug-support-initialize-page-tables-in-bottom-up-next-fix.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch
mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page-fix-fix.patch
tree-wide-use-reinit_completion-instead-of-init_completion-fix.patch
kernel-provide-a-__smp_call_function_single-stub-for-config_smp-fix.patch
llists-move-llist_reverse_order-from-raid5-to-llistc-fix.patch
kfifo-api-type-safety-checkpatch-fixes.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

