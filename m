From: akpm@linux-foundation.org
Subject: - e1000_7033_dump_ring.patch removed from -mm tree
Date: Thu, 29 Mar 2007 18:55:35 -0700
Message-ID: <200703300157.l2U1viXH017719@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45812 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753780AbXC3B5q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 21:57:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: auke-jan.h.kok@intel.com, mm-commits@vger.kernel.org


The patch titled
     e1000_7033_dump_ring
has been removed from the -mm tree.  Its filename was
     e1000_7033_dump_ring.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: e1000_7033_dump_ring
From: Auke Kok <auke-jan.h.kok@intel.com>

e1000 debug patch - an attempt to diagnose the rare "e1000: eth0:
e1000_clean_tx_irq: Detected Tx Unit Hang" problem.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000/e1000_main.c |  149 +++++++++++++++++++++++++++++++
 1 file changed, 149 insertions(+)

diff -puN drivers/net/e1000/e1000_main.c~e1000_7033_dump_ring drivers/net/e1000/e1000_main.c
--- a/drivers/net/e1000/e1000_main.c~e1000_7033_dump_ring
+++ a/drivers/net/e1000/e1000_main.c
@@ -3506,6 +3506,152 @@ e1000_xmit_frame(struct sk_buff *skb, st
 	return NETDEV_TX_OK;
 }
 
