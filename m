From: akpm@linux-foundation.org
Subject: + mm-further-fix-swapin-race-condition.patch added to -mm tree
Date: Mon, 20 Sep 2010 11:48:26 -0700
Message-ID: <201009201848.o8KImQsx006539@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39729 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754410Ab0ITStP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Sep 2010 14:49:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, riel@redhat.com, stable@kernel.org


The patch titled
     mm: further fix swapin race condition
has been added to the -mm tree.  Its filename is
     mm-further-fix-swapin-race-condition.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: further fix swapin race condition
From: Hugh Dickins <hughd@google.com>

Commit 4969c1192d15afa3389e7ae3302096ff684ba655 "mm: fix swapin race
condition" is now agreed to be incomplete.  There's a race, not very much
less likely than the original race envisaged, in which it is further
necessary to check that the swapcache page's swap has not changed.

Here's the reasoning: cast in terms of reuse_swap_page(), but probably
could be reformulated to rely on try_to_free_swap() instead, or on
swapoff+swapon.

A, faults into do_swap_page(): does page1 = lookup_swap_cache(swap1) and
comes through the lock_page(page1).

B, a racing thread of the same process, faults on the same address: does
page1 = lookup_swap_cache(swap1) and now waits in lock_page(page1), but
for whatever reason is unlucky not to get the lock any time soon.

A carries on through do_swap_page(), a write fault, but cannot reuse the
swap page1 (another reference to swap1).  Unlocks the page1 (but B doesn't
get it yet), does COW in do_wp_page(), page2 now in that pte.

C, perhaps the parent of A+B, comes in and write faults the same swap
page1 into its mm, reuse_swap_page() succeeds this time, swap1 is freed.

kswapd comes in after some time (B still unlucky) and swaps out some pages
from A+B and C: it allocates the original swap1 to page2 in A+B, and some
other swap2 to the original page1 now in C.  But does not immediately free
page1 (actually it couldn't: B holds a reference), leaving it in swap
cache for now.

B at last gets the lock on page1, hooray!  Is PageSwapCache(page1)?  Yes. 
Is pte_same(*page_table, orig_pte)?  Yes, because page2 has now been given
the swap1 which page1 used to have.  So B proceeds to insert page1 into
A+B's page_table, though its content now belongs to C, quite different
from what A wrote there.

B ought to have checked that page1's swap was still swap1.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN mm/memory.c~mm-further-fix-swapin-race-condition mm/memory.c
--- a/mm/memory.c~mm-further-fix-swapin-race-condition
+++ a/mm/memory.c
@@ -2680,10 +2680,12 @@ static int do_swap_page(struct mm_struct
 	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
 
 	/*
-	 * Make sure try_to_free_swap didn't release the swapcache
-	 * from under us. The page pin isn't enough to prevent that.
+	 * Make sure try_to_free_swap or reuse_swap_page or swapoff did not
+	 * release the swapcache from under us.  The page pin, and pte_same
+	 * test below, are not enough to exclude that.  Even if it is still
+	 * swapcache, we need to check that the page's swap has not changed.
 	 */
-	if (unlikely(!PageSwapCache(page)))
+	if (unlikely(!PageSwapCache(page) || page_private(page) != entry.val))
 		goto out_page;
 
 	if (ksm_might_need_to_copy(page, vma, address)) {
_

Patches currently in -mm which might be from hughd@google.com are

linux-next.patch
proc-pid-smaps-fix-dirty-pages-accounting.patch
proc-pid-smaps-export-amount-of-anonymous-memory-in-a-mapping.patch
rmap-fix-walk-during-fork.patch
unlink_anon_vmas-in-__split_vma-in-case-of-error.patch
mm-further-fix-swapin-race-condition.patch
mm-compaction-fix-compactpagefailed-counting.patch
vmscantmpfs-treat-used-once-pages-on-tmpfs-as-used-once.patch
ipc-shmc-add-rss-and-swap-size-information-to-proc-sysvipc-shm.patch
ipc-shmc-add-rss-and-swap-size-information-to-proc-sysvipc-shm-v2.patch
prio_tree-debugging-patch.patch

