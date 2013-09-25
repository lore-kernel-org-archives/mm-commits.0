From: akpm@linux-foundation.org
Subject: [merged]
 revert-memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
 removed from -mm tree
Date: Wed, 25 Sep 2013 12:05:56 -0700
Message-ID: <52433414.496Pt1nR4UmiMR6R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab3IYTF5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Sep 2013 15:05:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, torvalds@linux-foundation.org, mhocko@suse.cz, hannes@cmpxchg.org, akpm@linux-foundation.org

Subject: [merged] revert-memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch removed from -mm tree
To: akpm@linux-foundation.org,hannes@cmpxchg.org,mhocko@suse.cz,torvalds@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 25 Sep 2013 12:05:56 -0700


The patch titled
     Subject: revert "memcg, vmscan: do not fall into reclaim-all pass too quickly"
has been removed from the -mm tree.  Its filename was
     revert-memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix-fix.patch
sound-soc-atmel-atmel-pcmc-fix-warning.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm.patch
kernel-printk-printkc-convert-to-pr_foo.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate.patch
fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

