From: akpm@linux-foundation.org
Subject: - knfsd-nfsd4-fix-handling-of-directories-without-default-acls.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:16:28 -0800
Message-ID: <200702170716.l1H7GSkd021704@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51133 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946499AbXBQHQd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:16:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: nfsd4: fix handling of directories without default ACLs
has been removed from the -mm tree.  Its filename was
     knfsd-nfsd4-fix-handling-of-directories-without-default-acls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: nfsd4: fix handling of directories without default ACLs
From: J. Bruce Fields <bfields@citi.umich.edu>

When setting an ACL that lacks inheritable ACEs on a directory, we should set
a default ACL of zero length, not a default ACL with all bits denied.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4acl.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff -puN fs/nfsd/nfs4acl.c~knfsd-nfsd4-fix-handling-of-directories-without-default-acls fs/nfsd/nfs4acl.c
--- a/fs/nfsd/nfs4acl.c~knfsd-nfsd4-fix-handling-of-directories-without-default-acls
+++ a/fs/nfsd/nfs4acl.c
@@ -416,6 +416,7 @@ struct posix_ace_state_array {
  * calculated so far: */
 
 struct posix_acl_state {
+	int empty;
 	struct posix_ace_state owner;
 	struct posix_ace_state group;
 	struct posix_ace_state other;
@@ -431,6 +432,7 @@ init_state(struct posix_acl_state *state
 	int alloc;
 
 	memset(state, 0, sizeof(struct posix_acl_state));
+	state->empty = 1;
 	/*
 	 * In the worst case, each individual acl could be for a distinct
 	 * named user or group, but we don't no which, so we allocate
@@ -498,6 +500,20 @@ posix_state_to_acl(struct posix_acl_stat
 	int nace;
 	int i, error = 0;
 
+	/*
+	 * ACLs with no ACEs are treated differently in the inheritable
+	 * and effective cases: when there are no inheritable ACEs, we
+	 * set a zero-length default posix acl:
+	 */
+	if (state->empty && (flags & NFS4_ACL_TYPE_DEFAULT)) {
+		pacl = posix_acl_alloc(0, GFP_KERNEL);
+		return pacl ? pacl : ERR_PTR(-ENOMEM);
+	}
+	/*
+	 * When there are no effective ACEs, the following will end
+	 * up setting a 3-element effective posix ACL with all
+	 * permissions zero.
+	 */
 	nace = 4 + state->users->n + state->groups->n;
 	pacl = posix_acl_alloc(nace, GFP_KERNEL);
 	if (!pacl)
@@ -613,6 +629,8 @@ static void process_one_v4_ace(struct po
 	u32 mask = ace->access_mask;
 	int i;
 
+	state->empty = 0;
+
 	switch (ace2type(ace)) {
 	case ACL_USER_OBJ:
 		if (ace->type == NFS4_ACE_ACCESS_ALLOWED_ACE_TYPE) {
@@ -717,7 +735,8 @@ int nfs4_acl_nfsv4_to_posix(struct nfs4_
 		ret = PTR_ERR(*pacl);
 		goto out_dstate;
 	}
-	*dpacl = posix_state_to_acl(&default_acl_state, flags);
+	*dpacl = posix_state_to_acl(&default_acl_state,
+						flags | NFS4_ACL_TYPE_DEFAULT);
 	if (IS_ERR(*dpacl)) {
 		ret = PTR_ERR(*dpacl);
 		posix_acl_release(*pacl);
_

Patches currently in -mm which might be from bfields@citi.umich.edu are

origin.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
