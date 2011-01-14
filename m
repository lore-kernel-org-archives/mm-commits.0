From: akpm@linux-foundation.org
Subject: [merged] ksm-drain-pagevecs-to-lru.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:49:19 -0800
Message-ID: <201101142252.p0EMq9be005594@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51499 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752591Ab1ANWwP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:52:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, caiqian@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ksm: drain pagevecs to lru
has been removed from the -mm tree.  Its filename was
     ksm-drain-pagevecs-to-lru.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: drain pagevecs to lru
From: Hugh Dickins <hughd@google.com>

It was hard to explain the page counts which were causing new LTP tests
of KSM to fail: we need to drain the per-cpu pagevecs to LRU occasionally.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: CAI Qian <caiqian@redhat.com>
Cc:Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN mm/ksm.c~ksm-drain-pagevecs-to-lru mm/ksm.c
--- a/mm/ksm.c~ksm-drain-pagevecs-to-lru
+++ a/mm/ksm.c
@@ -1296,6 +1296,18 @@ static struct rmap_item *scan_get_next_r
 
 	slot = ksm_scan.mm_slot;
 	if (slot == &ksm_mm_head) {
+		/*
+		 * A number of pages can hang around indefinitely on per-cpu
+		 * pagevecs, raised page count preventing write_protect_page
+		 * from merging them.  Though it doesn't really matter much,
+		 * it is puzzling to see some stuck in pages_volatile until
+		 * other activity jostles them out, and they also prevented
+		 * LTP's KSM test from succeeding deterministically; so drain
+		 * them here (here rather than on entry to ksm_do_scan(),
+		 * so we don't IPI too often when pages_to_scan is set low).
+		 */
+		lru_add_drain_all();
+
 		root_unstable_tree = RB_ROOT;
 
 		spin_lock(&ksm_mmlist_lock);
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-vmap-area-cache-fix.patch
prio_tree-debugging-patch.patch

