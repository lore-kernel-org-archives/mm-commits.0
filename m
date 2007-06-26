From: akpm@linux-foundation.org
Subject: + knfsd-nfsd4-fix-handling-of-acl-errrors.patch added to -mm tree
Date: Mon, 25 Jun 2007 20:46:26 -0700
Message-ID: <200706260346.l5Q3kQPN017632@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48731 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753092AbXFZDqq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 23:46:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@fieldses.org, bfields@citi.umich.edu, neilb@suse.de, soule@umich.edu


The patch titled
     knfsd: nfsd4: fix handling of acl errrors
has been added to the -mm tree.  Its filename is
     knfsd-nfsd4-fix-handling-of-acl-errrors.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: nfsd4: fix handling of acl errrors
From: "J. Bruce Fields" <bfields@fieldses.org>

nfs4_acl_nfsv4_to_posix() returns an error and returns any posix acls
calculated in two caller-provided pointers.  It was setting these pointers to
-errno in some error cases, resulting in nfsd4_set_nfs4_acl() calling
posix_acl_release() with a -errno as an argument.

Fix both the caller and the callee, by modifying nfsd4_set_nfs4_acl() to
stop relying on the passed-in-pointers being left as NULL in the error
case, and by modifying nfs4_acl_nfsv4_to_posix() to stop returning
garbage in those pointers.

Thanks to Alex Soule for reporting the bug.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: Alexander Soule <soule@umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4acl.c |    3 +++
 fs/nfsd/vfs.c     |   22 +++++++---------------
 2 files changed, 10 insertions(+), 15 deletions(-)

diff -puN fs/nfsd/nfs4acl.c~knfsd-nfsd4-fix-handling-of-acl-errrors fs/nfsd/nfs4acl.c
--- a/fs/nfsd/nfs4acl.c~knfsd-nfsd4-fix-handling-of-acl-errrors
+++ a/fs/nfsd/nfs4acl.c
@@ -737,13 +737,16 @@ int nfs4_acl_nfsv4_to_posix(struct nfs4_
 	*pacl = posix_state_to_acl(&effective_acl_state, flags);
 	if (IS_ERR(*pacl)) {
 		ret = PTR_ERR(*pacl);
+		*pacl = NULL;
 		goto out_dstate;
 	}
 	*dpacl = posix_state_to_acl(&default_acl_state,
 						flags | NFS4_ACL_TYPE_DEFAULT);
 	if (IS_ERR(*dpacl)) {
 		ret = PTR_ERR(*dpacl);
+		*dpacl = NULL;
 		posix_acl_release(*pacl);
+		*pacl = NULL;
 		goto out_dstate;
 	}
 	sort_pacl(*pacl);
diff -puN fs/nfsd/vfs.c~knfsd-nfsd4-fix-handling-of-acl-errrors fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~knfsd-nfsd4-fix-handling-of-acl-errrors
+++ a/fs/nfsd/vfs.c
@@ -435,7 +435,7 @@ nfsd4_set_nfs4_acl(struct svc_rqst *rqst
 	/* Get inode */
 	error = fh_verify(rqstp, fhp, 0 /* S_IFREG */, MAY_SATTR);
 	if (error)
-		goto out;
+		return error;
 
 	dentry = fhp->fh_dentry;
 	inode = dentry->d_inode;
@@ -444,33 +444,25 @@ nfsd4_set_nfs4_acl(struct svc_rqst *rqst
 
 	host_error = nfs4_acl_nfsv4_to_posix(acl, &pacl, &dpacl, flags);
 	if (host_error == -EINVAL) {
-		error = nfserr_attrnotsupp;
-		goto out;
+		return nfserr_attrnotsupp;
 	} else if (host_error < 0)
 		goto out_nfserr;
 
 	host_error = set_nfsv4_acl_one(dentry, pacl, POSIX_ACL_XATTR_ACCESS);
 	if (host_error < 0)
-		goto out_nfserr;
+		goto out_release;
 
-	if (S_ISDIR(inode->i_mode)) {
+	if (S_ISDIR(inode->i_mode))
 		host_error = set_nfsv4_acl_one(dentry, dpacl, POSIX_ACL_XATTR_DEFAULT);
-		if (host_error < 0)
-			goto out_nfserr;
-	}
-
-	error = nfs_ok;
 
-out:
+out_release:
 	posix_acl_release(pacl);
 	posix_acl_release(dpacl);
-	return (error);
 out_nfserr:
 	if (host_error == -EOPNOTSUPP)
-		error = nfserr_attrnotsupp;
+		return nfserr_attrnotsupp;
 	else
-		error = nfserrno(host_error);
-	goto out;
+		return nfserrno(host_error);
 }
 
 static struct posix_acl *
_

Patches currently in -mm which might be from bfields@fieldses.org are

nfs-refactor-ip-address-sanity-checks-in-nfs-client.patch
knfsd-nfsd4-fix-nfsv4-filehandle-size-units-confusion.patch
knfsd-nfsd4-silence-a-compiler-warning-in-acl-code.patch
knfsd-nfsd4-fix-handling-of-acl-errrors.patch
knfsd-nfsd-remove-unused-header-interfaceh.patch
knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix.patch
