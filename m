From: akpm@linux-foundation.org
Subject: - unionfs-fix-slab-abuses-with-krealloc.patch removed from -mm tree
Date: Tue, 15 May 2007 01:49:59 -0700
Message-ID: <200705150849.l4F8nwPO005552@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35955 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759647AbXEOIuJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 04:50:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@cs.helsinki.fi, jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     unionfs: fix slab abuses with krealloc
has been removed from the -mm tree.  Its filename was
     unionfs-fix-slab-abuses-with-krealloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: unionfs: fix slab abuses with krealloc
From: Pekka Enberg <penberg@cs.helsinki.fi>

This changes unionfs to use krealloc() for reallocating memory so that we
don't need to play tricks with slab internals.

Cc: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig          |    2 +-
 fs/unionfs/copyup.c |   35 +++++++++++++----------------------
 fs/unionfs/lookup.c |   34 ++++++++++++++--------------------
 3 files changed, 28 insertions(+), 43 deletions(-)

diff -puN fs/Kconfig~unionfs-fix-slab-abuses-with-krealloc fs/Kconfig
--- a/fs/Kconfig~unionfs-fix-slab-abuses-with-krealloc
+++ a/fs/Kconfig
@@ -1071,7 +1071,7 @@ config ECRYPT_FS
 
 config UNION_FS
 	tristate "Union file system (EXPERIMENTAL)"
-	depends on SLAB && EXPERIMENTAL
+	depends on EXPERIMENTAL
 	help
 	  Unionfs is a stackable unification file system, which appears to
 	  merge the contents of several directories (branches), while keeping
diff -puN fs/unionfs/copyup.c~unionfs-fix-slab-abuses-with-krealloc fs/unionfs/copyup.c
--- a/fs/unionfs/copyup.c~unionfs-fix-slab-abuses-with-krealloc
+++ a/fs/unionfs/copyup.c
@@ -618,23 +618,16 @@ static struct dentry *create_parents_nam
 	const char *childname;
 	unsigned int childnamelen;
 
-	int old_kmalloc_size;
-	int kmalloc_size;
-	int num_dentry;
+	int nr_dentry;
 	int count;
 
 	int old_bstart;
 	int old_bend;
 	struct dentry **path = NULL;
-	struct dentry **tmp_path;
 	struct super_block *sb;
 
 	verify_locked(dentry);
 
-	/* There is no sense allocating any less than the minimum. */
-	kmalloc_size = malloc_sizes[0].cs_size;
-	num_dentry = kmalloc_size / sizeof(struct dentry *);
-
 	if ((err = is_robranch_super(dir->i_sb, bindex))) {
 		hidden_dentry = ERR_PTR(err);
 		goto out;
@@ -644,7 +637,10 @@ static struct dentry *create_parents_nam
 	old_bend = dbend(dentry);
 
 	hidden_dentry = ERR_PTR(-ENOMEM);
-	path = kzalloc(kmalloc_size, GFP_KERNEL);
+
+	/* There is no sense allocating any less than the minimum. */
+	nr_dentry = 1;
+	path = kmalloc(nr_dentry * sizeof(struct dentry *), GFP_KERNEL);
 	if (!path)
 		goto out;
 
@@ -670,26 +666,21 @@ static struct dentry *create_parents_nam
 		/* find out the hidden_parent_dentry in the given branch */
 		hidden_parent_dentry = unionfs_lower_dentry_idx(parent_dentry, bindex);
 
-		/* store the child dentry */
-		path[count++] = child_dentry;
-
 		/* grow path table */
-		if (count == num_dentry) {
-			old_kmalloc_size = kmalloc_size;
-			kmalloc_size *= 2;
-			num_dentry = kmalloc_size / sizeof(struct dentry *);
+		if (count == nr_dentry) {
+			void *p;
 
-			tmp_path = kzalloc(kmalloc_size, GFP_KERNEL);
-			if (!tmp_path) {
+			nr_dentry *= 2;
+			p = krealloc(path, nr_dentry * sizeof(struct dentry *), GFP_KERNEL);
+			if (!p) {
 				hidden_dentry = ERR_PTR(-ENOMEM);
 				goto out;
 			}
-			memcpy(tmp_path, path, old_kmalloc_size);
-			kfree(path);
-			path = tmp_path;
-			tmp_path = NULL;
+			path = p;
 		}
 
+		/* store the child dentry */
+		path[count++] = child_dentry;
 	} while (!hidden_parent_dentry);
 	count--;
 
diff -puN fs/unionfs/lookup.c~unionfs-fix-slab-abuses-with-krealloc fs/unionfs/lookup.c
--- a/fs/unionfs/lookup.c~unionfs-fix-slab-abuses-with-krealloc
+++ a/fs/unionfs/lookup.c
@@ -432,8 +432,8 @@ void free_dentry_private_data(struct uni
 /* allocate new dentry private data, free old one if necessary */
 int new_dentry_private_data(struct dentry *dentry)
 {
-	int newsize;
-	int oldsize = 0;
+	int new_size;
+	int size;
 	struct unionfs_dentry_info *info = UNIONFS_D(dentry);
 	int unlock_on_err = 0;
 
@@ -451,8 +451,9 @@ int new_dentry_private_data(struct dentr
 		unlock_on_err = 1;
 
 		info->lower_paths = NULL;
+		size = 0;
 	} else
-		oldsize = sizeof(struct path) * info->bcount;
+		size = sizeof(struct path) * info->bcount;
 
 	info->bstart = -1;
 	info->bend = -1;
@@ -460,28 +461,21 @@ int new_dentry_private_data(struct dentr
 	info->bcount = sbmax(dentry->d_sb);
 	atomic_set(&info->generation,
 		   atomic_read(&UNIONFS_SB(dentry->d_sb)->generation));
-	newsize = sizeof(struct path) * sbmax(dentry->d_sb);
+
+	new_size = sizeof(struct path) * sbmax(dentry->d_sb);
 
 	/* Don't reallocate when we already have enough space. */
-	/* It would be ideal if we could actually use the slab macros to
-	 * determine what our object sizes is, but those are not exported.
-	 */
-	if (oldsize) {
-		int minsize = malloc_sizes[0].cs_size;
-
-		if (!newsize || ((oldsize < newsize) && (newsize > minsize))) {
-			kfree(info->lower_paths);
-			info->lower_paths = NULL;
-		}
-	}
+	if (new_size > size) {
+		void *p;
 
-	if (!info->lower_paths && newsize) {
-		info->lower_paths = kmalloc(newsize, GFP_ATOMIC);
-		if (!info->lower_paths)
+		p = krealloc(info->lower_paths, new_size, GFP_ATOMIC);
+		if (!p)
 			goto out_free;
-	}
 
-	memset(info->lower_paths, 0, (oldsize > newsize ? oldsize : newsize));
+		info->lower_paths = p;
+		size = new_size;
+	}
+	memset(info->lower_paths, 0, size);
 
 	spin_unlock(&dentry->d_lock);
 	return 0;
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

git-unionfs.patch
slab-allocators-drop-support-for-destructors.patch
revoke-special-mmap-handling.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
slab-leaks3-default-y.patch
