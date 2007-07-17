From: akpm@linux-foundation.org
Subject: - knfsd-nfsd4-return-nfserr_wrongsec.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:05:01 -0700
Message-ID: <200707172305.l6HN51fB011874@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49934 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932454AbXGQXPh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andros@citi.umich.edu, bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: nfsd4: return nfserr_wrongsec
has been removed from the -mm tree.  Its filename was
     knfsd-nfsd4-return-nfserr_wrongsec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: nfsd4: return nfserr_wrongsec
From: Andy Adamson <andros@citi.umich.edu>

Make the first actual use of the secinfo information by using it to return
nfserr_wrongsec when an export is found that doesn't allow the flavor used on
this request.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Andy Adamson <andros@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/export.c            |   26 ++++++++++++++++++++++++++
 fs/nfsd/nfsfh.c             |    6 ++++++
 fs/nfsd/nfssvc.c            |   10 ++++++++++
 fs/nfsd/vfs.c               |    4 ++++
 include/linux/nfsd/export.h |    1 +
 include/linux/nfsd/nfsd.h   |    1 +
 6 files changed, 48 insertions(+)

diff -puN fs/nfsd/export.c~knfsd-nfsd4-return-nfserr_wrongsec fs/nfsd/export.c
--- a/fs/nfsd/export.c~knfsd-nfsd4-return-nfserr_wrongsec
+++ a/fs/nfsd/export.c
@@ -1228,6 +1228,28 @@ exp_find(struct auth_domain *clp, int fs
 	return exp;
 }
 
+__be32 check_nfsd_access(struct svc_export *exp, struct svc_rqst *rqstp)
+{
+	struct exp_flavor_info *f;
+	struct exp_flavor_info *end = exp->ex_flavors + exp->ex_nflavors;
+
+	/* legacy gss-only clients are always OK: */
+	if (exp->ex_client == rqstp->rq_gssclient)
+		return 0;
+	/* ip-address based client; check sec= export option: */
+	for (f = exp->ex_flavors; f < end; f++) {
+		if (f->pseudoflavor == rqstp->rq_flavor)
+			return 0;
+	}
+	/* defaults in absence of sec= options: */
+	if (exp->ex_nflavors == 0) {
+		if (rqstp->rq_flavor == RPC_AUTH_NULL ||
+		    rqstp->rq_flavor == RPC_AUTH_UNIX)
+			return 0;
+	}
+	return nfserr_wrongsec;
+}
+
 /*
  * Uses rq_client and rq_gssclient to find an export; uses rq_client (an
  * auth_unix client) if it's available and has secinfo information;
@@ -1340,6 +1362,10 @@ exp_pseudoroot(struct svc_rqst *rqstp, s
 	if (IS_ERR(exp))
 		return nfserrno(PTR_ERR(exp));
 	rv = fh_compose(fhp, exp, exp->ex_dentry, NULL);
+	if (rv)
+		goto out;
+	rv = check_nfsd_access(exp, rqstp);
+out:
 	exp_put(exp);
 	return rv;
 }
diff -puN fs/nfsd/nfsfh.c~knfsd-nfsd4-return-nfserr_wrongsec fs/nfsd/nfsfh.c
--- a/fs/nfsd/nfsfh.c~knfsd-nfsd4-return-nfserr_wrongsec
+++ a/fs/nfsd/nfsfh.c
@@ -20,6 +20,7 @@
 
 #include <linux/sunrpc/clnt.h>
 #include <linux/sunrpc/svc.h>
+#include <linux/sunrpc/svcauth_gss.h>
 #include <linux/nfsd/nfsd.h>
 
 #define NFSDDBG_FACILITY		NFSDDBG_FH
@@ -248,6 +249,11 @@ fh_verify(struct svc_rqst *rqstp, struct
 	if (error)
 		goto out;
 
+	/* Check security flavor */
+	error = check_nfsd_access(exp, rqstp);
+	if (error)
+		goto out;
+
 	/* Finally, check access permissions. */
 	error = nfsd_permission(exp, dentry, access);
 
