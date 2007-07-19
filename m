From: akpm@linux-foundation.org
Subject: - knfsd-move-ex_rdonly-out-of-header.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:04:42 -0700
Message-ID: <200707192004.l6JK4gcs019973@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52579 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761407AbXGSUR7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:17:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: move EX_RDONLY out of header
has been removed from the -mm tree.  Its filename was
     knfsd-move-ex_rdonly-out-of-header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: move EX_RDONLY out of header
From: J. Bruce Fields <bfields@citi.umich.edu>

EX_RDONLY is only called in one place; just put it there.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Acked-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/vfs.c               |   12 ++++++++++++
 include/linux/nfsd/export.h |   12 ------------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff -puN fs/nfsd/vfs.c~knfsd-move-ex_rdonly-out-of-header fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~knfsd-move-ex_rdonly-out-of-header
+++ a/fs/nfsd/vfs.c
@@ -1797,6 +1797,18 @@ nfsd_statfs(struct svc_rqst *rqstp, stru
 	return err;
 }
 
+static inline int EX_RDONLY(struct svc_export *exp, struct svc_rqst *rqstp)
+{
+	struct exp_flavor_info *f;
+	struct exp_flavor_info *end = exp->ex_flavors + exp->ex_nflavors;
+
+	for (f = exp->ex_flavors; f < end; f++) {
+		if (f->pseudoflavor == rqstp->rq_flavor)
+			return f->flags & NFSEXP_READONLY;
+	}
+	return exp->ex_flags & NFSEXP_READONLY;
+}
+
 /*
  * Check for a user's access permissions to this inode.
  */
diff -puN include/linux/nfsd/export.h~knfsd-move-ex_rdonly-out-of-header include/linux/nfsd/export.h
--- a/include/linux/nfsd/export.h~knfsd-move-ex_rdonly-out-of-header
+++ a/include/linux/nfsd/export.h
@@ -116,18 +116,6 @@ struct svc_expkey {
 #define EX_NOHIDE(exp)		((exp)->ex_flags & NFSEXP_NOHIDE)
 #define EX_WGATHER(exp)		((exp)->ex_flags & NFSEXP_GATHERED_WRITES)
 
-static inline int EX_RDONLY(struct svc_export *exp, struct svc_rqst *rqstp)
-{
-	struct exp_flavor_info *f;
-	struct exp_flavor_info *end = exp->ex_flavors + exp->ex_nflavors;
-
-	for (f = exp->ex_flavors; f < end; f++) {
-		if (f->pseudoflavor == rqstp->rq_flavor)
-			return f->flags & NFSEXP_READONLY;
-	}
-	return exp->ex_flags & NFSEXP_READONLY;
-}
-
 __be32 check_nfsd_access(struct svc_export *exp, struct svc_rqst *rqstp);
 
 /*
_

Patches currently in -mm which might be from bfields@citi.umich.edu are

origin.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
vfs-fix-a-race-in-lease-breaking-during-truncate.patch
locks-kill-redundant-local-variable.patch
