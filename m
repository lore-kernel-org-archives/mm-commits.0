From: akpm@linux-foundation.org
Subject: + tpm-infineon-section-mismatch.patch added to -mm tree
Date: Thu, 10 Jan 2008 16:04:48 -0800
Message-ID: <200801110004.m0B04mGZ016484@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37824 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754781AbYAKAFD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 19:05:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, tpm@selhorst.net


The patch titled
     tpm: infineon section mismatch
has been added to the -mm tree.  Its filename is
     tpm-infineon-section-mismatch.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tpm: infineon section mismatch
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix section mismatch by making the driver template variable name
match one of the whitelisted variable names in modpost.

WARNING: vmlinux.o(.data+0x7a9e8): Section mismatch: reference to .init.text:tpm_inf_pnp_probe (between 'tpm_inf_pnp' and 'cn_idx')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Marcel Selhorst <tpm@selhorst.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm_infineon.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/char/tpm/tpm_infineon.c~tpm-infineon-section-mismatch drivers/char/tpm/tpm_infineon.c
--- a/drivers/char/tpm/tpm_infineon.c~tpm-infineon-section-mismatch
+++ a/drivers/char/tpm/tpm_infineon.c
@@ -611,7 +611,7 @@ static __devexit void tpm_inf_pnp_remove
 	}
 }
 
-static struct pnp_driver tpm_inf_pnp = {
+static struct pnp_driver tpm_inf_pnp_driver = {
 	.name = "tpm_inf_pnp",
 	.driver = {
 		.owner = THIS_MODULE,
@@ -625,12 +625,12 @@ static struct pnp_driver tpm_inf_pnp = {
 
 static int __init init_inf(void)
 {
-	return pnp_register_driver(&tpm_inf_pnp);
+	return pnp_register_driver(&tpm_inf_pnp_driver);
 }
 
 static void __exit cleanup_inf(void)
 {
-	pnp_unregister_driver(&tpm_inf_pnp);
+	pnp_unregister_driver(&tpm_inf_pnp_driver);
 }
 
 module_init(init_inf);
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
