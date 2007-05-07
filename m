From: akpm@linux-foundation.org
Subject: + knfsd-fix-resource-leak-resulting-in-module-refcount-leak-for-rpcsec_gss_krb5ko.patch added to -mm tree
Date: Mon, 07 May 2007 16:08:28 -0700
Message-ID: <200705072308.l47N8SC1007828@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754656AbXEGXIf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 19:08:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ffilzlnx@us.ibm.com, bfields@citi.umich.edu, neilb@suse.de


The patch titled
     knfsd: fix resource leak resulting in module refcount leak for rpcsec_gss_krb5.ko
has been added to the -mm tree.  Its filename is
     knfsd-fix-resource-leak-resulting-in-module-refcount-leak-for-rpcsec_gss_krb5ko.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: fix resource leak resulting in module refcount leak for rpcsec_gss_krb5.ko
From: Frank Filz <ffilzlnx@us.ibm.com>

I have been investigating a module reference count leak on the server for
rpcsec_gss_krb5.ko.  It turns out the problem is a reference count leak for
the security context in net/sunrpc/auth_gss/svcauth_gss.c.

The problem is that gss_write_init_verf() calls gss_svc_searchbyctx() which
does a rsc_lookup() but never releases the reference to the context.  There is
another issue that rpc.svcgssd sets an "end of time" expiration for the
context

By adding a cache_put() call in gss_svc_searchbyctx(), and setting an
expiration timeout in the downcall, cache_clean() does clean up the context
and the module reference count now goes to zero after unmount.

I also verified that if the context expires and then the client makes a new
request, a new context is established.

Here is the patch to fix the kernel, I will start a separate thread to discuss
what expiration time should be set by rpc.svcgssd.

Acked-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Frank Filz <ffilzlnx@us.ibm.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/auth_gss/svcauth_gss.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletion(-)

diff -puN net/sunrpc/auth_gss/svcauth_gss.c~knfsd-fix-resource-leak-resulting-in-module-refcount-leak-for-rpcsec_gss_krb5ko net/sunrpc/auth_gss/svcauth_gss.c
--- a/net/sunrpc/auth_gss/svcauth_gss.c~knfsd-fix-resource-leak-resulting-in-module-refcount-leak-for-rpcsec_gss_krb5ko
+++ a/net/sunrpc/auth_gss/svcauth_gss.c
@@ -938,6 +938,7 @@ static inline int
 gss_write_init_verf(struct svc_rqst *rqstp, struct rsi *rsip)
 {
 	struct rsc *rsci;
+	int        rc;
 
 	if (rsip->major_status != GSS_S_COMPLETE)
 		return gss_write_null_verf(rqstp);
@@ -946,7 +947,9 @@ gss_write_init_verf(struct svc_rqst *rqs
 		rsip->major_status = GSS_S_NO_CONTEXT;
 		return gss_write_null_verf(rqstp);
 	}
-	return gss_write_verf(rqstp, rsci->mechctx, GSS_SEQ_WIN);
+	rc = gss_write_verf(rqstp, rsci->mechctx, GSS_SEQ_WIN);
+	cache_put(&rsci->h, &rsc_cache);
+	return rc;
 }
 
 /*
_

Patches currently in -mm which might be from ffilzlnx@us.ibm.com are

knfsd-fix-resource-leak-resulting-in-module-refcount-leak-for-rpcsec_gss_krb5ko.patch
