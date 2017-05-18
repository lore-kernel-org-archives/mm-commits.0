From: akpm@linux-foundation.org
Subject: + mm-thp-swap-delay-splitting-thp-during-swap-out-fix.patch added to -mm tree
Date: Thu, 18 May 2017 13:26:49 -0700
Message-ID: <591e0389.7Tyi0cy+W4RdEZYi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42728 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751200AbdERU0u (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 May 2017 16:26:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, hannes@cmpxchg.org, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, THP, swap: Fix two issues in THP optimize patch
has been added to the -mm tree.  Its filename is
     mm-thp-swap-delay-splitting-thp-during-swap-out-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-swap-delay-splitting-thp-during-swap-out-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-swap-delay-splitting-thp-during-swap-out-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm, THP, swap: Fix two issues in THP optimize patch

When changing the logic for cluster allocation for THP in get_swap_page(),
I made a mistake so that a normal swap slot may be allocated for a THP
instead of return with failure.  This is fixed in the patch.

And I found two likely/unlikely annotation is wrong in get_swap_pages(),
because that is slow path, I just removed the likely/unlikely annotation.

Link: http://lkml.kernel.org/r/87k25ed8zo.fsf@yhuang-dev.intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_slots.c |    5 +++--
 mm/swapfile.c   |    4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff -puN mm/swap_slots.c~mm-thp-swap-delay-splitting-thp-during-swap-out-fix mm/swap_slots.c
--- a/mm/swap_slots.c~mm-thp-swap-delay-splitting-thp-during-swap-out-fix
+++ a/mm/swap_slots.c
@@ -309,8 +309,9 @@ swp_entry_t get_swap_page(struct page *p
 
 	entry.val = 0;
 
-	if (IS_ENABLED(CONFIG_THP_SWAP) && PageTransHuge(page)) {
-		get_swap_pages(1, true, &entry);
+	if (PageTransHuge(page)) {
+		if (IS_ENABLED(CONFIG_THP_SWAP))
+			get_swap_pages(1, true, &entry);
 		return entry;
 	}
 
diff -puN mm/swapfile.c~mm-thp-swap-delay-splitting-thp-during-swap-out-fix mm/swapfile.c
--- a/mm/swapfile.c~mm-thp-swap-delay-splitting-thp-during-swap-out-fix
+++ a/mm/swapfile.c
@@ -937,13 +937,13 @@ start_over:
 			spin_unlock(&si->lock);
 			goto nextsi;
 		}
-		if (likely(cluster))
+		if (cluster)
 			n_ret = swap_alloc_cluster(si, swp_entries);
 		else
 			n_ret = scan_swap_map_slots(si, SWAP_HAS_CACHE,
 						    n_goal, swp_entries);
 		spin_unlock(&si->lock);
-		if (n_ret || unlikely(cluster))
+		if (n_ret || cluster)
 			goto check_out;
 		pr_debug("scan_swap_map of si %d failed to find offset\n",
 			si->type);
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-thp-swap-delay-splitting-thp-during-swap-out.patch
mm-thp-swap-delay-splitting-thp-during-swap-out-fix.patch
mm-thp-swap-check-whether-thp-can-be-split-firstly.patch
mm-thp-swap-enable-thp-swap-optimization-only-if-has-compound-map.patch

