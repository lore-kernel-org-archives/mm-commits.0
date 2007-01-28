From: akpm@osdl.org
Subject: + isdn-rename-some-debugging-macros-to-not-resemble-config.patch added to -mm tree
Date: Sun, 28 Jan 2007 15:58:05 -0800
Message-ID: <200701282358.l0SNw5Yo006451@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42602 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932982AbXA1X6L (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 28 Jan 2007 18:58:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, kkeil@suse.de


The patch titled
     ISDN: Rename some debugging macros to not resemble CONFIG options
has been added to the -mm tree.  Its filename is
     isdn-rename-some-debugging-macros-to-not-resemble-config.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ISDN: Rename some debugging macros to not resemble CONFIG options
From: "Robert P. J. Day" <rpjday@mindspring.com>

Rename some of the debugging macros for ISDN AVM so that they don't resemble
kernel config settings, as they're primarily for author debugging instead.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/isdn/hardware/avm/b1dma.c |   14 +++++++-------
 drivers/isdn/hardware/avm/c4.c    |   16 ++++++++--------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff -puN drivers/isdn/hardware/avm/b1dma.c~isdn-rename-some-debugging-macros-to-not-resemble-config drivers/isdn/hardware/avm/b1dma.c
--- a/drivers/isdn/hardware/avm/b1dma.c~isdn-rename-some-debugging-macros-to-not-resemble-config
+++ a/drivers/isdn/hardware/avm/b1dma.c
@@ -29,7 +29,7 @@
 
 static char *revision = "$Revision: 1.1.2.3 $";
 
-#undef CONFIG_B1DMA_DEBUG
+#undef AVM_B1DMA_DEBUG
 
 /* ------------------------------------------------------------- */
 
@@ -391,16 +391,16 @@ static void b1dma_dispatch_tx(avmcard *c
 			_put_slice(&p, skb->data, len);
 		}
 		txlen = (u8 *)p - (u8 *)dma->sendbuf.dmabuf;
-#ifdef CONFIG_B1DMA_DEBUG
+#ifdef AVM_B1DMA_DEBUG
 		printk(KERN_DEBUG "tx: put msg len=%d\n", txlen);
 #endif
 	} else {
 		txlen = skb->len-2;
-#ifdef CONFIG_B1DMA_POLLDEBUG
+#ifdef AVM_B1DMA_POLLDEBUG
 		if (skb->data[2] == SEND_POLLACK)
 			printk(KERN_INFO "%s: send ack\n", card->name);
 #endif
-#ifdef CONFIG_B1DMA_DEBUG
+#ifdef AVM_B1DMA_DEBUG
 		printk(KERN_DEBUG "tx: put 0x%x len=%d\n", 
 		       skb->data[2], txlen);
 #endif
@@ -450,7 +450,7 @@ static void b1dma_handle_rx(avmcard *car
 	u32 ApplId, MsgLen, DataB3Len, NCCI, WindowSize;
 	u8 b1cmd =  _get_byte(&p);
 
-#ifdef CONFIG_B1DMA_DEBUG
+#ifdef AVM_B1DMA_DEBUG
 	printk(KERN_DEBUG "rx: 0x%x %lu\n", b1cmd, (unsigned long)dma->recvlen);
 #endif
 	
@@ -515,7 +515,7 @@ static void b1dma_handle_rx(avmcard *car
 		break;
 
 	case RECEIVE_START:
-#ifdef CONFIG_B1DMA_POLLDEBUG
+#ifdef AVM_B1DMA_POLLDEBUG
 		printk(KERN_INFO "%s: receive poll\n", card->name);
 #endif
 		if (!suppress_pollack)
@@ -601,7 +601,7 @@ static void b1dma_handle_interrupt(avmca
 				rxlen = (dma->recvlen + 3) & ~3;
 				b1dma_writel(card, dma->recvbuf.dmaaddr+4, AMCC_RXPTR);
 				b1dma_writel(card, rxlen, AMCC_RXLEN);
-#ifdef CONFIG_B1DMA_DEBUG
+#ifdef AVM_B1DMA_DEBUG
 			} else {
 				printk(KERN_ERR "%s: rx not complete (%d).\n",
 					card->name, rxlen);
diff -puN drivers/isdn/hardware/avm/c4.c~isdn-rename-some-debugging-macros-to-not-resemble-config drivers/isdn/hardware/avm/c4.c
--- a/drivers/isdn/hardware/avm/c4.c~isdn-rename-some-debugging-macros-to-not-resemble-config
+++ a/drivers/isdn/hardware/avm/c4.c
@@ -28,8 +28,8 @@
 #include <linux/isdn/capilli.h>
 #include "avmcard.h"
 
-#undef CONFIG_C4_DEBUG
-#undef CONFIG_C4_POLLDEBUG
+#undef AVM_C4_DEBUG
+#undef AVM_C4_POLLDEBUG
 
 /* ------------------------------------------------------------- */
 
@@ -420,7 +420,7 @@ static void c4_dispatch_tx(avmcard *card
 
 	skb = skb_dequeue(&dma->send_queue);
 	if (!skb) {
-#ifdef CONFIG_C4_DEBUG
+#ifdef AVM_C4_DEBUG
 		printk(KERN_DEBUG "%s: tx underrun\n", card->name);
 #endif
 		return;
@@ -444,16 +444,16 @@ static void c4_dispatch_tx(avmcard *card
 			_put_slice(&p, skb->data, len);
 		}
 		txlen = (u8 *)p - (u8 *)dma->sendbuf.dmabuf;
-#ifdef CONFIG_C4_DEBUG
+#ifdef AVM_C4_DEBUG
 		printk(KERN_DEBUG "%s: tx put msg len=%d\n", card->name, txlen);
 #endif
 	} else {
 		txlen = skb->len-2;
-#ifdef CONFIG_C4_POLLDEBUG
+#ifdef AVM_C4_POLLDEBUG
 		if (skb->data[2] == SEND_POLLACK)
 			printk(KERN_INFO "%s: ack to c4\n", card->name);
 #endif
-#ifdef CONFIG_C4_DEBUG
+#ifdef AVM_C4_DEBUG
 		printk(KERN_DEBUG "%s: tx put 0x%x len=%d\n",
 				card->name, skb->data[2], txlen);
 #endif
@@ -508,7 +508,7 @@ static void c4_handle_rx(avmcard *card)
 	u32 cidx;
 
 
-#ifdef CONFIG_C4_DEBUG
+#ifdef AVM_C4_DEBUG
 	printk(KERN_DEBUG "%s: rx 0x%x len=%lu\n", card->name,
 				b1cmd, (unsigned long)dma->recvlen);
 #endif
@@ -586,7 +586,7 @@ static void c4_handle_rx(avmcard *card)
 		break;
 
 	case RECEIVE_START:
-#ifdef CONFIG_C4_POLLDEBUG
+#ifdef AVM_C4_POLLDEBUG
 		printk(KERN_INFO "%s: poll from c4\n", card->name);
 #endif
 		if (!suppress_pollack)
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
fix-config_x86_64_-typo-in-drivers-kvm-svmc.patch
acpi-correct-apparent-typo-config_acpi_debug_output.patch
git-alsa.patch
remove-useless-reference-to-obsolete-kerneld.patch
ppc-use-syslog-macro-for-the-printk-log-level.patch
fix-apparent-typo-config_serial_cpm_smc.patch
remove-the-unused-kernel-config-option-video_videobuf.patch
change-incorrect-config_input_atixl-to-config_mouse_atixl.patch
remove-unused-kernel-config-option-dlci_count.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
fix-misspelled-usbnet_mii-kernel-config-option.patch
fix-apparent-typo-config_usb_cdcether.patch
remove-unused-kernel-config-option-x86_xadd.patch
uml-fix-apparent-config_64_bit-typo.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
get-rid-of-double-zeroing-of-allocated-pages.patch
remove-unnecessary-memset0-calls-after-kzalloc-calls.patch
discuss-a-couple-common-errors-in-kernel-doc-usage.patch
numerous-fixes-to-kernel-doc-info-in-source-files.patch
remove-a-couple-final-references-to-obsolete-verify_area.patch
remove-the-last-reference-to-rwlock_is_locked-macro.patch
extend-the-set-of-__attribute__-shortcut-macros.patch
remove-final-reference-to-superfluous-smp_commence.patch
replace-regular-code-with-appropriate-calls-to-container_of.patch
remove-dead-kernel-config-option-aedsp16_mpu401.patch
remove-references-to-obsolete-kernel-config-option-debug_rwsems.patch
remove-unused-kernel-config-option-zisofs_fs.patch
remove-unused-kernel-config-option-lcd_device.patch
remove-unused-kernel-config-option-paride_parport.patch
fix-apparent-typo-config_lockdep_debug.patch
isdn-fix-typo-config_hisax_quadro-config_hisax_sct_quadro.patch
isdn-rename-some-debugging-macros-to-not-resemble-config.patch
isdn-rename-debug-option-config_serial_nopause_io.patch
isdn-remove-defunct-test-emulator.patch
isdn-rename-special-macro-config_hisax_hfc4s8s_pcimem.patch
correct-apparent-typo-config_aty_ct-in-aty-video.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
