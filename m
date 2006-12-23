From: akpm@osdl.org
Subject: - tlclk-delete-unnecessary-sysfs_remove_group.patch removed from -mm tree
Date: Fri, 22 Dec 2006 23:54:35 -0800
Message-ID: <200612230754.kBN7sZIW010224@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49749 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753274AbWLWHyj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Dec 2006 02:54:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, greg@kroah.com, mark.gross@intel.com, sebastien.bouchard@ca.kontron.com, mm-commits@vger.kernel.org


The patch titled
     tlclk: delete unnecessary sysfs_remove_group
has been removed from the -mm tree.  Its filename was
     tlclk-delete-unnecessary-sysfs_remove_group.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
powerpc-use-is_init.patch
git-dvb.patch
ehca-fix-kthread_create-error-check.patch
ehca-fix-do_mmap-error-check.patch
git-input.patch
git-mtd.patch
net-use-bitrev8.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
iscsi-fix-crypto_alloc_hash-error-check.patch
git-watchdog.patch

