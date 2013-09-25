From: akpm@linux-foundation.org
Subject: [merged]
 revert-vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
 removed from -mm tree
Date: Wed, 25 Sep 2013 12:06:06 -0700
Message-ID: <5243341e./ilg8Pg3ePFxsp24%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48639 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab3IYTGH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Sep 2013 15:06:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, torvalds@linux-foundation.org, mhocko@suse.cz, hannes@cmpxchg.org, akpm@linux-foundation.org

Subject: [merged] revert-vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch removed from -mm tree
To: akpm@linux-foundation.org,hannes@cmpxchg.org,mhocko@suse.cz,torvalds@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 25 Sep 2013 12:06:06 -0700


The patch titled
     Subject: revert "vmscan, memcg: do softlimit reclaim also for targeted reclaim"
has been removed from the -mm tree.  Its filename was
     revert-vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

