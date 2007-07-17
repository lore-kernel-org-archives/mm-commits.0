From: akpm@linux-foundation.org
Subject: - knfsd-nfsd4-store-pseudoflavor-in-request.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:04:44 -0700
Message-ID: <200707172304.l6HN4ich011829@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35794 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935844AbXGQXQY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andros@citi.umich.edu, bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: nfsd4: store pseudoflavor in request
has been removed from the -mm tree.  Its filename was
     knfsd-nfsd4-store-pseudoflavor-in-request.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: nfsd4: store pseudoflavor in request
From: Andy Adamson <andros@citi.umich.edu>

Add a new field to the svc_rqst structure to record the pseudoflavor that the
request was made with.  For now we record the pseudoflavor but don't use it
for anything.

Signed-off-by: Andy Adamson <andros@citi.umich.edu>
Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sunrpc/gss_api.h        |    1 +
 include/linux/sunrpc/svc.h            |    1 +
 net/sunrpc/auth_gss/gss_mech_switch.c |   14 ++++++++++++++
 net/sunrpc/auth_gss/svcauth_gss.c     |    2 ++
 net/sunrpc/svcauth_unix.c             |    3 +++
 5 files changed, 21 insertions(+)

diff -puN include/linux/sunrpc/gss_api.h~knfsd-nfsd4-store-pseudoflavor-in-request include/linux/sunrpc/gss_api.h
--- a/include/linux/sunrpc/gss_api.h~knfsd-nfsd4-store-pseudoflavor-in-request
+++ a/include/linux/sunrpc/gss_api.h
@@ -58,6 +58,7 @@ u32 gss_unwrap(
 u32 gss_delete_sec_context(
 		struct gss_ctx		**ctx_id);
 
+u32 gss_svc_to_pseudoflavor(struct gss_api_mech *, u32 service);
 u32 gss_pseudoflavor_to_service(struct gss_api_mech *, u32 pseudoflavor);
 char *gss_service_to_auth_domain_name(struct gss_api_mech *, u32 service);
 
diff -puN include/linux/sunrpc/svc.h~knfsd-nfsd4-store-pseudoflavor-in-request include/linux/sunrpc/svc.h
--- a/include/linux/sunrpc/svc.h~knfsd-nfsd4-store-pseudoflavor-in-request
+++ a/include/linux/sunrpc/svc.h
@@ -212,6 +212,7 @@ struct svc_rqst {
 	struct svc_pool *	rq_pool;	/* thread pool */
 	struct svc_procedure *	rq_procinfo;	/* procedure info */
 	struct auth_ops *	rq_authop;	/* authentication flavour */
+	u32			rq_flavor;	/* pseudoflavor */
 	struct svc_cred		rq_cred;	/* auth info */
 	struct sk_buff *	rq_skbuff;	/* fast recv inet buffer */
 	struct svc_deferred_req*rq_deferred;	/* deferred request we are replaying */
diff -puN net/sunrpc/auth_gss/gss_mech_switch.c~knfsd-nfsd4-store-pseudoflavor-in-request net/sunrpc/auth_gss/gss_mech_switch.c
--- a/net/sunrpc/auth_gss/gss_mech_switch.c~knfsd-nfsd4-store-pseudoflavor-in-request
+++ a/net/sunrpc/auth_gss/gss_mech_switch.c
@@ -194,6 +194,20 @@ gss_mech_get_by_pseudoflavor(u32 pseudof
 EXPORT_SYMBOL(gss_mech_get_by_pseudoflavor);
 
 u32
+gss_svc_to_pseudoflavor(struct gss_api_mech *gm, u32 service)
+{
+	int i;
+
+	for (i = 0; i < gm->gm_pf_num; i++) {
+		if (gm->gm_pfs[i].service == service) {
+			return gm->gm_pfs[i].pseudoflavor;
+		}
+	}
+	return RPC_AUTH_MAXFLAVOR; /* illegal value */
+}
+EXPORT_SYMBOL(gss_svc_to_pseudoflavor);
+
+u32
 gss_pseudoflavor_to_service(struct gss_api_mech *gm, u32 pseudoflavor)
 {
 	int i;
diff -puN net/sunrpc/auth_gss/svcauth_gss.c~knfsd-nfsd4-store-pseudoflavor-in-request net/sunrpc/auth_gss/svcauth_gss.c
--- a/net/sunrpc/auth_gss/svcauth_gss.c~knfsd-nfsd4-store-pseudoflavor-in-request
+++ a/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1131,6 +1131,8 @@ svcauth_gss_accept(struct svc_rqst *rqst
 		}
 		svcdata->rsci = rsci;
 		cache_get(&rsci->h);
+		rqstp->rq_flavor = gss_svc_to_pseudoflavor(
+					rsci->mechctx->mech_type, gc->gc_svc);
 		ret = SVC_OK;
 		goto out;
 	}
diff -puN net/sunrpc/svcauth_unix.c~knfsd-nfsd4-store-pseudoflavor-in-request net/sunrpc/svcauth_unix.c
--- a/net/sunrpc/svcauth_unix.c~knfsd-nfsd4-store-pseudoflavor-in-request
+++ a/net/sunrpc/svcauth_unix.c
@@ -5,6 +5,7 @@
 #include <linux/sunrpc/xdr.h>
 #include <linux/sunrpc/svcsock.h>
 #include <linux/sunrpc/svcauth.h>
+#include <linux/sunrpc/gss_api.h>
 #include <linux/err.h>
 #include <linux/seq_file.h>
 #include <linux/hash.h>
@@ -707,6 +708,7 @@ svcauth_null_accept(struct svc_rqst *rqs
 	svc_putnl(resv, RPC_AUTH_NULL);
 	svc_putnl(resv, 0);
 
+	rqstp->rq_flavor = RPC_AUTH_NULL;
 	return SVC_OK;
 }
 
@@ -784,6 +786,7 @@ svcauth_unix_accept(struct svc_rqst *rqs
 	svc_putnl(resv, RPC_AUTH_NULL);
 	svc_putnl(resv, 0);
 
+	rqstp->rq_flavor = RPC_AUTH_UNIX;
 	return SVC_OK;
 
 badcred:
_

Patches currently in -mm which might be from andros@citi.umich.edu are

origin.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
