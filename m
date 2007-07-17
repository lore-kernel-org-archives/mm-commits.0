From: akpm@linux-foundation.org
Subject: - knfsd-nfsd-make-all-exp_finding-functions-return-errnos-on-err.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:04:40 -0700
Message-ID: <200707172304.l6HN4eej011823@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53513 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936714AbXGQXQa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@puzzle.fieldses.org, bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: nfsd: make all exp_finding functions return -errno's on err
has been removed from the -mm tree.  Its filename was
     knfsd-nfsd-make-all-exp_finding-functions-return-errnos-on-err.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: nfsd: make all exp_finding functions return -errno's on err
From: J. Bruce Fields <bfields@puzzle.fieldses.org>

Currently exp_find(), exp_get_by_name(), and friends, return an export on
success, and on failure return:

	errors -EAGAIN (drop this request pending an upcall) or
		-ETIMEDOUT (an upcall has timed out), or
	return NULL, which can mean either that there was a memory allocation
		failure, or that an export was not found, or that a passed-in
		export lacks an auth_domain.

Many callers seem to assume that NULL means that an export was not found,
which may lead to bugs in the case of a memory allocation failure.

Modify these functions to distinguish between the two NULL cases by returning
either -ENOENT or -ENOMEM.  They now never return NULL.  We get to simplify
some code in the process.

We return -ENOENT in the case of a missing auth_domain.  This case should
probably be removed (or converted to a bug) after confirming that it can never
happen.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/export.c |   58 +++++++++++++++++----------------------------
 fs/nfsd/nfsfh.c  |   11 +++-----
 fs/nfsd/vfs.c    |    9 +++---
 3 files changed, 32 insertions(+), 46 deletions(-)

diff -puN fs/nfsd/export.c~knfsd-nfsd-make-all-exp_finding-functions-return-errnos-on-err fs/nfsd/export.c
--- a/fs/nfsd/export.c~knfsd-nfsd-make-all-exp_finding-functions-return-errnos-on-err
+++ a/fs/nfsd/export.c
@@ -739,16 +739,18 @@ exp_find_key(svc_client *clp, int fsid_t
 	int err;
 	
 	if (!clp)
-		return NULL;
+		return ERR_PTR(-ENOENT);
 
 	key.ek_client = clp;
 	key.ek_fsidtype = fsid_type;
 	memcpy(key.ek_fsid, fsidv, key_len(fsid_type));
 
 	ek = svc_expkey_lookup(&key);
-	if (ek != NULL)
-		if ((err = cache_check(&svc_expkey_cache, &ek->h, reqp)))
-			ek = ERR_PTR(err);
+	if (ek == NULL)
+		return ERR_PTR(-ENOMEM);
+	err = cache_check(&svc_expkey_cache, &ek->h, reqp);
+	if (err)
+		return ERR_PTR(err);
 	return ek;
 }
 
@@ -809,30 +811,21 @@ exp_get_by_name(svc_client *clp, struct 
 		struct cache_req *reqp)
 {
 	struct svc_export *exp, key;
+	int err;
 	
 	if (!clp)
-		return NULL;
+		return ERR_PTR(-ENOENT);
 
 	key.ex_client = clp;
 	key.ex_mnt = mnt;
 	key.ex_dentry = dentry;
 
 	exp = svc_export_lookup(&key);
-	if (exp != NULL)  {
-		int err;
-
-		err = cache_check(&svc_export_cache, &exp->h, reqp);
-		switch (err) {
-		case 0: break;
-		case -EAGAIN:
-		case -ETIMEDOUT:
-			exp = ERR_PTR(err);
-			break;
-		default:
-			exp = NULL;
-		}
-	}
-
+	if (exp == NULL)
+		return ERR_PTR(-ENOMEM);
+	err = cache_check(&svc_export_cache, &exp->h, reqp);
+	if (err)
+		return ERR_PTR(err);
 	return exp;
 }
 
