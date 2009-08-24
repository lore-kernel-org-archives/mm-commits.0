From: akpm@linux-foundation.org
Subject: + fs-remove-unneeded-dcache_unhashed-tricks.patch added to -mm tree
Date: Mon, 24 Aug 2009 14:56:26 -0700
Message-ID: <200908242156.n7OLuQx2020553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45253 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752927AbZHXV4p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Aug 2009 17:56:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, davem@davemloft.net, davidel@xmailserver.org, hch@lst.de, jens.axboe@oracle.com, mszeredi@suse.cz, viro@zeniv.linux.org.uk


The patch titled
     fs: remove unneeded DCACHE_UNHASHED tricks
has been added to the -mm tree.  Its filename is
     fs-remove-unneeded-dcache_unhashed-tricks.patch

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
Subject: fs: remove unneeded DCACHE_UNHASHED tricks
From: Nick Piggin <npiggin@suse.de>

Filesystems outside the regular namespace do not have to clear
DCACHE_UNHASHED in order to have a working /proc/$pid/fd/XXX.  Nothing in
proc prevents the fd link from being used if its dentry is not in the
hash.

Also, it does not get put into the dcache hash if DCACHE_UNHASHED is
clear; that depends on the filesystem calling d_add or d_rehash.

So delete the misleading comments and needless code.

Acked-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/anon_inodes.c |   16 ----------------
 fs/pipe.c        |   18 ------------------
 net/socket.c     |   19 -------------------
 3 files changed, 53 deletions(-)

diff -puN fs/anon_inodes.c~fs-remove-unneeded-dcache_unhashed-tricks fs/anon_inodes.c
--- a/fs/anon_inodes.c~fs-remove-unneeded-dcache_unhashed-tricks
+++ a/fs/anon_inodes.c
@@ -33,24 +33,11 @@ static int anon_inodefs_get_sb(struct fi
 			     mnt);
 }
 
-static int anon_inodefs_delete_dentry(struct dentry *dentry)
-{
-	/*
-	 * We faked vfs to believe the dentry was hashed when we created it.
-	 * Now we restore the flag so that dput() will work correctly.
-	 */
-	dentry->d_flags |= DCACHE_UNHASHED;
-	return 1;
-}
-
 static struct file_system_type anon_inode_fs_type = {
 	.name		= "anon_inodefs",
 	.get_sb		= anon_inodefs_get_sb,
 	.kill_sb	= kill_anon_super,
 };
-static const struct dentry_operations anon_inodefs_dentry_operations = {
-	.d_delete	= anon_inodefs_delete_dentry,
-};
 
 /*
  * nop .set_page_dirty method so that people can use .page_mkwrite on
@@ -119,9 +106,6 @@ int anon_inode_getfd(const char *name, c
 	 */
 	atomic_inc(&anon_inode_inode->i_count);
 
-	dentry->d_op = &anon_inodefs_dentry_operations;
-	/* Do not publish this dentry inside the global dentry hash table */
-	dentry->d_flags &= ~DCACHE_UNHASHED;
 	d_instantiate(dentry, anon_inode_inode);
 
 	error = -ENFILE;
diff -puN fs/pipe.c~fs-remove-unneeded-dcache_unhashed-tricks fs/pipe.c
--- a/fs/pipe.c~fs-remove-unneeded-dcache_unhashed-tricks
+++ a/fs/pipe.c
@@ -887,17 +887,6 @@ void free_pipe_info(struct inode *inode)
 }
 
 static struct vfsmount *pipe_mnt __read_mostly;
-static int pipefs_delete_dentry(struct dentry *dentry)
-{
-	/*
-	 * At creation time, we pretended this dentry was hashed
-	 * (by clearing DCACHE_UNHASHED bit in d_flags)
-	 * At delete time, we restore the truth : not hashed.
-	 * (so that dput() can proceed correctly)
-	 */
-	dentry->d_flags |= DCACHE_UNHASHED;
-	return 0;
-}
 
 /*
  * pipefs_dname() is called from d_path().
@@ -909,7 +898,6 @@ static char *pipefs_dname(struct dentry 
 }
 
 static const struct dentry_operations pipefs_dentry_operations = {
-	.d_delete	= pipefs_delete_dentry,
 	.d_dname	= pipefs_dname,
 };
 
@@ -969,12 +957,6 @@ struct file *create_write_pipe(int flags
 		goto err_inode;
 
 	dentry->d_op = &pipefs_dentry_operations;
-	/*
-	 * We dont want to publish this dentry into global dentry hash table.
-	 * We pretend dentry is already hashed, by unsetting DCACHE_UNHASHED
-	 * This permits a working /proc/$pid/fd/XXX on pipes
-	 */
-	dentry->d_flags &= ~DCACHE_UNHASHED;
 	d_instantiate(dentry, inode);
 
 	err = -ENFILE;
diff -puN net/socket.c~fs-remove-unneeded-dcache_unhashed-tricks net/socket.c
--- a/net/socket.c~fs-remove-unneeded-dcache_unhashed-tricks
+++ a/net/socket.c
@@ -307,18 +307,6 @@ static struct file_system_type sock_fs_t
 	.kill_sb =	kill_anon_super,
 };
 
-static int sockfs_delete_dentry(struct dentry *dentry)
-{
-	/*
-	 * At creation time, we pretended this dentry was hashed
-	 * (by clearing DCACHE_UNHASHED bit in d_flags)
-	 * At delete time, we restore the truth : not hashed.
-	 * (so that dput() can proceed correctly)
-	 */
-	dentry->d_flags |= DCACHE_UNHASHED;
-	return 0;
-}
-
 /*
  * sockfs_dname() is called from d_path().
  */
@@ -329,7 +317,6 @@ static char *sockfs_dname(struct dentry 
 }
 
 static const struct dentry_operations sockfs_dentry_operations = {
-	.d_delete = sockfs_delete_dentry,
 	.d_dname  = sockfs_dname,
 };
 
@@ -378,12 +365,6 @@ static int sock_attach_fd(struct socket 
 		return -ENOMEM;
 
 	dentry->d_op = &sockfs_dentry_operations;
-	/*
-	 * We dont want to push this dentry into global dentry hash table.
-	 * We pretend dentry is already hashed, by unsetting DCACHE_UNHASHED
-	 * This permits a working /proc/$pid/fd/XXX on sockets
-	 */
-	dentry->d_flags &= ~DCACHE_UNHASHED;
 	d_instantiate(dentry, SOCK_INODE(sock));
 
 	sock->file = file;
_

Patches currently in -mm which might be from npiggin@suse.de are

linux-next.patch
fs-remove-unneeded-dcache_unhashed-tricks.patch
fs-new-truncate-helpers.patch
fs-use-new-truncate-helpers.patch
fs-introduce-new-truncate-sequence.patch
fs-convert-simple-fs-to-new-truncate.patch
tmpfs-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention-fix.patch
fat-convert-to-use-the-new-truncate-convention.patch
btrfs-convert-to-use-the-new-truncate-convention.patch
jfs-convert-to-use-the-new-truncate-convention.patch
udf-convert-to-use-the-new-truncate-convention.patch
minix-convert-to-use-the-new-truncate-convention.patch
ksm-no-debug-in-page_dup_rmap.patch
fs-turn-iprune_mutex-into-rwsem.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

