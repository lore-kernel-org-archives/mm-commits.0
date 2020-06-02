From: akpm@linux-foundation.org
Subject: [merged]
 mm-swapfilec-remove-the-extra-check-in-scan_swap_map_slots.patch removed
 from -mm tree
Date: Tue, 02 Jun 2020 14:40:18 -0700
Message-ID: <20200602214018.Rf0hYZsgr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbgFBVkT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:40:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, mm-commits@vger.kernel.org, richard.weiyang@gmail.com


The patch titled
     Subject: mm/swapfile.c: remove the extra check in scan_swap_map_slots()
has been removed from the -mm tree.  Its filename was
     mm-swapfilec-remove-the-extra-check-in-scan_swap_map_slots.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/swapfile.c: remove the extra check in scan_swap_map_slots()

scan_swap_map_slots() is only called by scan_swap_map() and
get_swap_pages().  Both ensure nr would not exceed SWAP_BATCH.

Just remove it.

Link: http://lkml.kernel.org/r/20200325220309.9803-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/swapfile.c~mm-swapfilec-remove-the-extra-check-in-scan_swap_map_slots
+++ a/mm/swapfile.c
@@ -740,9 +740,6 @@ static int scan_swap_map_slots(struct sw
 	int latency_ration = LATENCY_LIMIT;
 	int n_ret = 0;
 
-	if (nr > SWAP_BATCH)
-		nr = SWAP_BATCH;
