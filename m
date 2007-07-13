From: akpm@linux-foundation.org
Subject: + coda-cleanup-downcall-handler.patch added to -mm tree
Date: Thu, 12 Jul 2007 22:29:43 -0700
Message-ID: <200707130529.l6D5ThnG030823@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42170 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751699AbXGMFg4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 01:36:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaharkes@cs.cmu.edu


The patch titled
     coda: cleanup downcall handler
has been added to the -mm tree.  Its filename is
     coda-cleanup-downcall-handler.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: coda: cleanup downcall handler
From: Jan Harkes <jaharkes@cs.cmu.edu>

Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/upcall.c |  117 ++++++++++++++++++++-------------------------
 1 file changed, 53 insertions(+), 64 deletions(-)

diff -puN fs/coda/upcall.c~coda-cleanup-downcall-handler fs/coda/upcall.c
--- a/fs/coda/upcall.c~coda-cleanup-downcall-handler
+++ a/fs/coda/upcall.c
@@ -859,77 +859,66 @@ exit:
 
 int coda_downcall(int opcode, union outputArgs * out, struct super_block *sb)
 {
-	/* Handle invalidation requests. */
-          if ( !sb || !sb->s_root || !sb->s_root->d_inode)
-		  return 0; 
+	struct inode *inode = NULL;
+	struct CodaFid *fid, *newfid;
 
-	  switch (opcode) {
+	/* Handle invalidation requests. */
+	if ( !sb || !sb->s_root)
+		return 0;
 
-	  case CODA_FLUSH : {
-		   coda_cache_clear_all(sb);
-		   shrink_dcache_sb(sb);
-		   coda_flag_inode(sb->s_root->d_inode, C_FLUSH);
-		   return(0);
-	  }
-
-	  case CODA_PURGEUSER : {
-		   coda_cache_clear_all(sb);
-		   return(0);
-	  }
-
-	  case CODA_ZAPDIR : {
-	          struct inode *inode;
-		  struct CodaFid *fid = &out->coda_zapdir.CodaFid;
-
-		  inode = coda_fid_to_inode(fid, sb);
-		  if (inode) {
-			  coda_flag_inode_children(inode, C_PURGE);
-	                  coda_flag_inode(inode, C_VATTR);
-			  iput(inode);
-		  }
-		  
-		  return(0);
-	  }
-
-	  case CODA_ZAPFILE : {
-	          struct inode *inode;
-		  struct CodaFid *fid = &out->coda_zapfile.CodaFid;
-		  inode = coda_fid_to_inode(fid, sb);
-		  if ( inode ) {
-	                  coda_flag_inode(inode, C_VATTR);
-			  iput(inode);
-		  }
-		  return 0;
-	  }
-
-	  case CODA_PURGEFID : {
-	          struct inode *inode;
-		  struct CodaFid *fid = &out->coda_purgefid.CodaFid;
-		  inode = coda_fid_to_inode(fid, sb);
-		  if ( inode ) { 
+	switch (opcode) {
+	case CODA_FLUSH:
+		coda_cache_clear_all(sb);
+		shrink_dcache_sb(sb);
+		if (sb->s_root->d_inode)
+		    coda_flag_inode(sb->s_root->d_inode, C_FLUSH);
+		break;
+
+	case CODA_PURGEUSER:
+		coda_cache_clear_all(sb);
+		break;
+
+	case CODA_ZAPDIR:
+		fid = &out->coda_zapdir.CodaFid;
+		inode = coda_fid_to_inode(fid, sb);
+		if (inode) {
+			coda_flag_inode_children(inode, C_PURGE);
+			coda_flag_inode(inode, C_VATTR);
+		}
+		break;
+
+	case CODA_ZAPFILE:
+		fid = &out->coda_zapfile.CodaFid;
+		inode = coda_fid_to_inode(fid, sb);
+		if (inode)
+			coda_flag_inode(inode, C_VATTR);
+		break;
+
+	case CODA_PURGEFID:
+		fid = &out->coda_purgefid.CodaFid;
+		inode = coda_fid_to_inode(fid, sb);
+		if (inode) {
 			coda_flag_inode_children(inode, C_PURGE);
 
 			/* catch the dentries later if some are still busy */
 			coda_flag_inode(inode, C_PURGE);
 			d_prune_aliases(inode);
 
-			iput(inode);
-		  }
-		  return 0;
-	  }
-
-	  case CODA_REPLACE : {
-	          struct inode *inode;
-		  struct CodaFid *oldfid = &out->coda_replace.OldFid;
-		  struct CodaFid *newfid = &out->coda_replace.NewFid;
-		  inode = coda_fid_to_inode(oldfid, sb);
-		  if ( inode ) { 
-			  coda_replace_fid(inode, oldfid, newfid);
-			  iput(inode);
-		  }
-		  return 0;
-	  }
-	  }
-	  return 0;
+		}
+		break;
+
+	case CODA_REPLACE:
+		fid = &out->coda_replace.OldFid;
+		newfid = &out->coda_replace.NewFid;
+		inode = coda_fid_to_inode(fid, sb);
+		if (inode)
+			coda_replace_fid(inode, fid, newfid);
+		break;
+	}
+
+	if (inode)
+		iput(inode);
+
+	return 0;
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
