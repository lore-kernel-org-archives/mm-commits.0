From: akpm@linux-foundation.org
Subject: - nfsd-return-errors-not-null-from-export-functions.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:04:38 -0700
Message-ID: <200707192004.l6JK4cFW019967@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59738 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760803AbXGSUR6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:17:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     nfsd: return errors, not NULL, from export functions
has been removed from the -mm tree.  Its filename was
     nfsd-return-errors-not-null-from-export-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: nfsd: return errors, not NULL, from export functions
From: J. Bruce Fields <bfields@citi.umich.edu>

I converted the various export-returning functions to return -ENOENT instead
of NULL, but missed a few cases.

This particular case could cause actual bugs in the case of a krb5 client that
doesn't match any ip-based client and that is trying to access a filesystem
not exported to krb5 clients.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Acked-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/export.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/nfsd/export.c~nfsd-return-errors-not-null-from-export-functions fs/nfsd/export.c
--- a/fs/nfsd/export.c~nfsd-return-errors-not-null-from-export-functions
+++ a/fs/nfsd/export.c
@@ -1265,7 +1265,7 @@ struct svc_export *
 rqst_exp_get_by_name(struct svc_rqst *rqstp, struct vfsmount *mnt,
 		struct dentry *dentry)
 {
-	struct svc_export *gssexp, *exp = NULL;
+	struct svc_export *gssexp, *exp = ERR_PTR(-ENOENT);
 
 	if (rqstp->rq_client == NULL)
 		goto gss;
@@ -1288,7 +1288,7 @@ gss:
 						&rqstp->rq_chandle);
 	if (PTR_ERR(gssexp) == -ENOENT)
 		return exp;
-	if (exp && !IS_ERR(exp))
+	if (!IS_ERR(exp))
 		exp_put(exp);
 	return gssexp;
 }
@@ -1296,7 +1296,7 @@ gss:
 struct svc_export *
 rqst_exp_find(struct svc_rqst *rqstp, int fsid_type, u32 *fsidv)
 {
-	struct svc_export *gssexp, *exp = NULL;
+	struct svc_export *gssexp, *exp = ERR_PTR(-ENOENT);
 
 	if (rqstp->rq_client == NULL)
 		goto gss;
@@ -1318,7 +1318,7 @@ gss:
 						&rqstp->rq_chandle);
 	if (PTR_ERR(gssexp) == -ENOENT)
 		return exp;
-	if (exp && !IS_ERR(exp))
+	if (!IS_ERR(exp))
 		exp_put(exp);
 	return gssexp;
 }
_

Patches currently in -mm which might be from bfields@citi.umich.edu are

origin.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
vfs-fix-a-race-in-lease-breaking-during-truncate.patch
locks-kill-redundant-local-variable.patch
