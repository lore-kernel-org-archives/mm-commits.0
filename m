From: akpm@linux-foundation.org
Subject: - knfsd-nfsd4-secinfo-handling-without-secinfo=-option.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:05:13 -0700
Message-ID: <200707172305.l6HN5DcD011898@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37112 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935765AbXGQXPY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: nfsd4: secinfo handling without secinfo= option
has been removed from the -mm tree.  Its filename was
     knfsd-nfsd4-secinfo-handling-without-secinfo=-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -22,6 +22,7 @@
 int gss_svc_init(void);
 void gss_svc_shutdown(void);
 int svcauth_gss_register_pseudoflavor(u32 pseudoflavor, char * name);
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

origin.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
git-vfs-lease-api.patch
