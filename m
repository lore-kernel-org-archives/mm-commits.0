From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_io-mark-various-intentional-data-races-v2.patch
 added to -mm tree
Date: Thu, 13 Feb 2020 19:27:23 -0800
Message-ID: <20200214032723.6YJTLBS7X%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728484AbgBND1Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 Feb 2020 22:27:24 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cai@lca.pw, elver@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_io-mark-various-intentional-data-races-v2
has been added to the -mm tree.  Its filename is
     mm-page_io-mark-various-intentional-data-races-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_io-mark-various-intentional-data-races-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_io-mark-various-intentional-data-races-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Qian Cai <cai@lca.pw>
Subject: mm-page_io-mark-various-intentional-data-races-v2

add a missing annotation

Link: http://lkml.kernel.org/r/1581612585-5812-1-git-send-email-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_io.c~mm-page_io-mark-various-intentional-data-races-v2
+++ a/mm/page_io.c
@@ -86,7 +86,7 @@ static void swap_slot_free_notify(struct
 		return;
 
 	sis = page_swap_info(page);
-	if (!(sis->flags & SWP_BLKDEV))
+	if (data_race(!(sis->flags & SWP_BLKDEV)))
 		return;
 
 	/*
_

Patches currently in -mm which might be from cai@lca.pw are

mm-kmemleak-annotate-various-data-races-obj-ptr.patch
mm-swapfile-fix-and-annotate-various-data-races.patch
mm-swapfile-fix-and-annotate-various-data-races-v2.patch
mm-page_counter-fix-various-data-races-at-memsw.patch
mm-memcontrol-fix-a-data-race-in-scan-count.patch
mm-list_lru-fix-a-data-race-in-list_lru_count_one.patch
mm-mempool-fix-a-data-race-in-mempool_free.patch
mm-util-annotate-an-data-race-at-vm_committed_as.patch
mm-rmap-annotate-a-data-race-at-tlb_flush_batched.patch
mm-frontswap-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races-v2.patch
mm-swap_state-mark-various-intentional-data-races.patch
