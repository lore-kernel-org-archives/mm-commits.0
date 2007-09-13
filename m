From: akpm@linux-foundation.org
Subject: - fs-cramfs-inodec-remove-error-variable.patch removed from -mm tree
Date: Wed, 12 Sep 2007 19:31:55 -0700
Message-ID: <200709130231.l8D2VtpG030503@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55875 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757285AbXIMCcK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Sep 2007 22:32:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lists-receive@programmierforen.de, mm-commits@vger.kernel.org


The patch titled
     fs/cramfs/inode.c: remove error variable
has been removed from the -mm tree.  Its filename was
     fs-cramfs-inodec-remove-error-variable.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
Subject: fs/cramfs/inode.c: remove error variable
From: Andi Drebes <lists-receive@programmierforen.de>

Remove a variable from fs/cramfs/inode.c that is just used to store a return
value which is immediately read afterwards.

Tested on an i386 box.
Signed-off-by: Andi Drebes <lists-receive@programmierforen.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cramfs/inode.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/cramfs/inode.c~fs-cramfs-inodec-remove-error-variable fs/cramfs/inode.c
--- a/fs/cramfs/inode.c~fs-cramfs-inodec-remove-error-variable
+++ a/fs/cramfs/inode.c
@@ -372,7 +372,7 @@ static int cramfs_readdir(struct file *f
 		char *name;
 		ino_t ino;
 		mode_t mode;
-		int namelen, error;
+		int namelen;
 
 		mutex_lock(&read_mutex);
 		de = cramfs_read(sb, OFFSET(inode) + offset, sizeof(*de)+CRAMFS_MAXPATHLEN);
@@ -398,8 +398,7 @@ static int cramfs_readdir(struct file *f
 				break;
 			namelen--;
 		}
-		error = filldir(dirent, buf, namelen, offset, ino, mode >> 12);
-		if (error)
+		if (filldir(dirent, buf, namelen, offset, ino, mode >> 12))
 			break;
 
 		offset = nextoffset;
_

Patches currently in -mm which might be from lists-receive@programmierforen.de are

git-dvb.patch
cramfs-error-message-about-endianess.patch
fs-cramfs-inodec-remove-unused-variable.patch
fs-cramfs-inodec-replace-hardcoded-value-with-preprocessor-constant.patch
fs-cramfs-inodec-remove-error-variable.patch
