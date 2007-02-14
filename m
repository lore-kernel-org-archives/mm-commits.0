From: akpm@linux-foundation.org
Subject: + knfsd-nfsd4-relax-checking-of-acl-inheritance-bits.patch added to -mm tree
Date: Wed, 14 Feb 2007 13:14:25 -0800
Message-ID: <200702142114.l1ELEP8n009267@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46070 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932606AbXBNVOa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 16:14:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@citi.umich.edu, neilb@suse.de


The patch titled
     knfsd: nfsd4: relax checking of ACL inheritance bits
has been added to the -mm tree.  Its filename is
     knfsd-nfsd4-relax-checking-of-acl-inheritance-bits.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: nfsd4: relax checking of ACL inheritance bits
From: J. Bruce Fields <bfields@citi.umich.edu>

The rfc allows us to be more permissive about the ACL inheritance bits we
accept:

	"If the server supports a single "inherit ACE" flag that applies to
	both files and directories, the server may reject the request
	(i.e., requiring the client to set both the file and directory
	inheritance flags). The server may also accept the request and
	silently turn on the ACE4_DIRECTORY_INHERIT_ACE flag."

Let's take the latter option--the ACL is a complex attribute that could be
rejected for a wide variety of reasons, and the protocol gives us little
ability to explain the reason for the rejection, so erroring out is a
user-unfriendly last resort.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4acl.c |   23 +++++++++++++----------
 1 files changed, 13 insertions(+), 10 deletions(-)

diff -puN fs/nfsd/nfs4acl.c~knfsd-nfsd4-relax-checking-of-acl-inheritance-bits fs/nfsd/nfs4acl.c
--- a/fs/nfsd/nfs4acl.c~knfsd-nfsd4-relax-checking-of-acl-inheritance-bits
+++ a/fs/nfsd/nfs4acl.c
@@ -61,9 +61,11 @@
 
 /* flags used to simulate posix default ACLs */
 #define NFS4_INHERITANCE_FLAGS (NFS4_ACE_FILE_INHERIT_ACE \
-		| NFS4_ACE_DIRECTORY_INHERIT_ACE | NFS4_ACE_INHERIT_ONLY_ACE)
+		| NFS4_ACE_DIRECTORY_INHERIT_ACE)
 
-#define NFS4_SUPPORTED_FLAGS (NFS4_INHERITANCE_FLAGS | NFS4_ACE_IDENTIFIER_GROUP)
+#define NFS4_SUPPORTED_FLAGS (NFS4_INHERITANCE_FLAGS \
+		| NFS4_ACE_INHERIT_ONLY_ACE \
+		| NFS4_ACE_IDENTIFIER_GROUP)
 
 #define MASK_EQUAL(mask1, mask2) \
 	( ((mask1) & NFS4_ACE_MASK_ALL) == ((mask2) & NFS4_ACE_MASK_ALL) )
@@ -707,11 +709,16 @@ nfs4_acl_split(struct nfs4_acl *acl, str
 		if (ace->flag & ~NFS4_SUPPORTED_FLAGS)
 			return -EINVAL;
 
-		switch (ace->flag & NFS4_INHERITANCE_FLAGS) {
-		case 0:
+		if ((ace->flag & NFS4_INHERITANCE_FLAGS) == 0) {
 			/* Leave this ace in the effective acl: */
 			continue;
-		case NFS4_INHERITANCE_FLAGS:
+		}
+		/*
+		 * Note that when only one of FILE_INHERIT or DIRECTORY_INHERIT
+		 * is set, we're effectively turning on the other.  That's OK,
+		 * according to rfc 3530.
+		 */
+		if (ace->flag & NFS4_ACE_INHERIT_ONLY_ACE) {
 			/* Add this ace to the default acl and remove it
 			 * from the effective acl: */
 			error = nfs4_acl_add_ace(dacl, ace->type, ace->flag,
@@ -721,17 +728,13 @@ nfs4_acl_split(struct nfs4_acl *acl, str
 			list_del(h);
 			kfree(ace);
 			acl->naces--;
-			break;
-		case NFS4_INHERITANCE_FLAGS & ~NFS4_ACE_INHERIT_ONLY_ACE:
+		} else {
 			/* Add this ace to the default, but leave it in
 			 * the effective acl as well: */
 			error = nfs4_acl_add_ace(dacl, ace->type, ace->flag,
 				ace->access_mask, ace->whotype, ace->who);
 			if (error)
 				return error;
-			break;
-		default:
-			return -EINVAL;
 		}
 	}
 	return 0;
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
