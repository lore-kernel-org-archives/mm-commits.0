From: akpm@osdl.org
Subject: + knfsd-nfsd4-simplify-migration-op-check.patch added to -mm tree
Date: Fri, 08 Dec 2006 16:09:48 -0800
Message-ID: <200612090009.kB909msq010429@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:55634 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947595AbWLIAKC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 19:10:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@fieldses.org, bfields@citi.umich.edu, neilb@suse.de


The patch titled
     knfsd: nfsd4: simplify migration op check
has been added to the -mm tree.  Its filename is
     knfsd-nfsd4-simplify-migration-op-check.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: nfsd4: simplify migration op check
From: J.Bruce Fields <bfields@fieldses.org>

I'm not too fond of these big if conditions.  Replace them by checks of a flag
in the operation descriptor.  To my eye this makes the code a bit more
self-documenting, and makes the complicated part of the code (proc_compound) a
little more compact.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/nfsd/nfs4proc.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff -puN fs/nfsd/nfs4proc.c~knfsd-nfsd4-simplify-migration-op-check fs/nfsd/nfs4proc.c
--- a/fs/nfsd/nfs4proc.c~knfsd-nfsd4-simplify-migration-op-check
+++ a/fs/nfsd/nfs4proc.c
@@ -802,6 +802,8 @@ typedef __be32(*nfsd4op_func)(struct svc
 struct nfsd4_operation {
 	nfsd4op_func op_func;
 	u32 op_flags;
+/* GETATTR and ops not listed as returning NFS4ERR_MOVED: */
+#define ALLOWED_ON_ABSENT_FS 1
 };
 
 static struct nfsd4_operation nfsd4_ops[];
@@ -887,17 +889,8 @@ nfsd4_proc_compound(struct svc_rqst *rqs
 				op->status = nfserr_nofilehandle;
 				goto encode_op;
 			}
-		}
-		/* Check must be done at start of each operation, except
-		 * for GETATTR and ops not listed as returning NFS4ERR_MOVED
-		 */
-		else if (cstate->current_fh.fh_export->ex_fslocs.migrated &&
-			 !((op->opnum == OP_GETATTR) ||
-			   (op->opnum == OP_PUTROOTFH) ||
-			   (op->opnum == OP_PUTPUBFH) ||
-			   (op->opnum == OP_RENEW) ||
-			   (op->opnum == OP_SETCLIENTID) ||
-			   (op->opnum == OP_RELEASE_LOCKOWNER))) {
+		} else if (cstate->current_fh.fh_export->ex_fslocs.migrated &&
+			  !(opdesc->op_flags & ALLOWED_ON_ABSENT_FS)) {
 			op->status = nfserr_moved;
 			goto encode_op;
 		}
@@ -951,6 +944,7 @@ static struct nfsd4_operation nfsd4_ops[
 	},
 	[OP_GETATTR] = {
 		.op_func = (nfsd4op_func)nfsd4_getattr,
+		.op_flags = ALLOWED_ON_ABSENT_FS,
 	},
 	[OP_GETFH] = {
 		.op_func = (nfsd4op_func)nfsd4_getfh,
@@ -988,8 +982,13 @@ static struct nfsd4_operation nfsd4_ops[
 	[OP_PUTFH] = {
 		.op_func = (nfsd4op_func)nfsd4_putfh,
 	},
+	[OP_PUTPUBFH] = {
+		/* unsupported; just for future reference: */
+		.op_flags = ALLOWED_ON_ABSENT_FS,
+	},
 	[OP_PUTROOTFH] = {
 		.op_func = (nfsd4op_func)nfsd4_putrootfh,
+		.op_flags = ALLOWED_ON_ABSENT_FS,
 	},
 	[OP_READ] = {
 		.op_func = (nfsd4op_func)nfsd4_read,
@@ -1008,6 +1007,7 @@ static struct nfsd4_operation nfsd4_ops[
 	},
 	[OP_RENEW] = {
 		.op_func = (nfsd4op_func)nfsd4_renew,
+		.op_flags = ALLOWED_ON_ABSENT_FS,
 	},
 	[OP_RESTOREFH] = {
 		.op_func = (nfsd4op_func)nfsd4_restorefh,
@@ -1020,6 +1020,7 @@ static struct nfsd4_operation nfsd4_ops[
 	},
 	[OP_SETCLIENTID] = {
 		.op_func = (nfsd4op_func)nfsd4_setclientid,
+		.op_flags = ALLOWED_ON_ABSENT_FS,
 	},
 	[OP_SETCLIENTID_CONFIRM] = {
 		.op_func = (nfsd4op_func)nfsd4_setclientid_confirm,
@@ -1032,6 +1033,7 @@ static struct nfsd4_operation nfsd4_ops[
 	},
 	[OP_RELEASE_LOCKOWNER] = {
 		.op_func = (nfsd4op_func)nfsd4_release_lockowner,
+		.op_flags = ALLOWED_ON_ABSENT_FS,
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

