From: akpm@osdl.org
Subject: + knfsd-nfsd4-handling-more-nfsd_cross_mnt-errors-in-nfsd4-readdir.patch added to -mm tree
Date: Fri, 08 Dec 2006 16:09:30 -0800
Message-ID: <200612090009.kB909Uln010390@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:55566 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947572AbWLIAJo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 19:09:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@fieldses.org, bfields@citi.umich.edu, neilb@suse.de


The patch titled
     knfsd: nfsd4: handling more nfsd_cross_mnt errors in nfsd4 readdir
has been added to the -mm tree.  Its filename is
     knfsd-nfsd4-handling-more-nfsd_cross_mnt-errors-in-nfsd4-readdir.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 5 insertions(+), 9 deletions(-)

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

origin.patch
knfsd-nfsd4-remove-a-dprink-from-nfsd4_lock.patch
knfsd-svcrpc-fix-gss-krb5i-memory-leak.patch
knfsd-nfsd4-clarify-units-of-compound_slack_space.patch
knfsd-nfsd-make-exp_rootfh-handle-exp_parent-errors.patch
knfsd-nfsd-simplify-exp_pseudoroot.patch
knfsd-nfsd4-handling-more-nfsd_cross_mnt-errors-in-nfsd4-readdir.patch
knfsd-nfsd-dont-drop-silently-on-upcall-deferral.patch
knfsd-svcrpc-remove-another-silent-drop-from-deferral-code.patch
knfsd-nfsd4-pass-saved-and-current-fh-together-into-nfsd4-operations.patch
knfsd-nfsd4-remove-spurious-replay_owner-check.patch
knfsd-nfsd4-move-replay_owner-to-cstate.patch
knfsd-nfsd4-dont-inline-nfsd4-compound-op-functions.patch
knfsd-nfsd4-make-verify-and-nverify-wrappers.patch
knfsd-nfsd4-reorganize-compound-ops.patch
knfsd-nfsd4-simplify-migration-op-check.patch
knfsd-nfsd4-simplify-filehandle-check.patch

