From: akpm@osdl.org
Subject: + remove-final-vestiges-of-config_unwind_info.patch added to -mm tree
Date: Sun, 28 Jan 2007 16:01:07 -0800
Message-ID: <200701290001.l0T017mu006551@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42671 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932982AbXA2ABV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 28 Jan 2007 19:01:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, ak@suse.de, jbeulich@novell.com


The patch titled
     Remove final vestiges of CONFIG_UNWIND_INFO
has been added to the -mm tree.  Its filename is
     remove-final-vestiges-of-config_unwind_info.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove final vestiges of CONFIG_UNWIND_INFO
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the sole remaining reference to the apparently dead config variable
CONFIG_UNWIND_INFO.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-i386/dwarf2.h |   26 --------------------------
 1 file changed, 26 deletions(-)

diff -puN include/asm-i386/dwarf2.h~remove-final-vestiges-of-config_unwind_info include/asm-i386/dwarf2.h
--- a/include/asm-i386/dwarf2.h~remove-final-vestiges-of-config_unwind_info
+++ a/include/asm-i386/dwarf2.h
@@ -12,30 +12,6 @@
    away for older version.
  */
 
-#ifdef CONFIG_UNWIND_INFO
-
-#define CFI_STARTPROC .cfi_startproc
-#define CFI_ENDPROC .cfi_endproc
-#define CFI_DEF_CFA .cfi_def_cfa
-#define CFI_DEF_CFA_REGISTER .cfi_def_cfa_register
-#define CFI_DEF_CFA_OFFSET .cfi_def_cfa_offset
-#define CFI_ADJUST_CFA_OFFSET .cfi_adjust_cfa_offset
-#define CFI_OFFSET .cfi_offset
-#define CFI_REL_OFFSET .cfi_rel_offset
-#define CFI_REGISTER .cfi_register
-#define CFI_RESTORE .cfi_restore
-#define CFI_REMEMBER_STATE .cfi_remember_state
-#define CFI_RESTORE_STATE .cfi_restore_state
-#define CFI_UNDEFINED .cfi_undefined
-
-#ifdef CONFIG_AS_CFI_SIGNAL_FRAME
-#define CFI_SIGNAL_FRAME .cfi_signal_frame
-#else
-#define CFI_SIGNAL_FRAME
-#endif
-
-#else
-
 /* Due to the structure of pre-exisiting code, don't use assembler line
    comment character # to ignore the arguments. Instead, use a dummy macro. */
 .macro ignore a=0, b=0, c=0, d=0
@@ -57,5 +33,3 @@
 #define CFI_SIGNAL_FRAME ignore
 
 #endif
-
-#endif
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
remove-final-vestiges-of-config_unwind_info.patch
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
