From: akpm@linux-foundation.org
Subject: + mm-delete-unnecessary-ttu_-flags.patch added to -mm tree
Date: Tue, 28 Feb 2017 16:32:29 -0800
Message-ID: <58b6169d.LD8VUMOqlYjjFWNv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39452 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751337AbdCAAcb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 19:32:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shli@fb.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: delete unnecessary TTU_* flags
has been added to the -mm tree.  Its filename is
     mm-delete-unnecessary-ttu_-flags.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-delete-unnecessary-ttu_-flags.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-delete-unnecessary-ttu_-flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shaohua Li <shli@fb.com>
Subject: mm: delete unnecessary TTU_* flags

Patch series "mm: fix some MADV_FREE issues", v5.

We are trying to use MADV_FREE in jemalloc.  Several issues are found. 
Without solving the issues, jemalloc can't use the MADV_FREE feature.

- Doesn't support system without swap enabled.  Because if swap is off,
  we can't or can't efficiently age anonymous pages.  And since MADV_FREE
  pages are mixed with other anonymous pages, we can't reclaim MADV_FREE
  pages.  In current implementation, MADV_FREE will fallback to
  MADV_DONTNEED without swap enabled.  But in our environment, a lot of
  machines don't enable swap.  This will prevent our setup using
  MADV_FREE.

- Increases memory pressure.  page reclaim bias file pages reclaim
  against anonymous pages.  This doesn't make sense for MADV_FREE pages,
  because those pages could be freed easily and refilled with very slight
  penality.  Even page reclaim doesn't bias file pages, there is still an
  issue, because MADV_FREE pages and other anonymous pages are mixed
  together.  To reclaim a MADV_FREE page, we probably must scan a lot of
  other anonymous pages, which is inefficient.  In our test, we usually
  see oom with MADV_FREE enabled and nothing without it.

- Accounting.  There are two accounting problems.  We don't have a
  global accounting.  If the system is abnormal, we don't know if it's a
  problem from MADV_FREE side.  The other problem is RSS accounting. 
  MADV_FREE pages are accounted as normal anon pages and reclaimed lazily,
  so application's RSS becomes bigger.  This confuses our workloads.  We
  have monitoring daemon running and if it finds applications' RSS becomes
  abnormal, the daemon will kill the applications even kernel can reclaim
  the memory easily.

