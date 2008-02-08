From: akpm@linux-foundation.org
Subject: - memory-cgroup-enhancements-implicit-force_empty-at-rmdir.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:04:33 -0800
Message-ID: <200802080804.m1884E6T014250@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57109 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755512AbYBHIXz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:23:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, a.p.zijlstra@chello.nl, balbir@linux.vnet.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, menage@google.com, nickpiggin@yahoo.com.au


The patch titled
     memory cgroup enhancements: implicit force_empty() at rmdir
has been removed from the -mm tree.  Its filename was
     memory-cgroup-enhancements-implicit-force_empty-at-rmdir.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory cgroup enhancements: implicit force_empty() at rmdir
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Add pre_destroy handler for mem_cgroup and try to make mem_cgroup empty at
rmdir().

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Paul Menage <menage@google.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/memcontrol.c~memory-cgroup-enhancements-implicit-force_empty-at-rmdir mm/memcontrol.c
--- a/mm/memcontrol.c~memory-cgroup-enhancements-implicit-force_empty-at-rmdir
+++ a/mm/memcontrol.c
@@ -895,6 +895,13 @@ mem_cgroup_create(struct cgroup_subsys *
 	return &mem->css;
 }
 
+static void mem_cgroup_pre_destroy(struct cgroup_subsys *ss,
+					struct cgroup *cont)
+{
+	struct mem_cgroup *mem = mem_cgroup_from_cont(cont);
+	mem_cgroup_force_empty(mem);
+}
+
 static void mem_cgroup_destroy(struct cgroup_subsys *ss,
 				struct cgroup *cont)
 {
@@ -946,6 +953,7 @@ struct cgroup_subsys mem_cgroup_subsys =
 	.name = "memory",
 	.subsys_id = mem_cgroup_subsys_id,
 	.create = mem_cgroup_create,
+	.pre_destroy = mem_cgroup_pre_destroy,
 	.destroy = mem_cgroup_destroy,
 	.populate = mem_cgroup_populate,
 	.attach = mem_cgroup_move_task,
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
enable-hotplug-memory-remove-for-ppc64.patch
add-arch-specific-walk_memory_remove-for-ppc64.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
