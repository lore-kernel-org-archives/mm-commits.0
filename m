From: akpm@linux-foundation.org
Subject: - knfsd-nfsd-remove-superfluous-assignment-from-nfsd_lookup.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:04:50 -0700
Message-ID: <200707172304.l6HN4oub011858@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41975 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762617AbXGQXP7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: nfsd: remove superfluous assignment from nfsd_lookup
has been removed from the -mm tree.  Its filename was
     knfsd-nfsd-remove-superfluous-assignment-from-nfsd_lookup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: nfsd: remove superfluous assignment from nfsd_lookup
From: J. Bruce Fields <bfields@citi.umich.edu>

The "err" variable will only be used in the final return, which always happens
after either the preceding

	err = fh_compose(...);

or after the following

	err = nfserrno(host_err);

So the earlier assignment to err is ignored.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/vfs.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/nfsd/vfs.c~knfsd-nfsd-remove-superfluous-assignment-from-nfsd_lookup fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~knfsd-nfsd-remove-superfluous-assignment-from-nfsd_lookup
+++ a/fs/nfsd/vfs.c
@@ -168,8 +168,6 @@ nfsd_lookup(struct svc_rqst *rqstp, stru
 	exp  = fhp->fh_export;
 	exp_get(exp);
 
-	err = nfserr_acces;
-
 	/* Lookup the name, but don't follow links */
 	if (isdotent(name, len)) {
 		if (len==1)
_

Patches currently in -mm which might be from bfields@citi.umich.edu are

origin.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
git-vfs-lease-api.patch
