From: akpm@linux-foundation.org
Subject: [merged] vfs-remove-extraneous-null-d_inode-check-from-do_filp_open.patch removed from -mm tree
Date: Thu, 17 Dec 2009 12:39:45 -0800
Message-ID: <200912172039.nBHKdjjQ017540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764572AbZLQUkO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Dec 2009 15:40:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, hch@lst.de, mszeredi@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: remove extraneous NULL d_inode check from do_filp_open
has been removed from the -mm tree.  Its filename was
     vfs-remove-extraneous-null-d_inode-check-from-do_filp_open.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: remove extraneous NULL d_inode check from do_filp_open
From: Jeff Layton <jlayton@redhat.com>

We can't get to this point unless it's a valid pointer.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Acked-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/namei.c~vfs-remove-extraneous-null-d_inode-check-from-do_filp_open fs/namei.c
--- a/fs/namei.c~vfs-remove-extraneous-null-d_inode-check-from-do_filp_open
+++ a/fs/namei.c
@@ -1796,7 +1796,7 @@ do_last:
 
 	path_to_nameidata(&path, &nd);
 	error = -EISDIR;
-	if (path.dentry->d_inode && S_ISDIR(path.dentry->d_inode->i_mode))
+	if (S_ISDIR(path.dentry->d_inode->i_mode))
 		goto exit;
 ok:
 	/*
_

Patches currently in -mm which might be from jlayton@redhat.com are

origin.patch
linux-next.patch

