From: akpm@linux-foundation.org
Subject: - knfsd-nfsd4-simplify-exp_pseudoroot-arguments.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:04:48 -0700
Message-ID: <200707172304.l6HN4mE0011855@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34784 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936624AbXGQXQE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: nfsd4: simplify exp_pseudoroot arguments
has been removed from the -mm tree.  Its filename was
     knfsd-nfsd4-simplify-exp_pseudoroot-arguments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: nfsd4: simplify exp_pseudoroot arguments
From: J. Bruce Fields <bfields@citi.umich.edu>

We're passing three arguments to exp_pseudoroot, two of which are just fields
of the svc_rqst.  Soon we'll want to pass in a third field as well.  So let's
just give up and pass in the whole struct svc_rqst.

Also sneak in some minor style cleanups while we're at it.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/export.c            |    5 ++---
 fs/nfsd/nfs4proc.c          |    7 +++----
 fs/nfsd/nfs4xdr.c           |    2 +-
 include/linux/nfsd/export.h |    2 +-
 4 files changed, 7 insertions(+), 9 deletions(-)

diff -puN fs/nfsd/export.c~knfsd-nfsd4-simplify-exp_pseudoroot-arguments fs/nfsd/export.c
--- a/fs/nfsd/export.c~knfsd-nfsd4-simplify-exp_pseudoroot-arguments
+++ a/fs/nfsd/export.c
@@ -1235,8 +1235,7 @@ exp_find(struct auth_domain *clp, int fs
  * export point with fsid==0
  */
 __be32
-exp_pseudoroot(struct auth_domain *clp, struct svc_fh *fhp,
-	       struct cache_req *creq)
+exp_pseudoroot(struct svc_rqst *rqstp, struct svc_fh *fhp)
 {
 	struct svc_export *exp;
 	__be32 rv;
@@ -1244,7 +1243,7 @@ exp_pseudoroot(struct auth_domain *clp, 
 
 	mk_fsid(FSID_NUM, fsidv, 0, 0, 0, NULL);
 
-	exp = exp_find(clp, FSID_NUM, fsidv, creq);
+	exp = exp_find(rqstp->rq_client, FSID_NUM, fsidv, rqstp->rq_chandle);
 	if (PTR_ERR(exp) == -ENOENT)
 		return nfserr_perm;
 	if (IS_ERR(exp))
diff -puN fs/nfsd/nfs4proc.c~knfsd-nfsd4-simplify-exp_pseudoroot-arguments fs/nfsd/nfs4proc.c
--- a/fs/nfsd/nfs4proc.c~knfsd-nfsd4-simplify-exp_pseudoroot-arguments
+++ a/fs/nfsd/nfs4proc.c
@@ -286,8 +286,7 @@ nfsd4_putrootfh(struct svc_rqst *rqstp, 
 	__be32 status;
 
 	fh_put(&cstate->current_fh);
-	status = exp_pseudoroot(rqstp->rq_client, &cstate->current_fh,
-			      &rqstp->rq_chandle);
+	status = exp_pseudoroot(rqstp, &cstate->current_fh);
 	return status;
 }
 
@@ -474,8 +473,8 @@ nfsd4_lookupp(struct svc_rqst *rqstp, st
 	__be32 ret;
 
 	fh_init(&tmp_fh, NFS4_FHSIZE);
-	if((ret = exp_pseudoroot(rqstp->rq_client, &tmp_fh,
-			      &rqstp->rq_chandle)) != 0)
+	ret = exp_pseudoroot(rqstp, &tmp_fh);
+	if (ret)
 		return ret;
 	if (tmp_fh.fh_dentry == cstate->current_fh.fh_dentry) {
 		fh_put(&tmp_fh);
diff -puN fs/nfsd/nfs4xdr.c~knfsd-nfsd4-simplify-exp_pseudoroot-arguments fs/nfsd/nfs4xdr.c
--- a/fs/nfsd/nfs4xdr.c~knfsd-nfsd4-simplify-exp_pseudoroot-arguments
+++ a/fs/nfsd/nfs4xdr.c
@@ -1296,7 +1296,7 @@ static char *nfsd4_path(struct svc_rqst 
 	char *path, *rootpath;
 
 	fh_init(&tmp_fh, NFS4_FHSIZE);
-	*stat = exp_pseudoroot(rqstp->rq_client, &tmp_fh, &rqstp->rq_chandle);
+	*stat = exp_pseudoroot(rqstp, &tmp_fh);
 	if (*stat)
 		return NULL;
 	rootpath = tmp_fh.fh_export->ex_path;
diff -puN include/linux/nfsd/export.h~knfsd-nfsd4-simplify-exp_pseudoroot-arguments include/linux/nfsd/export.h
--- a/include/linux/nfsd/export.h~knfsd-nfsd4-simplify-exp_pseudoroot-arguments
+++ a/include/linux/nfsd/export.h
@@ -135,7 +135,7 @@ struct svc_export *	exp_parent(struct au
 				   struct cache_req *reqp);
 int			exp_rootfh(struct auth_domain *, 
 					char *path, struct knfsd_fh *, int maxsize);
-__be32			exp_pseudoroot(struct auth_domain *, struct svc_fh *fhp, struct cache_req *creq);
+__be32			exp_pseudoroot(struct svc_rqst *, struct svc_fh *);
 __be32			nfserrno(int errno);
 
 extern struct cache_detail svc_export_cache;
_

Patches currently in -mm which might be from bfields@citi.umich.edu are

origin.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
git-vfs-lease-api.patch
