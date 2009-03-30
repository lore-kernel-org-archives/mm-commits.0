From: akpm@linux-foundation.org
Subject: + shmem-writepage-directly-to-swap.patch added to -mm tree
Date: Mon, 30 Mar 2009 16:30:55 -0700
Message-ID: <200903302330.n2UNUuSE023788@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752110AbZC3Xeg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 19:34:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, penberg@cs.helsinki.fi, riel@redhat.com


The patch titled
     shmem: writepage directly to swap
has been added to the -mm tree.  Its filename is
     shmem-writepage-directly-to-swap.patch

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
Subject: shmem: writepage directly to swap
From: Hugh Dickins <hugh@veritas.com>

Synopsis: if shmem_writepage calls swap_writepage directly, most shmem
swap loads benefit, and a catastrophic interaction between SLUB and some
flash storage is avoided.

shmem_writepage() has always been peculiar in making no attempt to write:
it has just transferred a shmem page from file cache to swap cache, then
let that page make its way around the LRU again before being written and
freed.

The idea was that people use tmpfs because they want those pages to stay
in RAM; so although we give it an overflow to swap, we should resist
writing too soon, giving those pages a second chance before they can be
reclaimed.

That was always questionable, and I've toyed with this patch for years;
but never had a clear justification to depart from the original design.

It became more questionable in 2.6.28, when the split LRU patches classed
shmem and tmpfs pages as SwapBacked rather than as file_cache: that in
itself gives them more resistance to reclaim than normal file pages.  I
prepared this patch for 2.6.29, but the merge window arrived before I'd
completed gathering statistics to justify sending it in.

Then while comparing SLQB against SLUB, running SLUB on a laptop I'd
habitually used with SLAB, I found SLUB to run my tmpfs kbuild swapping
tests five times slower than SLAB or SLQB - other machines slower too, but
nowhere near so bad.  Simpler "cp -a" swapping tests showed the same.

slub_max_order=0 brings sanity to all, but heavy swapping is too far from
normal to justify such a tuning.  The crucial factor on that laptop turns
out to be that I'm using an SD card for swap.  What happens is this:

By default, SLUB uses order-2 pages for shmem_inode_cache (and many other
fs inodes), so creating tmpfs files under memory pressure brings lumpy
reclaim into play.  One subpage of the order is chosen from the bottom of
the LRU as usual, then the other three picked out from their random
positions on the LRUs.

In a tmpfs load, many of these pages will be ones which already passed
through shmem_writepage, so already have swap allocated.  And though their
offsets on swap were probably allocated sequentially, now that the pages
are picked off at random, their swap offsets are scattered.

But the flash storage on the SD card is very sensitive to having its
writes merged: once swap is written at scattered offsets, performance
falls apart.  Rotating disk seeks increase too, but less disastrously.

So: stop giving shmem/tmpfs pages a second pass around the LRU, write them
out to swap as soon as their swap has been allocated.

It's surely possible to devise an artificial load which runs faster the
old way, one whose sizing is such that the tmpfs pages on their second
pass are the ones that are wanted again, and other pages not.

But I've not yet found such a load: on all machines, under the loads I've
tried, immediate swap_writepage speeds up shmem swapping: especially when
using the SLUB allocator (and more effectively than slub_max_order=0), but
also with the others; and it also reduces the variance between runs.  How
much faster varies widely: a factor of five is rare, 5% is common.

One load which might have suffered: imagine a swapping shmem load in a
limited mem_cgroup on a machine with plenty of memory.  Before 2.6.29 the
swapcache was not charged, and such a load would have run quickest with
the shmem swapcache never written to swap.  But now swapcache is charged,
so even this load benefits from shmem_writepage directly to swap.

Apologies for the #ifndef CONFIG_SWAP swap_writepage() stub in swap.h:
it's silly because that will never get called; but refactoring shmem.c
sensibly according to CONFIG_SWAP will be a separate task.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    5 +++++
 mm/shmem.c           |    3 +--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff -puN include/linux/swap.h~shmem-writepage-directly-to-swap include/linux/swap.h
--- a/include/linux/swap.h~shmem-writepage-directly-to-swap
+++ a/include/linux/swap.h
@@ -383,6 +383,11 @@ static inline struct page *swapin_readah
 	return NULL;
 }
 
+static inline int swap_writepage(struct page *p, struct writeback_control *wbc)
+{
+	return 0;
+}
+
 static inline struct page *lookup_swap_cache(swp_entry_t swp)
 {
 	return NULL;
diff -puN mm/shmem.c~shmem-writepage-directly-to-swap mm/shmem.c
--- a/mm/shmem.c~shmem-writepage-directly-to-swap
+++ a/mm/shmem.c
@@ -1068,8 +1068,7 @@ static int shmem_writepage(struct page *
 		swap_duplicate(swap);
 		BUG_ON(page_mapped(page));
 		page_cache_release(page);	/* pagecache ref */
-		set_page_dirty(page);
-		unlock_page(page);
+		swap_writepage(page, wbc);
 		if (inode) {
 			mutex_lock(&shmem_swaplist_mutex);
 			/* move instead of add in case we're racing */
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
linux-next.patch
clocksource-pass-clocksource-to-read-callback.patch
mm-disable-preemption-in-apply_to_pte_range.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
mm-shmemc-fix-division-by-zero.patch
get_mm_hiwater_xxx-trivial-s-define-inline.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
mm-dont-call-mark_page_accessed-in-do_swap_page.patch
mm-update_page_reclaim_stat-is-called-from-page-fault-path.patch
mm-add-comment-why-mark_page_accessed-would-be-better-than-pte_mkyoung-in-follow_page.patch
mm-add-comment-why-mark_page_accessed-would-be-better-than-pte_mkyoung-in-follow_page-fix.patch
mm-dont-free-swap-slots-on-page-deactivation.patch
mm-remove-pagevec_swap_free.patch
mm-page_mkwrite-change-prototype-to-match-fault-sysfs.patch
shmem-writepage-directly-to-swap.patch
getrusage-fill-ru_maxrss-value.patch
memcg-charge-swapcache-to-proper-memcg.patch
cgroups-use-css-id-in-swap-cgroup-for-saving-memory-v5.patch
cgroups-use-css-id-in-swap-cgroup-for-saving-memory-v5-fix.patch
memcg-remove-redundant-message-at-swapon.patch
prio_tree-debugging-patch.patch

