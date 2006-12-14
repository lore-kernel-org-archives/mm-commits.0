From: akpm@osdl.org
Subject: - knfsd-nfsd4-simplify-filehandle-check.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:17:40 -0800
Message-ID: <200612140617.kBE6HdwU002312@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52740 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbWLNGSM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:18:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@fieldses.org, bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: nfsd4: simplify filehandle check
has been removed from the -mm tree.  Its filename was
     knfsd-nfsd4-simplify-filehandle-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: nfsd4: simplify filehandle check
From: J.Bruce Fields <bfields@fieldses.org>

Kill another big "if" clause.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/nfsd/nfs4proc.c |   29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff -puN fs/nfsd/nfs4proc.c~knfsd-nfsd4-simplify-filehandle-check fs/nfsd/nfs4proc.c
--- a/fs/nfsd/nfs4proc.c~knfsd-nfsd4-simplify-filehandle-check
+++ a/fs/nfsd/nfs4proc.c
@@ -802,8 +802,10 @@ typedef __be32(*nfsd4op_func)(struct svc
 struct nfsd4_operation {
 	nfsd4op_func op_func;
 	u32 op_flags;
+/* Most ops require a valid current filehandle; a few don't: */
+#define ALLOWED_WITHOUT_FH 1
 /* GETATTR and ops not listed as returning NFS4ERR_MOVED: */
-#define ALLOWED_ON_ABSENT_FS 1
+#define ALLOWED_ON_ABSENT_FS 2
 };
 
 static struct nfsd4_operation nfsd4_ops[];
@@ -874,18 +876,8 @@ nfsd4_proc_compound(struct svc_rqst *rqs
 
 		opdesc = &nfsd4_ops[op->opnum];
 
-		/* All operations except RENEW, SETCLIENTID, RESTOREFH
-		* SETCLIENTID_CONFIRM, PUTFH and PUTROOTFH
-		* require a valid current filehandle
-		*/
 		if (!cstate->current_fh.fh_dentry) {
-			if (!((op->opnum == OP_PUTFH) ||
-			      (op->opnum == OP_PUTROOTFH) ||
-			      (op->opnum == OP_SETCLIENTID) ||
-			      (op->opnum == OP_SETCLIENTID_CONFIRM) ||
-			      (op->opnum == OP_RENEW) ||
-			      (op->opnum == OP_RESTOREFH) ||
-			      (op->opnum == OP_RELEASE_LOCKOWNER))) {
+			if (!(opdesc->op_flags & ALLOWED_WITHOUT_FH)) {
 				op->status = nfserr_nofilehandle;
 				goto encode_op;
 			}
@@ -981,14 +973,15 @@ static struct nfsd4_operation nfsd4_ops[
 	},
 	[OP_PUTFH] = {
 		.op_func = (nfsd4op_func)nfsd4_putfh,
+		.op_flags = ALLOWED_WITHOUT_FH | ALLOWED_ON_ABSENT_FS,
 	},
 	[OP_PUTPUBFH] = {
 		/* unsupported; just for future reference: */
-		.op_flags = ALLOWED_ON_ABSENT_FS,
+		.op_flags = ALLOWED_WITHOUT_FH | ALLOWED_ON_ABSENT_FS,
 	},
 	[OP_PUTROOTFH] = {
 		.op_func = (nfsd4op_func)nfsd4_putrootfh,
-		.op_flags = ALLOWED_ON_ABSENT_FS,
+		.op_flags = ALLOWED_WITHOUT_FH | ALLOWED_ON_ABSENT_FS,
 	},
 	[OP_READ] = {
 		.op_func = (nfsd4op_func)nfsd4_read,
@@ -1007,10 +1000,11 @@ static struct nfsd4_operation nfsd4_ops[
 	},
 	[OP_RENEW] = {
 		.op_func = (nfsd4op_func)nfsd4_renew,
-		.op_flags = ALLOWED_ON_ABSENT_FS,
+		.op_flags = ALLOWED_WITHOUT_FH | ALLOWED_ON_ABSENT_FS,
 	},
 	[OP_RESTOREFH] = {
 		.op_func = (nfsd4op_func)nfsd4_restorefh,
+		.op_flags = ALLOWED_WITHOUT_FH | ALLOWED_ON_ABSENT_FS,
 	},
 	[OP_SAVEFH] = {
 		.op_func = (nfsd4op_func)nfsd4_savefh,
@@ -1020,10 +1014,11 @@ static struct nfsd4_operation nfsd4_ops[
 	},
 	[OP_SETCLIENTID] = {
 		.op_func = (nfsd4op_func)nfsd4_setclientid,
-		.op_flags = ALLOWED_ON_ABSENT_FS,
+		.op_flags = ALLOWED_WITHOUT_FH | ALLOWED_ON_ABSENT_FS,
 	},
 	[OP_SETCLIENTID_CONFIRM] = {
 		.op_func = (nfsd4op_func)nfsd4_setclientid_confirm,
+		.op_flags = ALLOWED_WITHOUT_FH | ALLOWED_ON_ABSENT_FS,
 	},
 	[OP_VERIFY] = {
 		.op_func = (nfsd4op_func)nfsd4_verify,
@@ -1033,7 +1028,7 @@ static struct nfsd4_operation nfsd4_ops[
 	},
 	[OP_RELEASE_LOCKOWNER] = {
 		.op_func = (nfsd4op_func)nfsd4_release_lockowner,
-		.op_flags = ALLOWED_ON_ABSENT_FS,
+		.op_flags = ALLOWED_WITHOUT_FH | ALLOWED_ON_ABSENT_FS,
 	},
 };
 
_

Patches currently in -mm which might be from bfields@fieldses.org are


