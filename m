From: akpm@linux-foundation.org
Subject: + knfsd-nfsd4-remove-superfluous-cancel_delayed_work-call.patch added to -mm tree
Date: Thu, 22 Mar 2007 23:52:57 -0800
Message-ID: <200703230752.l2N7qvK4009464@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41367 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422657AbXCWHxV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 Mar 2007 03:53:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@fieldses.org, bfields@citi.umich.edu, neilb@suse.de, oleg@tv-sign.ru


The patch titled
     knfsd: nfsd4: remove superfluous cancel_delayed_work() call
has been added to the -mm tree.  Its filename is
     knfsd-nfsd4-remove-superfluous-cancel_delayed_work-call.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: nfsd4: remove superfluous cancel_delayed_work() call
From: "J. Bruce Fields" <bfields@fieldses.org>

This cancel_delayed_work call is called from a function that is only called
from a piece of code that immediate follows a cancel and destruction of the
workqueue, so it's clearly a mistake.

Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4state.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/nfsd/nfs4state.c~knfsd-nfsd4-remove-superfluous-cancel_delayed_work-call fs/nfsd/nfs4state.c
--- a/fs/nfsd/nfs4state.c~knfsd-nfsd4-remove-superfluous-cancel_delayed_work-call
+++ a/fs/nfsd/nfs4state.c
@@ -3260,7 +3260,6 @@ __nfs4_state_shutdown(void)
 		unhash_delegation(dp);
 	}
 
-	cancel_delayed_work(&laundromat_work);
 	nfsd4_shutdown_recdir();
 	nfs4_init = 0;
 }
_

Patches currently in -mm which might be from bfields@fieldses.org are

knfsd-nfsd4-remove-superfluous-cancel_delayed_work-call.patch
