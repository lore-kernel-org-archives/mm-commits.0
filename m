From: akpm@linux-foundation.org
Subject: [merged]
 mm-swap-fix-swap-space-leak-in-error-path-of-swap_free_entries.patch
 removed from -mm tree
Date: Thu, 04 May 2017 12:13:44 -0700
Message-ID: <20170504191344.7VGWwUumU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52036 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756335AbdEDTNq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 May 2017 15:13:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, minchan@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com, shli@kernel.org, tim.c.chen@linux.intel.com, ying.huang@intel.com


The patch titled
     Subject: mm/swapfile.c: fix swap space leak in error path of swap_free_entries()
has been removed from the -mm tree.  Its filename was
     mm-swap-fix-swap-space-leak-in-error-path-of-swap_free_entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1079,8 +1079,6 @@ void swapcache_free_entries(swp_entry_t
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

mm-swap-use-kvzalloc-to-allocate-some-swap-data-structure.patch

