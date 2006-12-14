From: akpm@osdl.org
Subject: - knfsd-nfsd-make-exp_rootfh-handle-exp_parent-errors.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:14:54 -0800
Message-ID: <200612140614.kBE6EsMJ002168@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52439 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbWLNGP2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:15:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@fieldses.org, bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: nfsd: make exp_rootfh handle exp_parent errors
has been removed from the -mm tree.  Its filename was
     knfsd-nfsd-make-exp_rootfh-handle-exp_parent-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: nfsd: make exp_rootfh handle exp_parent errors
From: J.Bruce Fields <bfields@fieldses.org>

Since exp_parent can fail by returning an error (-EAGAIN) in addition to by
returning NULL, we should check for that case in exp_rootfh.

(TODO: we should check that userland handles these errors too.)

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/nfsd/export.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/nfsd/export.c~knfsd-nfsd-make-exp_rootfh-handle-exp_parent-errors fs/nfsd/export.c
--- a/fs/nfsd/export.c~knfsd-nfsd-make-exp_rootfh-handle-exp_parent-errors
+++ a/fs/nfsd/export.c
@@ -1104,6 +1104,10 @@ exp_rootfh(svc_client *clp, char *path, 
 		 path, nd.dentry, clp->name,
 		 inode->i_sb->s_id, inode->i_ino);
 	exp = exp_parent(clp, nd.mnt, nd.dentry, NULL);
+	if (IS_ERR(exp)) {
+		err = PTR_ERR(exp);
+		goto out;
+	}
 	if (!exp) {
 		dprintk("nfsd: exp_rootfh export not found.\n");
 		goto out;
_

Patches currently in -mm which might be from bfields@fieldses.org are


