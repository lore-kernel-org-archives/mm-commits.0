From: akpm@linux-foundation.org
Subject: [merged] fs-anon_inodes-implement-dname.patch removed from -mm tree
Date: Thu, 17 Dec 2009 12:39:33 -0800
Message-ID: <200912172039.nBHKdYkc017534@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764208AbZLQUjx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Dec 2009 15:39:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, davem@davemloft.net, davidel@xmailserver.org, hch@lst.de, jens.axboe@oracle.com, mszeredi@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fs: anon_inodes implement dname
has been removed from the -mm tree.  Its filename was
     fs-anon_inodes-implement-dname.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: anon_inodes implement dname
From: Nick Piggin <npiggin@suse.de>

Add a d_dname method for anon_inodes filesystem, the same way pipefs and
sockfs pseudo filesystems.  This allows us to remove the DCACHE_UNHASHED
hack from anon_inodes.c (see next patch).

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/anon_inodes.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN fs/anon_inodes.c~fs-anon_inodes-implement-dname fs/anon_inodes.c
--- a/fs/anon_inodes.c~fs-anon_inodes-implement-dname
+++ a/fs/anon_inodes.c
@@ -45,6 +45,15 @@ static int anon_inodefs_delete_dentry(st
 	return 1;
 }
 
+/*
+ * anon_inodefs_dname() is called from d_path().
+ */
+static char *anon_inodefs_dname(struct dentry *dentry, char *buffer, int buflen)
+{
+	return dynamic_dname(dentry, buffer, buflen, "anon_inode:%s",
+				dentry->d_name.name, dentry->d_inode->i_ino);
+}
+
 static struct file_system_type anon_inode_fs_type = {
 	.name		= "anon_inodefs",
 	.get_sb		= anon_inodefs_get_sb,
@@ -52,6 +61,7 @@ static struct file_system_type anon_inod
 };
 static const struct dentry_operations anon_inodefs_dentry_operations = {
 	.d_delete	= anon_inodefs_delete_dentry,
+	.d_dname	= anon_inodefs_dname,
 };
 
 /*
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
fs-improve-remountro-vs-buffercache-coherency.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

