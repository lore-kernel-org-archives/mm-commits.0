From: akpm@linux-foundation.org
Subject: - knfsd-nfsd4-relax-checking-of-acl-inheritance-bits.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:16:09 -0800
Message-ID: <200702170716.l1H7G9CU021679@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51094 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946478AbXBQHQO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:16:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: nfsd4: relax checking of ACL inheritance bits
has been removed from the -mm tree.  Its filename was
     knfsd-nfsd4-relax-checking-of-acl-inheritance-bits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 13 insertions(+), 10 deletions(-)

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

origin.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
