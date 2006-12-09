From: akpm@osdl.org
Subject: + knfsd-nfsd4-simplify-filehandle-check.patch added to -mm tree
Date: Fri, 08 Dec 2006 16:09:50 -0800
Message-ID: <200612090009.kB909olF010432@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:55635 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947590AbWLIAKD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 19:10:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@fieldses.org, bfields@citi.umich.edu, neilb@suse.de


The patch titled
     knfsd: nfsd4: simplify filehandle check
has been added to the -mm tree.  Its filename is
     knfsd-nfsd4-simplify-filehandle-check.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: nfsd4: simplify filehandle check
From: J.Bruce Fields <bfields@fieldses.org>

Kill another big "if" clause.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/nfsd/nfs4proc.c |   29 ++++++++++++-----------------
 1 files changed, 12 insertions(+), 17 deletions(-)

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

