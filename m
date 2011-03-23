From: akpm@linux-foundation.org
Subject: [merged] mm-dont-return-0-too-early-from-find_get_pages.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:36:55 -0700
Message-ID: <201103232040.p2NKeVZN028540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35630 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933344Ab1CWUzg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:55:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, a.p.zijlstra@chello.nl, fengguang.wu@intel.com, npiggin@kernel.dk, sqazi@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: don't return 0 too early from find_get_pages()
has been removed from the -mm tree.  Its filename was
     mm-dont-return-0-too-early-from-find_get_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: don't return 0 too early from find_get_pages()
From: Hugh Dickins <hughd@google.com>

Callers of find_get_pages(), or its wrapper pagevec_lookup() - notably
truncate_inode_pages_range() - stop looking further when it returns 0.

But if an interrupt comes just after its radix_tree_gang_lookup_slot(),
especially if we have preemptible RCU enabled, isn't it conceivable that
all 14 pages returned could be removed from the page cache by
shrink_page_list(), before find_get_pages() gets to process them?  So
causing it to return 0 although there may be plenty more pages beyond.

Make find_get_pages() and find_get_pages_tag() check for this unlikely
case, and restart should it occur; but callers of find_get_pages_contig()
have no such expectation, it's okay for that to return 0 early.

I have not seen this in practice, just worried by the possibility.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Salman Qazi <sqazi@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN mm/filemap.c~mm-dont-return-0-too-early-from-find_get_pages mm/filemap.c
--- a/mm/filemap.c~mm-dont-return-0-too-early-from-find_get_pages
+++ a/mm/filemap.c
@@ -885,6 +885,13 @@ repeat:
 		pages[ret] = page;
 		ret++;
 	}
+
+	/*
+	 * If all entries were removed before we could secure them,
+	 * try again, because callers stop trying once 0 is returned.
+	 */
+	if (unlikely(!ret && nr_found))
+		goto restart;
 	rcu_read_unlock();
 	return ret;
 }
@@ -1004,6 +1011,13 @@ repeat:
 		pages[ret] = page;
 		ret++;
 	}
+
+	/*
+	 * If all entries were removed before we could secure them,
+	 * try again, because callers stop trying once 0 is returned.
+	 */
+	if (unlikely(!ret && nr_found))
+		goto restart;
 	rcu_read_unlock();
 
 	if (ret)
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
prio_tree-debugging-patch.patch

