From: akpm@linux-foundation.org
Subject: - vfs-dcache-cleanups.patch removed from -mm tree
Date: Sat, 31 May 2008 00:42:55 -0700
Message-ID: <200805310742.m4V7gth2000947@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36505 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751435AbYEaHr1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 31 May 2008 03:47:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, hch@lst.de, viro@zeniv.linux.org.uk, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     vfs: dcache cleanups
has been removed from the -mm tree.  Its filename was
     vfs-dcache-cleanups.patch

This patch was dropped because it's more controversial than was first thought, and it was sent off-list

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: dcache cleanups
From: Miklos Szeredi <mszeredi@suse.cz>

d_path() cleanups and fix the following sparse warnings:

fs/dcache.c:2183:19: warning: symbol 'filp_cachep' was not declared. Should it be static?
fs/dcache.c:115:3: warning: context imbalance in 'dentry_iput' - unexpected unlock
fs/dcache.c:188:2: warning: context imbalance in 'dput' - different lock contexts for basic block
fs/dcache.c:400:2: warning: context imbalance in 'prune_one_dentry' - different lock contexts for basic block
fs/dcache.c:431:22: warning: context imbalance in 'prune_dcache' - different lock contexts for basic block
fs/dcache.c:563:2: warning: context imbalance in 'shrink_dcache_sb' - different lock contexts for basic block
fs/dcache.c:1385:6: warning: context imbalance in 'd_delete' - wrong count at exit
fs/dcache.c:1636:2: warning: context imbalance in '__d_unalias' - unexpected unlock
fs/dcache.c:1735:2: warning: context imbalance in 'd_materialise_unique' - different lock contexts for basic block

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |   51 ++++++++++++++++++++++++--------------------------
 1 file changed, 25 insertions(+), 26 deletions(-)

diff -puN fs/dcache.c~vfs-dcache-cleanups fs/dcache.c
--- a/fs/dcache.c~vfs-dcache-cleanups
+++ a/fs/dcache.c
@@ -17,6 +17,7 @@
 #include <linux/syscalls.h>
 #include <linux/string.h>
 #include <linux/mm.h>
+#include <linux/fdtable.h>
 #include <linux/fs.h>
 #include <linux/fsnotify.h>
 #include <linux/slab.h>
