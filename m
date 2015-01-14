From: akpm@linux-foundation.org
Subject: + mm-memcontrol-default-hierarchy-interface-for-memory-fix.patch
 added to -mm tree
Date: Tue, 13 Jan 2015 16:20:14 -0800
Message-ID: <54b5b63e.hychPPzfIL7TS5nx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53900 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbbANAUP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Jan 2015 19:20:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, gthelen@google.com, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: default hierarchy interface for memory fix
has been added to the -mm tree.  Its filename is
     mm-memcontrol-default-hierarchy-interface-for-memory-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-default-hierarchy-interface-for-memory-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-default-hierarchy-interface-for-memory-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: default hierarchy interface for memory fix

Document and rationalize where the default hierarchy interface differs
from the traditional memory cgroups interface.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Greg Thelen <gthelen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/unified-hierarchy.txt |   80 ++++++++++++++++++
 1 file changed, 80 insertions(+)

diff -puN Documentation/cgroups/unified-hierarchy.txt~mm-memcontrol-default-hierarchy-interface-for-memory-fix Documentation/cgroups/unified-hierarchy.txt
--- a/Documentation/cgroups/unified-hierarchy.txt~mm-memcontrol-default-hierarchy-interface-for-memory-fix
+++ a/Documentation/cgroups/unified-hierarchy.txt
@@ -327,6 +327,86 @@ supported and the interface files "relea
 - use_hierarchy is on by default and the cgroup file for the flag is
   not created.
 
