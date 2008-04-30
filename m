From: akpm@linux-foundation.org
Subject: - tpm-fix-section-mismatch-warning.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:48:58 -0700
Message-ID: <200804300548.m3U5mwgn029931@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751159AbYD3Fyv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:54:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, kjhall@us.ibm.com, tpm@selhorst.net, mm-commits@vger.kernel.org


The patch titled
     tpm: fix section mismatch warning
has been removed from the -mm tree.  Its filename was
     tpm-fix-section-mismatch-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tpm: fix section mismatch warning
From: Sam Ravnborg <sam@ravnborg.org>

Fix following warning:
WARNING: vmlinux.o(.init.text+0x32804): Section mismatch in reference from the function init_nsc() to the function .devexit.text:tpm_nsc_remove()

The function tpm_nsc_remove() are used outside __exit, so remove the __exit
annotation to make sure the function is always avilable.

Note: Trying to compare this module with other users of platform_device gve me
the impression that this driver needs some work to match other users.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Kylene Hall <kjhall@us.ibm.com>
Cc: Marcel Selhorst <tpm@selhorst.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm_nsc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/tpm/tpm_nsc.c~tpm-fix-section-mismatch-warning drivers/char/tpm/tpm_nsc.c
--- a/drivers/char/tpm/tpm_nsc.c~tpm-fix-section-mismatch-warning
+++ a/drivers/char/tpm/tpm_nsc.c
@@ -264,7 +264,7 @@ static const struct tpm_vendor_specific 
 
 static struct platform_device *pdev = NULL;
 
-static void __devexit tpm_nsc_remove(struct device *dev)
+static void tpm_nsc_remove(struct device *dev)
 {
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 	if ( chip ) {
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
git-x86.patch
git-m32r.patch
pcmcia-silence-section-mismatch-warnings-from-class_interface-variables.patch
pcmcia-silence-section-mismatch-warnings-from-pci_driver-variables.patch
pcmcia-annotate-cb_alloc-with-__ref.patch
git-pci.patch
git-s390.patch
git-sh.patch
scsi-fix-section-mismatch-in-aic94xx.patch
git-watchdog.patch
documentation-build-source-files-in-documentation-sub-dir.patch
remove-ifdef-__kernel__-checks-from-unexported-headers.patch

