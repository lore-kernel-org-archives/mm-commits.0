From: akpm@osdl.org
Subject: - knfsd-nfsd4-handling-more-nfsd_cross_mnt-errors-in-nfsd4-readdir.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:15:17 -0800
Message-ID: <200612140615.kBE6FH82002202@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52461 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974AbWLNGPu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:15:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@fieldses.org, bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: nfsd4: handling more nfsd_cross_mnt errors in nfsd4 readdir
has been removed from the -mm tree.  Its filename was
     knfsd-nfsd4-handling-more-nfsd_cross_mnt-errors-in-nfsd4-readdir.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: nfsd4: handling more nfsd_cross_mnt errors in nfsd4 readdir
From: J.Bruce Fields <bfields@fieldses.org>

This patch on its own causes no change in behavior, since nfsd_cross_mnt()
only returns -EAGAIN; but in the future I'd like it to also be able to return
-ETIMEDOUT, so we may as well handle any possible error here.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/nfsd/nfs4xdr.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff -puN fs/nfsd/nfs4xdr.c~knfsd-nfsd4-handling-more-nfsd_cross_mnt-errors-in-nfsd4-readdir fs/nfsd/nfs4xdr.c
--- a/fs/nfsd/nfs4xdr.c~knfsd-nfsd4-handling-more-nfsd_cross_mnt-errors-in-nfsd4-readdir
+++ a/fs/nfsd/nfs4xdr.c
@@ -1845,15 +1845,11 @@ nfsd4_encode_dirent_fattr(struct nfsd4_r
 
 	exp_get(exp);
 	if (d_mountpoint(dentry)) {
-		if (nfsd_cross_mnt(cd->rd_rqstp, &dentry, &exp)) {
-		/*
-		 * -EAGAIN is the only error returned from
-		 * nfsd_cross_mnt() and it indicates that an
-		 * up-call has  been initiated to fill in the export
-		 * options on exp.  When the answer comes back,
-		 * this call will be retried.
-		 */
-			nfserr = nfserr_dropit;
+		int err;
+
+		err = nfsd_cross_mnt(cd->rd_rqstp, &dentry, &exp);
+		if (err) {
+			nfserr = nfserrno(err);
 			goto out_put;
 		}
 
_

Patches currently in -mm which might be from bfields@fieldses.org are