@@ -97,9 +98,10 @@ static void d_free(struct dentry *dentry
 /*
  * Release the dentry's inode, using the filesystem
  * d_iput() operation if defined.
- * Called with dcache_lock and per dentry lock held, drops both.
  */
 static void dentry_iput(struct dentry * dentry)
+	__releases(dentry->d_lock)
+	__releases(dcache_lock)
 {
 	struct inode *inode = dentry->d_inode;
 	if (inode) {
@@ -158,12 +160,13 @@ static void dentry_lru_del_init(struct d
  * d_kill - kill dentry and return parent
  * @dentry: dentry to kill
  *
- * Called with dcache_lock and d_lock, releases both.  The dentry must
- * already be unhashed and removed from the LRU.
+ * The dentry must already be unhashed and removed from the LRU.
  *
  * If this is the root of the dentry tree, return NULL.
  */
 static struct dentry *d_kill(struct dentry *dentry)
+	__releases(dentry->d_lock)
+	__releases(dcache_lock)
 {
 	struct dentry *parent;
 
@@ -410,11 +413,11 @@ restart:
  * Try to prune ancestors as well.  This is necessary to prevent
  * quadratic behavior of shrink_dcache_parent(), but is also expected
  * to be beneficial in reducing dentry cache fragmentation.
- *
- * Called with dcache_lock, drops it and then regains.
- * Called with dentry->d_lock held, drops it.
  */
 static void prune_one_dentry(struct dentry * dentry)
+	__releases(dentry->d_lock)
+	__releases(dcache_lock)
+	__acquires(dcache_lock)
 {
 	__d_drop(dentry);
 	dentry = d_kill(dentry);
@@ -1731,10 +1734,9 @@ static int d_isparent(struct dentry *p1,
  *
  * Note: If ever the locking in lock_rename() changes, then please
  * remember to update this too...
- *
- * On return, dcache_lock will have been unlocked.
  */
 static struct dentry *__d_unalias(struct dentry *dentry, struct dentry *alias)
+	__releases(dcache_lock)
 {
 	struct mutex *m1 = NULL, *m2 = NULL;
 	struct dentry *ret;
@@ -1870,7 +1872,6 @@ out_nolock:
 shouldnt_be_hashed:
 	spin_unlock(&dcache_lock);
 	BUG();
-	goto shouldnt_be_hashed;
 }
 
 static int prepend(char **buffer, int *buflen, const char *str,
@@ -1885,7 +1886,7 @@ static int prepend(char **buffer, int *b
 }
 
 /**
- * d_path - return the path of a dentry
+ * __d_path - return the path of a dentry
  * @path: the dentry/vfsmount to report
  * @root: root vfsmnt/dentry (may be modified by this function)
  * @buffer: buffer to return value in
@@ -1906,8 +1907,9 @@ char *__d_path(const struct path *path, 
 {
 	struct dentry *dentry = path->dentry;
 	struct vfsmount *vfsmnt = path->mnt;
-	char * end = buffer+buflen;
-	char * retval;
+	char *end = buffer + buflen;
+	char *retval;
+	struct qstr *name;
 
 	prepend(&end, &buflen, "\0", 1);
 	if (!IS_ROOT(dentry) && d_unhashed(dentry) &&
@@ -1939,8 +1941,8 @@ char *__d_path(const struct path *path, 
 		}
 		parent = dentry->d_parent;
 		prefetch(parent);
-		if ((prepend(&end, &buflen, dentry->d_name.name,
-				dentry->d_name.len) != 0) ||
+		name = &dentry->d_name;
+		if ((prepend(&end, &buflen, name->name, name->len) != 0) ||
 		    (prepend(&end, &buflen, "/", 1) != 0))
 			goto Elong;
 		retval = end;
@@ -1951,8 +1953,8 @@ char *__d_path(const struct path *path, 
 
 global_root:
 	retval += 1;	/* hit the slash */
-	if (prepend(&retval, &buflen, dentry->d_name.name,
-		    dentry->d_name.len) != 0)
+	name = &dentry->d_name;
+	if (prepend(&retval, &buflen, name->name, name->len) != 0)
 		goto Elong;
 	root->mnt = vfsmnt;
 	root->dentry = dentry;
@@ -1972,7 +1974,7 @@ Elong:
  *
  * Returns the buffer or an error code if the path was too long.
  *
- * "buflen" should be positive. Caller holds the dcache_lock.
+ * "buflen" should be positive.
  */
 char *d_path(const struct path *path, char *buf, int buflen)
 {
@@ -2042,16 +2044,13 @@ char *dentry_path(struct dentry *dentry,
 	retval = end-1;
 	*retval = '/';
 
-	for (;;) {
-		struct dentry *parent;
-		if (IS_ROOT(dentry))
-			break;
+	while (!IS_ROOT(dentry)) {
+		struct dentry *parent = dentry->d_parent;
+		struct qstr *name;
 
-		parent = dentry->d_parent;
 		prefetch(parent);
-
-		if ((prepend(&end, &buflen, dentry->d_name.name,
-				dentry->d_name.len) != 0) ||
+		name = &dentry->d_name;
+		if ((prepend(&end, &buflen, name->name, name->len) != 0) ||
 		    (prepend(&end, &buflen, "/", 1) != 0))
 			goto Elong;
 
@@ -2102,7 +2101,7 @@ asmlinkage long sys_getcwd(char __user *
 	error = -ENOENT;
 	/* Has the current directory has been unlinked? */
 	spin_lock(&dcache_lock);
-	if (pwd.dentry->d_parent == pwd.dentry || !d_unhashed(pwd.dentry)) {
+	if (IS_ROOT(pwd.dentry) || !d_unhashed(pwd.dentry)) {
 		unsigned long len;
 		struct path tmp = root;
 		char * cwd;
_

Patches currently in -mm which might be from mszeredi@suse.cz are

vfs-dcache-cleanups.patch
vfs-fix-sys_getcwd-for-detached-mounts.patch
git-unprivileged-mounts.patch
lockd-dont-return-eagain-for-a-permanent-error.patch
locks-add-special-return-value-for-asynchronous-locks.patch
locks-cleanup-code-duplication.patch
locks-allow-lock-to-return-file_lock_deferred.patch
fuse-prepare-lookup-for-nfs-export.patch
fuse-add-export-operations.patch
fuse-add-fuse_lookup_name-helper.patch
fuse-nfs-export-special-lookups.patch
fuse-lockd-support.patch

