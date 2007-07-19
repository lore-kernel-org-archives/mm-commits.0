From: akpm@linux-foundation.org
Subject: - nfsd-remove-unnecessary-null-checks-from-nfsd_cross_mnt.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:04:40 -0700
Message-ID: <200707192004.l6JK4egW019970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33913 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760871AbXGSUR6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:17:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     nfsd: remove unnecessary NULL checks from nfsd_cross_mnt
has been removed from the -mm tree.  Its filename was
     nfsd-remove-unnecessary-null-checks-from-nfsd_cross_mnt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: nfsd: remove unnecessary NULL checks from nfsd_cross_mnt
From: J. Bruce Fields <bfields@citi.umich.edu>

We can now assume that rqst_exp_get_by_name() does not return NULL; so clean
up some unnecessary checks.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Acked-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/vfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/nfsd/vfs.c~nfsd-remove-unnecessary-null-checks-from-nfsd_cross_mnt fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~nfsd-remove-unnecessary-null-checks-from-nfsd_cross_mnt
+++ a/fs/nfsd/vfs.c
@@ -120,14 +120,14 @@ nfsd_cross_mnt(struct svc_rqst *rqstp, s
 		mntput(mnt);
 		goto out;
 	}
-	if (exp2 && ((exp->ex_flags & NFSEXP_CROSSMOUNT) || EX_NOHIDE(exp2))) {
+	if ((exp->ex_flags & NFSEXP_CROSSMOUNT) || EX_NOHIDE(exp2)) {
 		/* successfully crossed mount point */
 		exp_put(exp);
 		*expp = exp2;
 		dput(dentry);
 		*dpp = mounts;
 	} else {
-		if (exp2) exp_put(exp2);
+		exp_put(exp2);
 		dput(mounts);
 	}
 	mntput(mnt);
_

Patches currently in -mm which might be from bfields@citi.umich.edu are

origin.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
vfs-fix-a-race-in-lease-breaking-during-truncate.patch
locks-kill-redundant-local-variable.patch
