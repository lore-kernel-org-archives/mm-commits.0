From: akpm@osdl.org
Subject: + knfsd-nfsd-make-exp_rootfh-handle-exp_parent-errors.patch added to -mm tree
Date: Fri, 08 Dec 2006 16:09:26 -0800
Message-ID: <200612090009.kB909QZC010383@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:55557 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947519AbWLIAJm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 19:09:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@fieldses.org, bfields@citi.umich.edu, neilb@suse.de


The patch titled
     knfsd: nfsd: make exp_rootfh handle exp_parent errors
has been added to the -mm tree.  Its filename is
     knfsd-nfsd-make-exp_rootfh-handle-exp_parent-errors.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 4 insertions(+)

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

origin.patch
knfsd-nfsd4-remove-a-dprink-from-nfsd4_lock.patch
knfsd-svcrpc-fix-gss-krb5i-memory-leak.patch
knfsd-nfsd4-clarify-units-of-compound_slack_space.patch
knfsd-nfsd-make-exp_rootfh-handle-exp_parent-errors.patch
knfsd-nfsd-simplify-exp_pseudoroot.patch
knfsd-nfsd4-handling-more-nfsd_cross_mnt-errors-in-nfsd4-readdir.patch
knfsd-nfsd-dont-drop-silently-on-upcall-deferral.patch
knfsd-svcrpc-remove-another-silent-drop-from-deferral-code.patch
knfsd-nfsd4-pass-saved-and-current-fh-together-into-nfsd4-operations.patch
knfsd-nfsd4-remove-spurious-replay_owner-check.patch
knfsd-nfsd4-move-replay_owner-to-cstate.patch
knfsd-nfsd4-dont-inline-nfsd4-compound-op-functions.patch
knfsd-nfsd4-make-verify-and-nverify-wrappers.patch
knfsd-nfsd4-reorganize-compound-ops.patch
knfsd-nfsd4-simplify-migration-op-check.patch
knfsd-nfsd4-simplify-filehandle-check.patch