To address the first the two issues, we can either put MADV_FREE pages
into a separate LRU list (Minchan's previous patches and V1 patches), or
put them into LRU_INACTIVE_FILE list (suggested by Johannes).  The
patchset use the second idea.  The reason is LRU_INACTIVE_FILE list is
tiny nowadays and should be full of used once file pages.  So we can still
efficiently reclaim MADV_FREE pages there without interference with other
anon and active file pages.  Putting the pages into inactive file list
also has an advantage which allows page reclaim to prioritize MADV_FREE
pages and used once file pages.  MADV_FREE pages are put into the lru list
and clear SwapBacked flag, so PageAnon(page) && !PageSwapBacked(page) will
indicate a MADV_FREE pages.  These pages will directly freed without
pageout if they are clean, otherwise normal swap will reclaim them.

For the third issue, the previous post adds global accounting and a
separate RSS count for MADV_FREE pages.  The problem is we never get
accurate accounting for MADV_FREE pages.  The pages are mapped to
userspace, can be dirtied without notice from kernel side.  To get
accurate accounting, we could write protect the page, but then there is
extra page fault overhead, which people don't want to pay.  Jemalloc guys
have concerns about the inaccurate accounting, so this post drops the
accounting patches temporarily.  The info exported to /proc/pid/smaps for
MADV_FREE pages are kept, which is the only place we can get accurate
accounting right now.


This patch (of 6):

Johannes pointed out TTU_LZFREE is unnecessary.  It's true because we
always have the flag set if we want to do an unmap.  For cases we don't do
an unmap, the TTU_LZFREE part of code should never run.

Also the TTU_UNMAP is unnecessary.  If no other flags set (for example,
TTU_MIGRATION), an unmap is implied.

The patch includes Johannes's cleanup and dead TTU_ACTION macro removal
code

Link: http://lkml.kernel.org/r/4be3ea1bc56b26fd98a54d0a6f70bec63f6d8980.1487965799.git.shli@fb.com
Signed-off-by: Shaohua Li <shli@fb.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |   22 +++++++++-------------
 mm/memory-failure.c  |    2 +-
 mm/rmap.c            |    2 +-
 mm/vmscan.c          |   11 ++++-------
 4 files changed, 15 insertions(+), 22 deletions(-)

diff -puN include/linux/rmap.h~mm-delete-unnecessary-ttu_-flags include/linux/rmap.h
--- a/include/linux/rmap.h~mm-delete-unnecessary-ttu_-flags
+++ a/include/linux/rmap.h
@@ -83,19 +83,17 @@ struct anon_vma_chain {
 };
 
 enum ttu_flags {
-	TTU_UNMAP = 1,			/* unmap mode */
-	TTU_MIGRATION = 2,		/* migration mode */
-	TTU_MUNLOCK = 4,		/* munlock mode */
-	TTU_LZFREE = 8,			/* lazy free mode */
-	TTU_SPLIT_HUGE_PMD = 16,	/* split huge PMD if any */
-
-	TTU_IGNORE_MLOCK = (1 << 8),	/* ignore mlock */
-	TTU_IGNORE_ACCESS = (1 << 9),	/* don't age */
-	TTU_IGNORE_HWPOISON = (1 << 10),/* corrupted page is recoverable */
-	TTU_BATCH_FLUSH = (1 << 11),	/* Batch TLB flushes where possible
+	TTU_MIGRATION		= 0x1,	/* migration mode */
+	TTU_MUNLOCK		= 0x2,	/* munlock mode */
+
+	TTU_SPLIT_HUGE_PMD	= 0x4,	/* split huge PMD if any */
+	TTU_IGNORE_MLOCK	= 0x8,	/* ignore mlock */
+	TTU_IGNORE_ACCESS	= 0x10,	/* don't age */
+	TTU_IGNORE_HWPOISON	= 0x20,	/* corrupted page is recoverable */
+	TTU_BATCH_FLUSH		= 0x40,	/* Batch TLB flushes where possible
 					 * and caller guarantees they will
 					 * do a final flush if necessary */
-	TTU_RMAP_LOCKED = (1 << 12)	/* do not grab rmap lock:
+	TTU_RMAP_LOCKED		= 0x80	/* do not grab rmap lock:
 					 * caller holds it */
 };
 
@@ -193,8 +191,6 @@ static inline void page_dup_rmap(struct
 int page_referenced(struct page *, int is_locked,
 			struct mem_cgroup *memcg, unsigned long *vm_flags);
 
-#define TTU_ACTION(x) ((x) & TTU_ACTION_MASK)
-
 int try_to_unmap(struct page *, enum ttu_flags flags);
 
 /* Avoid racy checks */
diff -puN mm/memory-failure.c~mm-delete-unnecessary-ttu_-flags mm/memory-failure.c
--- a/mm/memory-failure.c~mm-delete-unnecessary-ttu_-flags
+++ a/mm/memory-failure.c
@@ -906,7 +906,7 @@ EXPORT_SYMBOL_GPL(get_hwpoison_page);
 static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
 				  int trapno, int flags, struct page **hpagep)
 {
-	enum ttu_flags ttu = TTU_UNMAP | TTU_IGNORE_MLOCK | TTU_IGNORE_ACCESS;
+	enum ttu_flags ttu = TTU_IGNORE_MLOCK | TTU_IGNORE_ACCESS;
 	struct address_space *mapping;
 	LIST_HEAD(tokill);
 	int ret;
diff -puN mm/rmap.c~mm-delete-unnecessary-ttu_-flags mm/rmap.c
--- a/mm/rmap.c~mm-delete-unnecessary-ttu_-flags
+++ a/mm/rmap.c
@@ -1418,7 +1418,7 @@ static int try_to_unmap_one(struct page
 			 */
 			VM_BUG_ON_PAGE(!PageSwapCache(page), page);
 
-			if (!PageDirty(page) && (flags & TTU_LZFREE)) {
+			if (!PageDirty(page)) {
 				/* It's a freeable page by MADV_FREE */
 				dec_mm_counter(mm, MM_ANONPAGES);
 				rp->lazyfreed++;
diff -puN mm/vmscan.c~mm-delete-unnecessary-ttu_-flags mm/vmscan.c
--- a/mm/vmscan.c~mm-delete-unnecessary-ttu_-flags
+++ a/mm/vmscan.c
@@ -965,7 +965,6 @@ static unsigned long shrink_page_list(st
 		int may_enter_fs;
 		enum page_references references = PAGEREF_RECLAIM_CLEAN;
 		bool dirty, writeback;
-		bool lazyfree = false;
 		int ret = SWAP_SUCCESS;
 
 		cond_resched();
@@ -1119,7 +1118,6 @@ static unsigned long shrink_page_list(st
 				goto keep_locked;
 			if (!add_to_swap(page, page_list))
 				goto activate_locked;
-			lazyfree = true;
 			may_enter_fs = 1;
 
 			/* Adding to swap updated mapping */
@@ -1137,9 +1135,8 @@ static unsigned long shrink_page_list(st
 		 * processes. Try to unmap it here.
 		 */
 		if (page_mapped(page) && mapping) {
-			switch (ret = try_to_unmap(page, lazyfree ?
-				(ttu_flags | TTU_BATCH_FLUSH | TTU_LZFREE) :
-				(ttu_flags | TTU_BATCH_FLUSH))) {
+			switch (ret = try_to_unmap(page,
+				ttu_flags | TTU_BATCH_FLUSH)) {
 			case SWAP_FAIL:
 				nr_unmap_fail++;
 				goto activate_locked;
@@ -1347,7 +1344,7 @@ unsigned long reclaim_clean_pages_from_l
 	}
 
 	ret = shrink_page_list(&clean_pages, zone->zone_pgdat, &sc,
-			TTU_UNMAP|TTU_IGNORE_ACCESS, NULL, true);
+			TTU_IGNORE_ACCESS, NULL, true);
 	list_splice(&clean_pages, page_list);
 	mod_node_page_state(zone->zone_pgdat, NR_ISOLATED_FILE, -ret);
 	return ret;
@@ -1739,7 +1736,7 @@ shrink_inactive_list(unsigned long nr_to
 	if (nr_taken == 0)
 		return 0;
 
-	nr_reclaimed = shrink_page_list(&page_list, pgdat, sc, TTU_UNMAP,
+	nr_reclaimed = shrink_page_list(&page_list, pgdat, sc, 0,
 				&stat, false);
 
 	spin_lock_irq(&pgdat->lru_lock);
_

Patches currently in -mm which might be from shli@fb.com are

mm-delete-unnecessary-ttu_-flags.patch
mm-dont-assume-anonymous-pages-have-swapbacked-flag.patch
mm-move-madv_free-pages-into-lru_inactive_file-list.patch
mm-reclaim-madv_free-pages.patch
mm-enable-madv_free-for-swapless-system.patch
proc-show-madv_free-pages-info-in-smaps.patch

