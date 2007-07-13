From: akpm@linux-foundation.org
Subject: + coda-cleanup-coda_lookup-use-dsplice_alias.patch added to -mm tree
Date: Thu, 12 Jul 2007 22:29:42 -0700
Message-ID: <200707130529.l6D5TgxF030820@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46854 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751652AbXGMFg1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 01:36:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaharkes@cs.cmu.edu


The patch titled
     coda: cleanup coda_lookup, use dsplice_alias
has been added to the -mm tree.  Its filename is
     coda-cleanup-coda_lookup-use-dsplice_alias.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: coda: cleanup coda_lookup, use dsplice_alias
From: Jan Harkes <jaharkes@cs.cmu.edu>

Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/dir.c |   57 ++++++++++++++++++------------------------------
 1 file changed, 22 insertions(+), 35 deletions(-)

diff -puN fs/coda/dir.c~coda-cleanup-coda_lookup-use-dsplice_alias fs/coda/dir.c
--- a/fs/coda/dir.c~coda-cleanup-coda_lookup-use-dsplice_alias
+++ a/fs/coda/dir.c
@@ -97,58 +97,45 @@ const struct file_operations coda_dir_op
 /* access routines: lookup, readlink, permission */
 static struct dentry *coda_lookup(struct inode *dir, struct dentry *entry, struct nameidata *nd)
 {
-	struct inode *res_inode = NULL;
+	struct inode *inode = NULL;
 	struct CodaFid resfid = { { 0, } };
-	int dropme = 0; /* to indicate entry should not be cached */
 	int type = 0;
 	int error = 0;
 	const char *name = entry->d_name.name;
 	size_t length = entry->d_name.len;
-	
-	if ( length > CODA_MAXNAMLEN ) {
-	        printk("name too long: lookup, %s (%*s)\n", 
+
+	if (length > CODA_MAXNAMLEN) {
+		printk(KERN_ERR "name too long: lookup, %s (%*s)\n",
 		       coda_i2s(dir), (int)length, name);
 		return ERR_PTR(-ENAMETOOLONG);
 	}
 
+	/* control object, create inode on the fly */
+	if (coda_isroot(dir) && coda_iscontrol(name, length)) {
+		error = coda_cnode_makectl(&inode, dir->i_sb);
+		type = CODA_NOCACHE;
+		goto exit;
+	}
+
 	lock_kernel();
-        /* control object, create inode on the fly */
-        if (coda_isroot(dir) && coda_iscontrol(name, length)) {
-	        error = coda_cnode_makectl(&res_inode, dir->i_sb);
-		dropme = 1;
-                goto exit;
-        }
 
-	error = venus_lookup(dir->i_sb, coda_i2f(dir), 
-			     (const char *)name, length, &type, &resfid);
+	error = venus_lookup(dir->i_sb, coda_i2f(dir), name, length,
+			     &type, &resfid);
+	if (!error)
+		error = coda_cnode_make(&inode, &resfid, dir->i_sb);
 
-	res_inode = NULL;
-	if (!error) {
-		if (type & CODA_NOCACHE) {
-			type &= (~CODA_NOCACHE);
-			dropme = 1;
-		}
+	unlock_kernel();
 
-	    	error = coda_cnode_make(&res_inode, &resfid, dir->i_sb);
-		if (error) {
-			unlock_kernel();
-			return ERR_PTR(error);
-		}
-	} else if (error != -ENOENT) {
-		unlock_kernel();
+	if (error && error != -ENOENT)
 		return ERR_PTR(error);
-	}
 
 exit:
-	entry->d_time = 0;
 	entry->d_op = &coda_dentry_operations;
-	d_add(entry, res_inode);
-	if ( dropme ) {
-		d_drop(entry);
-		coda_flag_inode(res_inode, C_VATTR);
-	}
-	unlock_kernel();
-        return NULL;
+
+	if (inode && (type & CODA_NOCACHE))
+		coda_flag_inode(inode, C_VATTR | C_PURGE);
+
+	return d_splice_alias(inode, entry);
 }
 
 
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
