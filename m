From: akpm@osdl.org
Subject: + acpi-correct-apparent-typo-config_acpi_debug_output.patch added to -mm tree
Date: Fri, 26 Jan 2007 23:12:54 -0800
Message-ID: <200701270712.l0R7CsuQ004268@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43743 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201AbXA0HM4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Jan 2007 02:12:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com


The patch titled
     ACPI: Correct apparent typo "CONFIG_ACPI_DEBUG_OUTPUT"
has been added to the -mm tree.  Its filename is
     acpi-correct-apparent-typo-config_acpi_debug_output.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ACPI: Correct apparent typo "CONFIG_ACPI_DEBUG_OUTPUT"
From: "Robert P. J. Day" <rpjday@mindspring.com>

Replace the apparent typo CONFIG_ACPI_DEBUG_OUTPUT with the non-Kconfig
conditional ACPI_DEBUG_OUTPUT, which is what every other file uses.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acpi/scan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/acpi/scan.c~acpi-correct-apparent-typo-config_acpi_debug_output drivers/acpi/scan.c
--- a/drivers/acpi/scan.c~acpi-correct-apparent-typo-config_acpi_debug_output
+++ a/drivers/acpi/scan.c
@@ -992,7 +992,7 @@ static int acpi_device_set_context(struc
 static void acpi_device_get_debug_info(struct acpi_device *device,
 				       acpi_handle handle, int type)
 {
-#ifdef CONFIG_ACPI_DEBUG_OUTPUT
+#ifdef ACPI_DEBUG_OUTPUT
 	char *type_string = NULL;
 	char name[80] = { '?', '\0' };
 	struct acpi_buffer buffer = { sizeof(name), name };
@@ -1029,7 +1029,7 @@ static void acpi_device_get_debug_info(s
 	}
 
 	printk(KERN_DEBUG "Found %s %s [%p]\n", type_string, name, handle);
-#endif				/*CONFIG_ACPI_DEBUG_OUTPUT */
+#endif				/* ACPI_DEBUG_OUTPUT */
 }
 
 static int acpi_bus_remove(struct acpi_device *dev, int rmdevice)
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
correct-apparent-typo-config_aty_ct-in-aty-video.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
