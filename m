From: akpm@linux-foundation.org
Subject: - coda-ignore-returned-values-when-upcalls-return-errors.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:03:17 -0700
Message-ID: <200707192003.l6JK3HaR019847@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49706 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761010AbXGSUQa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaharkes@cs.cmu.edu, mm-commits@vger.kernel.org


The patch titled
     coda: ignore returned values when upcalls return errors
has been removed from the -mm tree.  Its filename was
     coda-ignore-returned-values-when-upcalls-return-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: coda: ignore returned values when upcalls return errors
From: Jan Harkes <jaharkes@cs.cmu.edu>

Venus returns an ENOENT error on open, so we shouldn't try to grab the
filehandle for the returned fd.

Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/upcall.c |   59 ++++++++++++++++++++-------------------------
 1 file changed, 27 insertions(+), 32 deletions(-)

diff -puN fs/coda/upcall.c~coda-ignore-returned-values-when-upcalls-return-errors fs/coda/upcall.c
--- a/fs/coda/upcall.c~coda-ignore-returned-values-when-upcalls-return-errors
+++ a/fs/coda/upcall.c
@@ -84,12 +84,8 @@ int venus_rootfid(struct super_block *sb
         UPARG(CODA_ROOT);
 
 	error = coda_upcall(coda_sbp(sb), insize, &outsize, inp);
-	
-	if (error) {
-	        printk("coda_get_rootfid: error %d\n", error);
-	} else {
+	if (!error)
 		*fidp = outp->coda_root.VFid;
-	}
 
 	CODA_FREE(inp, insize);
 	return error;
@@ -106,9 +102,9 @@ int venus_getattr(struct super_block *sb
 	UPARG(CODA_GETATTR);
         inp->coda_getattr.VFid = *fid;
 
-        error = coda_upcall(coda_sbp(sb), insize, &outsize, inp);
-	
-	*attr = outp->coda_getattr.attr;
+	error = coda_upcall(coda_sbp(sb), insize, &outsize, inp);
+	if (!error)
+		*attr = outp->coda_getattr.attr;
 
 	CODA_FREE(inp, insize);
         return error;
@@ -153,10 +149,11 @@ int venus_lookup(struct super_block *sb,
         memcpy((char *)(inp) + offset, name, length);
         *((char *)inp + offset + length) = '\0';
 
-        error = coda_upcall(coda_sbp(sb), insize, &outsize, inp);
-
-	*resfid = outp->coda_lookup.VFid;
-	*type = outp->coda_lookup.vtype;
+	error = coda_upcall(coda_sbp(sb), insize, &outsize, inp);
+	if (!error) {
+		*resfid = outp->coda_lookup.VFid;
+		*type = outp->coda_lookup.vtype;
+	}
 
 	CODA_FREE(inp, insize);
 	return error;
@@ -278,11 +275,12 @@ int venus_mkdir(struct super_block *sb, 
         /* Venus must get null terminated string */
         memcpy((char *)(inp) + offset, name, length);
         *((char *)inp + offset + length) = '\0';
-        
-        error = coda_upcall(coda_sbp(sb), insize, &outsize, inp);
 
-	*attrs = outp->coda_mkdir.attr;
-	*newfid = outp->coda_mkdir.VFid;
+	error = coda_upcall(coda_sbp(sb), insize, &outsize, inp);
+	if (!error) {
+		*attrs = outp->coda_mkdir.attr;
+		*newfid = outp->coda_mkdir.VFid;
+	}
 
 	CODA_FREE(inp, insize);
 	return error;        
@@ -348,11 +346,12 @@ int venus_create(struct super_block *sb,
         /* Venus must get null terminated string */
         memcpy((char *)(inp) + offset, name, length);
         *((char *)inp + offset + length) = '\0';
-                
-        error = coda_upcall(coda_sbp(sb), insize, &outsize, inp);
 
-	*attrs = outp->coda_create.attr;
-	*newfid = outp->coda_create.VFid;
+	error = coda_upcall(coda_sbp(sb), insize, &outsize, inp);
+	if (!error) {
+		*attrs = outp->coda_create.attr;
+		*newfid = outp->coda_create.VFid;
+	}
 
 	CODA_FREE(inp, insize);
 	return error;        
@@ -417,19 +416,18 @@ int venus_readlink(struct super_block *s
 	UPARG(CODA_READLINK);
 
         inp->coda_readlink.VFid = *fid;
-    
-        error =  coda_upcall(coda_sbp(sb), insize, &outsize, inp);
-	
-	if (! error) {
-                retlen = outp->coda_readlink.count;
+
+	error = coda_upcall(coda_sbp(sb), insize, &outsize, inp);
+	if (!error) {
+		retlen = outp->coda_readlink.count;
 		if ( retlen > *length )
-		        retlen = *length;
+			retlen = *length;
 		*length = retlen;
 		result =  (char *)outp + (long)outp->coda_readlink.data;
 		memcpy(buffer, result, retlen);
 		*(buffer + retlen) = '\0';
 	}
-        
+
         CODA_FREE(inp, insize);
         return error;
 }
@@ -617,16 +615,13 @@ int venus_statfs(struct dentry *dentry, 
 	insize = max_t(unsigned int, INSIZE(statfs), OUTSIZE(statfs));
 	UPARG(CODA_STATFS);
 
-        error = coda_upcall(coda_sbp(dentry->d_sb), insize, &outsize, inp);
-	
-        if (!error) {
+	error = coda_upcall(coda_sbp(dentry->d_sb), insize, &outsize, inp);
+	if (!error) {
 		sfs->f_blocks = outp->coda_statfs.stat.f_blocks;
 		sfs->f_bfree  = outp->coda_statfs.stat.f_bfree;
 		sfs->f_bavail = outp->coda_statfs.stat.f_bavail;
 		sfs->f_files  = outp->coda_statfs.stat.f_files;
 		sfs->f_ffree  = outp->coda_statfs.stat.f_ffree;
-	} else {
-		printk("coda_statfs: Venus returns: %d\n", error);
 	}
 
         CODA_FREE(inp, insize);
_

Patches currently in -mm which might be from jaharkes@cs.cmu.edu are

origin.patch
