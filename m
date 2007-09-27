From: akpm@linux-foundation.org
Subject: - anon_inodesc-fix-error-check-in-anon_inode_getfd.patch removed from -mm tree
Date: Thu, 27 Sep 2007 11:37:26 -0700
Message-ID: <200709271837.l8RIbQEW019407@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39092 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756294AbXI0SiC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Sep 2007 14:38:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yanzheng@21cn.com, davidel@xmailserver.org, mm-commits@vger.kernel.org


The patch titled
     anon_inodes.c: fix error check in anon_inode_getfd
has been removed from the -mm tree.  Its filename was
     anon_inodesc-fix-error-check-in-anon_inode_getfd.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: anon_inodes.c: fix error check in anon_inode_getfd
From: "Yan Zheng" <yanzheng@21cn.com>

Hello,

igrab return NULL on error.

Signed-off-by: Yan Zheng <yanzheng@21cn.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/anon_inodes.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/anon_inodes.c~anon_inodesc-fix-error-check-in-anon_inode_getfd fs/anon_inodes.c
--- a/fs/anon_inodes.c~anon_inodesc-fix-error-check-in-anon_inode_getfd
+++ a/fs/anon_inodes.c
@@ -87,8 +87,8 @@ int anon_inode_getfd(int *pfd, struct in
 		return -ENFILE;
 
 	inode = igrab(anon_inode_inode);
-	if (IS_ERR(inode)) {
-		error = PTR_ERR(inode);
+	if (!inode) {
+		error = -ENOENT;
 		goto err_put_filp;
 	}
 
_

Patches currently in -mm which might be from yanzheng@21cn.com are

anon_inodesc-fix-error-check-in-anon_inode_getfd.patch
