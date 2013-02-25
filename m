From: akpm@linux-foundation.org
Subject: [merged] ksm-add-some-comments.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:55:59 -0800
Message-ID: <20130225205559.ACFC75A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:37365 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759851Ab3BYU4B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:56:01 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so348064vch.0
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:56:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, hannes@cmpxchg.org, izik.eidus@ravellosystems.com, mgorman@suse.de, pholasek@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: add some comments
has been removed from the -mm tree.  Its filename was
     ksm-add-some-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: ksm: add some comments

Added slightly more detail to the Documentation of merge_across_nodes, a
few comments in areas indicated by review, and renamed get_ksm_page()'s
argument from "locked" to "lock_it".  No functional change.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Petr Holasek <pholasek@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/ksm.txt |   16 ++++++++++++----
 mm/ksm.c                 |   18 ++++++++++++++----
 2 files changed, 26 insertions(+), 8 deletions(-)

diff -puN Documentation/vm/ksm.txt~ksm-add-some-comments Documentation/vm/ksm.txt
--- a/Documentation/vm/ksm.txt~ksm-add-some-comments
+++ a/Documentation/vm/ksm.txt
@@ -60,10 +60,18 @@ sleep_millisecs  - how many milliseconds
 
 merge_across_nodes - specifies if pages from different numa nodes can be merged.
                    When set to 0, ksm merges only pages which physically
-                   reside in the memory area of same NUMA node. It brings
-                   lower latency to access to shared page. Value can be
-                   changed only when there is no ksm shared pages in system.
-                   Default: 1
+                   reside in the memory area of same NUMA node. That brings
+                   lower latency to access of shared pages. Systems with more
+                   nodes, at significant NUMA distances, are likely to benefit
+                   from the lower latency of setting 0. Smaller systems, which
+                   need to minimize memory usage, are likely to benefit from
+                   the greater sharing of setting 1 (default). You may wish to
+                   compare how your system performs under each setting, before
+                   deciding on which to use. merge_across_nodes setting can be
+                   changed only when there are no ksm shared pages in system:
+                   set run 2 to unmerge pages first, then to 1 after changing
+                   merge_across_nodes, to remerge according to the new setting.
+                   Default: 1 (merging across nodes as in earlier releases)
 
 run              - set 0 to stop ksmd from running but keep merged pages,
                    set 1 to run ksmd e.g. "echo 1 > /sys/kernel/mm/ksm/run",
diff -puN mm/ksm.c~ksm-add-some-comments mm/ksm.c
--- a/mm/ksm.c~ksm-add-some-comments
+++ a/mm/ksm.c
@@ -87,6 +87,9 @@
  *    take 10 attempts to find a page in the unstable tree, once it is found,
  *    it is secured in the stable tree.  (When we scan a new page, we first
  *    compare it against the stable tree, and then against the unstable tree.)
+ *
+ * If the merge_across_nodes tunable is unset, then KSM maintains multiple
+ * stable trees and multiple unstable trees: one of each for each NUMA node.
  */
 
 /**
@@ -526,7 +529,7 @@ static void remove_node_from_stable_tree
  * a page to put something that might look like our key in page->mapping.
  * is on its way to being freed; but it is an anomaly to bear in mind.
  */
-static struct page *get_ksm_page(struct stable_node *stable_node, bool locked)
+static struct page *get_ksm_page(struct stable_node *stable_node, bool lock_it)
 {
 	struct page *page;
 	void *expected_mapping;
@@ -575,7 +578,7 @@ again:
 		goto stale;
 	}
 
-	if (locked) {
+	if (lock_it) {
 		lock_page(page);
 		if (ACCESS_ONCE(page->mapping) != expected_mapping) {
 			unlock_page(page);
@@ -705,10 +708,17 @@ static int remove_stable_node(struct sta
 		return 0;
 	}
 
-	if (WARN_ON_ONCE(page_mapped(page)))
+	if (WARN_ON_ONCE(page_mapped(page))) {
+		/*
+		 * This should not happen: but if it does, just refuse to let
+		 * merge_across_nodes be switched - there is no need to panic.
+		 */
 		err = -EBUSY;
-	else {
+	} else {
 		/*
+		 * The stable node did not yet appear stale to get_ksm_page(),
+		 * since that allows for an unmapped ksm page to be recognized
+		 * right up until it is freed; but the node is safe to remove.
 		 * This page might be in a pagevec waiting to be freed,
 		 * or it might be PageSwapCache (perhaps under writeback),
 		 * or it might have been removed from swapcache a moment ago.
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch
pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge.patch
mm-accelerate-munlock-treatment-of-thp-pages.patch

