From: akpm@linux-foundation.org
Subject: + sysfs-oops-workaround.patch added to -mm tree
Date: Tue, 24 Apr 2007 13:21:06 -0700
Message-ID: <200704242021.l3OKL6kR018389@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59609 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754057AbXDXUVJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Apr 2007 16:21:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: htejun@gmail.com


The patch titled
     sysfs oops workaround
has been added to the -mm tree.  Its filename is
     sysfs-oops-workaround.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

even-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
even-even-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
security-prevent-permission-checking-of-file-removal-via-sysfs_remove_group.patch
git-libata-all.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
optional-led-trigger-for-libata.patch
drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
git-scsi-misc.patch
introduce-config_has_dma.patch
sysfs-oops-workaround.patch
