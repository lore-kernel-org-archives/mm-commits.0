From: akpm@linux-foundation.org
Subject: [merged]
 mm-swapfilec-simplify-the-calculation-of-n_goal.patch removed from -mm tree
Date: Tue, 02 Jun 2020 14:40:16 -0700
Message-ID: <20200602214016.K8Zy5Ggki%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbgFBVkR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:40:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hughd@google.com, mm-commits@vger.kernel.org, richard.weiyang@gmail.com


The patch titled
     Subject: mm/swapfile.c: simplify the calculation of n_goal
has been removed from the -mm tree.  Its filename was
     mm-swapfilec-simplify-the-calculation-of-n_goal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/swapfile.c: simplify the calculation of n_goal

Use min3() to simplify the comparison and make it more self-explaining.

Link: http://lkml.kernel.org/r/20200325220309.9803-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
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
