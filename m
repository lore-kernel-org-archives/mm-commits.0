From: akpm@linux-foundation.org
Subject: + knfsd-nfsd4-secinfo-handling-without-secinfo=-option.patch added to -mm tree
Date: Fri, 13 Jul 2007 00:34:08 -0700
Message-ID: <200707130734.l6D7Y8O8005454@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50869 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760623AbXGMHeU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 03:34:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@citi.umich.edu, neilb@suse.de


The patch titled
     knfsd: nfsd4: secinfo handling without secinfo= option
has been added to the -mm tree.  Its filename is
     knfsd-nfsd4-secinfo-handling-without-secinfo=-option.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: nfsd4: secinfo handling without secinfo= option
From: J. Bruce Fields <bfields@citi.umich.edu>

We could return some sort of error in the case where someone asks for secinfo
on an export without the secinfo= option set--that'd be no worse than what
we've been doing.  But it's not really correct.  So, hack up an approximate
secinfo response in that case--it may not be complete, but it'll tell the
client at least one acceptable security flavor.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4xdr.c                  |   30 ++++++++++++++++++++++++---
 include/linux/sunrpc/svcauth_gss.h |    1 
 net/sunrpc/auth_gss/svcauth_gss.c  |    9 ++++++++
 3 files changed, 37 insertions(+), 3 deletions(-)

diff -puN fs/nfsd/nfs4xdr.c~knfsd-nfsd4-secinfo-handling-without-secinfo=-option fs/nfsd/nfs4xdr.c
--- a/fs/nfsd/nfs4xdr.c~knfsd-nfsd4-secinfo-handling-without-secinfo=-option
+++ a/fs/nfsd/nfs4xdr.c
@@ -57,6 +57,7 @@
 #include <linux/nfs4.h>
 #include <linux/nfs4_acl.h>
 #include <linux/sunrpc/gss_api.h>
+#include <linux/sunrpc/svcauth_gss.h>
 
 #define NFSDDBG_FACILITY		NFSDDBG_XDR
 
@@ -2454,15 +2455,38 @@ nfsd4_encode_secinfo(struct nfsd4_compou
 {
 	int i = 0;
 	struct svc_export *exp = secinfo->si_exp;
+	u32 nflavs;
+	struct exp_flavor_info *flavs;
+	struct exp_flavor_info def_flavs[2];
 	ENCODE_HEAD;
 
 	if (nfserr)
 		goto out;
+	if (exp->ex_nflavors) {
+		flavs = exp->ex_flavors;
+		nflavs = exp->ex_nflavors;
+	} else { /* Handling of some defaults in absence of real secinfo: */
+		flavs = def_flavs;
+		if (exp->ex_client->flavour->flavour == RPC_AUTH_UNIX) {
+			nflavs = 2;
+			flavs[0].pseudoflavor = RPC_AUTH_UNIX;
+			flavs[1].pseudoflavor = RPC_AUTH_NULL;
+		} else if (exp->ex_client->flavour->flavour == RPC_AUTH_GSS) {
+			nflavs = 1;
+			flavs[0].pseudoflavor
+					= svcauth_gss_flavor(exp->ex_client);
+		} else {
+			nflavs = 1;
+			flavs[0].pseudoflavor
+					= exp->ex_client->flavour->flavour;
+		}
+	}
+
 	RESERVE_SPACE(4);
-	WRITE32(exp->ex_nflavors);
+	WRITE32(nflavs);
 	ADJUST_ARGS();
-	for (i = 0; i < exp->ex_nflavors; i++) {
-		u32 flav = exp->ex_flavors[i].pseudoflavor;
+	for (i = 0; i < nflavs; i++) {
+		u32 flav = flavs[i].pseudoflavor;
 		struct gss_api_mech *gm = gss_mech_get_by_pseudoflavor(flav);
 
 		if (gm) {
diff -puN include/linux/sunrpc/svcauth_gss.h~knfsd-nfsd4-secinfo-handling-without-secinfo=-option include/linux/sunrpc/svcauth_gss.h
--- a/include/linux/sunrpc/svcauth_gss.h~knfsd-nfsd4-secinfo-handling-without-secinfo=-option
+++ a/include/linux/sunrpc/svcauth_gss.h
@@ -23,6 +23,7 @@ int gss_svc_init(void);
 void gss_svc_shutdown(void);
 int svcauth_gss_register_pseudoflavor(u32 pseudoflavor, char * name);
 void svcauth_gss_unregister_pseudoflavor(char *name);
+u32 svcauth_gss_flavor(struct auth_domain *dom);
 
 #endif /* __KERNEL__ */
 #endif /* _LINUX_SUNRPC_SVCAUTH_GSS_H */
diff -puN net/sunrpc/auth_gss/svcauth_gss.c~knfsd-nfsd4-secinfo-handling-without-secinfo=-option net/sunrpc/auth_gss/svcauth_gss.c
--- a/net/sunrpc/auth_gss/svcauth_gss.c~knfsd-nfsd4-secinfo-handling-without-secinfo=-option
+++ a/net/sunrpc/auth_gss/svcauth_gss.c
@@ -743,6 +743,15 @@ find_gss_auth_domain(struct gss_ctx *ctx
 
 static struct auth_ops svcauthops_gss;
 
+u32 svcauth_gss_flavor(struct auth_domain *dom)
+{
+	struct gss_domain *gd = container_of(dom, struct gss_domain, h);
+
+	return gd->pseudoflavor;
+}
+
+EXPORT_SYMBOL(svcauth_gss_flavor);
+
 int
 svcauth_gss_register_pseudoflavor(u32 pseudoflavor, char * name)
 {
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
