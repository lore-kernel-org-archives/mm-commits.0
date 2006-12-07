From: akpm@osdl.org
Subject: - dont-insert-pipe-dentries-into-dentry_hashtable.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:06:55 -0800
Message-ID: <200612072306.kB7N6tvu030321@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52758 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163939AbWLGXHY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:07:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dada1@cosmosbay.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     don't insert pipe dentries into dentry_hashtable.
has been removed from the -mm tree.  Its filename was
     dont-insert-pipe-dentries-into-dentry_hashtable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: don't insert pipe dentries into dentry_hashtable.
From: Eric Dumazet <dada1@cosmosbay.com>

We currently insert pipe dentries into the global dentry hashtable.  This
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
  pipe code, so that dput() can just kill_it.

This patch, combined with (avoid RCU for never hashed dentries) reduced
time of { pipe(p); close(p[0]); close(p[1]);} on my UP machine (1.6GHz
Pentium-M) from 3.23 us to 2.86 us (But this patch does not depend on other
patches, only bench results)

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Acked-by: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/pipe.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff -puN fs/pipe.c~dont-insert-pipe-dentries-into-dentry_hashtable fs/pipe.c
--- a/fs/pipe.c~dont-insert-pipe-dentries-into-dentry_hashtable
+++ a/fs/pipe.c
@@ -830,7 +830,14 @@ void free_pipe_info(struct inode *inode)
 static struct vfsmount *pipe_mnt __read_mostly;
 static int pipefs_delete_dentry(struct dentry *dentry)
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
 
 static struct dentry_operations pipefs_dentry_operations = {
@@ -891,17 +898,22 @@ struct file *create_write_pipe(void)
 	if (!inode)
 		goto err_file;
 
-	sprintf(name, "[%lu]", inode->i_ino);
+	this.len = sprintf(name, "[%lu]", inode->i_ino);
 	this.name = name;
-	this.len = strlen(name);
-	this.hash = inode->i_ino; /* will go */
+	this.hash = 0;
 	err = -ENOMEM;
 	dentry = d_alloc(pipe_mnt->mnt_sb->s_root, &this);
 	if (!dentry)
 		goto err_inode;
 
 	dentry->d_op = &pipefs_dentry_operations;
-	d_add(dentry, inode);
+	/*
+	 * We dont want to publish this dentry into global dentry hash table.
+	 * We pretend dentry is already hashed, by unsetting DCACHE_UNHASHED
+	 * This permits a working /proc/$pid/fd/XXX on pipes
+	 */
+	dentry->d_flags &= ~DCACHE_UNHASHED;
+	d_instantiate(dentry, inode);
 	f->f_vfsmnt = mntget(pipe_mnt);
 	f->f_dentry = dentry;
 	f->f_mapping = inode->i_mapping;
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

origin.patch
convert-i386-pda-code-to-use-%fs.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks.patch

