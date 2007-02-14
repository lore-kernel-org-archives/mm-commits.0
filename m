From: akpm@linux-foundation.org
Subject: + knfsd-nfsd4-fix-error-return-on-unsupported-acl.patch added to -mm tree
Date: Wed, 14 Feb 2007 13:14:33 -0800
Message-ID: <200702142114.l1ELEXMm009283@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46094 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932610AbXBNVOj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 16:14:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@citi.umich.edu, neilb@suse.de


The patch titled
     knfsd: nfsd4: fix error return on unsupported acl
has been added to the -mm tree.  Its filename is
     knfsd-nfsd4-fix-error-return-on-unsupported-acl.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

auth_gss-unregister-gss_domain-when-unloading-module.patch
knfsd-nfsd4-fix-non-terminated-string.patch
knfsd-nfsd4-relax-checking-of-acl-inheritance-bits.patch
knfsd-nfsd4-simplify-nfsv4-posix-translation.patch
knfsd-nfsd4-represent-nfsv4-acl-with-array-instead-of-linked-list.patch
knfsd-nfsd4-fix-memory-leak-on-kmalloc-failure-in-savemem.patch
knfsd-nfsd4-fix-error-return-on-unsupported-acl.patch
knfsd-nfsd4-acls-dont-return-explicit-mask.patch
knfsd-nfsd4-acls-avoid-unnecessary-denies.patch
knfsd-nfsd4-fix-handling-of-directories-without-default-acls.patch
