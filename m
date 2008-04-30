From: akpm@linux-foundation.org
Subject: - use-vmalloc-for-mem_cgroup-allocation-v3.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:43:14 -0700
Message-ID: <200804300543.m3U5hEgo029302@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33041 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755513AbYD3FoU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:44:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, lizf@cn.fujitsu.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     memcgroup: use vmalloc for mem_cgroup allocation
has been removed from the -mm tree.  Its filename was
     use-vmalloc-for-mem_cgroup-allocation-v3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcgroup: use vmalloc for mem_cgroup allocation
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

On ia64, this kmalloc() requires order-4 pages.  But this is not necessary to
be physically contiguous.  For big mem_cgroup, vmalloc is better.  For small
ones, kmalloc is used.

[akpm@linux-foundation.org: simplification]
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

diff -puN mm/memcontrol.c~use-vmalloc-for-mem_cgroup-allocation-v3 mm/memcontrol.c
--- a/mm/memcontrol.c~use-vmalloc-for-mem_cgroup-allocation-v3
+++ a/mm/memcontrol.c
@@ -31,6 +31,7 @@
 #include <linux/spinlock.h>
 #include <linux/fs.h>
 #include <linux/seq_file.h>
+#include <linux/vmalloc.h>
 
 #include <asm/uaccess.h>
 
@@ -983,6 +984,29 @@ static void free_mem_cgroup_per_zone_inf
 	kfree(mem->info.nodeinfo[node]);
 }
 
+static struct mem_cgroup *mem_cgroup_alloc(void)
+{
+	struct mem_cgroup *mem;
+
+	if (sizeof(*mem) < PAGE_SIZE)
+		mem = kmalloc(sizeof(*mem), GFP_KERNEL);
+	else
+		mem = vmalloc(sizeof(*mem));
+
+	if (mem)
+		memset(mem, 0, sizeof(*mem));
+	return mem;
+}
+
+static void mem_cgroup_free(struct mem_cgroup *mem)
+{
+	if (sizeof(*mem) < PAGE_SIZE)
+		kfree(mem);
+	else
+		vfree(mem);
+}
+
+
 static struct cgroup_subsys_state *
 mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
 {
@@ -993,12 +1017,11 @@ mem_cgroup_create(struct cgroup_subsys *
 		mem = &init_mem_cgroup;
 		page_cgroup_cache = KMEM_CACHE(page_cgroup, SLAB_PANIC);
 	} else {
-		mem = kzalloc(sizeof(struct mem_cgroup), GFP_KERNEL);
+		mem = mem_cgroup_alloc();
+		if (!mem)
+			return ERR_PTR(-ENOMEM);
 	}
 
-	if (mem == NULL)
-		return ERR_PTR(-ENOMEM);
-
 	res_counter_init(&mem->res);
 
 	memset(&mem->info, 0, sizeof(mem->info));
@@ -1012,7 +1035,7 @@ free_out:
 	for_each_node_state(node, N_POSSIBLE)
 		free_mem_cgroup_per_zone_info(mem, node);
 	if (cont->parent != NULL)
-		kfree(mem);
+		mem_cgroup_free(mem);
 	return ERR_PTR(-ENOMEM);
 }
 
@@ -1032,7 +1055,7 @@ static void mem_cgroup_destroy(struct cg
 	for_each_node_state(node, N_POSSIBLE)
 		free_mem_cgroup_per_zone_info(mem, node);
 
-	kfree(mem_cgroup_from_cont(cont));
+	mem_cgroup_free(mem_cgroup_from_cont(cont));
 }
 
 static int mem_cgroup_populate(struct cgroup_subsys *ss,
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
disable-the-memory-controller-by-default-v3.patch
proc-pagetypeinfo-fix-output-for-memoryless-nodes.patch

