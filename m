From: akpm@linux-foundation.org
Subject: + coda-fix-nlink-updates-for-directories.patch added to -mm tree
Date: Thu, 12 Jul 2007 22:29:30 -0700
Message-ID: <200707130529.l6D5TUPG030790@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60285 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751889AbXGMFaK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 01:30:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaharkes@cs.cmu.edu


The patch titled
     coda: fix nlink updates for directories
has been added to the -mm tree.  Its filename is
     coda-fix-nlink-updates-for-directories.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: coda: fix nlink updates for directories
From: Jan Harkes <jaharkes@cs.cmu.edu>

The Coda client sets the directory link count to 1 when it isn't sure how many
subdirectories we have.  In this case we shouldn't change the link count in
the kernel when a subdirectory is created or removed.

Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/dir.c |  106 +++++++++++++++++++++++++++---------------------
 1 file changed, 60 insertions(+), 46 deletions(-)

diff -puN fs/coda/dir.c~coda-fix-nlink-updates-for-directories fs/coda/dir.c
--- a/fs/coda/dir.c~coda-fix-nlink-updates-for-directories
+++ a/fs/coda/dir.c
@@ -173,12 +173,11 @@ int coda_permission(struct inode *inode,
 
  out:
 	unlock_kernel();
-
-        return error; 
+	return error;
 }
 
 
-static inline void coda_dir_changed(struct inode *dir, int link)
+static inline void coda_dir_update_mtime(struct inode *dir)
 {
 #ifdef REQUERY_VENUS_FOR_MTIME
 	/* invalidate the directory cnode's attributes so we refetch the
@@ -186,12 +185,27 @@ static inline void coda_dir_changed(stru
 	coda_flag_inode(dir, C_VATTR);
 #else
 	/* optimistically we can also act as if our nose bleeds. The
-         * granularity of the mtime is coarse anyways so we might actually be
-         * right most of the time. Note: we only do this for directories. */
+	 * granularity of the mtime is coarse anyways so we might actually be
+	 * right most of the time. Note: we only do this for directories. */
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
 #endif
-	if (link)
-		dir->i_nlink += link;
+}
+
+/* we have to wrap inc_nlink/drop_nlink because sometimes userspace uses a
+ * trick to fool GNU find's optimizations. If we can't be sure of the link
+ * (because of volume mount points) we set i_nlink to 1 which forces find
+ * to consider every child as a possible directory. We should also never
+ * see an increment or decrement for deleted directories where i_nlink == 0 */
+static inline void coda_dir_inc_nlink(struct inode *dir)
+{
+	if (dir->i_nlink >= 2)
+		inc_nlink(dir);
+}
+
+static inline void coda_dir_drop_nlink(struct inode *dir)
+{
+	if (dir->i_nlink > 2)
+		drop_nlink(dir);
 }
 
 /* creation routines: create, mknod, mkdir, link, symlink */
@@ -229,10 +243,10 @@ static int coda_create(struct inode *dir
 	}
 
 	/* invalidate the directory cnode's attributes */
-	coda_dir_changed(dir, 0);
+	coda_dir_update_mtime(dir);
 	unlock_kernel();
 	d_instantiate(de, inode);
-        return 0;
+	return 0;
 }
 
 static int coda_mkdir(struct inode *dir, struct dentry *de, int mode)
@@ -268,12 +282,13 @@ static int coda_mkdir(struct inode *dir,
 		d_drop(de);
 		return PTR_ERR(inode);
 	}
-	
+
 	/* invalidate the directory cnode's attributes */
-	coda_dir_changed(dir, 1);
+	coda_dir_inc_nlink(dir);
+	coda_dir_update_mtime(dir);
 	unlock_kernel();
 	d_instantiate(de, inode);
-        return 0;
+	return 0;
 }
 
 /* try to make de an entry in dir_inodde linked to source_de */ 
