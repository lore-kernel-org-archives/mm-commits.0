From: akpm@osdl.org
Subject: + knfsd-nfsd4-make-verify-and-nverify-wrappers.patch added to -mm tree
Date: Fri, 08 Dec 2006 16:09:44 -0800
Message-ID: <200612090009.kB909ixg010420@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:55622 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947583AbWLIAJ5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 19:09:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@fieldses.org, bfields@citi.umich.edu, neilb@suse.de


The patch titled
     knfsd: nfsd4: make verify and nverify wrappers
has been added to the -mm tree.  Its filename is
     knfsd-nfsd4-make-verify-and-nverify-wrappers.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: nfsd4: make verify and nverify wrappers
From: J.Bruce Fields <bfields@fieldses.org>

Make wrappers for verify and nverify, for consistency with other ops.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/nfsd/nfs4proc.c |   28 ++++++++++++++++++++++------
 1 files changed, 22 insertions(+), 6 deletions(-)

diff -puN fs/nfsd/nfs4proc.c~knfsd-nfsd4-make-verify-and-nverify-wrappers fs/nfsd/nfs4proc.c
--- a/fs/nfsd/nfs4proc.c~knfsd-nfsd4-make-verify-and-nverify-wrappers
+++ a/fs/nfsd/nfs4proc.c
@@ -681,7 +681,7 @@ nfsd4_write(struct svc_rqst *rqstp, stru
  * to NFS_OK after the call; NVERIFY by mapping NFSERR_NOT_SAME to NFS_OK.
  */
 static __be32
-nfsd4_verify(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
+_nfsd4_verify(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	     struct nfsd4_verify *verify)
 {
 	__be32 *buf, *p;
@@ -733,6 +733,26 @@ out_kfree:
 	return status;
 }
 
+static __be32
+nfsd4_nverify(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
+	      struct nfsd4_verify *verify)
+{
+	__be32 status;
+
+	status = _nfsd4_verify(rqstp, cstate, verify);
+	return status == nfserr_not_same ? nfs_ok : status;
+}
+
+static __be32
+nfsd4_verify(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
+	     struct nfsd4_verify *verify)
+{
+	__be32 status;
+
+	status = _nfsd4_verify(rqstp, cstate, verify);
+	return status == nfserr_same ? nfs_ok : status;
+}
+
 /*
  * NULL call.
  */
@@ -911,10 +931,8 @@ nfsd4_proc_compound(struct svc_rqst *rqs
 			op->status = nfsd4_lookupp(rqstp, cstate);
 			break;
 		case OP_NVERIFY:
-			op->status = nfsd4_verify(rqstp, cstate,
+			op->status = nfsd4_nverify(rqstp, cstate,
 						  &op->u.nverify);
-			if (op->status == nfserr_not_same)
-				op->status = nfs_ok;
 			break;
 		case OP_OPEN:
 			op->status = nfsd4_open(rqstp, cstate,
@@ -975,8 +993,6 @@ nfsd4_proc_compound(struct svc_rqst *rqs
 		case OP_VERIFY:
 			op->status = nfsd4_verify(rqstp, cstate,
 						  &op->u.verify);
-			if (op->status == nfserr_same)
-				op->status = nfs_ok;
 			break;
 		case OP_WRITE:
 			op->status = nfsd4_write(rqstp, cstate, &op->u.write);
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

