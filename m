From: akpm@linux-foundation.org
Subject: [merged] memcg-avoid-accessing-memcg-after-releasing-reference.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:49:57 -0700
Message-ID: <20130430184957.83D175A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:48821 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758617Ab3D3St7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:49:59 -0400
Received: by mail-qe0-f74.google.com with SMTP id a11so85609qen.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:49:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizefan@huawei.com, glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: avoid accessing memcg after releasing reference
has been removed from the -mm tree.  Its filename was
     memcg-avoid-accessing-memcg-after-releasing-reference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Li Zefan <lizefan@huawei.com>
Subject: memcg: avoid accessing memcg after releasing reference

This might cause a use-after-free bug.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Cc: Glauber Costa <glommer@parallels.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-avoid-accessing-memcg-after-releasing-reference mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-avoid-accessing-memcg-after-releasing-reference
+++ a/mm/memcontrol.c
@@ -3215,12 +3215,12 @@ void memcg_release_cache(struct kmem_cac
 
 	root = s->memcg_params->root_cache;
 	root->memcg_params->memcg_caches[id] = NULL;
-	mem_cgroup_put(memcg);
 
 	mutex_lock(&memcg->slab_caches_mutex);
 	list_del(&s->memcg_params->list);
 	mutex_unlock(&memcg->slab_caches_mutex);
 
+	mem_cgroup_put(memcg);
 out:
 	kfree(s->memcg_params);
 }
_

Patches currently in -mm which might be from lizefan@huawei.com are

origin.patch
linux-next.patch
exec-do-not-abuse-cred_guard_mutex-in-threadgroup_lock.patch