diff -puN fs/nfsd/nfssvc.c~knfsd-nfsd4-return-nfserr_wrongsec fs/nfsd/nfssvc.c
--- a/fs/nfsd/nfssvc.c~knfsd-nfsd4-return-nfserr_wrongsec
+++ a/fs/nfsd/nfssvc.c
@@ -494,6 +494,15 @@ out:
 	module_put_and_exit(0);
 }
 
+static __be32 map_new_errors(u32 vers, __be32 nfserr)
+{
+	if (nfserr == nfserr_jukebox && vers == 2)
+		return nfserr_dropit;
+	if (nfserr == nfserr_wrongsec && vers < 4)
+		return nfserr_acces;
+	return nfserr;
+}
+
 int
 nfsd_dispatch(struct svc_rqst *rqstp, __be32 *statp)
 {
@@ -536,6 +545,7 @@ nfsd_dispatch(struct svc_rqst *rqstp, __
 
 	/* Now call the procedure handler, and encode NFS status. */
 	nfserr = proc->pc_func(rqstp, rqstp->rq_argp, rqstp->rq_resp);
+	nfserr = map_new_errors(rqstp->rq_vers, nfserr);
 	if (nfserr == nfserr_jukebox && rqstp->rq_vers == 2)
 		nfserr = nfserr_dropit;
 	if (nfserr == nfserr_dropit) {
diff -puN fs/nfsd/vfs.c~knfsd-nfsd4-return-nfserr_wrongsec fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~knfsd-nfsd4-return-nfserr_wrongsec
+++ a/fs/nfsd/vfs.c
@@ -240,6 +240,9 @@ nfsd_lookup(struct svc_rqst *rqstp, stru
 	err = nfsd_lookup_dentry(rqstp, fhp, name, len, &exp, &dentry);
 	if (err)
 		return err;
+	err = check_nfsd_access(exp, rqstp);
+	if (err)
+		goto out;
 	/*
 	 * Note: we compose the file handle now, but as the
 	 * dentry may be negative, it may need to be updated.
@@ -247,6 +250,7 @@ nfsd_lookup(struct svc_rqst *rqstp, stru
 	err = fh_compose(resfh, exp, dentry, fhp);
 	if (!err && !dentry->d_inode)
 		err = nfserr_noent;
+out:
 	dput(dentry);
 	exp_put(exp);
 	return err;
diff -puN include/linux/nfsd/export.h~knfsd-nfsd4-return-nfserr_wrongsec include/linux/nfsd/export.h
--- a/include/linux/nfsd/export.h~knfsd-nfsd4-return-nfserr_wrongsec
+++ a/include/linux/nfsd/export.h
@@ -116,6 +116,7 @@ struct svc_expkey {
 #define EX_NOHIDE(exp)		((exp)->ex_flags & NFSEXP_NOHIDE)
 #define EX_WGATHER(exp)		((exp)->ex_flags & NFSEXP_GATHERED_WRITES)
 
+__be32 check_nfsd_access(struct svc_export *exp, struct svc_rqst *rqstp);
 
 /*
  * Function declarations
diff -puN include/linux/nfsd/nfsd.h~knfsd-nfsd4-return-nfserr_wrongsec include/linux/nfsd/nfsd.h
--- a/include/linux/nfsd/nfsd.h~knfsd-nfsd4-return-nfserr_wrongsec
+++ a/include/linux/nfsd/nfsd.h
@@ -236,6 +236,7 @@ void		nfsd_lockd_shutdown(void);
 #define	nfserr_badname		__constant_htonl(NFSERR_BADNAME)
 #define	nfserr_cb_path_down	__constant_htonl(NFSERR_CB_PATH_DOWN)
 #define	nfserr_locked		__constant_htonl(NFSERR_LOCKED)
+#define	nfserr_wrongsec		__constant_htonl(NFSERR_WRONGSEC)
 #define	nfserr_replay_me	__constant_htonl(NFSERR_REPLAY_ME)
 
 /* error codes for internal use */
_

Patches currently in -mm which might be from andros@citi.umich.edu are

origin.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