@@ -848,7 +841,7 @@ exp_parent(svc_client *clp, struct vfsmo
 	dget(dentry);
 	exp = exp_get_by_name(clp, mnt, dentry, reqp);
 
-	while (exp == NULL && !IS_ROOT(dentry)) {
+	while (PTR_ERR(exp) == -ENOENT && !IS_ROOT(dentry)) {
 		struct dentry *parent;
 
 		parent = dget_parent(dentry);
@@ -901,7 +894,7 @@ static void exp_fsid_unhash(struct svc_e
 		return;
 
 	ek = exp_get_fsid_key(exp->ex_client, exp->ex_fsid);
-	if (ek && !IS_ERR(ek)) {
+	if (!IS_ERR(ek)) {
 		ek->h.expiry_time = get_seconds()-1;
 		cache_put(&ek->h, &svc_expkey_cache);
 	}
@@ -939,7 +932,7 @@ static void exp_unhash(struct svc_export
 	struct inode *inode = exp->ex_dentry->d_inode;
 
 	ek = exp_get_key(exp->ex_client, inode->i_sb->s_dev, inode->i_ino);
-	if (ek && !IS_ERR(ek)) {
+	if (!IS_ERR(ek)) {
 		ek->h.expiry_time = get_seconds()-1;
 		cache_put(&ek->h, &svc_expkey_cache);
 	}
@@ -990,13 +983,12 @@ exp_export(struct nfsctl_export *nxp)
 
 	/* must make sure there won't be an ex_fsid clash */
 	if ((nxp->ex_flags & NFSEXP_FSID) &&
-	    (fsid_key = exp_get_fsid_key(clp, nxp->ex_dev)) &&
-	    !IS_ERR(fsid_key) &&
+	    (!IS_ERR(fsid_key = exp_get_fsid_key(clp, nxp->ex_dev))) &&
 	    fsid_key->ek_mnt &&
 	    (fsid_key->ek_mnt != nd.mnt || fsid_key->ek_dentry != nd.dentry) )
 		goto finish;
 
-	if (exp) {
+	if (!IS_ERR(exp)) {
 		/* just a flags/id/fsid update */
 
 		exp_fsid_unhash(exp);
@@ -1105,7 +1097,7 @@ exp_unexport(struct nfsctl_export *nxp)
 	err = -EINVAL;
 	exp = exp_get_by_name(dom, nd.mnt, nd.dentry, NULL);
 	path_release(&nd);
-	if (!exp)
+	if (IS_ERR(exp))
 		goto out_domain;
 
 	exp_do_unexport(exp);
@@ -1150,10 +1142,6 @@ exp_rootfh(svc_client *clp, char *path, 
 		err = PTR_ERR(exp);
 		goto out;
 	}
-	if (!exp) {
-		dprintk("nfsd: exp_rootfh export not found.\n");
-		goto out;
-	}
 
 	/*
 	 * fh must be initialized before calling fh_compose
@@ -1177,13 +1165,13 @@ exp_find(struct auth_domain *clp, int fs
 {
 	struct svc_export *exp;
 	struct svc_expkey *ek = exp_find_key(clp, fsid_type, fsidv, reqp);
-	if (!ek || IS_ERR(ek))
+	if (IS_ERR(ek))
 		return ERR_PTR(PTR_ERR(ek));
 
 	exp = exp_get_by_name(clp, ek->ek_mnt, ek->ek_dentry, reqp);
 	cache_put(&ek->h, &svc_expkey_cache);
 
-	if (!exp || IS_ERR(exp))
+	if (IS_ERR(exp))
 		return ERR_PTR(PTR_ERR(exp));
 	return exp;
 }
@@ -1205,10 +1193,10 @@ exp_pseudoroot(struct auth_domain *clp, 
 	mk_fsid(FSID_NUM, fsidv, 0, 0, 0, NULL);
 
 	exp = exp_find(clp, FSID_NUM, fsidv, creq);
+	if (PTR_ERR(exp) == -ENOENT)
+		return nfserr_perm;
 	if (IS_ERR(exp))
 		return nfserrno(PTR_ERR(exp));
-	if (exp == NULL)
-		return nfserr_perm;
 	rv = fh_compose(fhp, exp, exp->ex_dentry, NULL);
 	exp_put(exp);
 	return rv;
diff -puN fs/nfsd/nfsfh.c~knfsd-nfsd-make-all-exp_finding-functions-return-errnos-on-err fs/nfsd/nfsfh.c
--- a/fs/nfsd/nfsfh.c~knfsd-nfsd-make-all-exp_finding-functions-return-errnos-on-err
+++ a/fs/nfsd/nfsfh.c
@@ -160,15 +160,14 @@ fh_verify(struct svc_rqst *rqstp, struct
 				       &rqstp->rq_chandle);
 		}
 
-		if (IS_ERR(exp) && (PTR_ERR(exp) == -EAGAIN
-				|| PTR_ERR(exp) == -ETIMEDOUT)) {
-			error = nfserrno(PTR_ERR(exp));
+		error = nfserr_stale;
+		if (PTR_ERR(exp) == -ENOENT)
 			goto out;
-		}
 
-		error = nfserr_stale; 
-		if (!exp || IS_ERR(exp))
+		if (IS_ERR(exp)) {
+			error = nfserrno(PTR_ERR(exp));
 			goto out;
+		}
 
 		/* Check if the request originated from a secure port. */
 		error = nfserr_perm;
diff -puN fs/nfsd/vfs.c~knfsd-nfsd-make-all-exp_finding-functions-return-errnos-on-err fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~knfsd-nfsd-make-all-exp_finding-functions-return-errnos-on-err
+++ a/fs/nfsd/vfs.c
@@ -192,15 +192,14 @@ nfsd_lookup(struct svc_rqst *rqstp, stru
 
 			exp2 = exp_parent(exp->ex_client, mnt, dentry,
 					  &rqstp->rq_chandle);
-			if (IS_ERR(exp2)) {
+			if (PTR_ERR(exp2) == -ENOENT) {
+				dput(dentry);
+				dentry = dget(dparent);
+			} else if (IS_ERR(exp2)) {
 				host_err = PTR_ERR(exp2);
 				dput(dentry);
 				mntput(mnt);
 				goto out_nfserr;
-			}
-			if (!exp2) {
-				dput(dentry);
-				dentry = dget(dparent);
 			} else {
 				exp_put(exp);
 				exp = exp2;
_

Patches currently in -mm which might be from bfields@puzzle.fieldses.org are

origin.patch
