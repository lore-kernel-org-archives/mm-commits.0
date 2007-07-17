From: akpm@linux-foundation.org
Subject: - knfsd-nfsd4-implement-secinfo.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:05:11 -0700
Message-ID: <200707172305.l6HN5BvZ011895@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34273 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936594AbXGQXPx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andros@citi.umich.edu, bfields@citi.umich.edu, neilb@suse.de, uketinen@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     knfsd: nfsd4: implement secinfo
has been removed from the -mm tree.  Its filename was
     knfsd-nfsd4-implement-secinfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: nfsd4: implement secinfo
From: Andy Adamson <andros@citi.umich.edu>

Implement the secinfo operation.

(Thanks to Usha Ketineni wrote an earlier version of this support.)

Cc: Usha Ketineni <uketinen@us.ibm.com>
Signed-off-by: Andy Adamson <andros@citi.umich.edu>
Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4proc.c        |   28 +++++++++++++
 fs/nfsd/nfs4xdr.c         |   75 ++++++++++++++++++++++++++++++++++++
 include/linux/nfsd/nfsd.h |    3 +
 include/linux/nfsd/xdr4.h |    7 +++
 4 files changed, 113 insertions(+)

diff -puN fs/nfsd/nfs4proc.c~knfsd-nfsd4-implement-secinfo fs/nfsd/nfs4proc.c
--- a/fs/nfsd/nfs4proc.c~knfsd-nfsd4-implement-secinfo
+++ a/fs/nfsd/nfs4proc.c
@@ -47,6 +47,7 @@
 #include <linux/nfsd/state.h>
 #include <linux/nfsd/xdr4.h>
 #include <linux/nfs4_acl.h>
+#include <linux/sunrpc/gss_api.h>
 
 #define NFSDDBG_FACILITY		NFSDDBG_PROC
 
@@ -610,6 +611,30 @@ nfsd4_rename(struct svc_rqst *rqstp, str
 }
 
 static __be32
