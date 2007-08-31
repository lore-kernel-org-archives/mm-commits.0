From: akpm@linux-foundation.org
Subject: + fs-cramfs-inodec-replace-hardcoded-value-with-preprocessor-constant.patch added to -mm tree
Date: Fri, 31 Aug 2007 12:52:03 -0700
Message-ID: <200708311952.l7VJq3Mp023819@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56258 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752118AbXHaTwR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 15:52:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lists-receive@programmierforen.de


The patch titled
     fs/cramfs/inode.c: replace hardcoded value with preprocessor constant
has been added to the -mm tree.  Its filename is
     fs-cramfs-inodec-replace-hardcoded-value-with-preprocessor-constant.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 3 insertions(+), 3 deletions(-)

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

git-dvb.patch
cramfs-error-message-about-endianess.patch
fs-cramfs-inodec-remove-unused-variable.patch
fs-cramfs-inodec-replace-hardcoded-value-with-preprocessor-constant.patch
fs-cramfs-inodec-remove-error-variable.patch
