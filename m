From: akpm@linux-foundation.org
Subject: + edac-add-wissing-pieces-from-mpc85xx-fsl_soc_booke.patch added to -mm tree
Date: Fri, 28 May 2010 16:51:12 -0700
Message-ID: <201005282351.o4SNpCn6021354@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752419Ab0E1XvU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 May 2010 19:51:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: siccegge@cs.fau.de, dougthompson@xmission.com, galak@kernel.crashing.org, ptyser@xes-inc.com


The patch titled
     edac: add wissing pieces from MPC85xx -> FSL_SOC_BOOKE
has been added to the -mm tree.  Its filename is
     edac-add-wissing-pieces-from-mpc85xx-fsl_soc_booke.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: add wissing pieces from MPC85xx -> FSL_SOC_BOOKE
From: Christoph Egger <siccegge@cs.fau.de>

In 5753c082f66eca5be81f6bda85c1718c5eea6ada ("powerpc/85xx: Kconfig
cleanup") menuconfig MPC85xx was replaced by FSL_SOC_BOOKE but some
references insider the code were not adjusted accordingly.  This patch
adresses these missing pieces.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
Cc: Doug Thompson <dougthompson@xmission.com>
Cc: Peter Tyser <ptyser@xes-inc.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/mpc85xx_edac.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/edac/mpc85xx_edac.c~edac-add-wissing-pieces-from-mpc85xx-fsl_soc_booke drivers/edac/mpc85xx_edac.c
--- a/drivers/edac/mpc85xx_edac.c~edac-add-wissing-pieces-from-mpc85xx-fsl_soc_booke
+++ a/drivers/edac/mpc85xx_edac.c
@@ -43,7 +43,7 @@ static u32 orig_pci_err_en;
 #endif
 
 static u32 orig_l2_err_disable;
-#ifdef CONFIG_MPC85xx
+#ifdef CONFIG_FSL_SOC_BOOKE
 static u32 orig_hid1[2];
 #endif
 
@@ -1136,7 +1136,7 @@ static struct of_platform_driver mpc85xx
 	},
 };
 
-#ifdef CONFIG_MPC85xx
+#ifdef CONFIG_FSL_SOC_BOOKE
 static void __init mpc85xx_mc_clear_rfxe(void *data)
 {
 	orig_hid1[smp_processor_id()] = mfspr(SPRN_HID1);
@@ -1175,7 +1175,7 @@ static int __init mpc85xx_mc_init(void)
 		printk(KERN_WARNING EDAC_MOD_STR "PCI fails to register\n");
 #endif
 
-#ifdef CONFIG_MPC85xx
+#ifdef CONFIG_FSL_SOC_BOOKE
 	/*
 	 * need to clear HID1[RFXE] to disable machine check int
 	 * so we can catch it
@@ -1189,7 +1189,7 @@ static int __init mpc85xx_mc_init(void)
 
 module_init(mpc85xx_mc_init);
 
-#ifdef CONFIG_MPC85xx
+#ifdef CONFIG_FSL_SOC_BOOKE
 static void __exit mpc85xx_mc_restore_hid1(void *data)
 {
 	mtspr(SPRN_HID1, orig_hid1[smp_processor_id()]);
@@ -1198,7 +1198,7 @@ static void __exit mpc85xx_mc_restore_hi
 
 static void __exit mpc85xx_mc_exit(void)
 {
-#ifdef CONFIG_MPC85xx
+#ifdef CONFIG_FSL_SOC_BOOKE
 	on_each_cpu(mpc85xx_mc_restore_hid1, NULL, 0);
 #endif
 #ifdef CONFIG_PCI
_

Patches currently in -mm which might be from siccegge@cs.fau.de are

origin.patch
edac-add-wissing-pieces-from-mpc85xx-fsl_soc_booke.patch

