From: akpm@linux-foundation.org
Subject: + dvb-av7110-fix-section-mismatch.patch added to -mm tree
Date: Thu, 10 Jan 2008 16:04:50 -0800
Message-ID: <200801110004.m0B04o5I016491@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39477 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754664AbYAKAFK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 19:05:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, mchehab@infradead.org


The patch titled
     dvb/av7110: fix section mismatch
has been added to the -mm tree.  Its filename is
     dvb-av7110-fix-section-mismatch.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dvb/av7110: fix section mismatch
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix driver data name to match whitelist of acceptable names that contain
pointers init data so that section mismatch warning is placated.

WARNING: vmlinux.o(.data+0x141288): Section mismatch: reference to .init.text:av7110_attach (between 'av7110_extension' and 'ir_protocol')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/ttpci/av7110.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/media/dvb/ttpci/av7110.c~dvb-av7110-fix-section-mismatch drivers/media/dvb/ttpci/av7110.c
--- a/drivers/media/dvb/ttpci/av7110.c~dvb-av7110-fix-section-mismatch
+++ a/drivers/media/dvb/ttpci/av7110.c
@@ -2801,12 +2801,12 @@ static void av7110_irq(struct saa7146_de
 }
 
 
-static struct saa7146_extension av7110_extension;
+static struct saa7146_extension av7110_extension_driver;
 
 #define MAKE_AV7110_INFO(x_var,x_name) \
 static struct saa7146_pci_extension_data x_var = { \
 	.ext_priv = x_name, \
-	.ext = &av7110_extension }
+	.ext = &av7110_extension_driver }
 
 MAKE_AV7110_INFO(tts_1_X_fsc,"Technotrend/Hauppauge WinTV DVB-S rev1.X or Fujitsu Siemens DVB-C");
 MAKE_AV7110_INFO(ttt_1_X,    "Technotrend/Hauppauge WinTV DVB-T rev1.X");
@@ -2844,7 +2844,7 @@ static struct pci_device_id pci_tbl[] = 
 MODULE_DEVICE_TABLE(pci, pci_tbl);
 
 
-static struct saa7146_extension av7110_extension = {
+static struct saa7146_extension av7110_extension_driver = {
 	.name		= "dvb",
 	.flags		= SAA7146_USE_I2C_IRQ,
 
@@ -2861,14 +2861,14 @@ static struct saa7146_extension av7110_e
 static int __init av7110_init(void)
 {
 	int retval;
-	retval = saa7146_register_extension(&av7110_extension);
+	retval = saa7146_register_extension(&av7110_extension_driver);
 	return retval;
 }
 
 
 static void __exit av7110_exit(void)
 {
-	saa7146_unregister_extension(&av7110_extension);
+	saa7146_unregister_extension(&av7110_extension_driver);
 }
 
 module_init(av7110_init);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-dvb.patch
git-kbuild.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
pcmcia-include-bad-cis-filename-in-error-message.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
git-x86.patch
scsi-qla2xxx-qla_osc-section-fix.patch
register_cpu-__devinit-or-__cpuinit.patch
cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
dio-fix-kernel-doc-notation.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch
megaraid-fix-section-mismatch.patch
cciss-section-mismatch.patch
x86-discover_ebda-section-mismatch.patch
tpm-infineon-section-mismatch.patch
dvb-av7110-fix-section-mismatch.patch
hostap-section-mismatch-warning.patch
