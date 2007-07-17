From: akpm@linux-foundation.org
Subject: - knfsd-nfsd-provide-export-lookup-wrappers-which-take-a-svc_rqst.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:04:52 -0700
Message-ID: <200707172304.l6HN4qCx011861@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49580 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936640AbXGQXQE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: nfsd: provide export lookup wrappers which take a svc_rqst
has been removed from the -mm tree.  Its filename was
     knfsd-nfsd-provide-export-lookup-wrappers-which-take-a-svc_rqst.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: nfsd: provide export lookup wrappers which take a svc_rqst
From: J. Bruce Fields <bfields@citi.umich.edu>

Split the callers of exp_get_by_name(), exp_find(), and exp_parent() into
those that are processing requests and those that are doing other stuff (like
looking up filehandles for mountd).

No change in behavior, just a (fairly pointless, on its own) cleanup.

(Note this has the effect of making nfsd_cross_mnt() pass rqstp->rq_client
instead of exp->ex_client into exp_find_by_name().  However, the two should
have the same value at this point.)

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/export.c            |   28 +++++++++++++++++++++++++++-
 fs/nfsd/nfsfh.c             |    5 ++---
 fs/nfsd/vfs.c               |    5 ++---
 include/linux/nfsd/export.h |    7 +++++++
 4 files changed, 38 insertions(+), 7 deletions(-)

diff -puN fs/nfsd/export.c~knfsd-nfsd-provide-export-lookup-wrappers-which-take-a-svc_rqst fs/nfsd/export.c
--- a/fs/nfsd/export.c~knfsd-nfsd-provide-export-lookup-wrappers-which-take-a-svc_rqst
+++ a/fs/nfsd/export.c
@@ -1228,6 +1228,32 @@ exp_find(struct auth_domain *clp, int fs
 	return exp;
 }
 
