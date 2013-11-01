From: akpm@linux-foundation.org
Subject: + memcg-kmem-use-cache_from_memcg_idx-instead-of-hard-code.patch
 added to -mm tree
Date: Fri, 01 Nov 2013 13:12:18 -0700
Message-ID: <52740b22.q9GuKSv0tQs8WMpB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53642 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab3KAUMT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Nov 2013 16:12:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, penberg@kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, glommer@parallels.com, h.huangqiang@huawei.com

Subject: + memcg-kmem-use-cache_from_memcg_idx-instead-of-hard-code.patch added to -mm tree
To: h.huangqiang@huawei.com,glommer@parallels.com,hannes@cmpxchg.org,mhocko@suse.cz,penberg@kernel.org,rientjes@google.com
From: akpm@linux-foundation.org
Date: Fri, 01 Nov 2013 13:12:18 -0700


The patch titled
     Subject: memcg, kmem: use cache_from_memcg_idx instead of hard code
has been added to the -mm tree.  Its filename is
     memcg-kmem-use-cache_from_memcg_idx-instead-of-hard-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-kmem-use-cache_from_memcg_idx-instead-of-hard-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-kmem-use-cache_from_memcg_idx-instead-of-hard-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Qiang Huang <h.huangqiang@huawei.com>
Subject: memcg, kmem: use cache_from_memcg_idx instead of hard code

Signed-off-by: Qiang Huang <h.huangqiang@huawei.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/memcontrol.c~memcg-kmem-use-cache_from_memcg_idx-instead-of-hard-code mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-kmem-use-cache_from_memcg_idx-instead-of-hard-code
+++ a/mm/memcontrol.c
@@ -2956,7 +2956,7 @@ static struct kmem_cache *memcg_params_t
 
 	VM_BUG_ON(p->is_root_cache);
 	cachep = p->root_cache;
-	return cachep->memcg_params->memcg_caches[memcg_cache_id(p->memcg)];
+	return cache_from_memcg_idx(cachep, memcg_cache_id(p->memcg));
 }
 
 #ifdef CONFIG_SLABINFO
@@ -3393,7 +3393,7 @@ static struct kmem_cache *memcg_create_k
 	idx = memcg_cache_id(memcg);
 
 	mutex_lock(&memcg_cache_mutex);
-	new_cachep = cachep->memcg_params->memcg_caches[idx];
+	new_cachep = cache_from_memcg_idx(cachep, idx);
 	if (new_cachep) {
 		css_put(&memcg->css);
 		goto out;
@@ -3439,8 +3439,8 @@ void kmem_cache_destroy_memcg_children(s
 	 * we'll take the set_limit_mutex to protect ourselves against this.
 	 */
 	mutex_lock(&set_limit_mutex);
-	for (i = 0; i < memcg_limited_groups_array_size; i++) {
-		c = s->memcg_params->memcg_caches[i];
+	for_each_memcg_cache_index(i) {
+		c = cache_from_memcg_idx(s, i);
 		if (!c)
 			continue;
 
@@ -3573,8 +3573,8 @@ struct kmem_cache *__memcg_kmem_get_cach
 	 * code updating memcg_caches will issue a write barrier to match this.
 	 */
 	read_barrier_depends();
-	if (likely(cachep->memcg_params->memcg_caches[idx])) {
-		cachep = cachep->memcg_params->memcg_caches[idx];
+	if (likely(cache_from_memcg_idx(cachep, idx))) {
+		cachep = cache_from_memcg_idx(cachep, idx);
 		goto out;
 	}
 
_

Patches currently in -mm which might be from h.huangqiang@huawei.com are

mm-add-a-helper-function-to-check-may-oom-condition.patch
memcg-kmem-use-is_root_cache-instead-of-hard-code.patch
memcg-kmem-rename-cache_from_memcg-to-cache_from_memcg_idx.patch
memcg-kmem-use-cache_from_memcg_idx-instead-of-hard-code.patch

