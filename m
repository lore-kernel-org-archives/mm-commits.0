From: akpm@linux-foundation.org
Subject: - git-ioat.patch removed from -mm tree
Date: Fri, 24 Aug 2007 20:26:58 -0700
Message-ID: <200708250326.l7P3QwJO028113@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38403 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752535AbXHYD1I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 23:27:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: christopher.leech@intel.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     git-ioat.patch
has been removed from the -mm tree.  Its filename was
     git-ioat.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: git-ioat.patch

GIT f4aeeca728083fe5d5a573c4ad3056499999d82b git://lost.foo-projects.org/~cleech/linux-2.6#master

commit f4aeeca728083fe5d5a573c4ad3056499999d82b
Author: Chris Leech <christopher.leech@intel.com>
Date:   Tue Jan 23 09:52:14 2007 -0800

    I/OAT: Only offload copies for TCP when there will be a context switch
    The performance wins come with having the DMA copy engine doing the copies
    in parallel with the context switch.  If there is enough data ready on the
    socket at recv time just use a regular copy.
    
    Signed-off-by: Chris Leech <christopher.leech@intel.com>

commit c9288bea8ced2e78f530308737942cf6bf4eb667
Author: Chris Leech <christopher.leech@intel.com>
Date:   Tue Jan 23 09:52:13 2007 -0800

    I/OAT: Add entries to MAINTAINERS for the DMA memcpy subsystem and ioatdma
    
    Signed-off-by: Chris Leech <christopher.leech@intel.com>

commit 4a237e27825e77811c4fd89b16e11893de0c0648
Author: Chris Leech <christopher.leech@intel.com>
Date:   Tue Jan 23 09:52:13 2007 -0800

    I/OAT: Add documentation for the tcp_dma_copybreak sysctl
    
    Signed-off-by: Chris Leech <christopher.leech@intel.com>

commit f9f093d04bf3af8b81e3f41bf85bf48a53879f2c
Author: Chris Leech <christopher.leech@intel.com>
Date:   Tue Jan 23 09:52:13 2007 -0800

    I/OAT: Remove the use of writeq from the ioatdma driver
    There's only one now anyway, and it's not in a performance path,
    so make it behave the same on 32-bit and 64-bit CPUs.
    
    Signed-off-by: Chris Leech <christopher.leech@intel.com>

commit 1c13e71e958fe3e3fbbcadde2b6995ccb66863bf
Author: Chris Leech <christopher.leech@intel.com>
Date:   Tue Jan 23 09:52:13 2007 -0800

    I/OAT: Remove the wrappers around read(bwl)/write(bwl) in ioatdma
    
    Signed-off-by: Chris Leech <christopher.leech@intel.com>

commit 101b5f4e9cef341d26b7aebb28fbe6945b6b141e
Author: Jeff Garzik <jeff@garzik.org>
Date:   Tue Jan 23 09:52:12 2007 -0800

    drivers/dma: handle sysfs errors
    
    From: Jeff Garzik <jeff@garzik.org>
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>
    Signed-off-by: Chris Leech <christopher.leech@intel.com>

commit bdb2c47853f2b32274bbbca2e63f99d138057ddd
Author: Chris Leech <christopher.leech@intel.com>
Date:   Tue Jan 23 09:52:12 2007 -0800

    I/OAT: Push pending transactions to hardware more frequently
    Every 20 descriptors turns out to be to few append commands with
    newer/faster CPUs.  Pushing every 4 still cuts down on MMIO writes to an
    acceptable level without letting the DMA engine run out of work.
    
    Signed-off-by: Chris Leech <christopher.leech@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/networking/ip-sysctl.txt |    6 +
 MAINTAINERS                            |   12 ++
 drivers/dma/dmaengine.c                |   13 ++
 drivers/dma/ioatdma.c                  |   61 +++++------
 drivers/dma/ioatdma_io.h               |  118 -----------------------
 net/ipv4/tcp.c                         |   10 +
 6 files changed, 65 insertions(+), 155 deletions(-)

diff -puN Documentation/networking/ip-sysctl.txt~git-ioat Documentation/networking/ip-sysctl.txt
--- a/Documentation/networking/ip-sysctl.txt~git-ioat
+++ a/Documentation/networking/ip-sysctl.txt
@@ -433,6 +433,12 @@ tcp_workaround_signed_windows - BOOLEAN
 	not receive a window scaling option from them.
 	Default: 0
 
+tcp_dma_copybreak - INTEGER
+	Lower limit, in bytes, of the size of socket reads that will be
+	offloaded to a DMA copy engine, if one is present in the system
+	and CONFIG_NET_DMA is enabled.
+	Default: 4096
+
 CIPSOv4 Variables:
 
 cipso_cache_enable - BOOLEAN
diff -puN MAINTAINERS~git-ioat MAINTAINERS
--- a/MAINTAINERS~git-ioat
+++ a/MAINTAINERS
@@ -1294,6 +1294,12 @@ M:	juergh@gmail.com
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 
+DMA GENERIC MEMCPY SUBSYSTEM
+P:	Chris Leech
+M:	christopher.leech@intel.com
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+
 DOCBOOK FOR DOCUMENTATION
 P:	Randy Dunlap
 M:	rdunlap@xenotime.net
@@ -1930,6 +1936,12 @@ M:	shannon.nelson@intel.com
 L:	linux-kernel@vger.kernel.org
 S:	Supported
 
+INTEL I/OAT DMA DRIVER
+P:	Chris Leech
+M:	christopher.leech@intel.com
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+
 INTEL IXP4XX RANDOM NUMBER GENERATOR SUPPORT
 P:	Deepak Saxena
 M:	dsaxena@plexity.net
diff -puN drivers/dma/dmaengine.c~git-ioat drivers/dma/dmaengine.c
--- a/drivers/dma/dmaengine.c~git-ioat
+++ a/drivers/dma/dmaengine.c
@@ -348,7 +348,7 @@ EXPORT_SYMBOL(dma_async_client_chan_requ
 int dma_async_device_register(struct dma_device *device)
 {
 	static int id;
-	int chancnt = 0;
+	int chancnt = 0, rc;
 	struct dma_chan* chan;
 
 	if (!device)
@@ -403,6 +403,17 @@ int dma_async_device_register(struct dma
 	dma_clients_notify_available();
 
 	return 0;
+
+err_out:
+	list_for_each_entry(chan, &device->channels, device_node) {
+		if (chan->local == NULL)
+			continue;
+		kref_put(&device->refcount, dma_async_device_cleanup);
+		class_device_unregister(&chan->class_dev);
+		chancnt--;
+		free_percpu(chan->local);
+	}
+	return rc;
 }
 EXPORT_SYMBOL(dma_async_device_register);
 
diff -puN drivers/dma/ioatdma.c~git-ioat drivers/dma/ioatdma.c
--- a/drivers/dma/ioatdma.c~git-ioat
+++ a/drivers/dma/ioatdma.c
@@ -32,7 +32,6 @@
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
 #include "ioatdma.h"
-#include "ioatdma_io.h"
 #include "ioatdma_registers.h"
 #include "ioatdma_hw.h"
 
@@ -52,8 +51,8 @@ static int enumerate_dma_channels(struct
 	int i;
 	struct ioat_dma_chan *ioat_chan;
 
-	device->common.chancnt = ioatdma_read8(device, IOAT_CHANCNT_OFFSET);
-	xfercap_scale = ioatdma_read8(device, IOAT_XFERCAP_OFFSET);
+	device->common.chancnt = readb(device->reg_base + IOAT_CHANCNT_OFFSET);
+	xfercap_scale = readb(device->reg_base + IOAT_XFERCAP_OFFSET);
 	xfercap = (xfercap_scale == 0 ? -1 : (1UL << xfercap_scale));
 
 	for (i = 0; i < device->common.chancnt; i++) {
@@ -192,7 +191,7 @@ static int ioat_dma_alloc_chan_resources
 	 * In-use bit automatically set by reading chanctrl
 	 * If 0, we got it, if 1, someone else did
 	 */
-	chanctrl = ioatdma_chan_read16(ioat_chan, IOAT_CHANCTRL_OFFSET);
+	chanctrl = readw(ioat_chan->reg_base + IOAT_CHANCTRL_OFFSET);
 	if (chanctrl & IOAT_CHANCTRL_CHANNEL_IN_USE)
 		return -EBUSY;
 
@@ -201,12 +200,12 @@ static int ioat_dma_alloc_chan_resources
 		IOAT_CHANCTRL_ERR_INT_EN |
 		IOAT_CHANCTRL_ANY_ERR_ABORT_EN |
 		IOAT_CHANCTRL_ERR_COMPLETION_EN;
-        ioatdma_chan_write16(ioat_chan, IOAT_CHANCTRL_OFFSET, chanctrl);
+        writew(chanctrl, ioat_chan->reg_base + IOAT_CHANCTRL_OFFSET);
 
-	chanerr = ioatdma_chan_read32(ioat_chan, IOAT_CHANERR_OFFSET);
+	chanerr = readl(ioat_chan->reg_base + IOAT_CHANERR_OFFSET);
 	if (chanerr) {
 		printk("IOAT: CHANERR = %x, clearing\n", chanerr);
-		ioatdma_chan_write32(ioat_chan, IOAT_CHANERR_OFFSET, chanerr);
+		writel(chanerr, ioat_chan->reg_base + IOAT_CHANERR_OFFSET);
 	}
 
 	/* Allocate descriptors */
@@ -230,10 +229,10 @@ static int ioat_dma_alloc_chan_resources
 		               &ioat_chan->completion_addr);
 	memset(ioat_chan->completion_virt, 0,
 	       sizeof(*ioat_chan->completion_virt));
-	ioatdma_chan_write32(ioat_chan, IOAT_CHANCMP_OFFSET_LOW,
-	               ((u64) ioat_chan->completion_addr) & 0x00000000FFFFFFFF);
-	ioatdma_chan_write32(ioat_chan, IOAT_CHANCMP_OFFSET_HIGH,
-	               ((u64) ioat_chan->completion_addr) >> 32);
+	writel(((u64) ioat_chan->completion_addr) & 0x00000000FFFFFFFF,
+	       ioat_chan->reg_base + IOAT_CHANCMP_OFFSET_LOW);
+	writel(((u64) ioat_chan->completion_addr) >> 32,
+	       ioat_chan->reg_base + IOAT_CHANCMP_OFFSET_HIGH);
 
 	ioat_start_null_desc(ioat_chan);
 	return i;
@@ -251,7 +250,7 @@ static void ioat_dma_free_chan_resources
 
 	ioat_dma_memcpy_cleanup(ioat_chan);
 
-	ioatdma_chan_write8(ioat_chan, IOAT_CHANCMD_OFFSET, IOAT_CHANCMD_RESET);
+	writeb(IOAT_CHANCMD_RESET, ioat_chan->reg_base + IOAT_CHANCMD_OFFSET);
 
 	spin_lock_bh(&ioat_chan->desc_lock);
 	list_for_each_entry_safe(desc, _desc, &ioat_chan->used_desc, node) {
@@ -279,9 +278,9 @@ static void ioat_dma_free_chan_resources
 	ioat_chan->last_completion = ioat_chan->completion_addr = 0;
 
 	/* Tell hw the chan is free */
-	chanctrl = ioatdma_chan_read16(ioat_chan, IOAT_CHANCTRL_OFFSET);
+	chanctrl = readw(ioat_chan->reg_base + IOAT_CHANCTRL_OFFSET);
 	chanctrl &= ~IOAT_CHANCTRL_CHANNEL_IN_USE;
-	ioatdma_chan_write16(ioat_chan, IOAT_CHANCTRL_OFFSET, chanctrl);
+	writew(chanctrl, ioat_chan->reg_base + IOAT_CHANCTRL_OFFSET);
 }
 
 static struct dma_async_tx_descriptor *
@@ -361,9 +360,8 @@ static void ioat_dma_memcpy_issue_pendin
 
 	if (ioat_chan->pending != 0) {
 		ioat_chan->pending = 0;
-		ioatdma_chan_write8(ioat_chan,
-		                    IOAT_CHANCMD_OFFSET,
-		                    IOAT_CHANCMD_APPEND);
+		writeb(IOAT_CHANCMD_APPEND,
+		       ioat_chan->reg_base + IOAT_CHANCMD_OFFSET);
 	}
 }
 
@@ -393,7 +391,7 @@ static void ioat_dma_memcpy_cleanup(stru
 	if ((chan->completion_virt->full & IOAT_CHANSTS_DMA_TRANSFER_STATUS) ==
 		IOAT_CHANSTS_DMA_TRANSFER_STATUS_HALTED) {
 		printk("IOAT: Channel halted, chanerr = %x\n",
-			ioatdma_chan_read32(chan, IOAT_CHANERR_OFFSET));
+			readl(chan->reg_base + IOAT_CHANERR_OFFSET));
 
 		/* TODO do something to salvage the situation */
 	}
@@ -529,21 +527,21 @@ static irqreturn_t ioat_do_interrupt(int
 	unsigned long attnstatus;
 	u8 intrctrl;
 
-	intrctrl = ioatdma_read8(instance, IOAT_INTRCTRL_OFFSET);
+	intrctrl = readb(instance->reg_base + IOAT_INTRCTRL_OFFSET);
 
 	if (!(intrctrl & IOAT_INTRCTRL_MASTER_INT_EN))
 		return IRQ_NONE;
 
 	if (!(intrctrl & IOAT_INTRCTRL_INT_STATUS)) {
-		ioatdma_write8(instance, IOAT_INTRCTRL_OFFSET, intrctrl);
+		writeb(intrctrl, instance->reg_base + IOAT_INTRCTRL_OFFSET);
 		return IRQ_NONE;
 	}
 
-	attnstatus = ioatdma_read32(instance, IOAT_ATTNSTATUS_OFFSET);
+	attnstatus = readl(instance->reg_base + IOAT_ATTNSTATUS_OFFSET);
 
 	printk(KERN_ERR "ioatdma error: interrupt! status %lx\n", attnstatus);
 
-	ioatdma_write8(instance, IOAT_INTRCTRL_OFFSET, intrctrl);
+	writeb(intrctrl, instance->reg_base + IOAT_INTRCTRL_OFFSET);
 	return IRQ_HANDLED;
 }
 
@@ -572,15 +570,12 @@ static void ioat_start_null_desc(struct 
 	list_add_tail(&desc->node, &ioat_chan->used_desc);
 	spin_unlock_bh(&ioat_chan->desc_lock);
 
-#if (BITS_PER_LONG == 64)
-	ioatdma_chan_write64(ioat_chan, IOAT_CHAINADDR_OFFSET, desc->phys);
-#else
-	ioatdma_chan_write32(ioat_chan,
-	                     IOAT_CHAINADDR_OFFSET_LOW,
-	                     (u32) desc->phys);
-	ioatdma_chan_write32(ioat_chan, IOAT_CHAINADDR_OFFSET_HIGH, 0);
-#endif
-	ioatdma_chan_write8(ioat_chan, IOAT_CHANCMD_OFFSET, IOAT_CHANCMD_START);
+	writel(((u64) desc->phys) & 0x00000000FFFFFFFF,
+	       ioat_chan->reg_base + IOAT_CHAINADDR_OFFSET_LOW);
+	writel(((u64) desc->phys) >> 32,
+	       ioat_chan->reg_base + IOAT_CHAINADDR_OFFSET_HIGH);
+
+	writeb(IOAT_CHANCMD_START, ioat_chan->reg_base + IOAT_CHANCMD_OFFSET);
 }
 
 /*
@@ -719,7 +714,7 @@ static int __devinit ioat_probe(struct p
 
 	device->reg_base = reg_base;
 
-	ioatdma_write8(device, IOAT_INTRCTRL_OFFSET, IOAT_INTRCTRL_MASTER_INT_EN);
+	writeb(IOAT_INTRCTRL_MASTER_INT_EN, device->reg_base + IOAT_INTRCTRL_OFFSET);
 	pci_set_master(pdev);
 
 	INIT_LIST_HEAD(&device->common.channels);
@@ -790,7 +785,7 @@ static void __devexit ioat_remove(struct
 }
 
 /* MODULE API */
-MODULE_VERSION("1.7");
+MODULE_VERSION("1.9");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Intel Corporation");
 
diff -puN drivers/dma/ioatdma_io.h~git-ioat /dev/null
--- a/drivers/dma/ioatdma_io.h
+++ /dev/null
@@ -1,118 +0,0 @@
-/*
- * Copyright(c) 2004 - 2006 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc., 59
- * Temple Place - Suite 330, Boston, MA  02111-1307, USA.
- *
- * The full GNU General Public License is included in this distribution in the
- * file called COPYING.
- */
-#ifndef IOATDMA_IO_H
-#define IOATDMA_IO_H
-
-#include <asm/io.h>
-
-/*
- * device and per-channel MMIO register read and write functions
- * this is a lot of anoying inline functions, but it's typesafe
- */
-
-static inline u8 ioatdma_read8(struct ioat_device *device,
-                               unsigned int offset)
-{
-	return readb(device->reg_base + offset);
-}
-
-static inline u16 ioatdma_read16(struct ioat_device *device,
-                                 unsigned int offset)
-{
-	return readw(device->reg_base + offset);
-}
-
-static inline u32 ioatdma_read32(struct ioat_device *device,
-                                 unsigned int offset)
-{
-	return readl(device->reg_base + offset);
-}
-
-static inline void ioatdma_write8(struct ioat_device *device,
-                                  unsigned int offset, u8 value)
-{
-	writeb(value, device->reg_base + offset);
-}
-
-static inline void ioatdma_write16(struct ioat_device *device,
-                                   unsigned int offset, u16 value)
-{
-	writew(value, device->reg_base + offset);
-}
-
-static inline void ioatdma_write32(struct ioat_device *device,
-                                   unsigned int offset, u32 value)
-{
-	writel(value, device->reg_base + offset);
-}
-
-static inline u8 ioatdma_chan_read8(struct ioat_dma_chan *chan,
-                                    unsigned int offset)
-{
-	return readb(chan->reg_base + offset);
-}
-
-static inline u16 ioatdma_chan_read16(struct ioat_dma_chan *chan,
-                                      unsigned int offset)
-{
-	return readw(chan->reg_base + offset);
-}
-
-static inline u32 ioatdma_chan_read32(struct ioat_dma_chan *chan,
-                                      unsigned int offset)
-{
-	return readl(chan->reg_base + offset);
-}
-
-static inline void ioatdma_chan_write8(struct ioat_dma_chan *chan,
-                                       unsigned int offset, u8 value)
-{
-	writeb(value, chan->reg_base + offset);
-}
-
-static inline void ioatdma_chan_write16(struct ioat_dma_chan *chan,
-                                        unsigned int offset, u16 value)
-{
-	writew(value, chan->reg_base + offset);
-}
-
-static inline void ioatdma_chan_write32(struct ioat_dma_chan *chan,
-                                        unsigned int offset, u32 value)
-{
-	writel(value, chan->reg_base + offset);
-}
-
-#if (BITS_PER_LONG == 64)
-static inline u64 ioatdma_chan_read64(struct ioat_dma_chan *chan,
-                                      unsigned int offset)
-{
-	return readq(chan->reg_base + offset);
-}
-
-static inline void ioatdma_chan_write64(struct ioat_dma_chan *chan,
-                                        unsigned int offset, u64 value)
-{
-	writeq(value, chan->reg_base + offset);
-}
-#endif
-
-#endif /* IOATDMA_IO_H */
-
diff -puN net/ipv4/tcp.c~git-ioat net/ipv4/tcp.c
--- a/net/ipv4/tcp.c~git-ioat
+++ a/net/ipv4/tcp.c
@@ -1116,6 +1116,8 @@ int tcp_recvmsg(struct kiocb *iocb, stru
 	long timeo;
 	struct task_struct *user_recv = NULL;
 	int copied_early = 0;
+	int available = 0;
+	struct sk_buff *skb;
 
 	lock_sock(sk);
 
@@ -1142,7 +1144,11 @@ int tcp_recvmsg(struct kiocb *iocb, stru
 #ifdef CONFIG_NET_DMA
 	tp->ucopy.dma_chan = NULL;
 	preempt_disable();
-	if ((len > sysctl_tcp_dma_copybreak) && !(flags & MSG_PEEK) &&
+	skb = skb_peek_tail(&sk->sk_receive_queue);
+	if (skb)
+		available = TCP_SKB_CB(skb)->seq + skb->len - (*seq);
+	if ((available < target) &&
+	    (len > sysctl_tcp_dma_copybreak) && !(flags & MSG_PEEK) &&
 	    !sysctl_tcp_low_latency && __get_cpu_var(softnet_data).net_dma) {
 		preempt_enable_no_resched();
 		tp->ucopy.pinned_list = dma_pin_iovec_pages(msg->msg_iov, len);
@@ -1151,7 +1157,6 @@ int tcp_recvmsg(struct kiocb *iocb, stru
 #endif
 
 	do {
-		struct sk_buff *skb;
 		u32 offset;
 
 		/* Are we at urgent data? Stop if we have read anything or have SIGURG pending. */
@@ -1439,7 +1444,6 @@ skip_copy:
 
 #ifdef CONFIG_NET_DMA
 	if (tp->ucopy.dma_chan) {
-		struct sk_buff *skb;
 		dma_cookie_t done, used;
 
 		dma_async_memcpy_issue_pending(tp->ucopy.dma_chan);
_

Patches currently in -mm which might be from christopher.leech@intel.com are
