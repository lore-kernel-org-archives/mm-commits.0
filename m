From: akpm@linux-foundation.org
Subject: [folded-merged] mm-swap-sort-swap-entries-before-free-fix.patch
 removed from -mm tree
Date: Thu, 06 Jul 2017 15:21:58 -0700
Message-ID: <595eb806.LKxhkc3fZYD0D6o0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33260 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751956AbdGFWV7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:21:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hughd@google.com, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-swap-sort-swap-entries-before-free-fix
has been removed from the -mm tree.  Its filename was
     mm-swap-sort-swap-entries-before-free-fix.patch

This patch was dropped because it was folded into mm-swap-sort-swap-entries-before-free.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-swap-sort-swap-entries-before-free-fix

tweak comment

Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/swapfile.c~mm-swap-sort-swap-entries-before-free-fix mm/swapfile.c
--- a/mm/swapfile.c~mm-swap-sort-swap-entries-before-free-fix
+++ a/mm/swapfile.c
@@ -1218,10 +1218,9 @@ void swapcache_free_entries(swp_entry_t
 	p = NULL;
 
 	/*
-	 * Sort swap entries by swap device, so each lock is only
-	 * taken once.  Although nr_swapfiles isn't absolute correct,
-	 * but the overhead of sort() is so low that it isn't
-	 * necessary to optimize further.
+	 * Sort swap entries by swap device, so each lock is only taken once.
+	 * nr_swapfiles isn't absolutely correct, but the overhead of sort() is
+	 * so low that it isn't necessary to optimize further.
 	 */
 	if (nr_swapfiles > 1)
 		sort(entries, n, sizeof(entries[0]), swp_entry_cmp, NULL);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-swap-sort-swap-entries-before-free.patch