+/*
+ * Called from functions that handle requests; functions that do work on
+ * behalf of mountd are passed a single client name to use, and should
+ * use exp_get_by_name() or exp_find().
+ */
+struct svc_export *
+rqst_exp_get_by_name(struct svc_rqst *rqstp, struct vfsmount *mnt,
+		struct dentry *dentry)
+{
+	return exp_get_by_name(rqstp->rq_client, mnt, dentry,
+						&rqstp->rq_chandle);
+}
+
+struct svc_export *
+rqst_exp_find(struct svc_rqst *rqstp, int fsid_type, u32 *fsidv)
+{
+	return exp_find(rqstp->rq_client, fsid_type, fsidv,
+						&rqstp->rq_chandle);
+}
+
+struct svc_export *
+rqst_exp_parent(struct svc_rqst *rqstp, struct vfsmount *mnt,
+		struct dentry *dentry)
+{
+	return exp_parent(rqstp->rq_client, mnt, dentry, &rqstp->rq_chandle);
+}
 
 /*
  * Called when we need the filehandle for the root of the pseudofs,
@@ -1243,7 +1269,7 @@ exp_pseudoroot(struct svc_rqst *rqstp, s
 
 	mk_fsid(FSID_NUM, fsidv, 0, 0, 0, NULL);
 
-	exp = exp_find(rqstp->rq_client, FSID_NUM, fsidv, rqstp->rq_chandle);
+	exp = rqst_exp_find(rqstp, FSID_NUM, fsidv);
 	if (PTR_ERR(exp) == -ENOENT)
 		return nfserr_perm;
 	if (IS_ERR(exp))
diff -puN fs/nfsd/nfsfh.c~knfsd-nfsd-provide-export-lookup-wrappers-which-take-a-svc_rqst fs/nfsd/nfsfh.c
--- a/fs/nfsd/nfsfh.c~knfsd-nfsd-provide-export-lookup-wrappers-which-take-a-svc_rqst
+++ a/fs/nfsd/nfsfh.c
@@ -145,7 +145,7 @@ fh_verify(struct svc_rqst *rqstp, struct
 				fh->fh_fsid[1] = fh->fh_fsid[2];
 			}
 			if ((data_left -= len)<0) goto out;
-			exp = exp_find(rqstp->rq_client, fh->fh_fsid_type, datap, &rqstp->rq_chandle);
+			exp = rqst_exp_find(rqstp, fh->fh_fsid_type, datap);
 			datap += len;
 		} else {
 			dev_t xdev;
@@ -156,8 +156,7 @@ fh_verify(struct svc_rqst *rqstp, struct
 			xdev = old_decode_dev(fh->ofh_xdev);
 			xino = u32_to_ino_t(fh->ofh_xino);
 			mk_fsid(FSID_DEV, tfh, xdev, xino, 0, NULL);
-			exp = exp_find(rqstp->rq_client, FSID_DEV, tfh,
-				       &rqstp->rq_chandle);
+			exp = rqst_exp_find(rqstp, FSID_DEV, tfh);
 		}
 
 		error = nfserr_stale;
diff -puN fs/nfsd/vfs.c~knfsd-nfsd-provide-export-lookup-wrappers-which-take-a-svc_rqst fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~knfsd-nfsd-provide-export-lookup-wrappers-which-take-a-svc_rqst
+++ a/fs/nfsd/vfs.c
@@ -113,7 +113,7 @@ nfsd_cross_mnt(struct svc_rqst *rqstp, s
 
 	while (follow_down(&mnt,&mounts)&&d_mountpoint(mounts));
 
-	exp2 = exp_get_by_name(exp->ex_client, mnt, mounts, &rqstp->rq_chandle);
+	exp2 = rqst_exp_get_by_name(rqstp, mnt, mounts);
 	if (IS_ERR(exp2)) {
 		err = PTR_ERR(exp2);
 		dput(mounts);
@@ -188,8 +188,7 @@ nfsd_lookup(struct svc_rqst *rqstp, stru
 			dput(dentry);
 			dentry = dp;
 
-			exp2 = exp_parent(exp->ex_client, mnt, dentry,
-					  &rqstp->rq_chandle);
+			exp2 = rqst_exp_parent(rqstp, mnt, dentry);
 			if (PTR_ERR(exp2) == -ENOENT) {
 				dput(dentry);
 				dentry = dget(dparent);
diff -puN include/linux/nfsd/export.h~knfsd-nfsd-provide-export-lookup-wrappers-which-take-a-svc_rqst include/linux/nfsd/export.h
--- a/include/linux/nfsd/export.h~knfsd-nfsd-provide-export-lookup-wrappers-which-take-a-svc_rqst
+++ a/include/linux/nfsd/export.h
@@ -129,10 +129,16 @@ struct svc_export *	exp_get_by_name(stru
 					struct vfsmount *mnt,
 					struct dentry *dentry,
 					struct cache_req *reqp);
+struct svc_export *	rqst_exp_get_by_name(struct svc_rqst *,
+					     struct vfsmount *,
+					     struct dentry *);
 struct svc_export *	exp_parent(struct auth_domain *clp,
 				   struct vfsmount *mnt,
 				   struct dentry *dentry,
 				   struct cache_req *reqp);
+struct svc_export *	rqst_exp_parent(struct svc_rqst *,
+					struct vfsmount *mnt,
+					struct dentry *dentry);
 int			exp_rootfh(struct auth_domain *, 
 					char *path, struct knfsd_fh *, int maxsize);
 __be32			exp_pseudoroot(struct svc_rqst *, struct svc_fh *);
@@ -152,6 +158,7 @@ static inline void exp_get(struct svc_ex
 extern struct svc_export *
 exp_find(struct auth_domain *clp, int fsid_type, u32 *fsidv,
 	 struct cache_req *reqp);
+struct svc_export * rqst_exp_find(struct svc_rqst *, int, u32 *);
 
 #endif /* __KERNEL__ */
 
_

Patches currently in -mm which might be from bfields@citi.umich.edu are

origin.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
git-vfs-lease-api.patch
