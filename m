From: akpm@linux-foundation.org
Subject: + knfsd-move-ex_rdonly-out-of-header.patch added to -mm tree
Date: Wed, 18 Jul 2007 17:16:39 -0700
Message-ID: <200707190016.l6J0Gdg6004472@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44877 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760971AbXGSARR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 20:17:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@citi.umich.edu, neilb@suse.de


The patch titled
     knfsd: move EX_RDONLY out of header
has been added to the -mm tree.  Its filename is
     knfsd-move-ex_rdonly-out-of-header.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: move EX_RDONLY out of header
From: J. Bruce Fields <bfields@citi.umich.edu>

EX_RDONLY is only called in one place; just put it there.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: Neil Brown <neilb@suse.de>
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
git-vfs-lease-api.patch
nfsd-fix-possible-read-ahead-cache-and-export-table-corruption.patch
nfsd-return-errors-not-null-from-export-functions.patch
nfsd-remove-unnecessary-null-checks-from-nfsd_cross_mnt.patch
knfsd-move-ex_rdonly-out-of-header.patch
knfsd-clean-up-ex_rdonly.patch
