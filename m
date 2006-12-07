From: akpm@osdl.org
Subject: - net-dont-insert-socket-dentries-into-dentry_hashtable.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:07:01 -0800
Message-ID: <200612072307.kB7N71Wc030327@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52775 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163939AbWLGXH3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:07:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dada1@cosmosbay.com, davem@davemloft.net, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     net: don't insert socket dentries into dentry_hashtable
has been removed from the -mm tree.  Its filename was
     net-dont-insert-socket-dentries-into-dentry_hashtable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: net: don't insert socket dentries into dentry_hashtable
From: Eric Dumazet <dada1@cosmosbay.com>

We currently insert socket dentries into the global dentry hashtable.  This
is suboptimal because there is currently no way these entries can be used
for a lookup().  (/proc/xxx/fd/xxx uses a different mechanism).  Inserting
them in dentry hashtable slows dcache lookups.

To let __dpath() still work correctly (ie not adding a " (deleted)") after
dentry name, we do :

- Right after d_alloc(), pretend they are hashed by clearing the
  DCACHE_UNHASHED bit.

- Call d_instantiate() instead of d_add() : dentry is not inserted in
  hash table.

  __dpath() & friends work as intended during dentry lifetime.

- At dismantle time, once dput() must clear the dentry, setting again
  DCACHE_UNHASHED bit inside the custom d_delete() function provided by
  socket code, so that dput() can just kill_it.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 net/socket.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff -puN net/socket.c~net-dont-insert-socket-dentries-into-dentry_hashtable net/socket.c
--- a/net/socket.c~net-dont-insert-socket-dentries-into-dentry_hashtable
+++ a/net/socket.c
@@ -305,7 +305,14 @@ static struct file_system_type sock_fs_t
 
 static int sockfs_delete_dentry(struct dentry *dentry)
 {
-	return 1;
+	/*
+	 * At creation time, we pretended this dentry was hashed
+	 * (by clearing DCACHE_UNHASHED bit in d_flags)
+	 * At delete time, we restore the truth : not hashed.
+	 * (so that dput() can proceed correctly)
+	 */
+	dentry->d_flags |= DCACHE_UNHASHED;
+	return 0;
 }
 static struct dentry_operations sockfs_dentry_operations = {
 	.d_delete = sockfs_delete_dentry,
@@ -353,14 +360,20 @@ static int sock_attach_fd(struct socket 
 
 	this.len = sprintf(name, "[%lu]", SOCK_INODE(sock)->i_ino);
 	this.name = name;
-	this.hash = SOCK_INODE(sock)->i_ino;
+	this.hash = 0;
 
 	file->f_dentry = d_alloc(sock_mnt->mnt_sb->s_root, &this);
 	if (unlikely(!file->f_dentry))
 		return -ENOMEM;
 
 	file->f_dentry->d_op = &sockfs_dentry_operations;
-	d_add(file->f_dentry, SOCK_INODE(sock));
+	/*
+	 * We dont want to push this dentry into global dentry hash table.
+	 * We pretend dentry is already hashed, by unsetting DCACHE_UNHASHED
+	 * This permits a working /proc/$pid/fd/XXX on sockets
+	 */
+	file->f_dentry->d_flags &= ~DCACHE_UNHASHED;
+	d_instantiate(file->f_dentry, SOCK_INODE(sock));
 	file->f_vfsmnt = mntget(sock_mnt);
 	file->f_mapping = file->f_dentry->d_inode->i_mapping;
 
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

origin.patch
convert-i386-pda-code-to-use-%fs.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks.patch

