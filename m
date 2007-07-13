From: akpm@linux-foundation.org
Subject: + knfsd-nfsd4-make-readonly-access-depend-on-pseudoflavor.patch added to -mm tree
Date: Fri, 13 Jul 2007 00:34:01 -0700
Message-ID: <200707130734.l6D7Y1Fk005431@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35685 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761662AbXGMHeM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 03:34:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@citi.umich.edu, neilb@suse.de


The patch titled
     knfsd: nfsd4: make readonly access depend on pseudoflavor
has been added to the -mm tree.  Its filename is
     knfsd-nfsd4-make-readonly-access-depend-on-pseudoflavor.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: nfsd4: make readonly access depend on pseudoflavor
From: J. Bruce Fields <bfields@citi.umich.edu>

Allow readonly access to vary depending on the pseudoflavor, using the flag
passed with each pseudoflavor in the export downcall.  The rest of the flags
are ignored for now, though some day we might also allow id squashing to vary
based on the flavor.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfsfh.c             |    2 +-
 fs/nfsd/nfsproc.c           |    3 ++-
 fs/nfsd/vfs.c               |   13 +++++++------
 include/linux/nfsd/export.h |   13 ++++++++++++-
 include/linux/nfsd/nfsd.h   |    3 ++-
 5 files changed, 24 insertions(+), 10 deletions(-)

