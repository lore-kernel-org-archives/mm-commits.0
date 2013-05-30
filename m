From: akpm@linux-foundation.org
Subject: +
 swap-avoid-read_swap_cache_async-race-to-deadlock-while-waiting-on-discard-i-o-completion.patch added to -mm tree
Date: Thu, 30 May 2013 15:55:38 -0700
Message-ID: <51a7d8ea.vqGRQzd/5QZ7TsSh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60852 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab3E3Wzj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 May 2013 18:55:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, shli@kernel.org, kosaki.motohiro@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, aquini@redhat.com

Subject: + swap-avoid-read_swap_cache_async-race-to-deadlock-while-waiting-on-discard-i-o-completion.patch added to -mm tree
To: aquini@redhat.com,hannes@cmpxchg.org,hughd@google.com,kosaki.motohiro@jp.fujitsu.com,shli@kernel.org,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 30 May 2013 15:55:38 -0700


The patch titled
     Subject: swap: avoid read_swap_cache_async() race to deadlock while waiting on discard I/O completion
has been added to the -mm tree.  Its filename is
     swap-avoid-read_swap_cache_async-race-to-deadlock-while-waiting-on-discard-i-o-completion.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rafael Aquini <aquini@redhat.com>
Subject: swap: avoid read_swap_cache_async() race to deadlock while waiting on discard I/O completion

read_swap_cache_async() can race against get_swap_page(), and stumble
across a SWAP_HAS_CACHE entry in the swap map whose page wasn't brought
into the swapcache yet.  This transient swap_map state is expected to be
transitory, but the actual placement of discard at scan_swap_map() inserts
a wait for I/O completion thus making the thread at
read_swap_cache_async() to loop around its -EEXIST case, while the other
end at get_swap_page() is scheduled away at scan_swap_map().  This can
leave the system deadlocked if the I/O completion happens to be waiting on
the CPU waitqueue where read_swap_cache_async() is busy looping and
!CONFIG_PREEMPT.

This patch introduces a cond_resched() call to make the aforementioned
read_swap_cache_async() busy loop condition to bail out when necessary,
thus avoiding the subtle race window.

Signed-off-by: Rafael Aquini <aquini@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff -puN mm/swap_state.c~swap-avoid-read_swap_cache_async-race-to-deadlock-while-waiting-on-discard-i-o-completion mm/swap_state.c
--- a/mm/swap_state.c~swap-avoid-read_swap_cache_async-race-to-deadlock-while-waiting-on-discard-i-o-completion
+++ a/mm/swap_state.c
@@ -336,8 +336,24 @@ struct page *read_swap_cache_async(swp_e
 		 * Swap entry may have been freed since our caller observed it.
 		 */
 		err = swapcache_prepare(entry);
-		if (err == -EEXIST) {	/* seems racy */
+		if (err == -EEXIST) {
 			radix_tree_preload_end();
+			/*
+			 * We might race against get_swap_page() and stumble
+			 * across a SWAP_HAS_CACHE swap_map entry whose page
+			 * has not been brought into the swapcache yet, while
+			 * the other end is scheduled away waiting on discard
+			 * I/O completion at scan_swap_map().
+			 *
+			 * In order to avoid turning this transitory state
+			 * into a permanent loop around this -EEXIST case
+			 * if !CONFIG_PREEMPT and the I/O completion happens
+			 * to be waiting on the CPU waitqueue where we are now
+			 * busy looping, we just conditionally invoke the
+			 * scheduler here, if there are some more important
+			 * tasks to run.
+			 */
+			cond_resched();
 			continue;
 		}
 		if (err) {		/* swp entry is obsolete ? */
_

Patches currently in -mm which might be from aquini@redhat.com are

swap-avoid-read_swap_cache_async-race-to-deadlock-while-waiting-on-discard-i-o-completion.patch
swap-discard-while-swapping-only-if-swap_flag_discard_pages.patch
swap-discard-while-swapping-only-if-swap_flag_discard_pages-fix.patch
mm-add-vm-event-counters-for-balloon-pages-compaction.patch

