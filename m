From: akpm@osdl.org
Subject: + kbuild-remove-references-to-deprecated-prepare-all-target.patch added to -mm tree
Date: Mon, 29 Jan 2007 16:44:58 -0800
Message-ID: <200701300045.l0U0j09h004441@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35511 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964898AbXA3ApF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 19:45:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, sam@ravnborg.org


The patch titled
     Kbuild: Remove references to deprecated "prepare-all" target from Makefile
has been added to the -mm tree.  Its filename is
     kbuild-remove-references-to-deprecated-prepare-all-target.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Kbuild: Remove references to deprecated "prepare-all" target from Makefile
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove references to the deprecated "make prepare-all" target from the
top-level Makefile; use just "make prepare" instead.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Makefile |    5 +----
 1 files changed, 1 insertion(+), 4 deletions(-)

diff -puN Makefile~kbuild-remove-references-to-deprecated-prepare-all-target Makefile
--- a/Makefile~kbuild-remove-references-to-deprecated-prepare-all-target
+++ a/Makefile
@@ -830,9 +830,6 @@ include/config/kernel.release: include/c
 # Listed in dependency order
 PHONY += prepare archprepare prepare0 prepare1 prepare2 prepare3
 
-# prepare-all is deprecated, use prepare as valid replacement
-PHONY += prepare-all
-
 # prepare3 is used to check if we are building in a separate output directory,
 # and if so do:
 # 1) Check that make has not been executed in the kernel src $(srctree)
@@ -865,7 +862,7 @@ prepare0: archprepare FORCE
 	$(Q)$(MAKE) $(build)=.
 
 # All the preparing..
-prepare prepare-all: prepare0
+prepare: prepare0
 
 # Leave this as default for preprocessing vmlinux.lds.S, which is now
 # done in arch/$(ARCH)/kernel/Makefile
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
fix-config_x86_64_-typo-in-drivers-kvm-svmc.patch
acpi-correct-apparent-typo-config_acpi_debug_output.patch
git-alsa.patch
ppc-use-syslog-macro-for-the-printk-log-level.patch
fix-apparent-typo-config_serial_cpm_smc.patch
remove-the-unused-kernel-config-option-video_videobuf.patch
change-incorrect-config_input_atixl-to-config_mouse_atixl.patch
kbuild-remove-references-to-deprecated-prepare-all-target.patch
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
