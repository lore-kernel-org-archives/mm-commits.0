From: akpm@linux-foundation.org
Subject: - knfsd-nfsd4-fix-inheritance-flags-on-v4-ace-derived-from-posix-default-ace.patch removed from -mm tree
Date: Thu, 29 Mar 2007 00:41:34 -0700
Message-ID: <200703290741.l2T7fYS5030240@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46042 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753310AbXC2Hlk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 03:41:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: nfsd4: fix inheritance flags on v4 ace derived from posix default ace
has been removed from the -mm tree.  Its filename was
     knfsd-nfsd4-fix-inheritance-flags-on-v4-ace-derived-from-posix-default-ace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: nfsd4: fix inheritance flags on v4 ace derived from posix default ace
From: Bruce Fields <bfields@citi.umich.edu>

A regression introduced in the last set of acl patches removed the
INHERIT_ONLY flag from aces derived from the posix acl.  Fix.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4acl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nfsd/nfs4acl.c~knfsd-nfsd4-fix-inheritance-flags-on-v4-ace-derived-from-posix-default-ace fs/nfsd/nfs4acl.c
--- a/fs/nfsd/nfs4acl.c~knfsd-nfsd4-fix-inheritance-flags-on-v4-ace-derived-from-posix-default-ace
+++ a/fs/nfsd/nfs4acl.c
@@ -228,7 +228,7 @@ _posix_to_nfsv4_one(struct posix_acl *pa
 	struct posix_acl_summary pas;
 	unsigned short deny;
 	int eflag = ((flags & NFS4_ACL_TYPE_DEFAULT) ?
-					NFS4_INHERITANCE_FLAGS : 0);
+		NFS4_INHERITANCE_FLAGS | NFS4_ACE_INHERIT_ONLY_ACE : 0);
 
 	BUG_ON(pacl->a_count < 3);
 	summarize_posix_acl(pacl, &pas);
_

Patches currently in -mm which might be from bfields@citi.umich.edu are

origin.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
remove-nfs4_acl_add_ace.patch
