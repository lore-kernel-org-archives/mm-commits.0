From: akpm@linux-foundation.org
Subject: +
 mm-swap-fix-swap-space-leak-in-error-path-of-swap_free_entries.patch added
 to -mm tree
Date: Tue, 25 Apr 2017 14:37:27 -0700
Message-ID: <58ffc197.X+5lCfRaFyfWbcH6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54918 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2993855AbdDYVhd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Apr 2017 17:37:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, hughd@google.com, minchan@kernel.org, riel@redhat.com, shli@kernel.org, tim.c.chen@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile.c: fix swap space leak in error path of swap_free_entries()
has been added to the -mm tree.  Its filename is
     mm-swap-fix-swap-space-leak-in-error-path-of-swap_free_entries.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-fix-swap-space-leak-in-error-path-of-swap_free_entries.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-fix-swap-space-leak-in-error-path-of-swap_free_entries.patch

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
Subject: mm/swapfile.c: fix swap space leak in error path of swap_free_entries()

In swapcache_free_entries(), if swap_info_get_cont() returns NULL,
something wrong occurs for the swap entry.  But we should still continue
to free the following swap entries in the array instead of skip them to
avoid swap space leak.  This is just problem in error path, where system
may be in an inconsistent state, but it is still good to fix it.

Link: http://lkml.kernel.org/r/20170421124739.24534-1-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/swapfile.c~mm-swap-fix-swap-space-leak-in-error-path-of-swap_free_entries mm/swapfile.c
--- a/mm/swapfile.c~mm-swap-fix-swap-space-leak-in-error-path-of-swap_free_entries
+++ a/mm/swapfile.c
@@ -1091,8 +1091,6 @@ void swapcache_free_entries(swp_entry_t
 		p = swap_info_get_cont(entries[i], prev);
 		if (p)
 			swap_entry_free(p, entries[i]);
-		else
-			break;
 		prev = p;
 	}
 	if (p)
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-swap-fix-a-race-in-free_swap_and_cache.patch
mm-swap-fix-comment-in-__read_swap_cache_async.patch
mm-swap-improve-readability-via-make-spin_lock-unlock-balanced.patch
mm-swap-avoid-lock-swap_avail_lock-when-held-cluster-lock.patch
mm-swap-remove-unused-function-prototype.patch
mm-swap-sort-swap-entries-before-free.patch
mm-swap-fix-swap-space-leak-in-error-path-of-swap_free_entries.patch
mm-swap-use-kvzalloc-to-allocate-some-swap-data-structure.patch

