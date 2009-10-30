From: akpm@linux-foundation.org
Subject: [merged] mm-order-evictable-rescue-in-lru-putback.patch removed from -mm tree
Date: Fri, 30 Oct 2009 13:50:48 -0700
Message-ID: <200910302050.n9UKomW8011423@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932386AbZJ3UwF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Oct 2009 16:52:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, Lee.Schermerhorn@hp.com, a.p.zijlstra@chello.nl, hugh.dickins@tiscali.co.uk, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: order evictable rescue in LRU putback
has been removed from the -mm tree.  Its filename was
     mm-order-evictable-rescue-in-lru-putback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: order evictable rescue in LRU putback
From: Johannes Weiner <hannes@cmpxchg.org>

Isolators putting a page back to the LRU do not hold the page lock, and if
the page is mlocked, another thread might munlock it concurrently.

Expecting this, the putback code re-checks the evictability of a page when
it just moved it to the unevictable list in order to correct its decision.

The problem, however, is that ordering is not garuanteed between setting
PG_lru when moving the page to the list and checking PG_mlocked
afterwards:

	#0:				#1

	spin_lock()
					if (TestClearPageMlocked())
					  if (PageLRU())
					    move to evictable list
	SetPageLRU()
	spin_unlock()
	if (!PageMlocked())
	  move to evictable list

The PageMlocked() check may get reordered before SetPageLRU() in #0,
resulting in #0 not moving the still mlocked page, and in #1 failing to
isolate and move the page as well.  The page is now stranded on the
unevictable list.

The race condition is very unlikely.  The consequence currently is one
page falling off the reclaim grid and eventually getting freed with
PG_unevictable set, which triggers a warning in the page allocator.

TestClearPageMlocked() in #1 already provides full memory barrier
semantics.

This patch adds an explicit full barrier to force ordering between
SetPageLRU() and PageMlocked() so that either one of the competitors
rescues the page.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/vmscan.c~mm-order-evictable-rescue-in-lru-putback mm/vmscan.c
--- a/mm/vmscan.c~mm-order-evictable-rescue-in-lru-putback
+++ a/mm/vmscan.c
@@ -544,6 +544,16 @@ redo:
 		 */
 		lru = LRU_UNEVICTABLE;
 		add_page_to_unevictable_list(page);
+		/*
+		 * When racing with an mlock clearing (page is
+		 * unlocked), make sure that if the other thread does
+		 * not observe our setting of PG_lru and fails
+		 * isolation, we see PG_mlocked cleared below and move
+		 * the page back to the evictable list.
+		 *
+		 * The other side is TestClearPageMlocked().
+		 */
+		smp_mb();
 	}
 
 	/*
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch

