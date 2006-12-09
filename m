From: akpm@osdl.org
Subject: + knfsd-nfsd4-remove-a-dprink-from-nfsd4_lock.patch added to -mm tree
Date: Fri, 08 Dec 2006 16:09:20 -0800
Message-ID: <200612090009.kB909Kk5010365@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:55529 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947519AbWLIAJf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 19:09:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@fieldses.org, bfields@citi.umich.edu, neilb@suse.de


The patch titled
     knfsd: nfsd4: remove a dprink from nfsd4_lock
has been added to the -mm tree.  Its filename is
     knfsd-nfsd4-remove-a-dprink-from-nfsd4_lock.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: nfsd4: remove a dprink from nfsd4_lock
From: J.Bruce Fields <bfields@fieldses.org>

This dprintk is printing the wrong error now, but it's probably an unnecessary
dprintk anyway; just remove it.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/nfsd/nfs4state.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN fs/nfsd/nfs4state.c~knfsd-nfsd4-remove-a-dprink-from-nfsd4_lock fs/nfsd/nfs4state.c
--- a/fs/nfsd/nfs4state.c~knfsd-nfsd4-remove-a-dprink-from-nfsd4_lock
+++ a/fs/nfsd/nfs4state.c
@@ -2759,7 +2759,6 @@ nfsd4_lock(struct svc_rqst *rqstp, struc
 	conflock.fl_ops = NULL;
 	conflock.fl_lmops = NULL;
 	err = posix_lock_file_conf(filp, &file_lock, &conflock);
-	dprintk("NFSD: nfsd4_lock: posix_lock_file_conf status %d\n",status);
 	switch (-err) {
 	case 0: /* success! */
 		update_stateid(&lock_stp->st_stateid);
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

