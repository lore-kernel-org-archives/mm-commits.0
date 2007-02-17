From: akpm@linux-foundation.org
Subject: - knfsd-nfsd4-acls-dont-return-explicit-mask.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:16:22 -0800
Message-ID: <200702170716.l1H7GMDt021697@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51124 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946493AbXBQHQ1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:16:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@snoopy.citi.umich.edu, bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: nfsd4: acls: don't return explicit mask
has been removed from the -mm tree.  Its filename was
     knfsd-nfsd4-acls-dont-return-explicit-mask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: nfsd4: acls: don't return explicit mask
From: J. Bruce Fields <bfields@snoopy.citi.umich.edu>

Return just the effective permissions, and forget about the mask.  It isn't
worth the complexity.

WARNING: This breaks backwards compatibility with overly-picky nfsv4->posix
acl translation, as may has been included in some patched versions of libacl. 
To our knowledge no such version was every distributed by anyone outside citi.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4acl.c |   25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff -puN fs/nfsd/nfs4acl.c~knfsd-nfsd4-acls-dont-return-explicit-mask fs/nfsd/nfs4acl.c
--- a/fs/nfsd/nfs4acl.c~knfsd-nfsd4-acls-dont-return-explicit-mask
+++ a/fs/nfsd/nfs4acl.c
@@ -180,7 +180,8 @@ _posix_to_nfsv4_one(struct posix_acl *pa
 						unsigned int flags)
 {
 	struct posix_acl_entry *pa, *pe, *group_owner_entry;
-	u32 mask, mask_mask;
+	u32 mask;
+	unsigned short mask_mask;
 	int eflag = ((flags & NFS4_ACL_TYPE_DEFAULT) ?
 					NFS4_INHERITANCE_FLAGS : 0);
 
@@ -188,9 +189,9 @@ _posix_to_nfsv4_one(struct posix_acl *pa
 	pe = pacl->a_entries + pacl->a_count;
 	pa = pe - 2; /* if mask entry exists, it's second from the last. */
 	if (pa->e_tag == ACL_MASK)
-		mask_mask = deny_mask(mask_from_posix(pa->e_perm, flags), flags);
+		mask_mask = pa->e_perm;
 	else
-		mask_mask = 0;
+		mask_mask = S_IRWXO;
 
 	pa = pacl->a_entries;
 	BUG_ON(pa->e_tag != ACL_USER_OBJ);
@@ -199,10 +200,7 @@ _posix_to_nfsv4_one(struct posix_acl *pa
 	pa++;
 
 	while (pa->e_tag == ACL_USER) {
-		mask = mask_from_posix(pa->e_perm, flags);
-		nfs4_acl_add_ace(acl, NFS4_ACE_ACCESS_DENIED_ACE_TYPE,
-				eflag,  mask_mask, NFS4_ACL_WHO_NAMED, pa->e_id);
-
+		mask = mask_from_posix(pa->e_perm & mask_mask, flags);
 		nfs4_acl_add_pair(acl, eflag, mask,
 				NFS4_ACL_WHO_NAMED, pa->e_id, flags);
 		pa++;
@@ -213,24 +211,15 @@ _posix_to_nfsv4_one(struct posix_acl *pa
 
 	/* allow ACEs */
 
-	if (pacl->a_count > 3) {
-		BUG_ON(pa->e_tag != ACL_GROUP_OBJ);
-		nfs4_acl_add_ace(acl, NFS4_ACE_ACCESS_DENIED_ACE_TYPE,
-				NFS4_ACE_IDENTIFIER_GROUP | eflag, mask_mask,
-				NFS4_ACL_WHO_GROUP, 0);
-	}
 	group_owner_entry = pa;
-	mask = mask_from_posix(pa->e_perm, flags);
+	mask = mask_from_posix(pa->e_perm & mask_mask, flags);
 	nfs4_acl_add_ace(acl, NFS4_ACE_ACCESS_ALLOWED_ACE_TYPE,
 			NFS4_ACE_IDENTIFIER_GROUP | eflag, mask,
 			NFS4_ACL_WHO_GROUP, 0);
 	pa++;
 
 	while (pa->e_tag == ACL_GROUP) {
-		mask = mask_from_posix(pa->e_perm, flags);
-		nfs4_acl_add_ace(acl, NFS4_ACE_ACCESS_DENIED_ACE_TYPE,
-				NFS4_ACE_IDENTIFIER_GROUP | eflag, mask_mask,
-				NFS4_ACL_WHO_NAMED, pa->e_id);
+		mask = mask_from_posix(pa->e_perm & mask_mask, flags);
 		nfs4_acl_add_ace(acl, NFS4_ACE_ACCESS_ALLOWED_ACE_TYPE,
 		    		NFS4_ACE_IDENTIFIER_GROUP | eflag, mask,
 		    		NFS4_ACL_WHO_NAMED, pa->e_id);
_

Patches currently in -mm which might be from bfields@snoopy.citi.umich.edu are

origin.patch
