From: akpm@linux-foundation.org
Subject: - fs-cramfs-inodec-replace-hardcoded-value-with-preprocessor-constant.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:45:35 -0700
Message-ID: <200710190345.l9J3jZBo013233@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56467 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750703AbXJSDzO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lists-receive@programmierforen.de, mm-commits@vger.kernel.org


The patch titled
     fs/cramfs/inode.c: replace hardcoded value with preprocessor constant
has been removed from the -mm tree.  Its filename was
     fs-cramfs-inodec-replace-hardcoded-value-with-preprocessor-constant.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs/cramfs/inode.c: replace hardcoded value with preprocessor constant
From: Andi Drebes <lists-receive@programmierforen.de>

Remove the hardcoded value 256 in fs/cramfs/inode.c and replaces it with
CRAMFS_MAXPATHLEN.

Tested on an i386 box.
Signed-off-by: Andi Drebes <lists-receive@programmierforen.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cramfs/inode.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/cramfs/inode.c~fs-cramfs-inodec-replace-hardcoded-value-with-preprocessor-constant fs/cramfs/inode.c
--- a/fs/cramfs/inode.c~fs-cramfs-inodec-replace-hardcoded-value-with-preprocessor-constant
+++ a/fs/cramfs/inode.c
@@ -361,7 +361,7 @@ static int cramfs_readdir(struct file *f
 	if (offset & 3)
 		return -EINVAL;
 
-	buf = kmalloc(256, GFP_KERNEL);
+	buf = kmalloc(CRAMFS_MAXPATHLEN, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
@@ -375,7 +375,7 @@ static int cramfs_readdir(struct file *f
 		int namelen, error;
 
 		mutex_lock(&read_mutex);
-		de = cramfs_read(sb, OFFSET(inode) + offset, sizeof(*de)+256);
+		de = cramfs_read(sb, OFFSET(inode) + offset, sizeof(*de)+CRAMFS_MAXPATHLEN);
 		name = (char *)(de+1);
 
 		/*
@@ -425,7 +425,7 @@ static struct dentry * cramfs_lookup(str
 		char *name;
 		int namelen, retval;
 
-		de = cramfs_read(dir->i_sb, OFFSET(dir) + offset, sizeof(*de)+256);
+		de = cramfs_read(dir->i_sb, OFFSET(dir) + offset, sizeof(*de)+CRAMFS_MAXPATHLEN);
 		name = (char *)(de+1);
 
 		/* Try to take advantage of sorted directories */
_

Patches currently in -mm which might be from lists-receive@programmierforen.de are

origin.patch
