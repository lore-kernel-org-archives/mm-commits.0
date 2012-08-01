From: akpm@linux-foundation.org
Subject: [merged] mm-oom-move-declaration-for-mem_cgroup_out_of_memory-to-oomh.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:15:01 -0700
Message-ID: <20120801201502.6C1C55C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:60388 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538Ab2HAUPF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:15:05 -0400
Received: by bkcjc3 with SMTP id jc3so345221bkc.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:15:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: move declaration for mem_cgroup_out_of_memory to oom.h
has been removed from the -mm tree.  Its filename was
     mm-oom-move-declaration-for-mem_cgroup_out_of_memory-to-oomh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: move declaration for mem_cgroup_out_of_memory to oom.h

mem_cgroup_out_of_memory() is defined in mm/oom_kill.c, so declare it in
linux/oom.h rather than linux/memcontrol.h.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 --
 include/linux/oom.h        |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/memcontrol.h~mm-oom-move-declaration-for-mem_cgroup_out_of_memory-to-oomh include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-oom-move-declaration-for-mem_cgroup_out_of_memory-to-oomh
+++ a/include/linux/memcontrol.h
@@ -72,8 +72,6 @@ extern void mem_cgroup_uncharge_end(void
 extern void mem_cgroup_uncharge_page(struct page *page);
 extern void mem_cgroup_uncharge_cache_page(struct page *page);
 
-extern void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
-				     int order);
 bool __mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
 				  struct mem_cgroup *memcg);
 int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *memcg);
diff -puN include/linux/oom.h~mm-oom-move-declaration-for-mem_cgroup_out_of_memory-to-oomh include/linux/oom.h
--- a/include/linux/oom.h~mm-oom-move-declaration-for-mem_cgroup_out_of_memory-to-oomh
+++ a/include/linux/oom.h
@@ -49,6 +49,8 @@ extern unsigned long oom_badness(struct 
 extern int try_set_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
 extern void clear_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
 
+extern void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
+				     int order);
 extern void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 		int order, nodemask_t *mask, bool force_kill);
 extern int register_oom_notifier(struct notifier_block *nb);
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch
slab-do-not-call-compound_head-in-page_get_cache.patch

