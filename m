From: akpm@linux-foundation.org
Subject: - auth_gss-unregister-gss_domain-when-unloading-module.patch removed from -mm tree
Date: Mon, 23 Jul 2007 14:22:33 -0700
Message-ID: <200707232122.l6NLMXjE012437@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38675 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750756AbXGWVXS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 17:23:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, Trond.Myklebust@netapp.com, andros@citi.umich.edu, bfields@citi.umich.edu, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     auth_gss: unregister gss_domain when unloading module
has been removed from the -mm tree.  Its filename was
     auth_gss-unregister-gss_domain-when-unloading-module.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: auth_gss: unregister gss_domain when unloading module
From: Akinobu Mita <akinobu.mita@gmail.com>

Reloading rpcsec_gss_krb5 or rpcsec_gss_spkm3 hit duplicate registration in
svcauth_gss_register_pseudoflavor().  (If DEBUG_PAGEALLOC is enabled, oops
will happen at auth_domain_put() --> hlist_del() with uninitialized
hlist_node)

svcauth_gss_register_pseudoflavor(u32 pseudoflavor, char * name)
{
	...

        test = auth_domain_lookup(name, &new->h);
        if (test != &new->h) { /* XXX Duplicate registration? */
                auth_domain_put(&new->h);
                /* dangling ref-count... */
	...
}

This patch unregisters gss_domain and free it when unloading
modules.

- Define svcauth_gss_unregister_pseudoflavor()
  (doing the opposite of svcauth_gss_register_pseudoflavor())

- Call svcauth_gss_unregister_pseudoflavor() in gss_mech_free()

Cc: Andy Adamson <andros@citi.umich.edu>
Acked-by: J. Bruce Fields <bfields@citi.umich.edu>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: <stable@kernel.org>

Trond:

  "This is as buggy now as it was the last time this was submitted for
   review.  Without a suitable locking scheme you cannot assume that you hold
   the last reference."

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sunrpc/svcauth_gss.h    |    1 +
 net/sunrpc/auth_gss/gss_mech_switch.c |    8 +++++++-
 net/sunrpc/auth_gss/svcauth_gss.c     |   20 +++++++++++++++++---
 3 files changed, 25 insertions(+), 4 deletions(-)

diff -puN include/linux/sunrpc/svcauth_gss.h~auth_gss-unregister-gss_domain-when-unloading-module include/linux/sunrpc/svcauth_gss.h
--- a/include/linux/sunrpc/svcauth_gss.h~auth_gss-unregister-gss_domain-when-unloading-module
+++ a/include/linux/sunrpc/svcauth_gss.h
@@ -23,6 +23,7 @@ int gss_svc_init(void);
 void gss_svc_shutdown(void);
 int svcauth_gss_register_pseudoflavor(u32 pseudoflavor, char * name);
 u32 svcauth_gss_flavor(struct auth_domain *dom);
+void svcauth_gss_unregister_pseudoflavor(char *name);
 
 #endif /* __KERNEL__ */
 #endif /* _LINUX_SUNRPC_SVCAUTH_GSS_H */
diff -puN net/sunrpc/auth_gss/gss_mech_switch.c~auth_gss-unregister-gss_domain-when-unloading-module net/sunrpc/auth_gss/gss_mech_switch.c
--- a/net/sunrpc/auth_gss/gss_mech_switch.c~auth_gss-unregister-gss_domain-when-unloading-module
+++ a/net/sunrpc/auth_gss/gss_mech_switch.c
@@ -60,6 +60,9 @@ gss_mech_free(struct gss_api_mech *gm)
 
 	for (i = 0; i < gm->gm_pf_num; i++) {
 		pf = &gm->gm_pfs[i];
+		if (!pf->auth_domain_name)
+			continue;
+		svcauth_gss_unregister_pseudoflavor(pf->auth_domain_name);
 		kfree(pf->auth_domain_name);
 		pf->auth_domain_name = NULL;
 	}
@@ -93,8 +96,11 @@ gss_mech_svc_setup(struct gss_api_mech *
 			goto out;
 		status = svcauth_gss_register_pseudoflavor(pf->pseudoflavor,
 							pf->auth_domain_name);
-		if (status)
+		if (status) {
+			kfree(pf->auth_domain_name);
+			pf->auth_domain_name = NULL;
 			goto out;
+		}
 	}
 	return 0;
 out:
diff -puN net/sunrpc/auth_gss/svcauth_gss.c~auth_gss-unregister-gss_domain-when-unloading-module net/sunrpc/auth_gss/svcauth_gss.c
--- a/net/sunrpc/auth_gss/svcauth_gss.c~auth_gss-unregister-gss_domain-when-unloading-module
+++ a/net/sunrpc/auth_gss/svcauth_gss.c
@@ -771,9 +771,10 @@ svcauth_gss_register_pseudoflavor(u32 ps
 
 	test = auth_domain_lookup(name, &new->h);
 	if (test != &new->h) { /* XXX Duplicate registration? */
-		auth_domain_put(&new->h);
-		/* dangling ref-count... */
-		goto out;
+		WARN_ON(1);
+		stat = -EBUSY;
+		kfree(new->h.name);
+		goto out_free_dom;
 	}
 	return 0;
 
@@ -785,6 +786,19 @@ out:
 
 EXPORT_SYMBOL(svcauth_gss_register_pseudoflavor);
 
+void svcauth_gss_unregister_pseudoflavor(char *name)
+{
+	struct auth_domain *dom;
+
+	dom = auth_domain_find(name);
+	if (dom) {
+		auth_domain_put(dom);
+		auth_domain_put(dom);
+	}
+}
+
+EXPORT_SYMBOL(svcauth_gss_unregister_pseudoflavor);
+
 static inline int
 read_u32_from_xdr_buf(struct xdr_buf *buf, int base, u32 *obj)
 {
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

nfsd-fix-possible-oops-on-re-insertion-of-rpcsec_gss.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
