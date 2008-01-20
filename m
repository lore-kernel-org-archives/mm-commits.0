From: akpm@linux-foundation.org
Subject: - hostap-section-mismatch-warning.patch removed from -mm tree
Date: Sun, 20 Jan 2008 11:42:51 -0800
Message-ID: <200801201942.m0KJgWav032553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60657 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754716AbYATToo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 20 Jan 2008 14:44:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, linville@tuxdriver.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     hostap: section mismatch warning
has been removed from the -mm tree.  Its filename was
     hostap-section-mismatch-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hostap: section mismatch warning
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix section mismatch by changing variable name to match one of the
whitelisted (allowable) names for pointing into init data:

WARNING: vmlinux.o(.data+0xce618): Section mismatch: reference to .init.data:prism2_plx_id_table (between 'prism2_plx_drv_id' and 'dev_info')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/hostap/hostap_plx.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/net/wireless/hostap/hostap_plx.c~hostap-section-mismatch-warning drivers/net/wireless/hostap/hostap_plx.c
--- a/drivers/net/wireless/hostap/hostap_plx.c~hostap-section-mismatch-warning
+++ a/drivers/net/wireless/hostap/hostap_plx.c
@@ -608,7 +608,7 @@ static void prism2_plx_remove(struct pci
 
 MODULE_DEVICE_TABLE(pci, prism2_plx_id_table);
 
-static struct pci_driver prism2_plx_drv_id = {
+static struct pci_driver prism2_plx_driver = {
 	.name		= "hostap_plx",
 	.id_table	= prism2_plx_id_table,
 	.probe		= prism2_plx_probe,
@@ -618,13 +618,13 @@ static struct pci_driver prism2_plx_drv_
 
 static int __init init_prism2_plx(void)
 {
-	return pci_register_driver(&prism2_plx_drv_id);
+	return pci_register_driver(&prism2_plx_driver);
 }
 
 
 static void __exit exit_prism2_plx(void)
 {
-	pci_unregister_driver(&prism2_plx_drv_id);
+	pci_unregister_driver(&prism2_plx_driver);
 }
 
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
rcu-fix-section-mismatch.patch
hrtimer-fix-section-mismatch.patch
timer-fix-section-mismatch.patch
git-alsa.patch
git-dvb.patch
git-kbuild.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
pcmcia-include-bad-cis-filename-in-error-message.patch
git-scsi-misc.patch
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
