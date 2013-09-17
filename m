From: akpm@linux-foundation.org
Subject: +
 revert-memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
 added to -mm tree
Date: Tue, 17 Sep 2013 13:57:58 -0700
Message-ID: <5238c256.AVO70+fVES+d/Ggk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38424 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab3IQU57 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Sep 2013 16:57:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, torvalds@linux-foundation.org, mhocko@suse.cz, hannes@cmpxchg.org, akpm@linux-foundation.org

Subject: + revert-memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch added to -mm tree
To: akpm@linux-foundation.org,hannes@cmpxchg.org,mhocko@suse.cz,torvalds@linux-foundation.org
From: akpm@linux-foundation.org
Date: Tue, 17 Sep 2013 13:57:58 -0700


The patch titled
     Subject: revert "memcg, vmscan: do not fall into reclaim-all pass too quickly"
has been added to the -mm tree.  Its filename is
     revert-memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert "memcg, vmscan: do not fall into reclaim-all pass too quickly"

Revert

: commit e975de998b9612aa97e3165f8827c09e0d36ce77
: Author:     Michal Hocko <mhocko@suse.cz>
: AuthorDate: Thu Sep 12 15:13:34 2013 -0700
: Commit:     Linus Torvalds <torvalds@linux-foundation.org>
: CommitDate: Thu Sep 12 15:38:01 2013 -0700
: 
:     memcg, vmscan: do not fall into reclaim-all pass too quickly

I merged this prematurely - Michal and Johannes still disagree about the
overall design direction and the future remains unclear.

Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff -puN mm/vmscan.c~revert-memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly mm/vmscan.c
--- a/mm/vmscan.c~revert-memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly
+++ a/mm/vmscan.c
@@ -2176,11 +2176,10 @@ static inline bool should_continue_recla
 	}
 }
 
-static int
+static void
 __shrink_zone(struct zone *zone, struct scan_control *sc, bool soft_reclaim)
 {
 	unsigned long nr_reclaimed, nr_scanned;
-	int groups_scanned = 0;
 
 	do {
 		struct mem_cgroup *root = sc->target_mem_cgroup;
@@ -2198,7 +2197,6 @@ __shrink_zone(struct zone *zone, struct
 		while ((memcg = mem_cgroup_iter_cond(root, memcg, &reclaim, filter))) {
 			struct lruvec *lruvec;
 
-			groups_scanned++;
 			lruvec = mem_cgroup_zone_lruvec(zone, memcg);
 
 			shrink_lruvec(lruvec, sc);
@@ -2226,8 +2224,6 @@ __shrink_zone(struct zone *zone, struct
 
 	} while (should_continue_reclaim(zone, sc->nr_reclaimed - nr_reclaimed,
 					 sc->nr_scanned - nr_scanned, sc));
-
-	return groups_scanned;
 }
 
 
@@ -2235,19 +2231,8 @@ static void shrink_zone(struct zone *zon
 {
 	bool do_soft_reclaim = mem_cgroup_should_soft_reclaim(sc);
 	unsigned long nr_scanned = sc->nr_scanned;
-	int scanned_groups;
 
-	scanned_groups = __shrink_zone(zone, sc, do_soft_reclaim);
-	/*
-	 * memcg iterator might race with other reclaimer or start from
-	 * a incomplete tree walk so the tree walk in __shrink_zone
-	 * might have missed groups that are above the soft limit. Try
-	 * another loop to catch up with others. Do it just once to
-	 * prevent from reclaim latencies when other reclaimers always
-	 * preempt this one.
-	 */
-	if (do_soft_reclaim && !scanned_groups)
-		__shrink_zone(zone, sc, do_soft_reclaim);
+	__shrink_zone(zone, sc, do_soft_reclaim);
 
 	/*
 	 * No group is over the soft limit or those that are do not have
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
revert-memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
revert-memcg-track-all-children-over-limit-in-the-root.patch
revert-memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
revert-memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
revert-memcg-enhance-memcg-iterator-to-support-predicates.patch
revert-vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
revert-memcg-get-rid-of-soft-limit-tree-infrastructure.patch
revert-memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix.patch
drivers-staging-lustre-lustre-ptlrpc-sec_bulkc-rename-ptrs_per_page.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm.patch
mm-vmalloc-dont-warn-about-vmalloc-allocation-failure-twice-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
fat-additions-to-support-fat_fallocate-fix-fix.patch
linux-next.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
revert-memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
revert-memcg-track-all-children-over-limit-in-the-root.patch
revert-memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
revert-memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
revert-memcg-enhance-memcg-iterator-to-support-predicates.patch
revert-vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
revert-memcg-get-rid-of-soft-limit-tree-infrastructure.patch
revert-memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch

