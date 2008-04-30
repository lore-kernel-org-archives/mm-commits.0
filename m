From: akpm@linux-foundation.org
Subject: - net-use-get-put_unaligned_-helpers.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:49:22 -0700
Message-ID: <200804300549.m3U5nMdh029999@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45532 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756167AbYD3FuB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:50:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, auke-jan.h.kok@intel.com, grundler@parisc-linux.org, jeff@garzik.org, jesse.brandeburg@intel.com, john.ronciak@intel.com, viro@zeniv.linux.org.uk, mm-commit


The patch titled
     net: use get/put_unaligned_* helpers
has been removed from the -mm tree.  Its filename was
     net-use-get-put_unaligned_-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net: use get/put_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Auke Kok <auke-jan.h.kok@intel.com>
Cc: John Ronciak <john.ronciak@intel.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e100.c             |    2 -
 drivers/net/hamachi.c          |    2 -
 drivers/net/irda/mcs7780.c     |    2 -
 drivers/net/irda/stir4200.c    |    2 -
 drivers/net/tulip/de4x5.c      |   35 +++++++++++++++----------------
 drivers/net/tulip/de4x5.h      |    2 -
 drivers/net/tulip/tulip.h      |    7 +-----
 drivers/net/tulip/tulip_core.c |   10 ++++----
 drivers/net/yellowfin.c        |    2 -
 9 files changed, 30 insertions(+), 34 deletions(-)

diff -puN drivers/net/e100.c~net-use-get-put_unaligned_-helpers drivers/net/e100.c
--- a/drivers/net/e100.c~net-use-get-put_unaligned_-helpers
+++ a/drivers/net/e100.c
@@ -1802,7 +1802,7 @@ static int e100_rx_alloc_skb(struct nic 
 	 * it is protected by the before last buffer's el bit being set */
 	if (rx->prev->skb) {
 		struct rfd *prev_rfd = (struct rfd *)rx->prev->skb->data;
-		put_unaligned(cpu_to_le32(rx->dma_addr), &prev_rfd->link);
+		put_unaligned_le32(rx->dma_addr, &prev_rfd->link);
 	}
 
 	return 0;
diff -puN drivers/net/hamachi.c~net-use-get-put_unaligned_-helpers drivers/net/hamachi.c
--- a/drivers/net/hamachi.c~net-use-get-put_unaligned_-helpers
+++ a/drivers/net/hamachi.c
@@ -1508,7 +1508,7 @@ static int hamachi_rx(struct net_device 
 					    hmp->rx_buf_sz,
 					    PCI_DMA_FROMDEVICE);
 		buf_addr = (u8 *) hmp->rx_skbuff[entry]->data;
-		frame_status = le32_to_cpu(get_unaligned((__le32*)&(buf_addr[data_size - 12])));
+		frame_status = get_unaligned_le32(&(buf_addr[data_size - 12]));
 		if (hamachi_debug > 4)
 			printk(KERN_DEBUG "  hamachi_rx() status was %8.8x.\n",
 				frame_status);
diff -puN drivers/net/irda/mcs7780.c~net-use-get-put_unaligned_-helpers drivers/net/irda/mcs7780.c
--- a/drivers/net/irda/mcs7780.c~net-use-get-put_unaligned_-helpers
+++ a/drivers/net/irda/mcs7780.c
@@ -464,7 +464,7 @@ static void mcs_unwrap_fir(struct mcs_cb
 	}
 
 	fcs = ~(crc32_le(~0, buf, new_len));
-	if(fcs != le32_to_cpu(get_unaligned((__le32 *)(buf+new_len)))) {
+	if(fcs != get_unaligned_le32(buf + new_len)) {
 		IRDA_ERROR("crc error calc 0x%x len %d\n", fcs, new_len);
 		mcs->stats.rx_errors++;
 		mcs->stats.rx_crc_errors++;
diff -puN drivers/net/irda/stir4200.c~net-use-get-put_unaligned_-helpers drivers/net/irda/stir4200.c
--- a/drivers/net/irda/stir4200.c~net-use-get-put_unaligned_-helpers
+++ a/drivers/net/irda/stir4200.c
@@ -329,7 +329,7 @@ static void fir_eof(struct stir_cb *stir
 	}
 
 	fcs = ~(crc32_le(~0, rx_buff->data, len));
-	if (fcs != le32_to_cpu(get_unaligned((__le32 *)(rx_buff->data+len)))) {
+	if (fcs != get_unaligned_le32(rx_buff->data + len)) {
 		pr_debug("crc error calc 0x%x len %d\n", fcs, len);
 		stir->stats.rx_errors++;
 		stir->stats.rx_crc_errors++;
diff -puN drivers/net/tulip/de4x5.c~net-use-get-put_unaligned_-helpers drivers/net/tulip/de4x5.c
--- a/drivers/net/tulip/de4x5.c~net-use-get-put_unaligned_-helpers
+++ a/drivers/net/tulip/de4x5.c
@@ -482,7 +482,6 @@
 static char version[] __devinitdata = "de4x5.c:V0.546 2001/02/22 davies@maniac.ultranet.com\n";
 
 #define c_char const char
-#define TWIDDLE(a) (u_short)le16_to_cpu(get_unaligned((__le16 *)(a)))
 
 /*
 ** MII Information
@@ -4405,7 +4404,7 @@ srom_infoleaf_info(struct net_device *de
 	}
     }
 
-    lp->infoleaf_offset = TWIDDLE(p+1);
+	lp->infoleaf_offset = get_unaligned_le16(p + 1);
 
     return 0;
 }
@@ -4476,7 +4475,7 @@ srom_exec(struct net_device *dev, u_char
 
     while (count--) {
 	gep_wr(((lp->chipset==DC21140) && (lp->ibn!=5) ?
-		                                   *p++ : TWIDDLE(w++)), dev);
+		                                   *p++ : get_unaligned_le16(w++)), dev);
 	mdelay(2);                          /* 2ms per action */
     }
 
@@ -4711,10 +4710,10 @@ type1_infoblock(struct net_device *dev, 
 	lp->active = *p++;
 	lp->phy[lp->active].gep = (*p ? p : NULL); p += (*p + 1);
 	lp->phy[lp->active].rst = (*p ? p : NULL); p += (*p + 1);
-	lp->phy[lp->active].mc  = TWIDDLE(p); p += 2;
-	lp->phy[lp->active].ana = TWIDDLE(p); p += 2;
-	lp->phy[lp->active].fdx = TWIDDLE(p); p += 2;
-	lp->phy[lp->active].ttm = TWIDDLE(p);
+	lp->phy[lp->active].mc  = get_unaligned_le16(p); p += 2;
+	lp->phy[lp->active].ana = get_unaligned_le16(p); p += 2;
+	lp->phy[lp->active].fdx = get_unaligned_le16(p); p += 2;
+	lp->phy[lp->active].ttm = get_unaligned_le16(p);
 	return 0;
     } else if ((lp->media == INIT) && (lp->timeout < 0)) {
         lp->ibn = 1;
@@ -4751,16 +4750,16 @@ type2_infoblock(struct net_device *dev, 
 	lp->infoblock_media = (*p) & MEDIA_CODE;
 
         if ((*p++) & EXT_FIELD) {
-	    lp->cache.csr13 = TWIDDLE(p); p += 2;
-	    lp->cache.csr14 = TWIDDLE(p); p += 2;
-	    lp->cache.csr15 = TWIDDLE(p); p += 2;
+	    lp->cache.csr13 = get_unaligned_le16(p); p += 2;
+	    lp->cache.csr14 = get_unaligned_le16(p); p += 2;
+	    lp->cache.csr15 = get_unaligned_le16(p); p += 2;
 	} else {
 	    lp->cache.csr13 = CSR13;
 	    lp->cache.csr14 = CSR14;
 	    lp->cache.csr15 = CSR15;
 	}
-        lp->cache.gepc = ((s32)(TWIDDLE(p)) << 16); p += 2;
-        lp->cache.gep  = ((s32)(TWIDDLE(p)) << 16);
+        lp->cache.gepc = ((s32)(get_unaligned_le16(p)) << 16); p += 2;
+        lp->cache.gep  = ((s32)(get_unaligned_le16(p)) << 16);
 	lp->infoblock_csr6 = OMR_SIA;
 	lp->useMII = false;
 
@@ -4792,10 +4791,10 @@ type3_infoblock(struct net_device *dev, 
 	if (MOTO_SROM_BUG) lp->active = 0;
 	lp->phy[lp->active].gep = (*p ? p : NULL); p += (2 * (*p) + 1);
 	lp->phy[lp->active].rst = (*p ? p : NULL); p += (2 * (*p) + 1);
-	lp->phy[lp->active].mc  = TWIDDLE(p); p += 2;
-	lp->phy[lp->active].ana = TWIDDLE(p); p += 2;
-	lp->phy[lp->active].fdx = TWIDDLE(p); p += 2;
-	lp->phy[lp->active].ttm = TWIDDLE(p); p += 2;
+	lp->phy[lp->active].mc  = get_unaligned_le16(p); p += 2;
+	lp->phy[lp->active].ana = get_unaligned_le16(p); p += 2;
+	lp->phy[lp->active].fdx = get_unaligned_le16(p); p += 2;
+	lp->phy[lp->active].ttm = get_unaligned_le16(p); p += 2;
 	lp->phy[lp->active].mci = *p;
 	return 0;
     } else if ((lp->media == INIT) && (lp->timeout < 0)) {
@@ -4835,8 +4834,8 @@ type4_infoblock(struct net_device *dev, 
         lp->cache.csr13 = CSR13;              /* Hard coded defaults */
 	lp->cache.csr14 = CSR14;
 	lp->cache.csr15 = CSR15;
-        lp->cache.gepc = ((s32)(TWIDDLE(p)) << 16); p += 2;
-        lp->cache.gep  = ((s32)(TWIDDLE(p)) << 16); p += 2;
+        lp->cache.gepc = ((s32)(get_unaligned_le16(p)) << 16); p += 2;
+        lp->cache.gep  = ((s32)(get_unaligned_le16(p)) << 16); p += 2;
 	csr6 = *p++;
 	flags = *p++;
 
diff -puN drivers/net/tulip/de4x5.h~net-use-get-put_unaligned_-helpers drivers/net/tulip/de4x5.h
--- a/drivers/net/tulip/de4x5.h~net-use-get-put_unaligned_-helpers
+++ a/drivers/net/tulip/de4x5.h
@@ -1017,4 +1017,4 @@ struct de4x5_ioctl {
 #define DE4X5_SET_OMR           0x0d /* Set the OMR Register contents */
 #define DE4X5_GET_REG           0x0e /* Get the DE4X5 Registers */
 
-#define MOTO_SROM_BUG    ((lp->active == 8) && (((le32_to_cpu(get_unaligned(((__le32 *)dev->dev_addr))))&0x00ffffff)==0x3e0008))
+#define MOTO_SROM_BUG    (lp->active == 8 && (get_unaligned_le32(dev->dev_addr) & 0x00ffffff) == 0x3e0008)
diff -puN drivers/net/tulip/tulip.h~net-use-get-put_unaligned_-helpers drivers/net/tulip/tulip.h
--- a/drivers/net/tulip/tulip.h~net-use-get-put_unaligned_-helpers
+++ a/drivers/net/tulip/tulip.h
@@ -25,6 +25,7 @@
 #include <linux/pci.h>
 #include <asm/io.h>
 #include <asm/irq.h>
+#include <asm/unaligned.h>
 
 
 
@@ -304,11 +305,7 @@ enum t21143_csr6_bits {
 
 #define RUN_AT(x) (jiffies + (x))
 
-#if defined(__i386__)			/* AKA get_unaligned() */
-#define get_u16(ptr) (*(u16 *)(ptr))
-#else
-#define get_u16(ptr) (((u8*)(ptr))[0] + (((u8*)(ptr))[1]<<8))
-#endif
+#define get_u16(ptr) get_unaligned_le16((ptr))
 
 struct medialeaf {
 	u8 type;
diff -puN drivers/net/tulip/tulip_core.c~net-use-get-put_unaligned_-helpers drivers/net/tulip/tulip_core.c
--- a/drivers/net/tulip/tulip_core.c~net-use-get-put_unaligned_-helpers
+++ a/drivers/net/tulip/tulip_core.c
@@ -327,8 +327,8 @@ static void tulip_up(struct net_device *
 	tp->dirty_rx = tp->dirty_tx = 0;
 
 	if (tp->flags & MC_HASH_ONLY) {
-		u32 addr_low = le32_to_cpu(get_unaligned((__le32 *)dev->dev_addr));
-		u32 addr_high = le16_to_cpu(get_unaligned((__le16 *)(dev->dev_addr+4)));
+		u32 addr_low = get_unaligned_le32(dev->dev_addr);
+		u32 addr_high = get_unaligned_le16(dev->dev_addr + 4);
 		if (tp->chip_id == AX88140) {
 			iowrite32(0, ioaddr + CSR13);
 			iowrite32(addr_low,  ioaddr + CSR14);
@@ -1437,13 +1437,13 @@ static int __devinit tulip_init_one (str
 			do
 				value = ioread32(ioaddr + CSR9);
 			while (value < 0  && --boguscnt > 0);
-			put_unaligned(cpu_to_le16(value), ((__le16*)dev->dev_addr) + i);
+			put_unaligned_le16(value, ((__le16 *)dev->dev_addr) + i);
 			sum += value & 0xffff;
 		}
 	} else if (chip_idx == COMET) {
 		/* No need to read the EEPROM. */
-		put_unaligned(cpu_to_le32(ioread32(ioaddr + 0xA4)), (__le32 *)dev->dev_addr);
-		put_unaligned(cpu_to_le16(ioread32(ioaddr + 0xA8)), (__le16 *)(dev->dev_addr + 4));
+		put_unaligned_le32(ioread32(ioaddr + 0xA4), dev->dev_addr);
+		put_unaligned_le16(ioread32(ioaddr + 0xA8), dev->dev_addr + 4);
 		for (i = 0; i < 6; i ++)
 			sum += dev->dev_addr[i];
 	} else {
diff -puN drivers/net/yellowfin.c~net-use-get-put_unaligned_-helpers drivers/net/yellowfin.c
--- a/drivers/net/yellowfin.c~net-use-get-put_unaligned_-helpers
+++ a/drivers/net/yellowfin.c
@@ -1062,7 +1062,7 @@ static int yellowfin_rx(struct net_devic
 		buf_addr = rx_skb->data;
 		data_size = (le32_to_cpu(desc->dbdma_cmd) -
 			le32_to_cpu(desc->result_status)) & 0xffff;
-		frame_status = le16_to_cpu(get_unaligned((__le16*)&(buf_addr[data_size - 2])));
+		frame_status = get_unaligned_le16(&(buf_addr[data_size - 2]));
 		if (yellowfin_debug > 4)
 			printk(KERN_DEBUG "  yellowfin_rx() status was %4.4x.\n",
 				   frame_status);
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
frv-fix-arch-frv-mm-unalignedo-build-error.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
git-kvm.patch
git-mips.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

