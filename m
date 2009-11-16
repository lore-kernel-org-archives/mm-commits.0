From: akpm@linux-foundation.org
Subject: + vfs-remove-extraneous-null-d_inode-check-from-do_filp_open.patch added to -mm tree
Date: Mon, 16 Nov 2009 12:05:20 -0800
Message-ID: <200911162005.nAGK5KGw030337@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753884AbZKPUGJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Nov 2009 15:06:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlayton@redhat.com, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     vfs: remove extraneous NULL d_inode check from do_filp_open
has been added to the -mm tree.  Its filename is
     vfs-remove-extraneous-null-d_inode-check-from-do_filp_open.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: remove extraneous NULL d_inode check from do_filp_open
From: Jeff Layton <jlayton@redhat.com>

We can't get to this point unless it's a valid pointer.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/namei.c~vfs-remove-extraneous-null-d_inode-check-from-do_filp_open fs/namei.c
--- a/fs/namei.c~vfs-remove-extraneous-null-d_inode-check-from-do_filp_open
+++ a/fs/namei.c
@@ -1818,7 +1818,7 @@ do_last:
 
 	path_to_nameidata(&path, &nd);
 	error = -EISDIR;
-	if (path.dentry->d_inode && S_ISDIR(path.dentry->d_inode->i_mode))
+	if (S_ISDIR(path.dentry->d_inode->i_mode))
 		goto exit;
 ok:
 	/*
_

Patches currently in -mm which might be from jlayton@redhat.com are

vfs-remove-extraneous-null-d_inode-check-from-do_filp_open.patch

