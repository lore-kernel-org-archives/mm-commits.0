From: akpm@linux-foundation.org
Subject: [merged] drivers-scsi-correct-use-of-and.patch removed from -mm tree
Date: Fri, 06 Mar 2009 11:28:36 -0800
Message-ID: <200903061928.n26JSaA8022783@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41906 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755530AbZCFTa0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Mar 2009 14:30:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, James.Bottomley@HansenPartnership.com, james.smart@emulex.com, robert.w.love@intel.com, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi: correct use of ! and &
has been removed from the -mm tree.  Its filename was
     drivers-scsi-correct-use-of-and.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/scsi: correct use of ! and &
From: Julia Lawall <julia@diku.dk>

!ep->esb_stat is either 1 or 0, and the rightmost bit of ESB_ST_COMPLETE is
always 0, making the result of !ep->esb_stat & ESB_ST_COMPLETE always 0.
Thus parentheses around the argument to ! seem needed.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@ expression E; constant C; @@
(
  !E & !C
|
- !E & C
+ !(E & C)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Robert Love <robert.w.love@intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/libfc/fc_exch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/libfc/fc_exch.c~drivers-scsi-correct-use-of-and drivers/scsi/libfc/fc_exch.c
--- a/drivers/scsi/libfc/fc_exch.c~drivers-scsi-correct-use-of-and
+++ a/drivers/scsi/libfc/fc_exch.c
@@ -283,7 +283,7 @@ static void fc_exch_release(struct fc_ex
 			ep->destructor(&ep->seq, ep->arg);
 		if (ep->lp->tt.exch_put)
 			ep->lp->tt.exch_put(ep->lp, mp, ep->xid);
-		WARN_ON(!ep->esb_stat & ESB_ST_COMPLETE);
+		WARN_ON(!(ep->esb_stat & ESB_ST_COMPLETE));
 		mempool_free(ep, mp->ep_pool);
 	}
 }
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch

