From: akpm@linux-foundation.org
Subject: - uml-hostfs-make-hostfs=-option-work-as-a-jail-as-intended.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:55:59 -0800
Message-ID: <200703152155.l2FLtxOB027510@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42217 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427AbXCOV4D (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:56:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: blaisorblade@yahoo.it, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     uml: hostfs: make hostfs= option work as a jail, as intended.
has been removed from the -mm tree.  Its filename was
     uml-hostfs-make-hostfs=-option-work-as-a-jail-as-intended.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: hostfs: make hostfs= option work as a jail, as intended.
From: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>

When a given host directory is specified to be mounted both in hostfs=path1
and with mount option -o path2, we should give access to path1/path2, but this
does not happen.  Fix that in the simpler way.

Also, root_ino can be the empty string, since we use %s/%s as format.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Acked-by: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hostfs/hostfs_kern.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN fs/hostfs/hostfs_kern.c~uml-hostfs-make-hostfs=-option-work-as-a-jail-as-intended fs/hostfs/hostfs_kern.c
--- a/fs/hostfs/hostfs_kern.c~uml-hostfs-make-hostfs=-option-work-as-a-jail-as-intended
+++ a/fs/hostfs/hostfs_kern.c
@@ -47,7 +47,7 @@ struct dentry_operations hostfs_dentry_o
 };
 
 /* Changed in hostfs_args before the kernel starts running */
-static char *root_ino = "/";
+static char *root_ino = "";
 static int append = 0;
 
 #define HOSTFS_SUPER_MAGIC 0x00c0ffee
@@ -947,15 +947,17 @@ static int hostfs_fill_sb_common(struct 
 	sb->s_magic = HOSTFS_SUPER_MAGIC;
 	sb->s_op = &hostfs_sbops;
 
-	if((data == NULL) || (*data == '\0'))
-		data = root_ino;
+	/* NULL is printed as <NULL> by sprintf: avoid that. */
+	if (data == NULL)
+		data = "";
 
 	err = -ENOMEM;
-	name = kmalloc(strlen(data) + 1, GFP_KERNEL);
+	name = kmalloc(strlen(root_ino) + 1
+			+ strlen(data) + 1, GFP_KERNEL);
 	if(name == NULL)
 		goto out;
 
-	strcpy(name, data);
+	sprintf(name, "%s/%s", root_ino, data);
 
 	root_inode = iget(sb, 0);
 	if(root_inode == NULL)
_

Patches currently in -mm which might be from blaisorblade@yahoo.it are

origin.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
uml-fix-prototypes.patch
git-gccbug.patch
