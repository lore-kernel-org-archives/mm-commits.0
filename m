From: akpm@linux-foundation.org
Subject: - knfsd-nfsd-factor-nfsd_lookup-into-2-pieces.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:04:59 -0700
Message-ID: <200707172304.l6HN4xes011871@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47555 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935712AbXGQXPY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: nfsd: factor nfsd_lookup into 2 pieces
has been removed from the -mm tree.  Its filename was
     knfsd-nfsd-factor-nfsd_lookup-into-2-pieces.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: nfsd: factor nfsd_lookup into 2 pieces
From: J. Bruce Fields <bfields@citi.umich.edu>

Factor nfsd_lookup into nfsd_lookup_dentry, which finds the right dentry and
export, and a second part which composes the filehandle (and which will later
check the security flavor on the new export).

No change in behavior.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/vfs.c |   55 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 36 insertions(+), 19 deletions(-)

diff -puN fs/nfsd/vfs.c~knfsd-nfsd-factor-nfsd_lookup-into-2-pieces fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~knfsd-nfsd-factor-nfsd_lookup-into-2-pieces
+++ a/fs/nfsd/vfs.c
@@ -135,21 +135,10 @@ out:
 	return err;
 }
 
-/*
- * Look up one component of a pathname.
- * N.B. After this call _both_ fhp and resfh need an fh_put
- *
- * If the lookup would cross a mountpoint, and the mounted filesystem
- * is exported to the client with NFSEXP_NOHIDE, then the lookup is
- * accepted as it stands and the mounted directory is
- * returned. Otherwise the covered directory is returned.
- * NOTE: this mountpoint crossing is not supported properly by all
- *   clients and is explicitly disallowed for NFSv3
- *      NeilBrown <neilb@cse.unsw.edu.au>
- */
 __be32
-nfsd_lookup(struct svc_rqst *rqstp, struct svc_fh *fhp, const char *name,
-					int len, struct svc_fh *resfh)
+nfsd_lookup_dentry(struct svc_rqst *rqstp, struct svc_fh *fhp,
+		   const char *name, int len,
+		   struct svc_export **exp_ret, struct dentry **dentry_ret)
 {
 	struct svc_export	*exp;
 	struct dentry		*dparent;
@@ -219,6 +208,38 @@ nfsd_lookup(struct svc_rqst *rqstp, stru
 			}
 		}
 	}
+	*dentry_ret = dentry;
+	*exp_ret = exp;
+	return 0;
+
+out_nfserr:
+	exp_put(exp);
+	return nfserrno(host_err);
+}
+
+/*
+ * Look up one component of a pathname.
+ * N.B. After this call _both_ fhp and resfh need an fh_put
+ *
+ * If the lookup would cross a mountpoint, and the mounted filesystem
+ * is exported to the client with NFSEXP_NOHIDE, then the lookup is
+ * accepted as it stands and the mounted directory is
+ * returned. Otherwise the covered directory is returned.
+ * NOTE: this mountpoint crossing is not supported properly by all
+ *   clients and is explicitly disallowed for NFSv3
+ *      NeilBrown <neilb@cse.unsw.edu.au>
+ */
+__be32
+nfsd_lookup(struct svc_rqst *rqstp, struct svc_fh *fhp, const char *name,
+					int len, struct svc_fh *resfh)
+{
+	struct svc_export	*exp;
+	struct dentry		*dentry;
+	__be32 err;
+
+	err = nfsd_lookup_dentry(rqstp, fhp, name, len, &exp, &dentry);
+	if (err)
+		return err;
 	/*
 	 * Note: we compose the file handle now, but as the
 	 * dentry may be negative, it may need to be updated.
@@ -227,15 +248,11 @@ nfsd_lookup(struct svc_rqst *rqstp, stru
 	if (!err && !dentry->d_inode)
 		err = nfserr_noent;
 	dput(dentry);
-out:
 	exp_put(exp);
 	return err;
-
-out_nfserr:
-	err = nfserrno(host_err);
-	goto out;
 }
 
+
 /*
  * Set various file attributes.
  * N.B. After this call fhp needs an fh_put
_

Patches currently in -mm which might be from bfields@citi.umich.edu are

origin.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
git-vfs-lease-api.patch
