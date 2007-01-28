From: akpm@osdl.org
Subject: + isdn-rename-special-macro-config_hisax_hfc4s8s_pcimem.patch added to -mm tree
Date: Sun, 28 Jan 2007 15:58:11 -0800
Message-ID: <200701282358.l0SNwBHa006460@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42610 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932989AbXA1X6R (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 28 Jan 2007 18:58:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, kkeil@suse.de


The patch titled
     ISDN: Rename special macro CONFIG_HISAX_HFC4S8S_PCIMEM
has been added to the -mm tree.  Its filename is
     isdn-rename-special-macro-config_hisax_hfc4s8s_pcimem.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ISDN: Rename special macro CONFIG_HISAX_HFC4S8S_PCIMEM
From: "Robert P. J. Day" <rpjday@mindspring.com>

Rename the macro CONFIG_HISAX_HFC4S8S_PCIMEM to simply HISAX_HFC4S8S_PCIMEM so
that it no longer resembles a user-settable kernel config macro.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/isdn/hisax/hfc4s8s_l1.c |   48 +++++++++++++++---------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff -puN drivers/isdn/hisax/hfc4s8s_l1.c~isdn-rename-special-macro-config_hisax_hfc4s8s_pcimem drivers/isdn/hisax/hfc4s8s_l1.c
--- a/drivers/isdn/hisax/hfc4s8s_l1.c~isdn-rename-special-macro-config_hisax_hfc4s8s_pcimem
+++ a/drivers/isdn/hisax/hfc4s8s_l1.c
@@ -199,7 +199,7 @@ typedef struct _hfc4s8s_hw {
 /***************************/
 /* inline function defines */
 /***************************/
-#ifdef CONFIG_HISAX_HFC4S8S_PCIMEM	/* inline functions mempry mapped */
+#ifdef HISAX_HFC4S8S_PCIMEM	/* inline functions memory mapped */
 
 /* memory write and dummy IO read to avoid PCI byte merge problems */
 #define Write_hfc8(a,b,c) {(*((volatile u_char *)(a->membase+b)) = c); inb(a->iobase+4);}
@@ -305,7 +305,7 @@ wait_busy(hfc4s8s_hw * a)
 
 #define PCI_ENA_REGIO	0x01
 
-#endif				/* CONFIG_HISAX_HFC4S8S_PCIMEM */
+#endif				/* HISAX_HFC4S8S_PCIMEM */
 
 /******************************************************/
 /* function to read critical counter registers that   */
@@ -724,12 +724,12 @@ rx_d_frame(struct hfc4s8s_l1 *l1p, int e
 			} else {
 				/* read errornous D frame */
 
-#ifndef CONFIG_HISAX_HFC4S8S_PCIMEM
+#ifndef HISAX_HFC4S8S_PCIMEM
 				SetRegAddr(l1p->hw, A_FIFO_DATA0);
 #endif
 
 				while (z1 >= 4) {
-#ifdef CONFIG_HISAX_HFC4S8S_PCIMEM
+#ifdef HISAX_HFC4S8S_PCIMEM
 					Read_hfc32(l1p->hw, A_FIFO_DATA0);
 #else
 					fRead_hfc32(l1p->hw);
@@ -738,7 +738,7 @@ rx_d_frame(struct hfc4s8s_l1 *l1p, int e
 				}
 
 				while (z1--)
-#ifdef CONFIG_HISAX_HFC4S8S_PCIMEM
+#ifdef HISAX_HFC4S8S_PCIMEM
 					Read_hfc8(l1p->hw, A_FIFO_DATA0);
 #else
 					fRead_hfc8(l1p->hw);
@@ -752,12 +752,12 @@ rx_d_frame(struct hfc4s8s_l1 *l1p, int e
 
 		cp = skb->data;
 
-#ifndef CONFIG_HISAX_HFC4S8S_PCIMEM
+#ifndef HISAX_HFC4S8S_PCIMEM
 		SetRegAddr(l1p->hw, A_FIFO_DATA0);
 #endif
 
 		while (z1 >= 4) {
-#ifdef CONFIG_HISAX_HFC4S8S_PCIMEM
+#ifdef HISAX_HFC4S8S_PCIMEM
 			*((unsigned long *) cp) =
 			    Read_hfc32(l1p->hw, A_FIFO_DATA0);
 #else
@@ -768,7 +768,7 @@ rx_d_frame(struct hfc4s8s_l1 *l1p, int e
 		}
 
 		while (z1--)
-#ifdef CONFIG_HISAX_HFC4S8S_PCIMEM
+#ifdef HISAX_HFC4S8S_PCIMEM
 			*cp++ = Read_hfc8(l1p->hw, A_FIFO_DATA0);
 #else
 			*cp++ = fRead_hfc8(l1p->hw);
@@ -858,12 +858,12 @@ rx_b_frame(struct hfc4s8s_btype *bch)
 			wait_busy(l1->hw);
 			return;
 		}
-#ifndef CONFIG_HISAX_HFC4S8S_PCIMEM
+#ifndef HISAX_HFC4S8S_PCIMEM
 		SetRegAddr(l1->hw, A_FIFO_DATA0);
 #endif
 
 		while (z1 >= 4) {
-#ifdef CONFIG_HISAX_HFC4S8S_PCIMEM
+#ifdef HISAX_HFC4S8S_PCIMEM
 			*((unsigned long *) bch->rx_ptr) =
 			    Read_hfc32(l1->hw, A_FIFO_DATA0);
 #else
@@ -875,7 +875,7 @@ rx_b_frame(struct hfc4s8s_btype *bch)
 		}
 
 		while (z1--)
-#ifdef CONFIG_HISAX_HFC4S8S_PCIMEM
+#ifdef HISAX_HFC4S8S_PCIMEM
 			*(bch->rx_ptr++) = Read_hfc8(l1->hw, A_FIFO_DATA0);
 #else
 			*(bch->rx_ptr++) = fRead_hfc8(l1->hw);
@@ -939,12 +939,12 @@ tx_d_frame(struct hfc4s8s_l1 *l1p)
 	if ((skb = skb_dequeue(&l1p->d_tx_queue))) {
 		cp = skb->data;
 		cnt = skb->len;
-#ifndef CONFIG_HISAX_HFC4S8S_PCIMEM
+#ifndef HISAX_HFC4S8S_PCIMEM
 		SetRegAddr(l1p->hw, A_FIFO_DATA0);
 #endif
 
 		while (cnt >= 4) {
-#ifdef CONFIG_HISAX_HFC4S8S_PCIMEM
+#ifdef HISAX_HFC4S8S_PCIMEM
 			fWrite_hfc32(l1p->hw, A_FIFO_DATA0,
 				     *(unsigned long *) cp);
 #else
@@ -955,7 +955,7 @@ tx_d_frame(struct hfc4s8s_l1 *l1p)
 			cnt -= 4;
 		}
 
-#ifdef CONFIG_HISAX_HFC4S8S_PCIMEM
+#ifdef HISAX_HFC4S8S_PCIMEM
 		while (cnt--)
 			fWrite_hfc8(l1p->hw, A_FIFO_DATA0, *cp++);
 #else
@@ -1036,11 +1036,11 @@ tx_b_frame(struct hfc4s8s_btype *bch)
 		cp = skb->data + bch->tx_cnt;
 		bch->tx_cnt += cnt;
 
-#ifndef CONFIG_HISAX_HFC4S8S_PCIMEM
+#ifndef HISAX_HFC4S8S_PCIMEM
 		SetRegAddr(l1->hw, A_FIFO_DATA0);
 #endif
 		while (cnt >= 4) {
-#ifdef CONFIG_HISAX_HFC4S8S_PCIMEM
+#ifdef HISAX_HFC4S8S_PCIMEM
 			fWrite_hfc32(l1->hw, A_FIFO_DATA0,
 				     *(unsigned long *) cp);
 #else
@@ -1051,7 +1051,7 @@ tx_b_frame(struct hfc4s8s_btype *bch)
 		}
 
 		while (cnt--)
-#ifdef CONFIG_HISAX_HFC4S8S_PCIMEM
+#ifdef HISAX_HFC4S8S_PCIMEM
 			fWrite_hfc8(l1->hw, A_FIFO_DATA0, *cp++);
 #else
 			fWrite_hfc8(l1->hw, *cp++);
@@ -1280,7 +1280,7 @@ hfc4s8s_interrupt(int intno, void *dev_i
 	if (!hw || !(hw->mr.r_irq_ctrl & M_GLOB_IRQ_EN))
 		return IRQ_NONE;
 
-#ifndef	CONFIG_HISAX_HFC4S8S_PCIMEM
+#ifndef	HISAX_HFC4S8S_PCIMEM
 	/* read current selected regsister */
 	old_ioreg = GetRegAddr(hw);
 #endif
@@ -1291,7 +1291,7 @@ hfc4s8s_interrupt(int intno, void *dev_i
 	if (!
 	    (b = (Read_hfc8(hw, R_STATUS) & (M_MISC_IRQSTA | M_FR_IRQSTA)))
 && !hw->mr.r_irq_statech) {
-#ifndef	CONFIG_HISAX_HFC4S8S_PCIMEM
+#ifndef	HISAX_HFC4S8S_PCIMEM
 		SetRegAddr(hw, old_ioreg);
 #endif
 		return IRQ_NONE;
@@ -1321,7 +1321,7 @@ hfc4s8s_interrupt(int intno, void *dev_i
 	/* queue the request to allow other cards to interrupt */
 	schedule_work(&hw->tqueue);
 
-#ifndef	CONFIG_HISAX_HFC4S8S_PCIMEM
+#ifndef	HISAX_HFC4S8S_PCIMEM
 	SetRegAddr(hw, old_ioreg);
 #endif
 	return IRQ_HANDLED;
@@ -1470,7 +1470,7 @@ static void
 release_pci_ports(hfc4s8s_hw * hw)
 {
 	pci_write_config_word(hw->pdev, PCI_COMMAND, 0);
-#ifdef CONFIG_HISAX_HFC4S8S_PCIMEM
+#ifdef HISAX_HFC4S8S_PCIMEM
 	if (hw->membase)
 		iounmap((void *) hw->membase);
 #else
@@ -1485,7 +1485,7 @@ release_pci_ports(hfc4s8s_hw * hw)
 static void
 enable_pci_ports(hfc4s8s_hw * hw)
 {
-#ifdef CONFIG_HISAX_HFC4S8S_PCIMEM
+#ifdef HISAX_HFC4S8S_PCIMEM
 	pci_write_config_word(hw->pdev, PCI_COMMAND, PCI_ENA_MEMIO);
 #else
 	pci_write_config_word(hw->pdev, PCI_COMMAND, PCI_ENA_REGIO);
@@ -1560,7 +1560,7 @@ setup_instance(hfc4s8s_hw * hw)
 		       hw->irq);
 		goto out;
 	}
-#ifdef CONFIG_HISAX_HFC4S8S_PCIMEM
+#ifdef HISAX_HFC4S8S_PCIMEM
 	printk(KERN_INFO
 	       "HFC-4S/8S: found PCI card at membase 0x%p, irq %d\n",
 	       hw->hw_membase, hw->irq);
@@ -1613,7 +1613,7 @@ hfc4s8s_probe(struct pci_dev *pdev, cons
 	hw->irq = pdev->irq;
 	hw->iobase = pci_resource_start(pdev, 0);
 
-#ifdef CONFIG_HISAX_HFC4S8S_PCIMEM
+#ifdef HISAX_HFC4S8S_PCIMEM
 	hw->hw_membase = (u_char *) pci_resource_start(pdev, 1);
 	hw->membase = ioremap((ulong) hw->hw_membase, 256);
 #else
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
