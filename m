From: akpm@linux-foundation.org
Subject: + knfsd-nfsd4-simplify-nfsv4-posix-translation.patch added to -mm tree
Date: Wed, 14 Feb 2007 13:14:27 -0800
Message-ID: <200702142114.l1ELERc2009270@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46077 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932607AbXBNVOc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 16:14:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@citi.umich.edu, neilb@suse.de


The patch titled
     knfsd: nfsd4: simplify nfsv4->posix translation
has been added to the -mm tree.  Its filename is
     knfsd-nfsd4-simplify-nfsv4-posix-translation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: nfsd4: simplify nfsv4->posix translation
From: J. Bruce Fields <bfields@citi.umich.edu>

The code that splits an incoming nfsv4 ACL into inheritable and effective
parts can be combined with the the code that translates each to a posix acl,
resulting in simpler code that requires one less pass through the ACL.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4acl.c |  133 ++++++++++++--------------------------------
 1 files changed, 38 insertions(+), 95 deletions(-)

diff -puN fs/nfsd/nfs4acl.c~knfsd-nfsd4-simplify-nfsv4-posix-translation fs/nfsd/nfs4acl.c
--- a/fs/nfsd/nfs4acl.c~knfsd-nfsd4-simplify-nfsv4-posix-translation
+++ a/fs/nfsd/nfs4acl.c
@@ -129,9 +129,7 @@ struct ace_container {
 
 static short ace2type(struct nfs4_ace *);
 static int _posix_to_nfsv4_one(struct posix_acl *, struct nfs4_acl *, unsigned int);
-static struct posix_acl *_nfsv4_to_posix_one(struct nfs4_acl *, unsigned int);
 int nfs4_acl_add_ace(struct nfs4_acl *, u32, u32, u32, int, uid_t);
-static int nfs4_acl_split(struct nfs4_acl *, struct nfs4_acl *);
 
 struct nfs4_acl *
 nfs4_acl_posix_to_nfsv4(struct posix_acl *pacl, struct posix_acl *dpacl,
@@ -344,46 +342,6 @@ sort_pacl(struct posix_acl *pacl)
 	return;
 }
 
-int
-nfs4_acl_nfsv4_to_posix(struct nfs4_acl *acl, struct posix_acl **pacl,
-		struct posix_acl **dpacl, unsigned int flags)
-{
-	struct nfs4_acl *dacl;
-	int error = -ENOMEM;
-
-	*pacl = NULL;
-	*dpacl = NULL;
-
-	dacl = nfs4_acl_new();
-	if (dacl == NULL)
-		goto out;
-
-	error = nfs4_acl_split(acl, dacl);
-	if (error)
-		goto out_acl;
-
-	*pacl = _nfsv4_to_posix_one(acl, flags);
-	if (IS_ERR(*pacl)) {
-		error = PTR_ERR(*pacl);
-		*pacl = NULL;
-		goto out_acl;
-	}
-
-	*dpacl = _nfsv4_to_posix_one(dacl, flags);
-	if (IS_ERR(*dpacl)) {
-		error = PTR_ERR(*dpacl);
-		*dpacl = NULL;
-	}
-out_acl:
-	if (error) {
-		posix_acl_release(*pacl);
-		*pacl = NULL;
-	}
-	nfs4_acl_free(dacl);
-out:
-	return error;
-}
-
 /*
  * While processing the NFSv4 ACE, this maintains bitmasks representing
  * which permission bits have been allowed and which denied to a given
@@ -668,76 +626,61 @@ static void process_one_v4_ace(struct po
 	}
 }
 
-static struct posix_acl *
-_nfsv4_to_posix_one(struct nfs4_acl *n4acl, unsigned int flags)
+int nfs4_acl_nfsv4_to_posix(struct nfs4_acl *acl, struct posix_acl **pacl,
+			    struct posix_acl **dpacl, unsigned int flags)
 {
-	struct posix_acl_state state;
-	struct posix_acl *pacl;
+	struct posix_acl_state effective_acl_state, default_acl_state;
 	struct nfs4_ace *ace;
 	int ret;
 
-	ret = init_state(&state, n4acl->naces);
+	ret = init_state(&effective_acl_state, acl->naces);
 	if (ret)
-		return ERR_PTR(ret);
-
-	list_for_each_entry(ace, &n4acl->ace_head, l_ace)
-		process_one_v4_ace(&state, ace);
-
-	pacl = posix_state_to_acl(&state, flags);
-
-	free_state(&state);
-
-	if (!IS_ERR(pacl))
-		sort_pacl(pacl);
-	return pacl;
-}
-
-static int
-nfs4_acl_split(struct nfs4_acl *acl, struct nfs4_acl *dacl)
-{
-	struct list_head *h, *n;
-	struct nfs4_ace *ace;
-	int error = 0;
-
-	list_for_each_safe(h, n, &acl->ace_head) {
-		ace = list_entry(h, struct nfs4_ace, l_ace);
-
+		return ret;
+	ret = init_state(&default_acl_state, acl->naces);
+	if (ret)
+		goto out_estate;
+	ret = -EINVAL;
+	list_for_each_entry(ace, &acl->ace_head, l_ace) {
 		if (ace->type != NFS4_ACE_ACCESS_ALLOWED_ACE_TYPE &&
 		    ace->type != NFS4_ACE_ACCESS_DENIED_ACE_TYPE)
-			return -EINVAL;
-
+			goto out_dstate;
 		if (ace->flag & ~NFS4_SUPPORTED_FLAGS)
-			return -EINVAL;
-
+			goto out_dstate;
 		if ((ace->flag & NFS4_INHERITANCE_FLAGS) == 0) {
-			/* Leave this ace in the effective acl: */
+			process_one_v4_ace(&effective_acl_state, ace);
 			continue;
 		}
