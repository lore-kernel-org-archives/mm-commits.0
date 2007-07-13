From: akpm@linux-foundation.org
Subject: + knfsd-nfsd-factor-nfsd_lookup-into-2-pieces.patch added to -mm tree
Date: Fri, 13 Jul 2007 00:33:58 -0700
Message-ID: <200707130733.l6D7XwC0005356@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34437 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760784AbXGMHeI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 03:34:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@citi.umich.edu, neilb@suse.de


The patch titled
     knfsd: nfsd: factor nfsd_lookup into 2 pieces
has been added to the -mm tree.  Its filename is
     knfsd-nfsd-factor-nfsd_lookup-into-2-pieces.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

auth_gss-unregister-gss_domain-when-unloading-module.patch
git-vfs-lease-api.patch
fix-trivial-typos-in-anon_inodesc-comments.patch
knfsd-lockd-nfsd4-use-same-grace-period-for-lockd-and-nfsd4.patch
knfsd-nfsd4-fix-nfsv4-filehandle-size-units-confusion.patch
knfsd-nfsd4-silence-a-compiler-warning-in-acl-code.patch
knfsd-nfsd4-fix-enc_stateid_sz-for-nfsd-callbacks.patch
knfsd-nfsd4-fix-handling-of-acl-errrors.patch
knfsd-nfsd-remove-unused-header-interfaceh.patch
knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size.patch
knfsd-nfsd4-dont-delegate-files-that-have-had-conflicts.patch
knfsd-nfsd-make-all-exp_finding-functions-return-errnos-on-err.patch
knfsd-nfsd4-build-rpcsec_gss-whenever-nfsd4-is-built.patch
knfsd-nfsd4-store-pseudoflavor-in-request.patch
knfsd-nfsd4-parse-secinfo-information-in-exports-downcall.patch
knfsd-nfsd4-simplify-exp_pseudoroot-arguments.patch
knfsd-nfsd-remove-superfluous-assignment-from-nfsd_lookup.patch
knfsd-nfsd-provide-export-lookup-wrappers-which-take-a-svc_rqst.patch
knfsd-nfsd-set-rq_client-to-ip-address-determined-domain.patch
knfsd-nfsd-use-ip-address-based-domain-in-secinfo-case.patch
knfsd-nfsd-factor-nfsd_lookup-into-2-pieces.patch
knfsd-nfsd4-return-nfserr_wrongsec.patch
knfsd-nfsd4-make-readonly-access-depend-on-pseudoflavor.patch
knfsd-nfsd-factor-out-code-from-show_expflags.patch
knfsd-nfsd-display-export-secinfo-information.patch
knfsd-rpc-add-gss-krb5-and-spkm3-oid-values.patch
knfsd-nfsd4-implement-secinfo.patch
knfsd-nfsd4-secinfo-handling-without-secinfo=-option.patch
knfsd-nfsd-allow-auth_sys-nlm-on-rpcsec_gss-exports.patch
knfsd-nfsd-enforce-per-flavor-id-squashing.patch
