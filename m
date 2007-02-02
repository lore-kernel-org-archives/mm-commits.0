From: akpm@linux-foundation.org
Subject: + replace-incorrect-macro-name-wireless_ext-with.patch added to -mm tree
Date: Fri, 02 Feb 2007 15:01:04 -0800
Message-ID: <200702022301.l12N14Gl020224@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43731 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946133AbXBBXBm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Feb 2007 18:01:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, linville@tuxdriver.com


The patch titled
     Replace incorrect macro name "WIRELESS_EXT" with "CONFIG_WIRELESS_EXT"
has been added to the -mm tree.  Its filename is
     replace-incorrect-macro-name-wireless_ext-with.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Replace incorrect macro name "WIRELESS_EXT" with "CONFIG_WIRELESS_EXT"
From: "Robert P. J. Day" <rpjday@mindspring.com>

Rename the (apparently) incorrect macro name WIRELESS_EXT to
CONFIG_WIRELESS_EXT.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 net/core/net-sysfs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN net/core/net-sysfs.c~replace-incorrect-macro-name-wireless_ext-with net/core/net-sysfs.c
--- a/net/core/net-sysfs.c~replace-incorrect-macro-name-wireless_ext-with
+++ a/net/core/net-sysfs.c
@@ -329,7 +329,7 @@ static struct attribute_group netstat_gr
 	.attrs  = netstat_attrs,
 };
 
-#ifdef WIRELESS_EXT
+#ifdef CONFIG_WIRELESS_EXT
 /* helper function that does all the locking etc for wireless stats */
 static ssize_t wireless_show(struct class_device *cd, char *buf,
 			     ssize_t (*format)(const struct iw_statistics *,
@@ -462,7 +462,7 @@ int netdev_register_sysfs(struct net_dev
 	if (net->get_stats)
 		*groups++ = &netstat_group;
 
-#ifdef WIRELESS_EXT
+#ifdef CONFIG_WIRELESS_EXT
 	if (net->wireless_handlers && net->wireless_handlers->get_wireless_stats)
 		*groups++ = &wireless_group;
 #endif
_

Patches currently in -mm which might be from rpjday@mindspring.com are

git-acpi.patch
git-alsa.patch
ppc-use-syslog-macro-for-the-printk-log-level.patch
fix-apparent-typo-config_serial_cpm_smc.patch
remove-the-unused-kernel-config-option-video_videobuf.patch
change-incorrect-config_input_atixl-to-config_mouse_atixl.patch
kbuild-remove-references-to-deprecated-prepare-all-target.patch
git-mips.patch
remove-unused-kernel-config-option-dlci_count.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
fix-misspelled-usbnet_mii-kernel-config-option.patch
fix-apparent-typo-config_usb_cdcether.patch
rename-ipw2100-debugging-macros-to-not-look-like-config.patch
replace-incorrect-macro-name-wireless_ext-with.patch
remove-unused-kernel-config-option-x86_xadd.patch
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
add-is_power_of_2-checking-to-log2h.patch
isdn-fix-typo-config_hisax_quadro-config_hisax_sct_quadro.patch
isdn-rename-some-debugging-macros-to-not-resemble-config.patch
isdn-rename-debug-option-config_serial_nopause_io.patch
isdn-remove-defunct-test-emulator.patch
isdn-rename-special-macro-config_hisax_hfc4s8s_pcimem.patch
correct-apparent-typo-config_aty_ct-in-aty-video.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