+- The original lower boundary, the soft limit, is defined as a limit
+  that is per default unset.  As a result, the set of cgroups that
+  global reclaim prefers is opt-in, rather than opt-out.  The costs
+  for optimizing these mostly negative lookups are so high that the
+  implementation, despite its enormous size, does not even provide the
+  basic desirable behavior.  First off, the soft limit has no
+  hierarchical meaning.  All configured groups are organized in a
+  global rbtree and treated like equal peers, regardless where they
+  are located in the hierarchy.  This makes subtree delegation
+  impossible.  Second, the soft limit reclaim pass is so aggressive
+  that it not just introduces high allocation latencies into the
+  system, but also impacts system performance due to overreclaim, to
+  the point where the feature becomes self-defeating.
+
+  The memory.low boundary on the other hand is a top-down allocated
+  reserve.  A cgroup enjoys reclaim protection when it and all its
+  ancestors are below their low boundaries, which makes delegation of
+  subtrees possible.  Secondly, new cgroups have no reserve per
+  default and in the common case most cgroups are eligible for the
+  preferred reclaim pass.  This allows the new low boundary to be
+  efficiently implemented with just a minor addition to the generic
+  reclaim code, without the need for out-of-band data structures and
+  reclaim passes.  Because the generic reclaim code considers all
+  cgroups except for the ones running low in the preferred first
+  reclaim pass, overreclaim of individual groups is eliminated as
+  well, resulting in much better overall workload performance.
+
+- The original high boundary, the hard limit, is defined as a strict
+  limit that can not budge, even if the OOM killer has to be called.
+  But this generally goes against the goal of making the most out of
+  the available memory.  The memory consumption of workloads varies
+  during runtime, and that requires users to overcommit.  But doing
+  that with a strict upper limit requires either a fairly accurate
+  prediction of the working set size or adding slack to the limit.
+  Since working set size estimation is hard and error prone, and
+  getting it wrong results in OOM kills, most users tend to err on the
+  side of a looser limit and end up wasting precious resources.
+
+  The memory.high boundary on the other hand can be set much more
+  conservatively.  When hit, it throttles allocations by forcing them
+  into direct reclaim to work off the excess, but it never invokes the
+  OOM killer.  As a result, a high boundary that is chosen too
+  aggressively will not terminate the processes, but instead it will
+  lead to gradual performance degradation.  The user can monitor this
+  and make corrections until the minimal memory footprint that still
+  gives acceptable performance is found.
+
+  In extreme cases, with many concurrent allocations and a complete
+  breakdown of reclaim progress within the group, the high boundary
+  can be exceeded.  But even then it's mostly better to satisfy the
+  allocation from the slack available in other groups or the rest of
+  the system than killing the group.  Otherwise, memory.max is there
+  to limit this type of spillover and ultimately contain buggy or even
+  malicious applications.
+
+- The original control file names are unwieldy and inconsistent in
+  many different ways.  For example, the upper boundary hit count is
+  exported in the memory.failcnt file, but an OOM event count has to
+  be manually counted by listening to memory.oom_control events, and
+  lower boundary / soft limit events have to be counted by first
+  setting a threshold for that value and then counting those events.
+  Also, usage and limit files encode their units in the filename.
+  That makes the filenames very long, even though this is not
+  information that a user needs to be reminded of every time they type
+  out those names.
+
+  To address these naming issues, as well as to signal clearly that
+  the new interface carries a new configuration model, the naming
+  conventions in it necessarily differ from the old interface.
+
+- The original limit files indicate the state of an unset limit with a
+  Very High Number, and a configured limit can be unset by echoing -1
+  into those files.  But that very high number is implementation and
+  architecture dependent and not very descriptive.  And while -1 can
+  be understood as an underflow into the highest possible value, -2 or
+  -10M etc. do not work, so it's not consistent.
+
+  memory.low and memory.high will indicate "none" if the boundary is
+  not configured, and a configured boundary can be unset by writing
+  "none" into these files as well.
 
 5. Planned Changes
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch
memcg-remove-extra-newlines-from-memcg-oom-kill-log.patch
mm-memory-remove-vm_file-check-on-shared-writable-vmas.patch
mm-memory-merge-shared-writable-dirtying-branches-in-do_wp_page.patch
mm-page_alloc-place-zone_id-check-before-vm_bug_on_page-check.patch
memcg-zap-__memcg_chargeuncharge_slab.patch
memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache.patch
memcg-zap-memcg_slab_caches-and-memcg_slab_mutex.patch
mm-add-fields-for-compound-destructor-and-order-into-struct-page.patch
swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration.patch
mm-memcontrol-track-move_lock-state-internally.patch
mm-memcontrol-track-move_lock-state-internally-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch
mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_.patch
mm-hugetlb-pmd_huge-returns-true-for-non-present-hugepage.patch
mm-hugetlb-take-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault.patch
mm-hugetlb-add-migration-hwpoisoned-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-add-migration-entry-check-in-__unmap_hugepage_range.patch
mm-hugetlb-fix-suboptimal-migration-hwpoisoned-entry-check.patch
mm-hugetlb-cleanup-and-rename-is_hugetlb_entry_migrationhwpoisoned.patch
mm-set-page-pfmemalloc-in-prep_new_page.patch
mm-page_alloc-reduce-number-of-alloc_pages-functions-parameters.patch
mm-reduce-try_to_compact_pages-parameters.patch
mm-microoptimize-zonelist-operations.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
vmscan-force-scan-offline-memory-cgroups.patch
memcg-add-build_bug_on-for-string-tables.patch
mm-page_counter-pull-1-handling-out-of-page_counter_memparse.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
mm-memcontrol-default-hierarchy-interface-for-memory-checkpatch-fixes.patch
mm-memcontrol-default-hierarchy-interface-for-memory-fix.patch
mm-memcontrol-fold-move_anon-and-move_file.patch
oom-add-helpers-for-setting-and-clearing-tif_memdie.patch
oom-thaw-the-oom-victim-if-it-is-frozen.patch
pm-convert-printk-to-pr_-equivalent.patch
sysrq-convert-printk-to-pr_-equivalent.patch
oom-pm-make-oom-detection-in-the-freezer-path-raceless.patch
mm-memcontrol-remove-unnecessary-soft-limit-tree-node-test.patch
mm-memcontrol-consolidate-memory-controller-initialization.patch
mm-memcontrol-consolidate-swap-controller-code.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps.patch

