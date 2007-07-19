From: akpm@linux-foundation.org
Subject: - coda-use-ilookup5.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:03:05 -0700
Message-ID: <200707192003.l6JK35hg019826@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53955 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760974AbXGSUQV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaharkes@cs.cmu.edu, mm-commits@vger.kernel.org


The patch titled
     coda: use ilookup5
has been removed from the -mm tree.  Its filename was
     coda-use-ilookup5.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