+nfsd4_secinfo(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
+	      struct nfsd4_secinfo *secinfo)
+{
+	struct svc_fh resfh;
+	struct svc_export *exp;
+	struct dentry *dentry;
+	__be32 err;
+
+	fh_init(&resfh, NFS4_FHSIZE);
+	err = nfsd_lookup_dentry(rqstp, &cstate->current_fh,
+				    secinfo->si_name, secinfo->si_namelen,
+				    &exp, &dentry);
+	if (err)
+		return err;
+	if (dentry->d_inode == NULL) {
+		exp_put(exp);
+		err = nfserr_noent;
+	} else
+		secinfo->si_exp = exp;
+	dput(dentry);
+	return err;
+}
+
+static __be32
 nfsd4_setattr(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	      struct nfsd4_setattr *setattr)
 {
@@ -1008,6 +1033,9 @@ static struct nfsd4_operation nfsd4_ops[
 	[OP_SAVEFH] = {
 		.op_func = (nfsd4op_func)nfsd4_savefh,
 	},
+	[OP_SECINFO] = {
+		.op_func = (nfsd4op_func)nfsd4_secinfo,
+	},
 	[OP_SETATTR] = {
 		.op_func = (nfsd4op_func)nfsd4_setattr,
 	},
diff -puN fs/nfsd/nfs4xdr.c~knfsd-nfsd4-implement-secinfo fs/nfsd/nfs4xdr.c
--- a/fs/nfsd/nfs4xdr.c~knfsd-nfsd4-implement-secinfo
+++ a/fs/nfsd/nfs4xdr.c
@@ -56,6 +56,7 @@
 #include <linux/nfsd_idmap.h>
 #include <linux/nfs4.h>
 #include <linux/nfs4_acl.h>
+#include <linux/sunrpc/gss_api.h>
 
 #define NFSDDBG_FACILITY		NFSDDBG_XDR
 
@@ -819,6 +820,23 @@ nfsd4_decode_renew(struct nfsd4_compound
 }
 
 static __be32
+nfsd4_decode_secinfo(struct nfsd4_compoundargs *argp,
+		     struct nfsd4_secinfo *secinfo)
+{
+	DECODE_HEAD;
+
+	READ_BUF(4);
+	READ32(secinfo->si_namelen);
+	READ_BUF(secinfo->si_namelen);
+	SAVEMEM(secinfo->si_name, secinfo->si_namelen);
+	status = check_filename(secinfo->si_name, secinfo->si_namelen,
+								nfserr_noent);
+	if (status)
+		return status;
+	DECODE_TAIL;
+}
+
+static __be32
 nfsd4_decode_setattr(struct nfsd4_compoundargs *argp, struct nfsd4_setattr *setattr)
 {
 	DECODE_HEAD;
@@ -1131,6 +1149,9 @@ nfsd4_decode_compound(struct nfsd4_compo
 		case OP_SAVEFH:
 			op->status = nfs_ok;
 			break;
+		case OP_SECINFO:
+			op->status = nfsd4_decode_secinfo(argp, &op->u.secinfo);
+			break;
 		case OP_SETATTR:
 			op->status = nfsd4_decode_setattr(argp, &op->u.setattr);
 			break;
@@ -1847,11 +1868,19 @@ nfsd4_encode_dirent_fattr(struct nfsd4_r
 	if (d_mountpoint(dentry)) {
 		int err;
 
+		/*
+		 * Why the heck aren't we just using nfsd_lookup??
+		 * Different "."/".." handling?  Something else?
+		 * At least, add a comment here to explain....
+		 */
 		err = nfsd_cross_mnt(cd->rd_rqstp, &dentry, &exp);
 		if (err) {
 			nfserr = nfserrno(err);
 			goto out_put;
 		}
+		nfserr = check_nfsd_access(exp, cd->rd_rqstp);
+		if (nfserr)
+			goto out_put;
 
 	}
 	nfserr = nfsd4_encode_fattr(NULL, exp, dentry, p, buflen, cd->rd_bmval,
@@ -2419,6 +2448,49 @@ nfsd4_encode_rename(struct nfsd4_compoun
 	}
 }
 
+static void
+nfsd4_encode_secinfo(struct nfsd4_compoundres *resp, int nfserr,
+		     struct nfsd4_secinfo *secinfo)
+{
+	int i = 0;
+	struct svc_export *exp = secinfo->si_exp;
+	ENCODE_HEAD;
+
+	if (nfserr)
+		goto out;
+	RESERVE_SPACE(4);
+	WRITE32(exp->ex_nflavors);
+	ADJUST_ARGS();
+	for (i = 0; i < exp->ex_nflavors; i++) {
+		u32 flav = exp->ex_flavors[i].pseudoflavor;
+		struct gss_api_mech *gm = gss_mech_get_by_pseudoflavor(flav);
+
+		if (gm) {
+			RESERVE_SPACE(4);
+			WRITE32(RPC_AUTH_GSS);
+			ADJUST_ARGS();
+			RESERVE_SPACE(4 + gm->gm_oid.len);
+			WRITE32(gm->gm_oid.len);
+			WRITEMEM(gm->gm_oid.data, gm->gm_oid.len);
+			ADJUST_ARGS();
+			RESERVE_SPACE(4);
+			WRITE32(0); /* qop */
+			ADJUST_ARGS();
+			RESERVE_SPACE(4);
+			WRITE32(gss_pseudoflavor_to_service(gm, flav));
+			ADJUST_ARGS();
+			gss_mech_put(gm);
+		} else {
+			RESERVE_SPACE(4);
+			WRITE32(flav);
+			ADJUST_ARGS();
+		}
+	}
+out:
+	if (exp)
+		exp_put(exp);
+}
+
 /*
  * The SETATTR encode routine is special -- it always encodes a bitmap,
  * regardless of the error status.
@@ -2559,6 +2631,9 @@ nfsd4_encode_operation(struct nfsd4_comp
 		break;
 	case OP_SAVEFH:
 		break;
+	case OP_SECINFO:
+		nfsd4_encode_secinfo(resp, op->status, &op->u.secinfo);
+		break;
 	case OP_SETATTR:
 		nfsd4_encode_setattr(resp, op->status, &op->u.setattr);
 		break;
diff -puN include/linux/nfsd/nfsd.h~knfsd-nfsd4-implement-secinfo include/linux/nfsd/nfsd.h
--- a/include/linux/nfsd/nfsd.h~knfsd-nfsd4-implement-secinfo
+++ a/include/linux/nfsd/nfsd.h
@@ -71,6 +71,9 @@ int		nfsd_cross_mnt(struct svc_rqst *rqs
 		                struct svc_export **expp);
 __be32		nfsd_lookup(struct svc_rqst *, struct svc_fh *,
 				const char *, int, struct svc_fh *);
+__be32		 nfsd_lookup_dentry(struct svc_rqst *, struct svc_fh *,
+				const char *, int,
+				struct svc_export **, struct dentry **);
 __be32		nfsd_setattr(struct svc_rqst *, struct svc_fh *,
 				struct iattr *, int, time_t);
 #ifdef CONFIG_NFSD_V4
diff -puN include/linux/nfsd/xdr4.h~knfsd-nfsd4-implement-secinfo include/linux/nfsd/xdr4.h
--- a/include/linux/nfsd/xdr4.h~knfsd-nfsd4-implement-secinfo
+++ a/include/linux/nfsd/xdr4.h
@@ -293,6 +293,12 @@ struct nfsd4_rename {
 	struct nfsd4_change_info  rn_tinfo; /* response */
 };
 
+struct nfsd4_secinfo {
+	u32 si_namelen;					/* request */
+	char *si_name;					/* request */
+	struct svc_export *si_exp;			/* response */
+};
+
 struct nfsd4_setattr {
 	stateid_t	sa_stateid;         /* request */
 	u32		sa_bmval[2];        /* request */
@@ -365,6 +371,7 @@ struct nfsd4_op {
 		struct nfsd4_remove		remove;
 		struct nfsd4_rename		rename;
 		clientid_t			renew;
+		struct nfsd4_secinfo		secinfo;
 		struct nfsd4_setattr		setattr;
 		struct nfsd4_setclientid	setclientid;
 		struct nfsd4_setclientid_confirm setclientid_confirm;
_

Patches currently in -mm which might be from andros@citi.umich.edu are

origin.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
