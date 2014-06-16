From: akpm@linux-foundation.org
Subject: [withdrawn] memcg-doc-clarify-global-vs-limit-reclaims.patch
 removed from -mm tree
Date: Mon, 16 Jun 2014 15:35:05 -0700
Message-ID: <539f7119.nw33tJmvtwQ8mgj0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46085 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbaFPWfG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jun 2014 18:35:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, tj@kernel.org, kosaki.motohiro@jp.fujitsu.com, klamm@yandex-team.ru, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, gthelen@google.com, mhocko@suse.cz


The patch titled
     Subject: memcg, doc: clarify global vs. limit reclaims
has been removed from the -mm tree.  Its filename was
     memcg-doc-clarify-global-vs-limit-reclaims.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg, doc: clarify global vs. limit reclaims

Be explicit about global and hard limit reclaims in our documentation.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Roman Gushchin <klamm@yandex-team.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |   29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff -puN Documentation/cgroups/memory.txt~memcg-doc-clarify-global-vs-limit-reclaims Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-doc-clarify-global-vs-limit-reclaims
+++ a/Documentation/cgroups/memory.txt
@@ -236,23 +236,26 @@ it by cgroup.
 2.5 Reclaim
 
 Each cgroup maintains a per cgroup LRU which has the same structure as
-global VM. When a cgroup goes over its limit, we first try
-to reclaim memory from the cgroup so as to make space for the new
-pages that the cgroup has touched. If the reclaim is unsuccessful,
-an OOM routine is invoked to select and kill the bulkiest task in the
-cgroup. (See 10. OOM Control below.)
-
-The reclaim algorithm has not been modified for cgroups, except that
-pages that are selected for reclaiming come from the per-cgroup LRU
-list.
+global VM. Cgroups can get reclaimed basically under two conditions
+ - under global memory pressure when all cgroups are reclaimed
+   proportionally wrt. their LRU size in a round robin fashion
+ - when a cgroup or its hierarchical parent (see 6. Hierarchical support)
+   hits hard limit. If the reclaim is unsuccessful, an OOM routine is invoked
+   to select and kill the bulkiest task in the cgroup. (See 10. OOM Control
+   below.)
+
+Global and hard-limit reclaims share the same code the only difference
+is the objective of the reclaim. The global reclaim aims at balancing
+zones' watermarks while the limit reclaim frees some memory to allow new
+charges.
 
-NOTE: Reclaim does not work for the root cgroup, since we cannot set any
-limits on the root cgroup.
+NOTE: Hard limit reclaim does not work for the root cgroup, since we cannot set
+any limits on the root cgroup.
 
 Note2: When panic_on_oom is set to "2", the whole system will panic.
 
-When oom event notifier is registered, event will be delivered.
-(See oom_control section)
+When oom event notifier is registered, event will be delivered to the root
+of the memory pressure which cannot be handled (See oom_control section)
 
 2.6 Locking
 
_

Patches currently in -mm which might be from mhocko@suse.cz are

mm-vmscanc-avoid-recording-the-original-scan-targets-in-shrink_lruvec.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-pagewalk-remove-pgd_entry-and-pud_entry.patch
mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control.patch
madvise-cleanup-swapin_walk_pmd_entry.patch
memcg-separate-mem_cgroup_move_charge_pte_range.patch
arch-powerpc-mm-subpage-protc-cleanup-subpage_walk_pmd_entry.patch
mm-pagewalk-move-pmd_trans_huge_lock-from-callbacks-to-common-code.patch
mincore-apply-page-table-walker-on-do_mincore.patch
memcg-doc-clarify-global-vs-limit-reclaims-fix.patch
memcg-document-memorylow_limit_in_bytes.patch
vmscan-memcg-check-whether-the-low-limit-should-be-ignored.patch
memcg-deprecate-memoryforce_empty-knob.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch

