From: akpm@linux-foundation.org
Subject: [folded-merged] memcg-fast-hierarchy-aware-child-test-fix.patch removed from -mm tree
Date: Fri, 22 Feb 2013 15:52:05 -0800
Message-ID: <20130222235205.B376E5A415F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:57337 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443Ab3BVXwH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 18:52:07 -0500
Received: by mail-qc0-f201.google.com with SMTP id o22so121363qcr.4
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 15:52:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyuki@gmail.com, mhocko@suse.cz, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-fast-hierarchy-aware-child-test-fix
has been removed from the -mm tree.  Its filename was
     memcg-fast-hierarchy-aware-child-test-fix.patch

This patch was dropped because it was folded into memcg-fast-hierarchy-aware-child-test.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-fast-hierarchy-aware-child-test-fix

tweak comments

Cc: Glauber Costa <glommer@parallels.com>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN mm/memcontrol.c~memcg-fast-hierarchy-aware-child-test-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fast-hierarchy-aware-child-test-fix
+++ a/mm/memcontrol.c
@@ -4763,8 +4763,9 @@ static void mem_cgroup_reparent_charges(
 }
 
 /*
- * this mainly exists for tests during set of use_hierarchy. Since this is
- * the very setting we are changing, the current hierarchy value is meaningless
+ * This mainly exists for tests during the setting of set of use_hierarchy.
+ * Since this is the very setting we are changing, the current hierarchy value
+ * is meaningless
  */
 static inline bool __memcg_has_children(struct mem_cgroup *memcg)
 {
@@ -4777,11 +4778,11 @@ static inline bool __memcg_has_children(
 }
 
 /*
- * must be called with cgroup_lock held, unless the cgroup is guaranteed to be
- * already dead (like in mem_cgroup_force_empty, for instance).  This is
- * different than mem_cgroup_count_children, in the sense that we don't really
- * care how many children we have, we only need to know if we have any. It is
- * also count any memcg without hierarchy as infertile for that matter.
+ * Must be called with cgroup_lock held, unless the cgroup is guaranteed to be
+ * already dead (in mem_cgroup_force_empty(), for instance).  This is different
+ * from mem_cgroup_count_children(), in the sense that we don't really care how
+ * many children we have; we only need to know if we have any.  It also counts
+ * any memcg without hierarchy as infertile.
  */
 static inline bool memcg_has_children(struct mem_cgroup *memcg)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-md-persistent-data-dm-transaction-managerc-rename-hash_size.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
cma-make-putback_lru_pages-call-conditional.patch
mm-vmscan-clean-up-get_scan_count.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
mm-remove-flags-argument-to-mmap_region.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove.patch
memory-hotplug-remove-page-table-of-x86_64-architecture.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline.patch
cpu_hotplug-clear-apicid-to-node-when-the-cpu-is-hotremoved.patch
cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node.patch
page_alloc-add-movable_memmap-kernel-parameter.patch
acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat.patch
memory-failure-do-code-refactor-of-soft_offline_page.patch
memory-failure-use-num_poisoned_pages-instead-of-mce_bad_pages.patch
mm-memory-failurec-fix-wrong-num_poisoned_pages-in-handling-memory-error-on-thp.patch
mm-dont-inline-page_mapping.patch
swap-make-each-swap-partition-have-one-address_space.patch
page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory.patch
memcg-reduce-the-size-of-struct-memcg-244-fold.patch
memcg-fast-hierarchy-aware-child-test.patch
mm-rename-page-struct-field-helpers.patch
mm-rename-page-struct-field-helpers-fix.patch
mm-page_alloc-add-informative-debugging-message-in-page_outside_zone_boundaries-fix.patch
hwpoison-fix-misjudgement-of-page_action-for-errors-on-mlocked-pages-fix.patch
mm-accurately-document-nr_free__pages-functions-with-code-comments-fix.patch
tmpfs-fix-mempolicy-object-leaks-fix.patch

