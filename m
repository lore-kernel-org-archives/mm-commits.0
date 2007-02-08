From: akpm@linux-foundation.org
Subject: - ppc-use-syslog-macro-for-the-printk-log-level.patch removed from -mm tree
Date: Thu, 08 Feb 2007 01:47:49 -0800
Message-ID: <200702080947.l189lnKU010977@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35696 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423169AbXBHJry (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 04:47:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, mm-commits@vger.kernel.org


The patch titled
     ppc: use syslog macro for the printk log level
has been removed from the -mm tree.  Its filename was
     ppc-use-syslog-macro-for-the-printk-log-level.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ppc: use syslog macro for the printk log level
From: "Robert P. J. Day" <rpjday@mindspring.com>

Use the appropriate logging macro for the priority level for that
printk call.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ppc/syslib/m8260_pci_erratum9.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/ppc/syslib/m8260_pci_erratum9.c~ppc-use-syslog-macro-for-the-printk-log-level arch/ppc/syslib/m8260_pci_erratum9.c
--- a/arch/ppc/syslib/m8260_pci_erratum9.c~ppc-use-syslog-macro-for-the-printk-log-level
+++ a/arch/ppc/syslib/m8260_pci_erratum9.c
@@ -105,7 +105,8 @@ void idma_pci9_init(void)
 	idma_reg[IDMA_CHAN].idmr = 0;		/* mask all IDMA interrupts */
 	idma_reg[IDMA_CHAN].idsr = 0xff;	/* clear all event flags */
 
-	printk("<4>Using IDMA%d for MPC8260 device erratum PCI 9 workaround\n",
+	printk(	KERN_WARNING
+		"Using IDMA%d for MPC8260 device erratum PCI 9 workaround\n",
 		IDMA_CHAN + 1);
 
 	return;
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-alsa.patch
git-powerpc.patch
git-dvb.patch
change-incorrect-config_input_atixl-to-config_mouse_atixl.patch
kbuild-remove-references-to-deprecated-prepare-all-target.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
fix-misspelled-usbnet_mii-kernel-config-option.patch
fix-apparent-typo-config_usb_cdcether.patch
git-wireless.patch
replace-incorrect-macro-name-wireless_ext-with.patch
remove-unused-kernel-config-option-x86_xadd.patch
remove-final-references-to-deprecated-map_anon-page-protection-flag.patch
uml-fix-apparent-config_64_bit-typo.patch
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
ntfs-rename-incorrect-check-of-ntfs_debug-with-just-debug.patch
quota-have-linux-quotah-include-linux-rwsemh-explicitly.patch
isdn-fix-typo-config_hisax_quadro-config_hisax_sct_quadro.patch
isdn-rename-some-debugging-macros-to-not-resemble-config.patch
isdn-rename-debug-option-config_serial_nopause_io.patch
isdn-remove-defunct-test-emulator.patch
isdn-rename-special-macro-config_hisax_hfc4s8s_pcimem.patch
correct-apparent-typo-config_aty_ct-in-aty-video.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
