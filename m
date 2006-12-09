From: akpm@osdl.org
Subject: + knfsd-nfsd4-remove-spurious-replay_owner-check.patch added to -mm tree
Date: Fri, 08 Dec 2006 16:09:38 -0800
Message-ID: <200612090009.kB909ci2010410@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:55599 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947574AbWLIAJw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 19:09:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@fieldses.org, bfields@citi.umich.edu, neilb@suse.de


The patch titled
     knfsd: nfsd4: remove spurious replay_owner check
has been added to the -mm tree.  Its filename is
     knfsd-nfsd4-remove-spurious-replay_owner-check.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: nfsd4: remove spurious replay_owner check
From: J.Bruce Fields <bfields@fieldses.org>

OK, this is embarassing--I've even looked back at the history, and cannot for
the life of me figure out why I added this check.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/nfsd/nfs4proc.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nfsd/nfs4proc.c~knfsd-nfsd4-remove-spurious-replay_owner-check fs/nfsd/nfs4proc.c
--- a/fs/nfsd/nfs4proc.c~knfsd-nfsd4-remove-spurious-replay_owner-check
+++ a/fs/nfsd/nfs4proc.c
@@ -1008,7 +1008,7 @@ encode_op:
 			nfsd4_encode_operation(resp, op);
 			status = op->status;
 		}
-		if (replay_owner && (replay_owner != (void *)(-1))) {
+		if (replay_owner) {
 			nfs4_put_stateowner(replay_owner);
 			replay_owner = NULL;
 		}
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

