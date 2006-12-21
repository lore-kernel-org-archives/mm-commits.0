From: akpm@osdl.org
Subject: + tlclk-delete-unnecessary-sysfs_remove_group.patch added to -mm tree
Date: Wed, 20 Dec 2006 19:44:14 -0800
Message-ID: <200612210344.kBL3iEGf014793@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:34960 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422662AbWLUDoa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 22:44:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, greg@kroah.com, mark.gross@intel.com, sebastien.bouchard@ca.kontron.com


The patch titled
     tlclk: delete unnecessary sysfs_remove_group
has been added to the -mm tree.  Its filename is
     tlclk-delete-unnecessary-sysfs_remove_group.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tlclk: delete unnecessary sysfs_remove_group
From: Akinobu Mita <akinobu.mita@gmail.com>

It is unnecessary and invalid to call sysfs_remove_group() after
sysfs_create_group() failure.

Cc: Sebastien Bouchard <sebastien.bouchard@ca.kontron.com>
Cc: Mark Gross <mark.gross@intel.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/tlclk.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/char/tlclk.c~tlclk-delete-unnecessary-sysfs_remove_group drivers/char/tlclk.c
--- a/drivers/char/tlclk.c~tlclk-delete-unnecessary-sysfs_remove_group
+++ a/drivers/char/tlclk.c
@@ -807,8 +807,6 @@ static int __init tlclk_init(void)
 			&tlclk_attribute_group);
 	if (ret) {
 		printk(KERN_ERR "tlclk: failed to create sysfs device attributes.\n");
-		sysfs_remove_group(&tlclk_device->dev.kobj,
-			&tlclk_attribute_group);
 		goto out5;
 	}
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
audit-fix-kstrdup-error-check.patch
gss_spkm3-fix-error-handling-in-module-init.patch
tlclk-delete-unnecessary-sysfs_remove_group.patch
git-acpi.patch
git-alsa.patch
powerpc-use-is_init.patch
git-drm.patch
ehca-fix-kthread_create-error-check.patch
ehca-fix-do_mmap-error-check.patch
pc110pad-return-proper-error.patch
git-mtd.patch
net-use-bitrev8.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
iscsi-fix-crypto_alloc_hash-error-check.patch
git-watchdog.patch

