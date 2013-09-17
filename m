From: akpm@linux-foundation.org
Subject: +
 revert-vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
 added to -mm tree
Date: Tue, 17 Sep 2013 13:58:07 -0700
Message-ID: <5238c25f.ebEf7YGOMTf1J/3y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38444 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab3IQU6I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Sep 2013 16:58:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, torvalds@linux-foundation.org, mhocko@suse.cz, hannes@cmpxchg.org, akpm@linux-foundation.org

Subject: + revert-vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch added to -mm tree
To: akpm@linux-foundation.org,hannes@cmpxchg.org,mhocko@suse.cz,torvalds@linux-foundation.org
From: akpm@linux-foundation.org
Date: Tue, 17 Sep 2013 13:58:07 -0700


The patch titled
     Subject: revert "vmscan, memcg: do softlimit reclaim also for targeted reclaim"
has been added to the -mm tree.  Its filename is
     revert-vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch

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
Subject: revert "vmscan, memcg: do softlimit reclaim also for targeted reclaim"

Revert

: commit a5b7c87f92076352dbff2fe0423ec255e1c9a71b
: Author:     Michal Hocko <mhocko@suse.cz>
: AuthorDate: Thu Sep 12 15:13:25 2013 -0700
: Commit:     Linus Torvalds <torvalds@linux-foundation.org>
: CommitDate: Thu Sep 12 15:38:00 2013 -0700
: 
:     vmscan, memcg: do softlimit reclaim also for targeted reclaim

I merged this prematurely - Michal and Johannes still disagree about the
overall design direction and the future remains unclear.

Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 ++----
 mm/memcontrol.c            |   14 +++++---------
 mm/vmscan.c                |    4 ++--
 3 files changed, 9 insertions(+), 15 deletions(-)

diff -puN include/linux/memcontrol.h~revert-vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~revert-vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim
+++ a/include/linux/memcontrol.h
@@ -234,8 +234,7 @@ static inline void mem_cgroup_dec_page_s
 	mem_cgroup_update_page_stat(page, idx, -1);
 }
 
-bool mem_cgroup_soft_reclaim_eligible(struct mem_cgroup *memcg,
-		struct mem_cgroup *root);
+bool mem_cgroup_soft_reclaim_eligible(struct mem_cgroup *memcg);
 
 void __mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx);
 static inline void mem_cgroup_count_vm_event(struct mm_struct *mm,
@@ -435,8 +434,7 @@ static inline void mem_cgroup_dec_page_s
 }
 
 static inline
-bool mem_cgroup_soft_reclaim_eligible(struct mem_cgroup *memcg,
-		struct mem_cgroup *root)
+bool mem_cgroup_soft_reclaim_eligible(struct mem_cgroup *memcg)
 {
 	return false;
 }
diff -puN mm/memcontrol.c~revert-vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim mm/memcontrol.c
--- a/mm/memcontrol.c~revert-vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim
+++ a/mm/memcontrol.c
@@ -1760,13 +1760,11 @@ int mem_cgroup_select_victim_node(struct
 #endif
 
 /*
- * A group is eligible for the soft limit reclaim under the given root
- * hierarchy if
- *	a) it is over its soft limit
+ * A group is eligible for the soft limit reclaim if
+ * 	a) it is over its soft limit
  *	b) any parent up the hierarchy is over its soft limit
  */
-bool mem_cgroup_soft_reclaim_eligible(struct mem_cgroup *memcg,
-		struct mem_cgroup *root)
+bool mem_cgroup_soft_reclaim_eligible(struct mem_cgroup *memcg)
 {
 	struct mem_cgroup *parent = memcg;
 
@@ -1774,14 +1772,12 @@ bool mem_cgroup_soft_reclaim_eligible(st
 		return true;
 
 	/*
-	 * If any parent up to the root in the hierarchy is over its soft limit
-	 * then we have to obey and reclaim from this group as well.
+	 * If any parent up the hierarchy is over its soft limit then we
+	 * have to obey and reclaim from this group as well.
 	 */
 	while ((parent = parent_mem_cgroup(parent))) {
 		if (res_counter_soft_limit_excess(&parent->res))
 			return true;
-		if (parent == root)
-			break;
 	}
 
 	return false;
diff -puN mm/vmscan.c~revert-vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim mm/vmscan.c
--- a/mm/vmscan.c~revert-vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim
+++ a/mm/vmscan.c
@@ -142,7 +142,7 @@ static bool global_reclaim(struct scan_c
 
 static bool mem_cgroup_should_soft_reclaim(struct scan_control *sc)
 {
-	return !mem_cgroup_disabled();
+	return !mem_cgroup_disabled() && global_reclaim(sc);
 }
 #else
 static bool global_reclaim(struct scan_control *sc)
@@ -2195,7 +2195,7 @@ __shrink_zone(struct zone *zone, struct
 			struct lruvec *lruvec;
 
 			if (soft_reclaim &&
-			    !mem_cgroup_soft_reclaim_eligible(memcg, root)) {
+			    !mem_cgroup_soft_reclaim_eligible(memcg)) {
 				memcg = mem_cgroup_iter(root, memcg, &reclaim);
 				continue;
 			}
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

