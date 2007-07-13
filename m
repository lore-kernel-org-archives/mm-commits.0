From: akpm@linux-foundation.org
Subject: + knfsd-nfsd-enforce-per-flavor-id-squashing.patch added to -mm tree
Date: Fri, 13 Jul 2007 00:34:10 -0700
Message-ID: <200707130734.l6D7YAD7005460@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59692 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935975AbXGMHpA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 03:45:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@citi.umich.edu, neilb@suse.de


The patch titled
     knfsd: nfsd: enforce per-flavor id squashing
has been added to the -mm tree.  Its filename is
     knfsd-nfsd-enforce-per-flavor-id-squashing.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: nfsd: enforce per-flavor id squashing
From: J. Bruce Fields <bfields@citi.umich.edu>

Allow root squashing to vary per-pseudoflavor, so that you can (for example)
allow root access only when sufficiently strong security is in use.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/auth.c              |   18 ++++++++++++++++--
 include/linux/nfsd/export.h |    3 ++-
 2 files changed, 18 insertions(+), 3 deletions(-)

diff -puN fs/nfsd/auth.c~knfsd-nfsd-enforce-per-flavor-id-squashing fs/nfsd/auth.c
--- a/fs/nfsd/auth.c~knfsd-nfsd-enforce-per-flavor-id-squashing
+++ a/fs/nfsd/auth.c
@@ -12,17 +12,31 @@
 
 #define	CAP_NFSD_MASK (CAP_FS_MASK|CAP_TO_MASK(CAP_SYS_RESOURCE))
 
+static int nfsexp_flags(struct svc_rqst *rqstp, struct svc_export *exp)
+{
+	struct exp_flavor_info *f;
+	struct exp_flavor_info *end = exp->ex_flavors + exp->ex_nflavors;
+
+	for (f = exp->ex_flavors; f < end; f++) {
+		if (f->pseudoflavor == rqstp->rq_flavor)
+			return f->flags;
+	}
+	return exp->ex_flags;
+
+}
+
 int nfsd_setuser(struct svc_rqst *rqstp, struct svc_export *exp)
 {
 	struct svc_cred	cred = rqstp->rq_cred;
 	int i;
+	int flags = nfsexp_flags(rqstp, exp);
 	int ret;
 
-	if (exp->ex_flags & NFSEXP_ALLSQUASH) {
+	if (flags & NFSEXP_ALLSQUASH) {
 		cred.cr_uid = exp->ex_anon_uid;
 		cred.cr_gid = exp->ex_anon_gid;
 		cred.cr_group_info = groups_alloc(0);
-	} else if (exp->ex_flags & NFSEXP_ROOTSQUASH) {
+	} else if (flags & NFSEXP_ROOTSQUASH) {
 		struct group_info *gi;
 		if (!cred.cr_uid)
 			cred.cr_uid = exp->ex_anon_uid;
diff -puN include/linux/nfsd/export.h~knfsd-nfsd-enforce-per-flavor-id-squashing include/linux/nfsd/export.h
--- a/include/linux/nfsd/export.h~knfsd-nfsd-enforce-per-flavor-id-squashing
+++ a/include/linux/nfsd/export.h
@@ -43,7 +43,8 @@
 #define NFSEXP_ALLFLAGS		0xFE3F
 
 /* The flags that may vary depending on security flavor: */
-#define NFSEXP_SECINFO_FLAGS	0
+#define NFSEXP_SECINFO_FLAGS	(NFSEXP_READONLY | NFSEXP_ROOTSQUASH \
+					| NFSEXP_ALLSQUASH)
 
 #ifdef __KERNEL__
 
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
