From: akpm@linux-foundation.org
Subject: + drivers-scsi-correct-use-of-and.patch added to -mm tree
Date: Thu, 05 Feb 2009 13:10:09 -0800
Message-ID: <200902052110.n15LA9pK005778@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46996 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752643AbZBEVKR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2009 16:10:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, James.Bottomley@HansenPartnership.com, robert.w.love@intel.com


The patch titled
     drivers/scsi: correct use of ! and &
has been added to the -mm tree.  Its filename is
     drivers-scsi-correct-use-of-and.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
drivers-scsi-correct-use-of-and.patch