@@ -296,16 +311,16 @@ static int coda_link(struct dentry *sour
 	error = venus_link(dir_inode->i_sb, coda_i2f(inode),
 			   coda_i2f(dir_inode), (const char *)name, len);
 
-	if (error) { 
+	if (error) {
 		d_drop(de);
 		goto out;
 	}
 
-	coda_dir_changed(dir_inode, 0);
+	coda_dir_update_mtime(dir_inode);
 	atomic_inc(&inode->i_count);
 	d_instantiate(de, inode);
 	inc_nlink(inode);
-        
+
 out:
 	unlock_kernel();
 	return(error);
@@ -336,18 +351,18 @@ static int coda_symlink(struct inode *di
 
 	/*
 	 * This entry is now negative. Since we do not create
-	 * an inode for the entry we have to drop it. 
+	 * an inode for the entry we have to drop it.
 	 */
 	d_drop(de);
-	error = venus_symlink(dir_inode->i_sb, coda_i2f(dir_inode), name, len, 
+	error = venus_symlink(dir_inode->i_sb, coda_i2f(dir_inode), name, len,
 			      symname, symlen);
 
 	/* mtime is no good anymore */
 	if ( !error )
-		coda_dir_changed(dir_inode, 0);
+		coda_dir_update_mtime(dir_inode);
 
 	unlock_kernel();
-        return error;
+	return error;
 }
 
 /* destruction routines: unlink, rmdir */
@@ -360,17 +375,16 @@ int coda_unlink(struct inode *dir, struc
 	lock_kernel();
 	coda_vfs_stat.unlink++;
 
-        error = venus_remove(dir->i_sb, coda_i2f(dir), name, len);
-        if ( error ) {
+	error = venus_remove(dir->i_sb, coda_i2f(dir), name, len);
+	if ( error ) {
 		unlock_kernel();
-                return error;
-        }
+		return error;
+	}
 
-	coda_dir_changed(dir, 0);
+	coda_dir_update_mtime(dir);
 	drop_nlink(de->d_inode);
 	unlock_kernel();
-
-        return 0;
+	return 0;
 }
 
 int coda_rmdir(struct inode *dir, struct dentry *de)
@@ -388,49 +402,49 @@ int coda_rmdir(struct inode *dir, struct
 	}
 	error = venus_rmdir(dir->i_sb, coda_i2f(dir), name, len);
 
-        if ( error ) {
+	if ( error ) {
 		unlock_kernel();
-                return error;
-        }
+		return error;
+	}
 
-	coda_dir_changed(dir, -1);
+	coda_dir_drop_nlink(dir);
+	coda_dir_update_mtime(dir);
 	drop_nlink(de->d_inode);
 	d_delete(de);
 	unlock_kernel();
-
-        return 0;
+	return 0;
 }
 
 /* rename */
-static int coda_rename(struct inode *old_dir, struct dentry *old_dentry, 
+static int coda_rename(struct inode *old_dir, struct dentry *old_dentry,
 		       struct inode *new_dir, struct dentry *new_dentry)
 {
-        const char *old_name = old_dentry->d_name.name;
-        const char *new_name = new_dentry->d_name.name;
+	const char *old_name = old_dentry->d_name.name;
+	const char *new_name = new_dentry->d_name.name;
 	int old_length = old_dentry->d_name.len;
 	int new_length = new_dentry->d_name.len;
-        int link_adjust = 0;
-        int error;
+	int error;
 
 	lock_kernel();
 	coda_vfs_stat.rename++;
 
-        error = venus_rename(old_dir->i_sb, coda_i2f(old_dir), 
-			     coda_i2f(new_dir), old_length, new_length, 
+	error = venus_rename(old_dir->i_sb, coda_i2f(old_dir),
+			     coda_i2f(new_dir), old_length, new_length,
 			     (const char *) old_name, (const char *)new_name);
 
-        if ( !error ) {
+	if ( !error ) {
 		if ( new_dentry->d_inode ) {
-			if ( S_ISDIR(new_dentry->d_inode->i_mode) )
-                        	link_adjust = 1;
-
-                        coda_dir_changed(old_dir, -link_adjust);
-                        coda_dir_changed(new_dir,  link_adjust);
+			if ( S_ISDIR(new_dentry->d_inode->i_mode) ) {
+				coda_dir_drop_nlink(old_dir);
+				coda_dir_inc_nlink(new_dir);
+			}
+			coda_dir_update_mtime(old_dir);
+			coda_dir_update_mtime(new_dir);
 			coda_flag_inode(new_dentry->d_inode, C_VATTR);
 		} else {
 			coda_flag_inode(old_dir, C_VATTR);
 			coda_flag_inode(new_dir, C_VATTR);
-                }
+		}
 	}
 	unlock_kernel();
 
_

Patches currently in -mm which might be from jaharkes@cs.cmu.edu are

coda-do-not-grab-an-uninitialized-fd-when-the-open-upcall-returns-an-error.patch
coda-correctly-invalidate-cached-access-rights.patch
coda-fix-nlink-updates-for-directories.patch
coda-allow-removal-of-busy-directories.patch
coda-coda-doesnt-track-atime.patch
coda-use-ilookup5.patch
coda-cleanup-dev-cfs-open-and-close-handling.patch
coda-cleanup-for-upcall-handling-path.patch
coda-block-signals-during-upcall-processing.patch
coda-avoid-lockdep-warning-in-coda_readdir.patch
coda-replace-upc_alloc-upc_free-with-kmalloc-kfree.patch
coda-ignore-returned-values-when-upcalls-return-errors.patch
coda-cleanup-coda_lookup-use-dsplice_alias.patch
coda-cleanup-downcall-handler.patch
coda-remove-struct-coda_sb_info.patch
coda-remove-statistics-counters-from-proc-fs-coda.patch
coda-update-module-information.patch
