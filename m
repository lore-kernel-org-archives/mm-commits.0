From: akpm@linux-foundation.org
Subject: - memcgroup-return-negative-error-code-in-mem_cgroup_create.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:46:08 -0800
Message-ID: <200802250046.m1P0k80R006318@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53523 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754724AbYBYAsy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:48:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcgroup: return negative error code in mem_cgroup_create()
has been removed from the -mm tree.  Its filename was
     memcgroup-return-negative-error-code-in-mem_cgroup_create.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcgroup: return negative error code in mem_cgroup_create()
From: Li Zefan <lizf@cn.fujitsu.com>

Cgroup requires the subsystem to return negative error code on error in the
create method.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcgroup-return-negative-error-code-in-mem_cgroup_create mm/memcontrol.c
--- a/mm/memcontrol.c~memcgroup-return-negative-error-code-in-mem_cgroup_create
+++ a/mm/memcontrol.c
@@ -1100,7 +1100,7 @@ mem_cgroup_create(struct cgroup_subsys *
 		mem = kzalloc(sizeof(struct mem_cgroup), GFP_KERNEL);
 
 	if (mem == NULL)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	res_counter_init(&mem->res);
 
@@ -1116,7 +1116,7 @@ free_out:
 		free_mem_cgroup_per_zone_info(mem, node);
 	if (cont->parent != NULL)
 		kfree(mem);
-	return NULL;
+	return ERR_PTR(-ENOMEM);
 }
 
 static void mem_cgroup_pre_destroy(struct cgroup_subsys *ss,
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are
