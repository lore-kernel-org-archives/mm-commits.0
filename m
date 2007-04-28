From: akpm@linux-foundation.org
Subject: - sysfs-oops-workaround.patch removed from -mm tree
Date: Sat, 28 Apr 2007 02:43:01 -0700
Message-ID: <200704280943.l3S9h1uH019050@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60066 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753952AbXD1JnE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 05:43:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htejun@gmail.com, mm-commits@vger.kernel.org


The patch titled
     sysfs oops workaround
has been removed from the -mm tree.  Its filename was
     sysfs-oops-workaround.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: sysfs oops workaround
From: Tejun Heo <htejun@gmail.com>

Okay, here's the workaround.  It leaks dentries and inodes if parent
is deleted first but other than that it should be okay.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/inode.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN fs/sysfs/inode.c~sysfs-oops-workaround fs/sysfs/inode.c
--- a/fs/sysfs/inode.c~sysfs-oops-workaround
+++ a/fs/sysfs/inode.c
@@ -212,8 +212,11 @@ static struct dentry *sysfs_lookup_sd(st
 	depth = sysfs_path_depth(sd);
 
 	while (depth--) {
-		/* negative intermediate node is a BUG */
-		BUG_ON(!dentry->d_inode);
+		/* XXX */ /* negative intermediate node is a BUG */
+		/* XXX */ /* BUG_ON(!dentry->d_inode); */
+		if (!dentry->d_inode)
+			return NULL;
+		/* XXX */
 
 		for (cur = sd, i = 0; i < depth; i++)
 			cur = cur->s_parent;
@@ -269,7 +272,7 @@ void sysfs_drop_dentry(struct sysfs_dire
 	}
 
 	if (isdir) {
-		BUG_ON(!simple_empty(dentry));
+		/* XXX */ /* BUG_ON(!simple_empty(dentry)); */
 		drop_nlink(dir);
 		/* unpin if directory */
 		dput(dentry);
_

Patches currently in -mm which might be from htejun@gmail.com are

origin.patch
idr-fix-obscure-bug-in-allocation-path.patch
idr-separate-out-idr_mark_full.patch
ida-implement-idr-based-id-allocator.patch
sysfs-oops-workaround.patch
even-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
even-even-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
security-prevent-permission-checking-of-file-removal-via-sysfs_remove_group.patch
git-libata-all.patch
ahci-crash-fix.patch
ata-printk-warning-fixes.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
optional-led-trigger-for-libata.patch
drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
ata_timing-ensure-t-cycle-is-always-correct.patch
drivers-ata-remove-the-wildcard-from-sata_nv-driver.patch
git-scsi-misc.patch
introduce-config_has_dma.patch
fix-wrong-identifier-name-in-documentation-driver-model-devrestxt.patch
