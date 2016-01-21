From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-drop-unused-css-argument-in-memcg_init_kmem.patch removed
 from -mm tree
Date: Thu, 21 Jan 2016 15:29:24 -0800
Message-ID: <56a169d4.2SO9QAki/4cOy1CL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36331 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbcAUX3Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:29:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.com, tj@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: drop unused @css argument in memcg_init_kmem
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-drop-unused-css-argument-in-memcg_init_kmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: drop unused @css argument in memcg_init_kmem

This series adds accounting of the historical "kmem" memory consumers to
the cgroup2 memory controller.

These consumers include the dentry cache, the inode cache, kernel stack
pages, and a few others that are pointed out in patch 7/8.  The footprint
of these consumers is directly tied to userspace activity in common
workloads, and so they have to be part of the minimally viable
configuration in order to present a complete feature to our users.

The cgroup2 interface of the memory controller is far from complete, but
this series, along with the socket memory accounting series, provides the
final semantic changes for the existing memory knobs in the cgroup2
interface, which is scheduled for initial release in the next merge
window.



This patch (of 8):

Remove unused css argument frmo memcg_init_kmem()

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Tejun Heo <tj@kernel.org>
Acked-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/net/tcp_memcontrol.h |    3 ++-
 mm/memcontrol.c              |    6 +++---
 net/ipv4/tcp_memcontrol.c    |    2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff -puN include/net/tcp_memcontrol.h~mm-memcontrol-drop-unused-css-argument-in-memcg_init_kmem include/net/tcp_memcontrol.h
--- a/include/net/tcp_memcontrol.h~mm-memcontrol-drop-unused-css-argument-in-memcg_init_kmem
+++ a/include/net/tcp_memcontrol.h
@@ -4,6 +4,7 @@
 struct cgroup_subsys;
 struct mem_cgroup;
 
-int tcp_init_cgroup(struct mem_cgroup *memcg, struct cgroup_subsys *ss);
+int tcp_init_cgroup(struct mem_cgroup *memcg);
 void tcp_destroy_cgroup(struct mem_cgroup *memcg);
+
 #endif /* _TCP_MEMCG_H */
diff -puN mm/memcontrol.c~mm-memcontrol-drop-unused-css-argument-in-memcg_init_kmem mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-drop-unused-css-argument-in-memcg_init_kmem
+++ a/mm/memcontrol.c
@@ -3583,7 +3583,7 @@ static int mem_cgroup_oom_control_write(
 }
 
 #ifdef CONFIG_MEMCG_KMEM
-static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
+static int memcg_init_kmem(struct mem_cgroup *memcg)
 {
 	int ret;
 
@@ -3591,7 +3591,7 @@ static int memcg_init_kmem(struct mem_cg
 	if (ret)
 		return ret;
 
-	return tcp_init_cgroup(memcg, ss);
+	return tcp_init_cgroup(memcg);
 }
 
 static void memcg_deactivate_kmem(struct mem_cgroup *memcg)
@@ -4274,7 +4274,7 @@ mem_cgroup_css_online(struct cgroup_subs
 	}
 	mutex_unlock(&memcg_create_mutex);
 
-	ret = memcg_init_kmem(memcg, &memory_cgrp_subsys);
+	ret = memcg_init_kmem(memcg);
 	if (ret)
 		return ret;
 
diff -puN net/ipv4/tcp_memcontrol.c~mm-memcontrol-drop-unused-css-argument-in-memcg_init_kmem net/ipv4/tcp_memcontrol.c
--- a/net/ipv4/tcp_memcontrol.c~mm-memcontrol-drop-unused-css-argument-in-memcg_init_kmem
+++ a/net/ipv4/tcp_memcontrol.c
@@ -6,7 +6,7 @@
 #include <linux/memcontrol.h>
 #include <linux/module.h>
 
-int tcp_init_cgroup(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
+int tcp_init_cgroup(struct mem_cgroup *memcg)
 {
 	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
 	struct page_counter *counter_parent = NULL;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

proc-revert-proc-pid-maps-annotation.patch
mm-oom_killc-dont-skip-pf_exiting-tasks-when-searching-for-a-victim.patch

