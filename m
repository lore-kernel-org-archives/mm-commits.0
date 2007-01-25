From: akpm@osdl.org
Subject: + remove-some-unused-scsi-related-kernel-config-variables.patch added to -mm tree
Date: Wed, 24 Jan 2007 21:40:18 -0800
Message-ID: <200701250540.l0P5eIq9007037@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47976 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933251AbXAYFk1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 00:40:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, James.Bottomley@steeleye.com


The patch titled
     Remove some unused SCSI-related kernel config variables.
has been added to the -mm tree.  Its filename is
     remove-some-unused-scsi-related-kernel-config-variables.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove some unused SCSI-related kernel config variables.
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the unused SCSI-related kernel config variables

	SCSI_NCR53C8XX_PROFILE_SUPPORT
	SCSI_NCR53C8XX_PROFILE
	53C700_IO_MAPPED
	AIC79XX_ENABLE_RD_STRM
	AIC7XXX_PROBE_EISA_VL

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/scsi/ncr53c8xx.txt     |    5 -----
 drivers/scsi/Kconfig                 |   16 ----------------
 drivers/scsi/aic7xxx/Kconfig.aic79xx |   12 ------------
 drivers/scsi/aic7xxx/Kconfig.aic7xxx |   10 ----------
 4 files changed, 43 deletions(-)

diff -puN Documentation/scsi/ncr53c8xx.txt~remove-some-unused-scsi-related-kernel-config-variables Documentation/scsi/ncr53c8xx.txt
--- a/Documentation/scsi/ncr53c8xx.txt~remove-some-unused-scsi-related-kernel-config-variables
+++ a/Documentation/scsi/ncr53c8xx.txt
@@ -562,11 +562,6 @@ if only one has a flaw for some SCSI fea
 support by the driver of this feature at linux start-up and enable
 this feature after boot-up only for devices that support it safely.
 
-CONFIG_SCSI_NCR53C8XX_PROFILE_SUPPORT  (default answer: n)
-    This option must be set for profiling information to be gathered 
-    and printed out through the proc file system. This features may 
-    impact performances.
-
 CONFIG_SCSI_NCR53C8XX_IOMAPPED       (default answer: n)
     Answer "y" if you suspect your mother board to not allow memory mapped I/O.
     May slow down performance a little.  This option is required by
diff -puN drivers/scsi/Kconfig~remove-some-unused-scsi-related-kernel-config-variables drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig~remove-some-unused-scsi-related-kernel-config-variables
+++ a/drivers/scsi/Kconfig
@@ -1193,17 +1193,6 @@ config SCSI_NCR53C8XX_SYNC
 	  There is no safe option other than using good cabling, right
 	  terminations and SCSI conformant devices.
 
-config SCSI_NCR53C8XX_PROFILE
-	bool "enable profiling"
-	depends on SCSI_ZALON || SCSI_NCR_Q720
-	help
-	  This option allows you to enable profiling information gathering.
-	  These statistics are not very accurate due to the low frequency
-	  of the kernel clock (100 Hz on i386) and have performance impact
-	  on systems that use very fast devices.
-
-	  The normal answer therefore is N.
-
 config SCSI_NCR53C8XX_NO_DISCONNECT
 	bool "not allow targets to disconnect"
 	depends on (SCSI_ZALON || SCSI_NCR_Q720) && SCSI_NCR53C8XX_DEFAULT_TAGS=0
@@ -1333,11 +1322,6 @@ config SCSI_SIM710
 
 	  It currently supports Compaq EISA cards and NCR MCA cards
 
-config 53C700_IO_MAPPED
-	bool
-	depends on SCSI_SIM710
-	default y
-
 config SCSI_SYM53C416
 	tristate "Symbios 53c416 SCSI support"
 	depends on ISA && SCSI
diff -puN drivers/scsi/aic7xxx/Kconfig.aic79xx~remove-some-unused-scsi-related-kernel-config-variables drivers/scsi/aic7xxx/Kconfig.aic79xx
--- a/drivers/scsi/aic7xxx/Kconfig.aic79xx~remove-some-unused-scsi-related-kernel-config-variables
+++ a/drivers/scsi/aic7xxx/Kconfig.aic79xx
@@ -57,18 +57,6 @@ config AIC79XX_BUILD_FIRMWARE
 	or modify the assembler Makefile or the files it includes if your
 	build environment is different than that of the author.
 
-config AIC79XX_ENABLE_RD_STRM
-	bool "Enable Read Streaming for All Targets"
-	depends on SCSI_AIC79XX
-	default n
-	help
-	Read Streaming is a U320 protocol option that should enhance
-	performance.  Early U320 drive firmware actually performs slower
-	with read streaming enabled so it is disabled by default.  Read
-	Streaming can be configured in much the same way as tagged queueing
-	using the "rd_strm" command line option.  See
-	drivers/scsi/aic7xxx/README.aic79xx for details.
-
 config AIC79XX_DEBUG_ENABLE
 	bool "Compile in Debugging Code"
 	depends on SCSI_AIC79XX
diff -puN drivers/scsi/aic7xxx/Kconfig.aic7xxx~remove-some-unused-scsi-related-kernel-config-variables drivers/scsi/aic7xxx/Kconfig.aic7xxx
--- a/drivers/scsi/aic7xxx/Kconfig.aic7xxx~remove-some-unused-scsi-related-kernel-config-variables
+++ a/drivers/scsi/aic7xxx/Kconfig.aic7xxx
@@ -50,16 +50,6 @@ config AIC7XXX_RESET_DELAY_MS
 
 	Default: 5000 (5 seconds)
 
-config AIC7XXX_PROBE_EISA_VL
-	bool "Probe for EISA and VL AIC7XXX Adapters"
-	depends on SCSI_AIC7XXX && EISA
-	help
-	Probe for EISA and VLB Aic7xxx controllers.  In many newer systems,
-	the invasive probes necessary to detect these controllers can cause
-	other devices to fail.  For this reason, the non-PCI probe code is
-	disabled by default.  The current value of this option can be "toggled"
-	via the no_probe kernel command line option.
-
 config AIC7XXX_BUILD_FIRMWARE
 	bool "Build Adapter Firmware with Kernel Build"
 	depends on SCSI_AIC7XXX && !PREVENT_FIRMWARE_BUILD
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
fix-various-kernel-doc-in-header-files.patch
git-alsa.patch
ppc-use-syslog-macro-for-the-printk-log-level.patch
remove-the-unused-kernel-config-option-video_videobuf.patch
remove-unused-kernel-config-option-dlci_count.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
remove-unused-kernel-config-option-x86_xadd.patch
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
oss-replace-kmallocmemset-combos-with-kzalloc.patch
