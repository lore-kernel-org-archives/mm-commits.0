From: akpm@linux-foundation.org
Subject: - knfsd-nfsd-allow-auth_sys-nlm-on-rpcsec_gss-exports.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:05:15 -0700
Message-ID: <200707172305.l6HN5FKH011901@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42455 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935394AbXGQXPV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: nfsd: allow auth_sys nlm on rpcsec_gss exports
has been removed from the -mm tree.  Its filename was
     knfsd-nfsd-allow-auth_sys-nlm-on-rpcsec_gss-exports.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: nfsd: allow auth_sys nlm on rpcsec_gss exports
From: J. Bruce Fields <bfields@citi.umich.edu>

Our clients (like other clients, as far as I know) use only auth_sys for nlm,
even when using rpcsec_gss for the main nfs operations.

Administrators that want to deny non-kerberos-authenticated locking requests
will need to turn off NFS protocol versions less than 4....

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfsfh.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN fs/nfsd/nfsfh.c~knfsd-nfsd-allow-auth_sys-nlm-on-rpcsec_gss-exports fs/nfsd/nfsfh.c
--- a/fs/nfsd/nfsfh.c~knfsd-nfsd-allow-auth_sys-nlm-on-rpcsec_gss-exports
+++ a/fs/nfsd/nfsfh.c
@@ -249,10 +249,16 @@ fh_verify(struct svc_rqst *rqstp, struct
 	if (error)
 		goto out;
 
-	/* Check security flavor */
-	error = check_nfsd_access(exp, rqstp);
-	if (error)
-		goto out;
+	if (!(access & MAY_LOCK)) {
+		/*
+		 * pseudoflavor restrictions are not enforced on NLM,
+		 * which clients virtually always use auth_sys for,
+		 * even while using RPCSEC_GSS for NFS.
+		 */
+		error = check_nfsd_access(exp, rqstp);
+		if (error)
+			goto out;
+	}
 
 	/* Finally, check access permissions. */
 	error = nfsd_permission(rqstp, exp, dentry, access);
_

Patches currently in -mm which might be from bfields@citi.umich.edu are

origin.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
git-vfs-lease-api.patch
