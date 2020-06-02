From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 065/128] mm/swapfile.c: remove the extra check in
 scan_swap_map_slots()
Date: Mon, 01 Jun 2020 21:48:58 -0700
Message-ID: <20200602044858.1zSPQmJV4%akpm@linux-foundation.org>
References: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgFBEs7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 00:48:59 -0400
In-Reply-To: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hughd@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, richard.weiyang@gmail.com, torvalds@linux-foundation.org

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
