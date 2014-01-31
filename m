From: akpm@linux-foundation.org
Subject: [merged]
 memcg-fix-mutex-not-unlocked-on-memcg_create_kmem_cache-fail-path.patch
 removed from -mm tree
Date: Fri, 31 Jan 2014 11:16:46 -0800
Message-ID: <52ebf69e.TzMrgtbyU3PKSbkH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50671 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932651AbaAaTQr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Jan 2014 14:16:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, mhocko@suse.cz, hannes@cmpxchg.org, glommer@parallels.com, vdavydov@parallels.com

Subject: [merged] memcg-fix-mutex-not-unlocked-on-memcg_create_kmem_cache-fail-path.patch removed from -mm tree
To: vdavydov@parallels.com,glommer@parallels.com,hannes@cmpxchg.org,mhocko@suse.cz,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 31 Jan 2014 11:16:46 -0800


The patch titled
     Subject: memcg: fix mutex not unlocked on memcg_create_kmem_cache fail path
has been removed from the -mm tree.  Its filename was
     memcg-fix-mutex-not-unlocked-on-memcg_create_kmem_cache-fail-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: fix mutex not unlocked on memcg_create_kmem_cache fail path

Commit 842e2873697e ("memcg: get rid of kmem_cache_dup()") introduced a
mutex for memcg_create_kmem_cache() to protect the tmp_name buffer that
holds the memcg name.  It failed to unlock the mutex if this buffer could
not be allocated.

This patch fixes the issue by appropriately unlocking the mutex if the
allocation fails.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Glauber Costa <glommer@parallels.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-mutex-not-unlocked-on-memcg_create_kmem_cache-fail-path mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-mutex-not-unlocked-on-memcg_create_kmem_cache-fail-path
+++ a/mm/memcontrol.c
@@ -3400,7 +3400,7 @@ void mem_cgroup_destroy_cache(struct kme
 static struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
 						  struct kmem_cache *s)
 {
-	struct kmem_cache *new;
+	struct kmem_cache *new = NULL;
 	static char *tmp_name = NULL;
 	static DEFINE_MUTEX(mutex);	/* protects tmp_name */
 
@@ -3416,7 +3416,7 @@ static struct kmem_cache *memcg_create_k
 	if (!tmp_name) {
 		tmp_name = kmalloc(PATH_MAX, GFP_KERNEL);
 		if (!tmp_name)
-			return NULL;
+			goto out;
 	}
 
 	rcu_read_lock();
@@ -3426,12 +3426,11 @@ static struct kmem_cache *memcg_create_k
 
 	new = kmem_cache_create_memcg(memcg, tmp_name, s->object_size, s->align,
 				      (s->flags & ~SLAB_PANIC), s->ctor, s);
-
 	if (new)
 		new->allocflags |= __GFP_KMEMCG;
 	else
 		new = s;
