From: akpm@linux-foundation.org
Subject: - dvb-av7110-fix-section-mismatch.patch removed from -mm tree
Date: Sun, 13 Jan 2008 03:33:56 -0800
Message-ID: <200801131133.m0DBXa49009861@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49751 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751399AbYAMLjQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jan 2008 06:39:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mchehab@infradead.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     dvb/av7110: fix section mismatch
has been removed from the -mm tree.  Its filename was
     dvb-av7110-fix-section-mismatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
scsi-qla2xxx-qla_osc-section-fix.patch
cciss-section-mismatch.patch
advansys-fix-section-mismatch-warning.patch
uvesafb-fix-section-mismatch-warnings.patch
driver-core-build-with-sysfs=n.patch
sysfs-make-sysfs_deprecated-depend-on-sysfs.patch
git-dvb.patch
git-kbuild.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
pcmcia-include-bad-cis-filename-in-error-message.patch
git-scsi-misc.patch
megaraid-fix-section-mismatch.patch
git-unionfs.patch
hostap-section-mismatch-warning.patch
git-ipwireless_cs.patch
git-x86.patch
register_cpu-__devinit-or-__cpuinit.patch
cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
dio-fix-kernel-doc-notation.patch
tpm-infineon-section-mismatch.patch
tdfxfb-fix-section-mismatch-warnings.patch
uvesafb-small-cleanups.patch
documentation-move-dnotifytxt-to-filesystems.patch
documentation-move-sharedsubtreestxt-to-filesystems.patch
documentation-create-new-scheduler-subdirectory.patch
reporting-bugs-cc-the-mailing-list-too.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch
