From: akpm@linux-foundation.org
Subject: + swap-dont-do-discard-if-no-discard-option-added.patch added to -mm tree
Date: Tue, 20 Mar 2012 12:42:33 -0700
Message-ID: <20120320194233.E5E65A02AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:60243 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202Ab2CTTmf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Mar 2012 15:42:35 -0400
Received: by qabg24 with SMTP id g24so31180qab.1
        for <mm-commits@vger.kernel.org>; Tue, 20 Mar 2012 12:42:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shli@kernel.org, Holger.Kiehl@dwd.de, hughd@google.com, shli@fusionio.com


The patch titled
     Subject: swap: don't do discard if no discard option added
has been added to the -mm tree.  Its filename is
     swap-dont-do-discard-if-no-discard-option-added.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2105,7 +2105,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 			p->flags |= SWP_SOLIDSTATE;
 			p->cluster_next = 1 + (random32() % p->highest_bit);
 		}
-		if (discard_swap(p) == 0 && (swap_flags & SWAP_FLAG_DISCARD))
+		if ((swap_flags & SWAP_FLAG_DISCARD) && discard_swap(p) == 0)
 			p->flags |= SWP_DISCARDABLE;
 	}
 
_
Subject: Subject: swap: don't do discard if no discard option added

Patches currently in -mm which might be from shli@kernel.org are

swap-dont-do-discard-if-no-discard-option-added.patch

