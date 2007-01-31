From: akpm@osdl.org
Subject: - net-remove-remaining-traces-of-config_e100_napi-for-pro-100.patch removed from -mm tree
Date: Wed, 31 Jan 2007 11:03:10 -0800
Message-ID: <200701311903.l0VJ3Asl023886@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43546 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933340AbXAaTDa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Jan 2007 14:03:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, auke-jan.h.kok@intel.com, jeff@garzik.org, john.ronciak@intel.com, mm-commits@vger.kernel.org


The patch titled
     net: remove remaining traces of "CONFIG_E100_NAPI" for PRO/100
has been removed from the -mm tree.  Its filename was
     net-remove-remaining-traces-of-config_e100_napi-for-pro-100.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: net: remove remaining traces of "CONFIG_E100_NAPI" for PRO/100
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the final two conditionals for the obsolete CONFIG_E100_NAPI kernel
config option.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: "Ronciak, John" <john.ronciak@intel.com>
Cc: Auke Kok <auke-jan.h.kok@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/e100.c |    8 --------
 1 files changed, 8 deletions(-)

diff -puN drivers/net/e100.c~net-remove-remaining-traces-of-config_e100_napi-for-pro-100 drivers/net/e100.c
--- a/drivers/net/e100.c~net-remove-remaining-traces-of-config_e100_napi-for-pro-100
+++ a/drivers/net/e100.c
@@ -2664,10 +2664,6 @@ static int e100_suspend(struct pci_dev *
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct nic *nic = netdev_priv(netdev);
 
-#ifdef CONFIG_E100_NAPI
-	if (netif_running(netdev))
-		netif_poll_disable(nic->netdev);
-#endif
 	del_timer_sync(&nic->watchdog);
 	netif_carrier_off(nic->netdev);
 
@@ -2713,10 +2709,6 @@ static void e100_shutdown(struct pci_dev
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct nic *nic = netdev_priv(netdev);
 
-#ifdef CONFIG_E100_NAPI
-	if (netif_running(netdev))
-		netif_poll_disable(nic->netdev);
-#endif
 	del_timer_sync(&nic->watchdog);
 	netif_carrier_off(nic->netdev);
 
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-acpi.patch
git-alsa.patch
ppc-use-syslog-macro-for-the-printk-log-level.patch
fix-apparent-typo-config_serial_cpm_smc.patch
remove-the-unused-kernel-config-option-video_videobuf.patch
change-incorrect-config_input_atixl-to-config_mouse_atixl.patch
kbuild-remove-references-to-deprecated-prepare-all-target.patch
net-remove-remaining-traces-of-config_e100_napi-for-pro-100.patch
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
add-is_power_of_2-checking-to-log2h.patch
isdn-fix-typo-config_hisax_quadro-config_hisax_sct_quadro.patch
isdn-rename-some-debugging-macros-to-not-resemble-config.patch
isdn-rename-debug-option-config_serial_nopause_io.patch
isdn-remove-defunct-test-emulator.patch
isdn-rename-special-macro-config_hisax_hfc4s8s_pcimem.patch
correct-apparent-typo-config_aty_ct-in-aty-video.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
