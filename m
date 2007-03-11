From: akpm@linux-foundation.org
Subject: + ppc-correct-apparently-misspelled-xmon-preprocessor.patch added to -mm tree
Date: Sun, 11 Mar 2007 01:45:33 -0800
Message-ID: <200703110945.l2B9jX41009103@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41665 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbXCKJpk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 05:45:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     PPC: correct apparently misspelled "XMON" preprocessor directive
has been added to the -mm tree.  Its filename is
     ppc-correct-apparently-misspelled-xmon-preprocessor.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PPC: correct apparently misspelled "XMON" preprocessor directive
From: "Robert P. J. Day" <rpjday@mindspring.com>

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/chrp/setup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/powerpc/platforms/chrp/setup.c~ppc-correct-apparently-misspelled-xmon-preprocessor arch/powerpc/platforms/chrp/setup.c
--- a/arch/powerpc/platforms/chrp/setup.c~ppc-correct-apparently-misspelled-xmon-preprocessor
+++ a/arch/powerpc/platforms/chrp/setup.c
@@ -427,7 +427,7 @@ static void __init chrp_find_openpic(voi
 	of_node_put(np);
 }
 
-#if defined(CONFIG_VT) && defined(CONFIG_INPUT_ADBHID) && defined(XMON)
+#if defined(CONFIG_VT) && defined(CONFIG_INPUT_ADBHID) && defined(CONFIG_XMON)
 static struct irqaction xmon_irqaction = {
 	.handler = xmon_irq,
 	.mask = CPU_MASK_NONE,
@@ -493,7 +493,7 @@ static void __init chrp_find_8259(void)
 
 void __init chrp_init_IRQ(void)
 {
-#if defined(CONFIG_VT) && defined(CONFIG_INPUT_ADBHID) && defined(XMON)
+#if defined(CONFIG_VT) && defined(CONFIG_INPUT_ADBHID) && defined(CONFIG_XMON)
 	struct device_node *kbd;
 #endif
 	chrp_find_openpic();
@@ -510,7 +510,7 @@ void __init chrp_init_IRQ(void)
 	if (_chrp_type == _CHRP_Pegasos)
 		ppc_md.get_irq        = i8259_irq;
 
-#if defined(CONFIG_VT) && defined(CONFIG_INPUT_ADBHID) && defined(XMON)
+#if defined(CONFIG_VT) && defined(CONFIG_INPUT_ADBHID) && defined(CONFIG_XMON)
 	/* see if there is a keyboard in the device tree
 	   with a parent of type "adb" */
 	for (kbd = find_devices("keyboard"); kbd; kbd = kbd->next)
_

Patches currently in -mm which might be from rpjday@mindspring.com are

remove-unused-header-file-sound-pci-cs46xx-imgs-cwcemb80h.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
git-avr32.patch
remove-unused-header-file-arch-ppc-syslib-cpc710h.patch
remove-unused-header-file-arch-powerpc-platforms-83xx-mpc834x_itxh.patch
ppc-correct-apparently-misspelled-xmon-preprocessor.patch
remove-unused-header-file-drivers-char-drm-via_mmh.patch
mtd-correct-misspelled-preprocessor-variable.patch
jffs2-remove-superfluous-source-file-fs-jffs2-comprtestc.patch
remove-unused-header-file-drivers-net-skfp-h-lnkstath.patch
remove-unused-header-file-drivers-net-wan-lmc-lmc_mediah.patch
delete-superfluous-source-file-net-wanrouter-af_wanpipec.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
remove-unused-header-file-drivers-message-fusion-lsi-mpi_inbh-and-drivers-message-fusion-lsi-mpi_log_fch.patch
remove-unused-header-file-arch-m68k-atari-atasoundh.patch
remove-unused-header-file-drivers-serial-crisv10h.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
reiserfs-correct-misspelled-reiserfs_proc_info-to.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
rocket-remove-modversions-include.patch
remove-unused-header-file-include-linux-elfnoteh.patch
remove-unused-header-file-drivers-message-i2o-i2o_lanh.patch
remove-unused-header-file-drivers-char-digih.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
remove-unused-header-file-drivers-video-riva-nv4refh.patch
