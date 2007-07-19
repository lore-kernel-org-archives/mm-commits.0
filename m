From: akpm@linux-foundation.org
Subject: - knfsd-clean-up-ex_rdonly.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:04:44 -0700
Message-ID: <200707192004.l6JK4iul019976@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34162 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761585AbXGSUSI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:18:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: clean up EX_RDONLY
has been removed from the -mm tree.  Its filename was
     knfsd-clean-up-ex_rdonly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: clean up EX_RDONLY
From: J. Bruce Fields <bfields@citi.umich.edu>

Share a little common code, reverse the arguments for consistency, drop the
unnecessary "inline", and lowercase the name.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Acked-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/auth.c              |    3 ++-
 fs/nfsd/vfs.c               |   13 +++----------
 include/linux/nfsd/export.h |    1 +
 3 files changed, 6 insertions(+), 11 deletions(-)

diff -puN fs/nfsd/auth.c~knfsd-clean-up-ex_rdonly fs/nfsd/auth.c
--- a/fs/nfsd/auth.c~knfsd-clean-up-ex_rdonly
+++ a/fs/nfsd/auth.c
@@ -9,10 +9,11 @@
 #include <linux/sunrpc/svc.h>
 #include <linux/sunrpc/svcauth.h>
 #include <linux/nfsd/nfsd.h>
+#include <linux/nfsd/export.h>
 
 #define	CAP_NFSD_MASK (CAP_FS_MASK|CAP_TO_MASK(CAP_SYS_RESOURCE))
 
-static int nfsexp_flags(struct svc_rqst *rqstp, struct svc_export *exp)
+int nfsexp_flags(struct svc_rqst *rqstp, struct svc_export *exp)
 {
 	struct exp_flavor_info *f;
 	struct exp_flavor_info *end = exp->ex_flavors + exp->ex_nflavors;
diff -puN fs/nfsd/vfs.c~knfsd-clean-up-ex_rdonly fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~knfsd-clean-up-ex_rdonly
+++ a/fs/nfsd/vfs.c
@@ -1797,16 +1797,9 @@ nfsd_statfs(struct svc_rqst *rqstp, stru
 	return err;
 }
 
-static inline int EX_RDONLY(struct svc_export *exp, struct svc_rqst *rqstp)
+static int exp_rdonly(struct svc_rqst *rqstp, struct svc_export *exp)
 {
-	struct exp_flavor_info *f;
-	struct exp_flavor_info *end = exp->ex_flavors + exp->ex_nflavors;
-
-	for (f = exp->ex_flavors; f < end; f++) {
-		if (f->pseudoflavor == rqstp->rq_flavor)
-			return f->flags & NFSEXP_READONLY;
-	}
-	return exp->ex_flags & NFSEXP_READONLY;
+	return nfsexp_flags(rqstp, exp) & NFSEXP_READONLY;
 }
 
 /*
@@ -1845,7 +1838,7 @@ nfsd_permission(struct svc_rqst *rqstp, 
 	 */
 	if (!(acc & MAY_LOCAL_ACCESS))
 		if (acc & (MAY_WRITE | MAY_SATTR | MAY_TRUNC)) {
-			if (EX_RDONLY(exp, rqstp) || IS_RDONLY(inode))
+			if (exp_rdonly(rqstp, exp) || IS_RDONLY(inode))
 				return nfserr_rofs;
 			if (/* (acc & MAY_WRITE) && */ IS_IMMUTABLE(inode))
 				return nfserr_perm;
diff -puN include/linux/nfsd/export.h~knfsd-clean-up-ex_rdonly include/linux/nfsd/export.h
--- a/include/linux/nfsd/export.h~knfsd-clean-up-ex_rdonly
+++ a/include/linux/nfsd/export.h
@@ -116,6 +116,7 @@ struct svc_expkey {
 #define EX_NOHIDE(exp)		((exp)->ex_flags & NFSEXP_NOHIDE)
 #define EX_WGATHER(exp)		((exp)->ex_flags & NFSEXP_GATHERED_WRITES)
 
+int nfsexp_flags(struct svc_rqst *rqstp, struct svc_export *exp);
 __be32 check_nfsd_access(struct svc_export *exp, struct svc_rqst *rqstp);
 
 /*
_

Patches currently in -mm which might be from bfields@citi.umich.edu are

origin.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
vfs-fix-a-race-in-lease-breaking-during-truncate.patch
locks-kill-redundant-local-variable.patch
