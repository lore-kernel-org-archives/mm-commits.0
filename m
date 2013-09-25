From: akpm@linux-foundation.org
Subject: [merged]
 revert-memcg-track-all-children-over-limit-in-the-root.patch removed from
 -mm tree
Date: Wed, 25 Sep 2013 12:05:58 -0700
Message-ID: <52433416.i8R/wLwBD61Dm29L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48622 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab3IYTF7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Sep 2013 15:05:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, torvalds@linux-foundation.org, mhocko@suse.cz, hannes@cmpxchg.org, akpm@linux-foundation.org

Subject: [merged] revert-memcg-track-all-children-over-limit-in-the-root.patch removed from -mm tree
To: akpm@linux-foundation.org,hannes@cmpxchg.org,mhocko@suse.cz,torvalds@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 25 Sep 2013 12:05:58 -0700


The patch titled
     Subject: revert "memcg: track all children over limit in the root"
has been removed from the -mm tree.  Its filename was
     revert-memcg-track-all-children-over-limit-in-the-root.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

