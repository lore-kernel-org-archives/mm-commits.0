From: akpm@linux-foundation.org
Subject: + memcontrol-move-mm_cgroup-to-header-file.patch added to -mm tree
Date: Tue, 25 Sep 2007 10:29:27 -0700
Message-ID: <200709251729.l8PHTRJQ028750@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43908 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751638AbXIYRaG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Sep 2007 13:30:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, balbir@linux.vnet.ibm.com


The patch titled
     memcontrol: move mm_cgroup to header file
has been added to the -mm tree.  Its filename is
     memcontrol-move-mm_cgroup-to-header-file.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: memcontrol: move mm_cgroup to header file
From: David Rientjes <rientjes@google.com>

Inline functions must preceed their use, so mm_cgroup() should be defined
in linux/memcontrol.h.

include/linux/memcontrol.h:48: warning: 'mm_cgroup' declared inline after
	being called
include/linux/memcontrol.h:48: warning: previous declaration of
	'mm_cgroup' was here

Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    8 ++++++--
 mm/memcontrol.c            |    5 -----
 2 files changed, 6 insertions(+), 7 deletions(-)

diff -puN include/linux/memcontrol.h~memcontrol-move-mm_cgroup-to-header-file include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcontrol-move-mm_cgroup-to-header-file
+++ a/include/linux/memcontrol.h
@@ -45,7 +45,11 @@ extern unsigned long mem_cgroup_isolate_
 extern void mem_cgroup_out_of_memory(struct mem_cgroup *mem, gfp_t gfp_mask);
 extern int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 					gfp_t gfp_mask);
-extern struct mem_cgroup *mm_cgroup(struct mm_struct *mm);
+
+static inline struct mem_cgroup *mm_cgroup(const struct mm_struct *mm)
+{
+	return rcu_dereference(mm->mem_cgroup);
+}
 
 static inline void mem_cgroup_uncharge_page(struct page *page)
 {
@@ -98,7 +102,7 @@ static inline int mem_cgroup_cache_charg
 	return 0;
 }
 
-static inline struct mem_cgroup *mm_cgroup(struct mm_struct *mm)
+static inline struct mem_cgroup *mm_cgroup(const struct mm_struct *mm)
 {
 	return NULL;
 }
diff -puN mm/memcontrol.c~memcontrol-move-mm_cgroup-to-header-file mm/memcontrol.c
--- a/mm/memcontrol.c~memcontrol-move-mm_cgroup-to-header-file
+++ a/mm/memcontrol.c
@@ -110,11 +110,6 @@ struct mem_cgroup *mem_cgroup_from_task(
 				struct mem_cgroup, css);
 }
 
-inline struct mem_cgroup *mm_cgroup(struct mm_struct *mm)
-{
-	return rcu_dereference(mm->mem_cgroup);
-}
-
 void mm_init_cgroup(struct mm_struct *mm, struct task_struct *p)
 {
 	struct mem_cgroup *mem;
_

Patches currently in -mm which might be from rientjes@google.com are

maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
oom-move-prototypes-to-appropriate-header-file.patch
oom-move-prototypes-to-appropriate-header-file-fix.patch
oom-move-constraints-to-enum.patch
oom-change-all_unreclaimable-zone-member-to-flags.patch
oom-change-all_unreclaimable-zone-member-to-flags-fix.patch
oom-add-per-zone-locking.patch
oom-serialize-out-of-memory-calls.patch
oom-add-oom_kill_allocating_task-sysctl.patch
oom-suppress-extraneous-stack-and-memory-dump.patch
oom-compare-cpuset-mems_allowed-instead-of-exclusive.patch
oom-do-not-take-callback_mutex.patch
oom-do-not-take-callback_mutex-fix.patch
add-a-missing-00-index-file-for-documentation-vm-fix.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-resource-counters-v7-fix.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
memcontrol-move-mm_cgroup-to-header-file.patch
