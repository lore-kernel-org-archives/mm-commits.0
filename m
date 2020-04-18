From: akpm@linux-foundation.org
Subject: + mm-swapfilec-simplify-the-calculation-of-n_goal.patch
 added to -mm tree
Date: Sat, 18 Apr 2020 15:13:20 -0700
Message-ID: <20200418221320.lLhRx596H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726887AbgDRWNW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 18 Apr 2020 18:13:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, mm-commits@vger.kernel.org, richard.weiyang@gmail.com


The patch titled
     Subject: mm/swapfile.c: simplify the calculation of n_goal
has been added to the -mm tree.  Its filename is
     mm-swapfilec-simplify-the-calculation-of-n_goal.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swapfilec-simplify-the-calculation-of-n_goal.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swapfilec-simplify-the-calculation-of-n_goal.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/swapfile.c: simplify the calculation of n_goal

Use min3() to simplify the comparison and make it more self-explaining.

Link: http://lkml.kernel.org/r/20200325220309.9803-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/mm/swapfile.c~mm-swapfilec-simplify-the-calculation-of-n_goal
+++ a/mm/swapfile.c
@@ -994,11 +994,7 @@ int get_swap_pages(int n_goal, swp_entry
 	if (avail_pgs <= 0)
 		goto noswap;
 
-	if (n_goal > SWAP_BATCH)
-		n_goal = SWAP_BATCH;
