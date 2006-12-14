From: akpm@osdl.org
Subject: - knfsd-nfsd4-remove-spurious-replay_owner-check.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:16:11 -0800
Message-ID: <200612140616.kBE6GBdN002238@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52558 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbWLNGQz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:16:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@fieldses.org, bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: nfsd4: remove spurious replay_owner check
has been removed from the -mm tree.  Its filename was
     knfsd-nfsd4-remove-spurious-replay_owner-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 1 insertion(+), 1 deletion(-)

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


