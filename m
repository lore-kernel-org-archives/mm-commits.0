From: akpm@linux-foundation.org
Subject: +
 mm-swapfilec-remove-the-extra-check-in-scan_swap_map_slots.patch added to
 -mm tree
Date: Sat, 18 Apr 2020 15:13:07 -0700
Message-ID: <20200418221307.HssgJydF6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726887AbgDRWNJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 18 Apr 2020 18:13:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, mm-commits@vger.kernel.org, richard.weiyang@gmail.com


The patch titled
     Subject: mm/swapfile.c: remove the extra check in scan_swap_map_slots()
has been added to the -mm tree.  Its filename is
     mm-swapfilec-remove-the-extra-check-in-scan_swap_map_slots.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swapfilec-remove-the-extra-check-in-scan_swap_map_slots.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swapfilec-remove-the-extra-check-in-scan_swap_map_slots.patch

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