+		if (!(flags & NFS4_ACL_DIR))
+			goto out_dstate;
 		/*
 		 * Note that when only one of FILE_INHERIT or DIRECTORY_INHERIT
 		 * is set, we're effectively turning on the other.  That's OK,
 		 * according to rfc 3530.
 		 */
-		if (ace->flag & NFS4_ACE_INHERIT_ONLY_ACE) {
-			/* Add this ace to the default acl and remove it
-			 * from the effective acl: */
-			error = nfs4_acl_add_ace(dacl, ace->type, ace->flag,
-				ace->access_mask, ace->whotype, ace->who);
-			if (error)
-				return error;
-			list_del(h);
-			kfree(ace);
-			acl->naces--;
-		} else {
-			/* Add this ace to the default, but leave it in
-			 * the effective acl as well: */
-			error = nfs4_acl_add_ace(dacl, ace->type, ace->flag,
-				ace->access_mask, ace->whotype, ace->who);
-			if (error)
-				return error;
-		}
+		process_one_v4_ace(&default_acl_state, ace);
+
+		if (!(ace->flag & NFS4_ACE_INHERIT_ONLY_ACE))
+			process_one_v4_ace(&effective_acl_state, ace);
 	}
-	return 0;
+	*pacl = posix_state_to_acl(&effective_acl_state, flags);
+	if (IS_ERR(*pacl)) {
+		ret = PTR_ERR(*pacl);
+		goto out_dstate;
+	}
+	*dpacl = posix_state_to_acl(&default_acl_state, flags);
+	if (IS_ERR(*dpacl)) {
+		ret = PTR_ERR(*dpacl);
+		posix_acl_release(*pacl);
+		goto out_dstate;
+	}
+	sort_pacl(*pacl);
+	sort_pacl(*dpacl);
+	ret = 0;
+out_dstate:
+	free_state(&default_acl_state);
+out_estate:
+	free_state(&effective_acl_state);
+	return ret;
 }
 
 static short
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
