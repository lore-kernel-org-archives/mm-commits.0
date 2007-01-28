From: akpm@osdl.org
Subject: + isdn-rename-debug-option-config_serial_nopause_io.patch added to -mm tree
Date: Sun, 28 Jan 2007 15:58:07 -0800
Message-ID: <200701282358.l0SNw7v5006454@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42605 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932983AbXA1X6M (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 28 Jan 2007 18:58:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, kkeil@suse.de


The patch titled
     ISDN: Rename debug option CONFIG_SERIAL_NOPAUSE_IO
has been added to the -mm tree.  Its filename is
     isdn-rename-debug-option-config_serial_nopause_io.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ISDN: Rename debug option CONFIG_SERIAL_NOPAUSE_IO
From: "Robert P. J. Day" <rpjday@mindspring.com>

Based on advice from K.  Keil, rename the special debug option
CONFIG_SERIAL_NOPAUSE_IO to ELSA_SERIAL_NOPAUSE_IO so it no longer resembles a
user-selectable kernel config option.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/isdn/hisax/elsa_ser.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/isdn/hisax/elsa_ser.c~isdn-rename-debug-option-config_serial_nopause_io drivers/isdn/hisax/elsa_ser.c
--- a/drivers/isdn/hisax/elsa_ser.c~isdn-rename-debug-option-config_serial_nopause_io
+++ a/drivers/isdn/hisax/elsa_ser.c
@@ -58,7 +58,7 @@ static inline unsigned int serial_in(str
 static inline unsigned int serial_inp(struct IsdnCardState *cs, int offset)
 {
 #ifdef SERIAL_DEBUG_REG
-#ifdef CONFIG_SERIAL_NOPAUSE_IO
+#ifdef ELSA_SERIAL_NOPAUSE_IO
 	u_int val = inb(cs->hw.elsa.base + 8 + offset);
 	debugl1(cs,"inp  %s %02x",ModemIn[offset], val);
 #else
@@ -67,7 +67,7 @@ static inline unsigned int serial_inp(st
 #endif
 	return(val);
 #else
-#ifdef CONFIG_SERIAL_NOPAUSE_IO
+#ifdef ELSA_SERIAL_NOPAUSE_IO
 	return inb(cs->hw.elsa.base + 8 + offset);
 #else
 	return inb_p(cs->hw.elsa.base + 8 + offset);
@@ -87,13 +87,13 @@ static inline void serial_outp(struct Is
 			       int value)
 {
 #ifdef SERIAL_DEBUG_REG
-#ifdef CONFIG_SERIAL_NOPAUSE_IO
+#ifdef ELSA_SERIAL_NOPAUSE_IO
 	debugl1(cs,"outp %s %02x",ModemOut[offset], value);
 #else
 	debugl1(cs,"outP %s %02x",ModemOut[offset], value);
 #endif
 #endif
-#ifdef CONFIG_SERIAL_NOPAUSE_IO
+#ifdef ELSA_SERIAL_NOPAUSE_IO
 	outb(value, cs->hw.elsa.base + 8 + offset);
 #else
     	outb_p(value, cs->hw.elsa.base + 8 + offset);
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
