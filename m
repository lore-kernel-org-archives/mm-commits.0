From: akpm@osdl.org
Subject: - knfsd-nfsd4-make-verify-and-nverify-wrappers.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:17:06 -0800
Message-ID: <200612140617.kBE6H672002280@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52675 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013AbWLNGRj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:17:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@fieldses.org, bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: nfsd4: make verify and nverify wrappers
has been removed from the -mm tree.  Its filename was
     knfsd-nfsd4-make-verify-and-nverify-wrappers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: nfsd4: make verify and nverify wrappers
From: J.Bruce Fields <bfields@fieldses.org>

Make wrappers for verify and nverify, for consistency with other ops.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/nfsd/nfs4proc.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

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


