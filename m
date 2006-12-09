From: akpm@osdl.org
Subject: + knfsd-nfsd-simplify-exp_pseudoroot.patch added to -mm tree
Date: Fri, 08 Dec 2006 16:09:28 -0800
Message-ID: <200612090009.kB909SlL010386@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:55563 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947571AbWLIAJn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 19:09:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@fieldses.org, bfields@citi.umich.edu, neilb@suse.de


The patch titled
     knfsd: nfsd: simplify exp_pseudoroot
has been added to the -mm tree.  Its filename is
     knfsd-nfsd-simplify-exp_pseudoroot.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 2 insertions(+), 4 deletions(-)

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

origin.patch
knfsd-nfsd4-remove-a-dprink-from-nfsd4_lock.patch
knfsd-svcrpc-fix-gss-krb5i-memory-leak.patch
knfsd-nfsd4-clarify-units-of-compound_slack_space.patch
knfsd-nfsd-make-exp_rootfh-handle-exp_parent-errors.patch
knfsd-nfsd-simplify-exp_pseudoroot.patch
knfsd-nfsd4-handling-more-nfsd_cross_mnt-errors-in-nfsd4-readdir.patch
knfsd-nfsd-dont-drop-silently-on-upcall-deferral.patch
knfsd-svcrpc-remove-another-silent-drop-from-deferral-code.patch
knfsd-nfsd4-pass-saved-and-current-fh-together-into-nfsd4-operations.patch
knfsd-nfsd4-remove-spurious-replay_owner-check.patch
knfsd-nfsd4-move-replay_owner-to-cstate.patch
knfsd-nfsd4-dont-inline-nfsd4-compound-op-functions.patch
knfsd-nfsd4-make-verify-and-nverify-wrappers.patch
knfsd-nfsd4-reorganize-compound-ops.patch
knfsd-nfsd4-simplify-migration-op-check.patch
knfsd-nfsd4-simplify-filehandle-check.patch

