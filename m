From: akpm@linux-foundation.org
Subject: - knfsd-nfsd-use-ip-address-based-domain-in-secinfo-case.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:04:57 -0700
Message-ID: <200707172304.l6HN4vAc011868@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34836 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935896AbXGQXPZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: nfsd: use ip-address-based domain in secinfo case
has been removed from the -mm tree.  Its filename was
     knfsd-nfsd-use-ip-address-based-domain-in-secinfo-case.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: nfsd: use ip-address-based domain in secinfo case
From: J. Bruce Fields <bfields@citi.umich.edu>

With this patch, we fall back on using the gss/pseudoflavor only if we fail to
find a matching auth_unix export that has a secinfo list.

As long as sec= options aren't used, there's still no change in behavior here
(except possibly for some additional auth_unix cache lookups, whose results
will be ignored).

The sec= option, however, is not actually enforced yet; later patches will add
the necessary checks.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/export.c |   76 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 67 insertions(+), 9 deletions(-)

diff -puN fs/nfsd/export.c~knfsd-nfsd-use-ip-address-based-domain-in-secinfo-case fs/nfsd/export.c
--- a/fs/nfsd/export.c~knfsd-nfsd-use-ip-address-based-domain-in-secinfo-case
+++ a/fs/nfsd/export.c
@@ -1229,6 +1229,10 @@ exp_find(struct auth_domain *clp, int fs
 }
 
 /*
+ * Uses rq_client and rq_gssclient to find an export; uses rq_client (an
+ * auth_unix client) if it's available and has secinfo information;
+ * otherwise, will try to use rq_gssclient.
+ *
  * Called from functions that handle requests; functions that do work on
  * behalf of mountd are passed a single client name to use, and should
  * use exp_get_by_name() or exp_find().
@@ -1237,29 +1241,83 @@ struct svc_export *
 rqst_exp_get_by_name(struct svc_rqst *rqstp, struct vfsmount *mnt,
 		struct dentry *dentry)
 {
-	struct auth_domain *clp;
+	struct svc_export *gssexp, *exp = NULL;
 
-	clp = rqstp->rq_gssclient ? rqstp->rq_gssclient : rqstp->rq_client;
-	return exp_get_by_name(clp, mnt, dentry, &rqstp->rq_chandle);
+	if (rqstp->rq_client == NULL)
+		goto gss;
+
+	/* First try the auth_unix client: */
+	exp = exp_get_by_name(rqstp->rq_client, mnt, dentry,
+						&rqstp->rq_chandle);
+	if (PTR_ERR(exp) == -ENOENT)
+		goto gss;
+	if (IS_ERR(exp))
+		return exp;
+	/* If it has secinfo, assume there are no gss/... clients */
+	if (exp->ex_nflavors > 0)
+		return exp;
+gss:
+	/* Otherwise, try falling back on gss client */
+	if (rqstp->rq_gssclient == NULL)
+		return exp;
+	gssexp = exp_get_by_name(rqstp->rq_gssclient, mnt, dentry,
+						&rqstp->rq_chandle);
+	if (PTR_ERR(gssexp) == -ENOENT)
+		return exp;
+	if (exp && !IS_ERR(exp))
+		exp_put(exp);
+	return gssexp;
 }
 
 struct svc_export *
 rqst_exp_find(struct svc_rqst *rqstp, int fsid_type, u32 *fsidv)
 {
-	struct auth_domain *clp;
+	struct svc_export *gssexp, *exp = NULL;
 
-	clp = rqstp->rq_gssclient ? rqstp->rq_gssclient : rqstp->rq_client;
-	return exp_find(clp, fsid_type, fsidv, &rqstp->rq_chandle);
+	if (rqstp->rq_client == NULL)
+		goto gss;
+
+	/* First try the auth_unix client: */
+	exp = exp_find(rqstp->rq_client, fsid_type, fsidv, &rqstp->rq_chandle);
+	if (PTR_ERR(exp) == -ENOENT)
+		goto gss;
+	if (IS_ERR(exp))
+		return exp;
+	/* If it has secinfo, assume there are no gss/... clients */
+	if (exp->ex_nflavors > 0)
+		return exp;
+gss:
+	/* Otherwise, try falling back on gss client */
+	if (rqstp->rq_gssclient == NULL)
+		return exp;
+	gssexp = exp_find(rqstp->rq_gssclient, fsid_type, fsidv,
+						&rqstp->rq_chandle);
+	if (PTR_ERR(gssexp) == -ENOENT)
+		return exp;
+	if (exp && !IS_ERR(exp))
+		exp_put(exp);
+	return gssexp;
 }
 
 struct svc_export *
 rqst_exp_parent(struct svc_rqst *rqstp, struct vfsmount *mnt,
 		struct dentry *dentry)
 {
-	struct auth_domain *clp;
+	struct svc_export *exp;
+
+	dget(dentry);
+	exp = rqst_exp_get_by_name(rqstp, mnt, dentry);
 
-	clp = rqstp->rq_gssclient ? rqstp->rq_gssclient : rqstp->rq_client;
-	return exp_parent(rqstp->rq_client, mnt, dentry, &rqstp->rq_chandle);
+	while (PTR_ERR(exp) == -ENOENT && !IS_ROOT(dentry)) {
+		struct dentry *parent;
+
+		parent = dget_parent(dentry);
+		dput(dentry);
+		dentry = parent;
+		exp = rqst_exp_get_by_name(rqstp, mnt, dentry);
+	}
+	dput(dentry);
+	return exp;
 }
 
 /*
_

Patches currently in -mm which might be from bfields@citi.umich.edu are

origin.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
git-vfs-lease-api.patch
