From: akpm@linux-foundation.org
Subject: + nfsd-fix-possible-oops-on-re-insertion-of-rpcsec_gss.patch added to -mm tree
Date: Mon, 23 Jul 2007 14:22:01 -0700
Message-ID: <200707232122.l6NLM1vt012428@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50698 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752581AbXGWVWy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 17:22:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@citi.umich.edu, akinobu.mita@gmail.com, neilb@suse.de, stable@kernel.org, trond.myklebust@fys.uio.no


The patch titled
     nfsd: fix possible oops on re-insertion of rpcsec_gss modules
has been added to the -mm tree.  Its filename is
     nfsd-fix-possible-oops-on-re-insertion-of-rpcsec_gss.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: nfsd: fix possible oops on re-insertion of rpcsec_gss modules
From: J. Bruce Fields <bfields@citi.umich.edu>

The handling of the re-registration case is wrong here; the "test" that was
returned from auth_domain_lookup will not be used again, so that reference
should be put.  And auth_domain_lookup never did anything with "new" in
this case, so we should just clean it up ourself.

Thanks to Akinobu Mita for bug report, analysis, and testing.

Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: Neil Brown <neilb@suse.de>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/auth_gss/svcauth_gss.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff -puN net/sunrpc/auth_gss/svcauth_gss.c~nfsd-fix-possible-oops-on-re-insertion-of-rpcsec_gss net/sunrpc/auth_gss/svcauth_gss.c
--- a/net/sunrpc/auth_gss/svcauth_gss.c~nfsd-fix-possible-oops-on-re-insertion-of-rpcsec_gss
+++ a/net/sunrpc/auth_gss/svcauth_gss.c
@@ -769,11 +769,12 @@ svcauth_gss_register_pseudoflavor(u32 ps
 	new->h.flavour = &svcauthops_gss;
 	new->pseudoflavor = pseudoflavor;
 
+	stat = 0;
 	test = auth_domain_lookup(name, &new->h);
-	if (test != &new->h) { /* XXX Duplicate registration? */
-		auth_domain_put(&new->h);
-		/* dangling ref-count... */
-		goto out;
+	if (test != &new->h) { /* Duplicate registration */
+		auth_domain_put(test);
+		kfree(new->h.name);
+		goto out_free_dom;
 	}
 	return 0;
 
_

Patches currently in -mm which might be from bfields@citi.umich.edu are

nfsd-fix-possible-oops-on-re-insertion-of-rpcsec_gss.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
locks-kill-redundant-local-variable.patch
vfs-fix-a-race-in-lease-breaking-during-truncate.patch
