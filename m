From: akpm@linux-foundation.org
Subject: + knfsd-nfsd-allow-auth_sys-nlm-on-rpcsec_gss-exports.patch added to -mm tree
Date: Fri, 13 Jul 2007 00:34:09 -0700
Message-ID: <200707130734.l6D7Y9w0005457@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37683 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935151AbXGMHo7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 03:44:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@citi.umich.edu, neilb@suse.de


The patch titled
     knfsd: nfsd: allow auth_sys nlm on rpcsec_gss exports
has been added to the -mm tree.  Its filename is
     knfsd-nfsd-allow-auth_sys-nlm-on-rpcsec_gss-exports.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: nfsd: allow auth_sys nlm on rpcsec_gss exports
From: J. Bruce Fields <bfields@citi.umich.edu>

Our clients (like other clients, as far as I know) use only auth_sys for nlm,
even when using rpcsec_gss for the main nfs operations.

Administrators that want to deny non-kerberos-authenticated locking requests
will need to turn off NFS protocol versions less than 4....

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfsfh.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN fs/nfsd/nfsfh.c~knfsd-nfsd-allow-auth_sys-nlm-on-rpcsec_gss-exports fs/nfsd/nfsfh.c
--- a/fs/nfsd/nfsfh.c~knfsd-nfsd-allow-auth_sys-nlm-on-rpcsec_gss-exports
+++ a/fs/nfsd/nfsfh.c
@@ -249,10 +249,16 @@ fh_verify(struct svc_rqst *rqstp, struct
 	if (error)
 		goto out;
 
-	/* Check security flavor */
-	error = check_nfsd_access(exp, rqstp);
-	if (error)
-		goto out;
+	if (!(access & MAY_LOCK)) {
+		/*
+		 * pseudoflavor restrictions are not enforced on NLM,
+		 * which clients virtually always use auth_sys for,
+		 * even while using RPCSEC_GSS for NFS.
+		 */
+		error = check_nfsd_access(exp, rqstp);
+		if (error)
+			goto out;
+	}
 
 	/* Finally, check access permissions. */
 	error = nfsd_permission(rqstp, exp, dentry, access);
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
