From: akpm@linux-foundation.org
Subject: + mm-mempolicyc-fix-indentation-of-the-comments-of-do_migrate_pages.patch added to -mm tree
Date: Mon, 25 Jan 2010 15:16:04 -0800
Message-ID: <201001252316.o0PNG44D016957@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48678 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750931Ab0AYXQI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jan 2010 18:16:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org


The patch titled
     mm/mempolicy.c: fix indentation of the comments of do_migrate_pages
has been added to the -mm tree.  Its filename is
     mm-mempolicyc-fix-indentation-of-the-comments-of-do_migrate_pages.patch

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
Subject: mm/mempolicy.c: fix indentation of the comments of do_migrate_pages
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Currently, do_migrate_pages() have very long comment and this is not
indent properly.  I often misunderstand it is function starting commnents
and confused it.

this patch fixes it.

note: this patch doesn't break 80 column rule. I guess original
      author intended this indentaion, but an accident corrupted it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   60 +++++++++++++++++++++++------------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff -puN mm/mempolicy.c~fix-indentation-of-the-comments-of-do_migrate_pages mm/mempolicy.c
--- a/mm/mempolicy.c~fix-indentation-of-the-comments-of-do_migrate_pages
+++ a/mm/mempolicy.c
@@ -888,36 +888,36 @@ int do_migrate_pages(struct mm_struct *m
 	if (err)
 		goto out;
 
-/*
- * Find a 'source' bit set in 'tmp' whose corresponding 'dest'
- * bit in 'to' is not also set in 'tmp'.  Clear the found 'source'
- * bit in 'tmp', and return that <source, dest> pair for migration.
- * The pair of nodemasks 'to' and 'from' define the map.
- *
- * If no pair of bits is found that way, fallback to picking some
- * pair of 'source' and 'dest' bits that are not the same.  If the
- * 'source' and 'dest' bits are the same, this represents a node
- * that will be migrating to itself, so no pages need move.
- *
- * If no bits are left in 'tmp', or if all remaining bits left
- * in 'tmp' correspond to the same bit in 'to', return false
- * (nothing left to migrate).
- *
- * This lets us pick a pair of nodes to migrate between, such that
- * if possible the dest node is not already occupied by some other
- * source node, minimizing the risk of overloading the memory on a
- * node that would happen if we migrated incoming memory to a node
- * before migrating outgoing memory source that same node.
- *
- * A single scan of tmp is sufficient.  As we go, we remember the
- * most recent <s, d> pair that moved (s != d).  If we find a pair
- * that not only moved, but what's better, moved to an empty slot
- * (d is not set in tmp), then we break out then, with that pair.
- * Otherwise when we finish scannng from_tmp, we at least have the
- * most recent <s, d> pair that moved.  If we get all the way through
- * the scan of tmp without finding any node that moved, much less
- * moved to an empty node, then there is nothing left worth migrating.
- */
+	/*
+	 * Find a 'source' bit set in 'tmp' whose corresponding 'dest'
+	 * bit in 'to' is not also set in 'tmp'.  Clear the found 'source'
+	 * bit in 'tmp', and return that <source, dest> pair for migration.
+	 * The pair of nodemasks 'to' and 'from' define the map.
+	 *
+	 * If no pair of bits is found that way, fallback to picking some
+	 * pair of 'source' and 'dest' bits that are not the same.  If the
+	 * 'source' and 'dest' bits are the same, this represents a node
+	 * that will be migrating to itself, so no pages need move.
+	 *
+	 * If no bits are left in 'tmp', or if all remaining bits left
+	 * in 'tmp' correspond to the same bit in 'to', return false
+	 * (nothing left to migrate).
+	 *
+	 * This lets us pick a pair of nodes to migrate between, such that
+	 * if possible the dest node is not already occupied by some other
+	 * source node, minimizing the risk of overloading the memory on a
+	 * node that would happen if we migrated incoming memory to a node
+	 * before migrating outgoing memory source that same node.
+	 *
+	 * A single scan of tmp is sufficient.  As we go, we remember the
+	 * most recent <s, d> pair that moved (s != d).  If we find a pair
+	 * that not only moved, but what's better, moved to an empty slot
+	 * (d is not set in tmp), then we break out then, with that pair.
+	 * Otherwise when we finish scannng from_tmp, we at least have the
+	 * most recent <s, d> pair that moved.  If we get all the way through
+	 * the scan of tmp without finding any node that moved, much less
+	 * moved to an empty node, then there is nothing left worth migrating.
+	 */
 
 	tmp = *from_nodes;
 	while (!nodes_empty(tmp)) {
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
sched-cpuacct-use-bigger-percpu-counter-batch-values-for-stats-counters.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mlock_vma_pages_range-never-return-negative-value.patch
mlock_vma_pages_range-only-return-success-or-failure.patch
vmscan-check-high-watermark-after-shrink-zone.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
vmscan-get_scan_ratio-cleanup.patch
memcg-add-anon_scan_ratio-to-memorystat-file.patch
mm-lockdep-annotate-reclaim-context-to-zone-reclaim-too.patch
mm-page_allocc-remove-duplicate-call-to-trace_mm_page_free_direct.patch
mm-page_allocc-adjust-a-call-site-to-trace_mm_page_free_direct.patch
mm-remove-function-free_hot_page.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix-2.patch
mm-fix-mbind-vma-merge-problem.patch
mm-fix-mbind-vma-merge-problem-fix.patch
mm-mempolicyc-fix-indentation-of-the-comments-of-do_migrate_pages.patch
prctl-add-pr_set_proctitle_area-option-for-prctl.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency.patch
memcg-move-charges-of-anonymous-swap-fix-2.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

