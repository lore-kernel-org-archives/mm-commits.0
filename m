From: akpm@linux-foundation.org
Subject: + memcg-avoid-accessing-memcg-after-releasing-reference.patch added to -mm tree
Date: Tue, 16 Apr 2013 15:58:06 -0700
Message-ID: <20130416225806.84FDB5A4145@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:32780 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965533Ab3DPW6J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Apr 2013 18:58:09 -0400
Received: by mail-ve0-f201.google.com with SMTP id jz10so105243veb.4
        for <mm-commits@vger.kernel.org>; Tue, 16 Apr 2013 15:58:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizefan@huawei.com, glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: memcg: avoid accessing memcg after releasing reference
has been added to the -mm tree.  Its filename is
     memcg-avoid-accessing-memcg-after-releasing-reference.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
memcg-keep-prevs-css-alive-for-the-whole-mem_cgroup_iter.patch
memcg-rework-mem_cgroup_iter-to-use-cgroup-iterators.patch
memcg-relax-memcg-iter-caching.patch
memcg-simplify-mem_cgroup_iter.patch
memcg-further-simplify-mem_cgroup_iter.patch
cgroup-remove-css_get_next.patch
kernel-cpusetc-use-register_hotmemory_notifier.patch
memcg-avoid-accessing-memcg-after-releasing-reference.patch
exec-do-not-abuse-cred_guard_mutex-in-threadgroup_lock.patch

