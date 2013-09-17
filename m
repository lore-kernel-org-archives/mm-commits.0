From: akpm@linux-foundation.org
Subject: + revert-memcg-track-all-children-over-limit-in-the-root.patch
 added to -mm tree
Date: Tue, 17 Sep 2013 13:58:00 -0700
Message-ID: <5238c258.B4QLQ6RFQ+BuFZEc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38429 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab3IQU6B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Sep 2013 16:58:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, torvalds@linux-foundation.org, mhocko@suse.cz, hannes@cmpxchg.org, akpm@linux-foundation.org

Subject: + revert-memcg-track-all-children-over-limit-in-the-root.patch added to -mm tree
To: akpm@linux-foundation.org,hannes@cmpxchg.org,mhocko@suse.cz,torvalds@linux-foundation.org
From: akpm@linux-foundation.org
Date: Tue, 17 Sep 2013 13:58:00 -0700


The patch titled
     Subject: revert "memcg: track all children over limit in the root"
has been added to the -mm tree.  Its filename is
     revert-memcg-track-all-children-over-limit-in-the-root.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-memcg-track-all-children-over-limit-in-the-root.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-memcg-track-all-children-over-limit-in-the-root.patch

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
Subject: revert "memcg: track all children over limit in the root"

Revert

: commit 1be171d60bddcce2602c5d009029274d67736fd7
: Author:     Michal Hocko <mhocko@suse.cz>
: AuthorDate: Thu Sep 12 15:13:32 2013 -0700
: Commit:     Linus Torvalds <torvalds@linux-foundation.org>
: CommitDate: Thu Sep 12 15:38:01 2013 -0700
: 
:     memcg: track all children over limit in the root

I merged this prematurely - Michal and Johannes still disagree about the
overall design direction and the future remains unclear.

Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN mm/memcontrol.c~revert-memcg-track-all-children-over-limit-in-the-root mm/memcontrol.c
--- a/mm/memcontrol.c~revert-memcg-track-all-children-over-limit-in-the-root
+++ a/mm/memcontrol.c
@@ -851,15 +851,9 @@ static void mem_cgroup_update_soft_limit
 	/*
 	 * Necessary to update all ancestors when hierarchy is used
 	 * because their event counter is not touched.
-	 * We track children even outside the hierarchy for the root
-	 * cgroup because tree walk starting at root should visit
-	 * all cgroups and we want to prevent from pointless tree
-	 * walk if no children is below the limit.
 	 */
 	while (delta && (parent = parent_mem_cgroup(parent)))
 		atomic_add(delta, &parent->children_in_excess);
-	if (memcg != root_mem_cgroup && !root_mem_cgroup->use_hierarchy)
-		atomic_add(delta, &root_mem_cgroup->children_in_excess);
 	spin_unlock(&memcg->soft_lock);
 }
 
@@ -6112,9 +6106,6 @@ static void mem_cgroup_css_offline(struc
 	if (memcg->soft_contributed) {
 		while ((memcg = parent_mem_cgroup(memcg)))
 			atomic_dec(&memcg->children_in_excess);
-
-		if (memcg != root_mem_cgroup && !root_mem_cgroup->use_hierarchy)
-			atomic_dec(&root_mem_cgroup->children_in_excess);
 	}
 	mem_cgroup_destroy_all_caches(memcg);
 	vmpressure_cleanup(&memcg->vmpressure);
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

