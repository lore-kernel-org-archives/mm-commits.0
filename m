From: akpm@linux-foundation.org
Subject: - git-nfsd.patch removed from -mm tree
Date: Mon, 05 May 2008 12:17:03 -0700
Message-ID: <200805051917.m45JH3on000428@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59126 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760667AbYEETRI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2008 15:17:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@citi.umich.edu, mm-commits@vger.kernel.org


The patch titled
     git-nfsd.patch
has been removed from the -mm tree.  Its filename was
     git-nfsd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: git-nfsd.patch

GIT 4187505b88bf7eb04d82d1e89e4e19be7922da8c git://git.linux-nfs.org/~bfields/linux.git#for-mm

commit 4187505b88bf7eb04d82d1e89e4e19be7922da8c
Author: J. Bruce Fields <bfields@citi.umich.edu>
Date:   Mon Apr 28 18:22:50 2008 -0400

    nfsd: remove unnecessary atomic ops
    
    These bit operations don't need to be atomic.  They're all done under a
    single big mutex anyway.
    
    Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
 fs/nfsd/nfs4state.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 8799b87..5c97d47 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1579,8 +1579,8 @@ nfs4_upgrade_open(struct svc_rqst *rqstp, struct svc_fh *cur_fh, struct nfs4_sta
 	}
 	/* remember the open */
 	filp->f_mode |= open->op_share_access;
-	set_bit(open->op_share_access, &stp->st_access_bmap);
-	set_bit(open->op_share_deny, &stp->st_deny_bmap);
+	__set_bit(open->op_share_access, &stp->st_access_bmap);
+	__set_bit(open->op_share_deny, &stp->st_deny_bmap);
 
 	return nfs_ok;
 }

Patches currently in -mm which might be from bfields@citi.umich.edu are

linux-next.patch
reiser4.patch

