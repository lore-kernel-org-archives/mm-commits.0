From: akpm@osdl.org
Subject: - knfsd-nfsd-simplify-exp_pseudoroot.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:15:06 -0800
Message-ID: <200612140615.kBE6F6MP002197@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52449 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971AbWLNGPj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:15:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@fieldses.org, bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: nfsd: simplify exp_pseudoroot
has been removed from the -mm tree.  Its filename was
     knfsd-nfsd-simplify-exp_pseudoroot.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: nfsd: simplify exp_pseudoroot
From: J.Bruce Fields <bfields@fieldses.org>

Note there's no need for special handling of -EAGAIN here; nfserrno() does
what we want already.  So this is a pure cleanup with no change in
functionality.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/nfsd/export.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/nfsd/export.c~knfsd-nfsd-simplify-exp_pseudoroot fs/nfsd/export.c
--- a/fs/nfsd/export.c~knfsd-nfsd-simplify-exp_pseudoroot
+++ a/fs/nfsd/export.c
@@ -1163,12 +1163,10 @@ exp_pseudoroot(struct auth_domain *clp, 
 	mk_fsid_v1(fsidv, 0);
 
 	exp = exp_find(clp, 1, fsidv, creq);
-	if (IS_ERR(exp) && PTR_ERR(exp) == -EAGAIN)
-		return nfserr_dropit;
+	if (IS_ERR(exp))
+		return nfserrno(PTR_ERR(exp));
 	if (exp == NULL)
 		return nfserr_perm;
-	else if (IS_ERR(exp))
-		return nfserrno(PTR_ERR(exp));
 	rv = fh_compose(fhp, exp, exp->ex_dentry, NULL);
 	exp_put(exp);
 	return rv;
_

Patches currently in -mm which might be from bfields@fieldses.org are