+void e1000_dump(struct e1000_adapter* adapter)
+{
+	/* this code doesn't handle multiple rings */
+	struct e1000_tx_ring *tx_ring = adapter->tx_ring;
+	struct e1000_rx_ring *rx_ring = adapter->rx_ring;
+	struct e1000_hw* hw = &adapter->hw;
+	int i=0;
+#define NUM_REGS 26 // 1 based count
+	uint32_t regs[NUM_REGS];
+	uint32_t *regs_buff = regs;
+
+	char *reg_name[] = {
+	"CTRL",  "STATUS",
+	"RCTL", "RDLEN", "RDH", "RDT", "RDTR",
+	"TCTL", "TDBAL", "TDBAH", "TDLEN", "TDH", "TDT",
+	"TIDV", "TXDCTL", "TADV", "TARC0",
+	"TDBAL1", "TDBAH1", "TDLEN1", "TDH1", "TDT1",
+	"TXDCTL1", "TARC1",
+	"CTRL_EXT", "ERT",
+	};
+
+	regs_buff[0]  = E1000_READ_REG(hw, CTRL);
+	regs_buff[1]  = E1000_READ_REG(hw, STATUS);
+
+	regs_buff[2]  = E1000_READ_REG(hw, RCTL);
+	regs_buff[3]  = E1000_READ_REG(hw, RDLEN);
+	regs_buff[4]  = E1000_READ_REG(hw, RDH);
+	regs_buff[5]  = E1000_READ_REG(hw, RDT);
+	regs_buff[6]  = E1000_READ_REG(hw, RDTR);
+
+	regs_buff[7]  = E1000_READ_REG(hw, TCTL);
+	regs_buff[8]  = E1000_READ_REG(hw, TDBAL);
+	regs_buff[9]  = E1000_READ_REG(hw, TDBAH);
+	regs_buff[10]  = E1000_READ_REG(hw, TDLEN);
+	regs_buff[11]  = E1000_READ_REG(hw, TDH);
+	regs_buff[12] = E1000_READ_REG(hw, TDT);
+	regs_buff[13] = E1000_READ_REG(hw, TIDV);
+	regs_buff[14] = E1000_READ_REG(hw, TXDCTL);
+	regs_buff[15] = E1000_READ_REG(hw, TADV);
+	regs_buff[16] = E1000_READ_REG(hw, TARC0);
+
+	regs_buff[17]  = E1000_READ_REG(hw, TDBAL1);
+	regs_buff[18]  = E1000_READ_REG(hw, TDBAH1);
+	regs_buff[19]  = E1000_READ_REG(hw, TDLEN1);
+	regs_buff[20]  = E1000_READ_REG(hw, TDH1);
+	regs_buff[21] = E1000_READ_REG(hw, TDT1);
+	regs_buff[22] = E1000_READ_REG(hw, TXDCTL1);
+	regs_buff[23] = E1000_READ_REG(hw, TARC1);
+	regs_buff[24] = E1000_READ_REG(hw, CTRL_EXT);
+	regs_buff[25] = E1000_READ_REG(hw, ERT);
+
+	printk(KERN_ERR"Register dump\n");
+	for (i = 0; i < NUM_REGS; i++) {
+		printk("%-15s  %08x\n",
+		reg_name[i], regs_buff[i]);
+	}
+
+	/*
+	 * transmit dump
+	 */
+	printk(KERN_ERR"TX Desc ring0 dump\n");
+
+	printk("T[desc]     [address 63:0  ] [vl pt Sdcdt ln] [bi->dma       ] leng  ntw timestmp bi->skb\n");
+	for(i = 0; tx_ring->desc && (i < tx_ring->count); i++ ) {
+		struct e1000_tx_desc* tx_desc = E1000_TX_DESC(*tx_ring, i);
+		struct e1000_buffer *buffer_info = &tx_ring->buffer_info[i];
+		struct my_u { u64 a; u64 b;};
+		struct my_u *u = (struct my_u *)tx_desc;
+		printk("T[0x%03X]     %016llX %016llX %016llX %04X  %3X %016llX %p",
+		       i, le64_to_cpu(u->a),le64_to_cpu(u->b),
+		       (u64)buffer_info->dma, buffer_info->length,
+		       buffer_info->next_to_watch, (u64)buffer_info->time_stamp,
+		       buffer_info->skb);
+		if(i == tx_ring->next_to_use && i == tx_ring->next_to_clean)
+			printk(" NTC/U\n");
+		else if(i == tx_ring->next_to_use)
+			printk(" NTU\n");
+		else if(i == tx_ring->next_to_clean)
+			printk(" NTC\n");
+		else
+			printk("\n");
+	}
+
+	/*
+	 * receive dump
+	 */
+	printk(KERN_ERR"\nRX Desc ring dump\n");
+
+	switch (adapter->rx_ps_pages) {
+	case 1:
+	case 2:
+	case 3:
+		printk("R  [desc]      [buffer 0 63:0 ] [buffer 1 63:0 ] [buffer 2 63:0 ] [buffer 3 63:0 ] [bi->dma       ] [bi->skb]\n");
+		printk("RWB[desc]      [ck ipid mrqhsh] [vl   l0 ee  es] [ l3  l2  l1 hs] [reserved      ] [bi->skb]\n");
+		for (i = 0; i < rx_ring->count; i++) {
+			struct e1000_buffer *buffer_info = &rx_ring->buffer_info[i];
+			union e1000_rx_desc_packet_split *rx_desc = E1000_RX_DESC_PS(*rx_ring, i);
+			struct my_u { u64 a; u64 b; u64 c; u64 d;};
+			struct my_u *u = (struct my_u *)rx_desc;
+			uint32_t staterr;
+			staterr = le32_to_cpu(rx_desc->wb.middle.status_error);
+			if (staterr & E1000_RXD_STAT_DD) {
+				printk("RWB[0x%03X]     %016llX %016llX %016llX %016llX %p",
+					i, le64_to_cpu(u->a),le64_to_cpu(u->b), le64_to_cpu(u->c), le64_to_cpu(u->d),
+					buffer_info->skb);
+			}
+			else {
+				printk("R  [0x%03X]     %016llX %016llX %016llX"
+					" %016llX %016llX %p", i,
+					le64_to_cpu(u->a), le64_to_cpu(u->b),
+					le64_to_cpu(u->c), le64_to_cpu(u->d),
+					(unsigned long long)buffer_info->dma,
+					buffer_info->skb);
+			}
+
+			if(i == rx_ring->next_to_use)
+				printk(" NTU\n");
+			else if(i == rx_ring->next_to_clean)
+				printk(" NTC\n");
+			else
+				printk("\n");
+		}
+		break;
+	default:
+	case 0:
+		printk("R[desc]      [address 63:0  ] [vl er S cks ln] [bi->dma       ] [bi->skb]\n");
+		for(i = 0; rx_ring->desc && (i < rx_ring->count); i++ ) {
+			struct e1000_rx_desc* rx_desc = E1000_RX_DESC(*rx_ring, i);
+			struct e1000_buffer *buffer_info = &rx_ring->buffer_info[i];
+			struct my_u { u64 a; u64 b;};
+			struct my_u *u = (struct my_u *)rx_desc;
+			printk("R[0x%03X]     %016llX %016llX %016llX %p",
+				i, le64_to_cpu(u->a),le64_to_cpu(u->b),
+				(u64)buffer_info->dma, buffer_info->skb);
+			if(i == rx_ring->next_to_use)
+				printk(" NTU\n");
+			else if(i == rx_ring->next_to_clean)
+				printk(" NTC\n");
+			else
+				printk("\n");
+		} /* for */
+	} /* switch */
+
+}
+
+
 /**
  * e1000_tx_timeout - Respond to a Tx Hang
  * @netdev: network interface device structure
@@ -3527,6 +3673,9 @@ e1000_reset_task(struct work_struct *wor
 	struct e1000_adapter *adapter =
 		container_of(work, struct e1000_adapter, reset_task);
 
+	/* dump the tx and rx rings */
+	e1000_dump(adapter);
+
 	e1000_reinit_locked(adapter);
 }
 
_

Patches currently in -mm which might be from auke-jan.h.kok@intel.com are

git-netdev-all.patch
git-e1000.patch
e1000-use-flush_keventd_work.patch
e1000_7033_dump_ring.patch
e1000-printk-warning-fixes.patch
