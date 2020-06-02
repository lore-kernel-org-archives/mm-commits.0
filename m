From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 064/128] mm/swapfile.c: simplify the calculation
 of n_goal
Date: Mon, 01 Jun 2020 21:48:55 -0700
Message-ID: <20200602044855.2nCLt6lXB%akpm@linux-foundation.org>
References: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgFBEs4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 00:48:56 -0400
In-Reply-To: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hughd@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, richard.weiyang@gmail.com, torvalds@linux-foundation.org

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
