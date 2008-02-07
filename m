From: akpm@linux-foundation.org
Subject: - tpm-infineon-section-mismatch.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:25:31 -0800
Message-ID: <200802070025.m170PCLj006695@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52198 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935100AbYBGApk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:45:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, sam@ravnborg.org, tpm@selhorst.net, mm-commits@vger.kernel.org


The patch titled
     tpm: infineon section mismatch
has been removed from the -mm tree.  Its filename was
     tpm-infineon-section-mismatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tpm: infineon section mismatch
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix section mismatch by making the driver template variable name
match one of the whitelisted variable names in modpost.

WARNING: vmlinux.o(.data+0x7a9e8): Section mismatch: reference to .init.text:tpm_inf_pnp_probe (between 'tpm_inf_pnp' and 'cn_idx')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Marcel Selhorst <tpm@selhorst.net>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
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

origin.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
documentation-move-dnotifytxt-to-filesystems.patch
documentation-move-sharedsubtreestxt-to-filesystems.patch
documentation-create-new-scheduler-subdirectory.patch
reporting-bugs-cc-the-mailing-list-too.patch
kernel-doc-prevent-duplicate-description-output.patch
kernel-doc-warn-on-badly-formatted-short-description.patch
email-clientstxt-sylpheed-is-ok-at-imap.patch
fs-menu-small-reorg.patch
the-scheduled-time-option-removal.patch
getdelays-fix-gcc-warnings.patch
profile-likely-unlikely-macros.patch
