From: akpm@linux-foundation.org
Subject: [merged] swap-dont-do-discard-if-no-discard-option-added.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:19:26 -0700
Message-ID: <20120322201926.68AE9A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:39689 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030638Ab2CVUT1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:19:27 -0400
Received: by qabg24 with SMTP id g24so62245qab.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:19:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shli@kernel.org, Holger.Kiehl@dwd.de, hughd@google.com, shli@fusionio.com, mm-commits@vger.kernel.org


The patch titled
     Subject: swap: don't do discard if no discard option added
has been removed from the -mm tree.  Its filename was
     swap-dont-do-discard-if-no-discard-option-added.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Shaohua Li <shli@kernel.org>
Subject: swap: don't do discard if no discard option added

When swapon() was not passed the SWAP_FLAG_DISCARD option, sys_swapon()
will still perform a discard operation.  This can cause problems if
discard is slow or buggy.

Reverse the order of the check so that a discard operation is performed
only if the sys_swapon() caller is attempting to enable discard.

Signed-off-by: Shaohua Li <shli@fusionio.com>
Reported-by: Holger Kiehl <Holger.Kiehl@dwd.de>
Tested-by: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swapfile.c~swap-dont-do-discard-if-no-discard-option-added mm/swapfile.c
--- a/mm/swapfile.c~swap-dont-do-discard-if-no-discard-option-added
+++ a/mm/swapfile.c
@@ -2103,7 +2103,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 			p->flags |= SWP_SOLIDSTATE;
 			p->cluster_next = 1 + (random32() % p->highest_bit);
 		}
-		if (discard_swap(p) == 0 && (swap_flags & SWAP_FLAG_DISCARD))
+		if ((swap_flags & SWAP_FLAG_DISCARD) && discard_swap(p) == 0)
 			p->flags |= SWP_DISCARDABLE;
 	}
 
_

Patches currently in -mm which might be from shli@kernel.org are

origin.patch

