From: akpm@linux-foundation.org
Subject: + coda-use-ilookup5.patch added to -mm tree
Date: Thu, 12 Jul 2007 22:29:34 -0700
Message-ID: <200707130529.l6D5TYsu030799@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36505 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751611AbXGMFaO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 01:30:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaharkes@cs.cmu.edu


The patch titled
     coda: use ilookup5
has been added to the -mm tree.  Its filename is
     coda-use-ilookup5.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: coda: use ilookup5
From: Jan Harkes <jaharkes@cs.cmu.edu>

Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/cnode.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN fs/coda/cnode.c~coda-use-ilookup5 fs/coda/cnode.c
--- a/fs/coda/cnode.c~coda-use-ilookup5
+++ a/fs/coda/cnode.c
@@ -55,11 +55,6 @@ static int coda_set_inode(struct inode *
 	return 0;
 }
 
-static int coda_fail_inode(struct inode *inode, void *data)
-{
-	return -1;
-}
-
 struct inode * coda_iget(struct super_block * sb, struct CodaFid * fid,
 			 struct coda_vattr * attr)
 {
@@ -141,7 +136,7 @@ struct inode *coda_fid_to_inode(struct C
 		return NULL;
 	}
 
-	inode = iget5_locked(sb, hash, coda_test_inode, coda_fail_inode, fid);
+	inode = ilookup5(sb, hash, coda_test_inode, fid);
 	if ( !inode )
 		return NULL;
 
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
