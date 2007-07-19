From: akpm@linux-foundation.org
Subject: + nfsd-remove-unnecessary-null-checks-from-nfsd_cross_mnt.patch added to -mm tree
Date: Wed, 18 Jul 2007 17:16:37 -0700
Message-ID: <200707190016.l6J0GbEw004469@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60474 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754658AbXGSARQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 20:17:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@citi.umich.edu, neilb@suse.de


The patch titled
     nfsd: remove unnecessary NULL checks from nfsd_cross_mnt
has been added to the -mm tree.  Its filename is
     nfsd-remove-unnecessary-null-checks-from-nfsd_cross_mnt.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: nfsd: remove unnecessary NULL checks from nfsd_cross_mnt
From: J. Bruce Fields <bfields@citi.umich.edu>

We can now assume that rqst_exp_get_by_name() does not return NULL; so clean
up some unnecessary checks.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/vfs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

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
git-vfs-lease-api.patch
nfsd-fix-possible-read-ahead-cache-and-export-table-corruption.patch
nfsd-return-errors-not-null-from-export-functions.patch
nfsd-remove-unnecessary-null-checks-from-nfsd_cross_mnt.patch
knfsd-move-ex_rdonly-out-of-header.patch
knfsd-clean-up-ex_rdonly.patch
