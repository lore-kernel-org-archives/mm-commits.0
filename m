From: akpm@linux-foundation.org
Subject: [folded-merged] mm-memcg-avoid-unnecessary-function-call-when-memcg-is-disabled-fix.patch removed from -mm tree
Date: Wed, 12 Dec 2012 13:39:01 -0800
Message-ID: <20121212213901.E585210004A@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:37589 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985Ab2LLVjD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 16:39:03 -0500
Received: by mail-qa0-f73.google.com with SMTP id a19so134296qad.4
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 13:39:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcg-avoid-unnecessary-function-call-when-memcg-is-disabled-fix
has been removed from the -mm tree.  Its filename was
     mm-memcg-avoid-unnecessary-function-call-when-memcg-is-disabled-fix.patch

This patch was dropped because it was folded into mm-memcg-avoid-unnecessary-function-call-when-memcg-is-disabled.patch

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm-memcg-avoid-unnecessary-function-call-when-memcg-is-disabled-fix

Move the check for !mm out of line as suggested by Andrew.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 mm/memcontrol.c            |    3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN include/linux/memcontrol.h~mm-memcg-avoid-unnecessary-function-call-when-memcg-is-disabled-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcg-avoid-unnecessary-function-call-when-memcg-is-disabled-fix
+++ a/include/linux/memcontrol.h
@@ -188,7 +188,7 @@ void __mem_cgroup_count_vm_event(struct 
 static inline void mem_cgroup_count_vm_event(struct mm_struct *mm,
 					     enum vm_event_item idx)
 {
-	if (mem_cgroup_disabled() || !mm)
+	if (mem_cgroup_disabled())
 		return;
 	__mem_cgroup_count_vm_event(mm, idx);
 }
diff -puN mm/memcontrol.c~mm-memcg-avoid-unnecessary-function-call-when-memcg-is-disabled-fix mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-avoid-unnecessary-function-call-when-memcg-is-disabled-fix
+++ a/mm/memcontrol.c
@@ -1156,6 +1156,9 @@ void __mem_cgroup_count_vm_event(struct 
 {
 	struct mem_cgroup *memcg;
 
+	if (!mm)
+		return;
+
 	rcu_read_lock();
 	memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
 	if (unlikely(!memcg))
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
thp-huge-zero-page-basic-preparation.patch
thp-zap_huge_pmd-zap-huge-zero-pmd.patch
thp-copy_huge_pmd-copy-huge-zero-page.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page.patch
thp-change_huge_pmd-make-sure-we-dont-try-to-make-a-page-writable.patch
thp-change-split_huge_page_pmd-interface.patch
thp-implement-splitting-pmd-for-huge-zero-page.patch
thp-setup-huge-zero-page-on-non-write-page-fault.patch
thp-lazy-huge-zero-page-allocation.patch
thp-implement-refcounting-for-huge-zero-page.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events.patch
thp-introduce-sysfs-knob-to-disable-huge-zero-page.patch
thp-avoid-race-on-multiple-parallel-page-faults-to-the-same-page.patch
node_states-introduce-n_memory.patch
cpuset-use-n_memory-instead-n_high_memory.patch
procfs-use-n_memory-instead-n_high_memory.patch
memcontrol-use-n_memory-instead-n_high_memory.patch
oom-use-n_memory-instead-n_high_memory.patch
mmmigrate-use-n_memory-instead-n_high_memory.patch
mempolicy-use-n_memory-instead-n_high_memory.patch
hugetlb-use-n_memory-instead-n_high_memory.patch
vmstat-use-n_memory-instead-n_high_memory.patch
kthread-use-n_memory-instead-n_high_memory.patch
init-use-n_memory-instead-n_high_memory.patch
vmscan-use-n_memory-instead-n_high_memory.patch
page_alloc-use-n_memory-instead-n_high_memory-change-the-node_states-initialization.patch
hotplug-update-nodemasks-management.patch
mm-memcg-avoid-unnecessary-function-call-when-memcg-is-disabled.patch
numa-add-config_movable_node-for-movable-dedicated-node.patch
numa-add-config_movable_node-for-movable-dedicated-node-fix.patch
memory_hotplug-allow-online-offline-memory-to-result-movable-node.patch
mm-oom-cleanup-pagefault-oom-handler.patch
mm-oom-remove-redundant-sleep-in-pagefault-oom-handler.patch
mm-oom-remove-statically-defined-arch-functions-of-same-name.patch
mm-introduce-new-field-managed_pages-to-struct-zone.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap-fix.patch
memcg-do-not-check-for-mm-in-mem_cgroup_count_vm_event-disabled.patch

