From: akpm@linux-foundation.org
Subject: - knfsd-nfsd4-fix-error-return-on-unsupported-acl.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:16:20 -0800
Message-ID: <200702170716.l1H7GKCl021694@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51116 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946489AbXBQHQZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:16:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: nfsd4: fix error return on unsupported acl
has been removed from the -mm tree.  Its filename was
     knfsd-nfsd4-fix-error-return-on-unsupported-acl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: nfsd4: fix error return on unsupported acl
From: J. Bruce Fields <bfields@citi.umich.edu>

We should be returning ATTRNOTSUPP, not NOTSUPP, when acls are unsupported.

Also fix a comment.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4xdr.c |    2 +-
 fs/nfsd/vfs.c     |    5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff -puN fs/nfsd/nfs4xdr.c~knfsd-nfsd4-fix-error-return-on-unsupported-acl fs/nfsd/nfs4xdr.c
--- a/fs/nfsd/nfs4xdr.c~knfsd-nfsd4-fix-error-return-on-unsupported-acl
+++ a/fs/nfsd/nfs4xdr.c
@@ -253,7 +253,7 @@ nfsd4_decode_fattr(struct nfsd4_compound
 		return status;
 
 	/*
-	 * According to spec, unsupported attributes return ERR_NOTSUPP;
+	 * According to spec, unsupported attributes return ERR_ATTRNOTSUPP;
 	 * read-only attributes return ERR_INVAL.
 	 */
 	if ((bmval[0] & ~NFSD_SUPPORTED_ATTRS_WORD0) || (bmval[1] & ~NFSD_SUPPORTED_ATTRS_WORD1))
diff -puN fs/nfsd/vfs.c~knfsd-nfsd4-fix-error-return-on-unsupported-acl fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~knfsd-nfsd4-fix-error-return-on-unsupported-acl
+++ a/fs/nfsd/vfs.c
@@ -466,7 +466,10 @@ out:
 	posix_acl_release(dpacl);
 	return (error);
 out_nfserr:
-	error = nfserrno(host_error);
+	if (host_error == -EOPNOTSUPP)
+		error = nfserr_attrnotsupp;
+	else
+		error = nfserrno(host_error);
 	goto out;
 }
 
_

Patches currently in -mm which might be from bfields@citi.umich.edu are

origin.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
