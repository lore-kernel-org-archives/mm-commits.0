From: akpm@linux-foundation.org
Subject: + knfsd-nfsd4-fix-memory-leak-on-kmalloc-failure-in-savemem.patch added to -mm tree
Date: Wed, 14 Feb 2007 13:14:31 -0800
Message-ID: <200702142114.l1ELEVn2009280@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46104 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932613AbXBNVOw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 16:14:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@snoopy.citi.umich.edu, bfields@citi.umich.edu, bhalevy@panasas.com, neilb@suse.de


The patch titled
     knfsd: nfsd4: fix memory leak on kmalloc failure in savemem
has been added to the -mm tree.  Its filename is
     knfsd-nfsd4-fix-memory-leak-on-kmalloc-failure-in-savemem.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: nfsd4: fix memory leak on kmalloc failure in savemem
From: J. Bruce Fields <bfields@snoopy.citi.umich.edu>

The wrong pointer is being kfree'd in savemem() when defer_free returns with
an error.

Signed-off-by: Benny Halevy <bhalevy@panasas.com>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4xdr.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff -puN fs/nfsd/nfs4xdr.c~knfsd-nfsd4-fix-memory-leak-on-kmalloc-failure-in-savemem fs/nfsd/nfs4xdr.c
--- a/fs/nfsd/nfs4xdr.c~knfsd-nfsd4-fix-memory-leak-on-kmalloc-failure-in-savemem
+++ a/fs/nfsd/nfs4xdr.c
@@ -199,24 +199,22 @@ defer_free(struct nfsd4_compoundargs *ar
 
 static char *savemem(struct nfsd4_compoundargs *argp, __be32 *p, int nbytes)
 {
-	void *new = NULL;
 	if (p == argp->tmp) {
-		new = kmalloc(nbytes, GFP_KERNEL);
-		if (!new) return NULL;
-		p = new;
+		p = kmalloc(nbytes, GFP_KERNEL);
+		if (!p)
+			return NULL;
 		memcpy(p, argp->tmp, nbytes);
 	} else {
 		BUG_ON(p != argp->tmpp);
 		argp->tmpp = NULL;
 	}
 	if (defer_free(argp, kfree, p)) {
-		kfree(new);
+		kfree(p);
 		return NULL;
 	} else
 		return (char *)p;
 }
 
-
 static __be32
 nfsd4_decode_bitmap(struct nfsd4_compoundargs *argp, u32 *bmval)
 {
_

Patches currently in -mm which might be from bfields@snoopy.citi.umich.edu are

knfsd-nfsd4-fix-memory-leak-on-kmalloc-failure-in-savemem.patch
knfsd-nfsd4-acls-dont-return-explicit-mask.patch
knfsd-nfsd4-acls-avoid-unnecessary-denies.patch
