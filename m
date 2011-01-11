From: akpm@linux-foundation.org
Subject: + ksm-drain-pagevecs-to-lru.patch added to -mm tree
Date: Tue, 11 Jan 2011 13:33:11 -0800
Message-ID: <201101112133.p0BLXBpP008081@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54533 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752904Ab1AKVdZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Jan 2011 16:33:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, aarcange@redhat.com, caiqian@redhat.com


The patch titled
     ksm: drain pagevecs to lru
has been added to the -mm tree.  Its filename is
     ksm-drain-pagevecs-to-lru.patch

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
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-avoid-a-potential-deadlock-due-to-lock_page-during-direct-compaction.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-avoid-a-potential-deadlock-due-to-lock_page-during-direct-compaction-fix.patch
do_wp_page-remove-the-reuse-flag.patch
do_wp_page-clarify-dirty_page-handling.patch
mlock-avoid-dirtying-pages-and-triggering-writeback.patch
mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages.patch
mm-add-foll_mlock-follow_page-flag.patch
mm-move-vm_locked-check-to-__mlock_vma_pages_range.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix.patch
thp-ksm-free-swap-when-swapcache-page-is-replaced.patch
thp-transparent-hugepage-core-fixlet.patch
thp-ksm-on-thp.patch
thp-add-compound_trans_head-helper.patch
ksm-drain-pagevecs-to-lru.patch
memcg-fix-memory-migration-of-shmem-swapcache.patch
prio_tree-debugging-patch.patch