diff -puN fs/nfsd/nfsfh.c~knfsd-nfsd4-make-readonly-access-depend-on-pseudoflavor fs/nfsd/nfsfh.c
--- a/fs/nfsd/nfsfh.c~knfsd-nfsd4-make-readonly-access-depend-on-pseudoflavor
+++ a/fs/nfsd/nfsfh.c
@@ -255,7 +255,7 @@ fh_verify(struct svc_rqst *rqstp, struct
 		goto out;
 
 	/* Finally, check access permissions. */
-	error = nfsd_permission(exp, dentry, access);
+	error = nfsd_permission(rqstp, exp, dentry, access);
 
 	if (error) {
 		dprintk("fh_verify: %s/%s permission failure, "
diff -puN fs/nfsd/nfsproc.c~knfsd-nfsd4-make-readonly-access-depend-on-pseudoflavor fs/nfsd/nfsproc.c
--- a/fs/nfsd/nfsproc.c~knfsd-nfsd4-make-readonly-access-depend-on-pseudoflavor
+++ a/fs/nfsd/nfsproc.c
@@ -278,7 +278,8 @@ nfsd_proc_create(struct svc_rqst *rqstp,
 					 *   echo thing > device-special-file-or-pipe
 					 * by doing a CREATE with type==0
 					 */
-					nfserr = nfsd_permission(newfhp->fh_export,
+					nfserr = nfsd_permission(rqstp,
+								 newfhp->fh_export,
 								 newfhp->fh_dentry,
 								 MAY_WRITE|MAY_LOCAL_ACCESS);
 					if (nfserr && nfserr != nfserr_rofs)
diff -puN fs/nfsd/vfs.c~knfsd-nfsd4-make-readonly-access-depend-on-pseudoflavor fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~knfsd-nfsd4-make-readonly-access-depend-on-pseudoflavor
+++ a/fs/nfsd/vfs.c
@@ -328,7 +328,7 @@ nfsd_setattr(struct svc_rqst *rqstp, str
 	/* The size case is special. It changes the file as well as the attributes.  */
 	if (iap->ia_valid & ATTR_SIZE) {
 		if (iap->ia_size < inode->i_size) {
-			err = nfsd_permission(fhp->fh_export, dentry, MAY_TRUNC|MAY_OWNER_OVERRIDE);
+			err = nfsd_permission(rqstp, fhp->fh_export, dentry, MAY_TRUNC|MAY_OWNER_OVERRIDE);
 			if (err)
 				goto out;
 		}
@@ -616,7 +616,7 @@ nfsd_access(struct svc_rqst *rqstp, stru
 
 			sresult |= map->access;
 
-			err2 = nfsd_permission(export, dentry, map->how);
+			err2 = nfsd_permission(rqstp, export, dentry, map->how);
 			switch (err2) {
 			case nfs_ok:
 				result |= map->access;
@@ -1042,7 +1042,7 @@ nfsd_read(struct svc_rqst *rqstp, struct
 	__be32		err;
 
 	if (file) {
-		err = nfsd_permission(fhp->fh_export, fhp->fh_dentry,
+		err = nfsd_permission(rqstp, fhp->fh_export, fhp->fh_dentry,
 				MAY_READ|MAY_OWNER_OVERRIDE);
 		if (err)
 			goto out;
@@ -1071,7 +1071,7 @@ nfsd_write(struct svc_rqst *rqstp, struc
 	__be32			err = 0;
 
 	if (file) {
-		err = nfsd_permission(fhp->fh_export, fhp->fh_dentry,
+		err = nfsd_permission(rqstp, fhp->fh_export, fhp->fh_dentry,
 				MAY_WRITE|MAY_OWNER_OVERRIDE);
 		if (err)
 			goto out;
@@ -1800,7 +1800,8 @@ nfsd_statfs(struct svc_rqst *rqstp, stru
  * Check for a user's access permissions to this inode.
  */
 __be32
-nfsd_permission(struct svc_export *exp, struct dentry *dentry, int acc)
+nfsd_permission(struct svc_rqst *rqstp, struct svc_export *exp,
+					struct dentry *dentry, int acc)
 {
 	struct inode	*inode = dentry->d_inode;
 	int		err;
@@ -1831,7 +1832,7 @@ nfsd_permission(struct svc_export *exp, 
 	 */
 	if (!(acc & MAY_LOCAL_ACCESS))
 		if (acc & (MAY_WRITE | MAY_SATTR | MAY_TRUNC)) {
-			if (EX_RDONLY(exp) || IS_RDONLY(inode))
+			if (EX_RDONLY(exp, rqstp) || IS_RDONLY(inode))
 				return nfserr_rofs;
 			if (/* (acc & MAY_WRITE) && */ IS_IMMUTABLE(inode))
 				return nfserr_perm;
diff -puN include/linux/nfsd/export.h~knfsd-nfsd4-make-readonly-access-depend-on-pseudoflavor include/linux/nfsd/export.h
--- a/include/linux/nfsd/export.h~knfsd-nfsd4-make-readonly-access-depend-on-pseudoflavor
+++ a/include/linux/nfsd/export.h
@@ -112,10 +112,21 @@ struct svc_expkey {
 
 #define EX_SECURE(exp)		(!((exp)->ex_flags & NFSEXP_INSECURE_PORT))
 #define EX_ISSYNC(exp)		(!((exp)->ex_flags & NFSEXP_ASYNC))
-#define EX_RDONLY(exp)		((exp)->ex_flags & NFSEXP_READONLY)
 #define EX_NOHIDE(exp)		((exp)->ex_flags & NFSEXP_NOHIDE)
 #define EX_WGATHER(exp)		((exp)->ex_flags & NFSEXP_GATHERED_WRITES)
 
+static inline int EX_RDONLY(struct svc_export *exp, struct svc_rqst *rqstp)
+{
+	struct exp_flavor_info *f;
+	struct exp_flavor_info *end = exp->ex_flavors + exp->ex_nflavors;
+
+	for (f = exp->ex_flavors; f < end; f++) {
+		if (f->pseudoflavor == rqstp->rq_flavor)
+			return f->flags & NFSEXP_READONLY;
+	}
+	return exp->ex_flags & NFSEXP_READONLY;
+}
+
 __be32 check_nfsd_access(struct svc_export *exp, struct svc_rqst *rqstp);
 
 /*
diff -puN include/linux/nfsd/nfsd.h~knfsd-nfsd4-make-readonly-access-depend-on-pseudoflavor include/linux/nfsd/nfsd.h
--- a/include/linux/nfsd/nfsd.h~knfsd-nfsd4-make-readonly-access-depend-on-pseudoflavor
+++ a/include/linux/nfsd/nfsd.h
@@ -119,7 +119,8 @@ __be32		nfsd_statfs(struct svc_rqst *, s
 				struct kstatfs *);
 
 int		nfsd_notify_change(struct inode *, struct iattr *);
-__be32		nfsd_permission(struct svc_export *, struct dentry *, int);
+__be32		nfsd_permission(struct svc_rqst *, struct svc_export *,
+				struct dentry *, int);
 int		nfsd_sync_dir(struct dentry *dp);
 
 #if defined(CONFIG_NFSD_V2_ACL) || defined(CONFIG_NFSD_V3_ACL)
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
