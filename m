From: akpm@osdl.org
Subject: - knfsd-nfsd4-remove-a-dprink-from-nfsd4_lock.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:14:24 -0800
Message-ID: <200612140614.kBE6EONW002151@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52417 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957AbWLNGO6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:14:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@fieldses.org, bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: nfsd4: remove a dprink from nfsd4_lock
has been removed from the -mm tree.  Its filename was
     knfsd-nfsd4-remove-a-dprink-from-nfsd4_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 1 deletion(-)

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


