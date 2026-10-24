Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832541;
	b=TLeHPjZaaCmIF7JIjec+Rn4kTPoswOejc9Iu/IWs61M9K6A7RvLQXrRRR3+B02Cqiz/V
	 SA0uadZgwye5DrPRtff/vEP2H/WWKVCiHKjervHMeQHTysOTjjybq9F7E+HaxkbbvKvj4
	 h2dDL13mm88D8ouCE3fjEag46DKQVnn/r8JKPxHKu50l5EcyR6K6k5gOgtJDIXZCAwThL
	 LPc/B2hI7Syp7o3QuaL54eNRrqbdSzHoSvVldllj5y4Ni6JAnWKVQDmxx/9PM3Gs2qGDR
	 YcgugubwqbAl0PtPk+4qiygPqCUk33CzPu0/XPFaXVGGWzF47JUMlFbMfmwCzgkP/4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832541;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=GVCfXSeVZmIyXsQvIvtFHjuV1QlKCPbAry5HsxR7ngs=;
	b=f7idAHVZ26HUMiwxfqgsUxyFSm3JjcY/Zs+pL2VILtNq8zFaHh5nU33nN1knodrqIk/R
	 2d/UGTYL1KCNJMyW6uOgSNRc1VrrunyEFtnRNDJ7Hu2xrhKNDqaeur9KHOfzN2g0u3aVz
	 wDGkj2P7qAul+EpvHQo4JowSxmP8NrCSkbx5BJUVTNNF+KbhDpJ+uO7Y9fO52sPbMt/+J
	 90DJ4lmH50VopF7UI9qVKEjlPspM2DZujZ+tr8ISQX4hV576UIMBjHGmR3uQPVyL4kcKR
	 KBFAAozed1q7HmhmArcoRCCg2lj6PDbcoVyVwrnlvKnVRgDKEzhl3elCX4UKJc14DMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=nbmsCN9V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B24606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=nbmsCN9V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C431F01825;
	Sat, 24 Oct 2026 09:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832541;
	bh=GVCfXSeVZmIyXsQvIvtFHjuV1QlKCPbAry5HsxR7ngs=;
	h=Date:To:From:Subject;
	b=nbmsCN9Vjf1Mg/rrNSf1/c9NZAspx5/drvybAwF8TQdJ2fojnEIgwjzNgvWWZersv
	 N+0QTH6uZvVa2NR/gyMHSqWRzLFawTF8R8L2VeQoJtrwQ8I5fDAoM6OFU46FGXmg7f
	 zJmjZES6FtsZvl9AlHOtOdtOZlqbJiN1wjBUSRpY=
Date: Sat, 24 Oct 2026 02:02:20 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,qi.zheng@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,harry@kernel.org,hannes@cmpxchg.org,david@fromorbit.com,akpm@linux-foundation.org,khorenko@virtuozzo.com
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shrinker-allocate-shrinker_info_unit-from-a-dedicated-kmem_cache.patch removed from -mm tree
Message-Id: <20261024090220.F3C431F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/shrinker: allocate shrinker_info_unit from a dedicated kmem_cache
has been removed from the -mm tree.  Its filename was
     mm-shrinker-allocate-shrinker_info_unit-from-a-dedicated-kmem_cache.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Subject: mm/shrinker: allocate shrinker_info_unit from a dedicated kmem_cache
Date: Mon, 19 Oct 2026 18:11:44 +0200

shrinker_info_unit holds BITS_PER_LONG atomic_long_t of deferred work plus
a one-word bitmap, 520 bytes on 64-bit.  kzalloc_node() takes it from
kmalloc-1k, so almost half of every unit is padding.

Allocate the units from a cache of their own, sized to the unit.  The
cache is not cache-line aligned: the counters of a unit already share
cache lines between shrinkers, and aligning the unit would only keep
neighbouring units off each other's boundary line, at the cost of part of
the saving.

Link: https://lore.kernel.org/20261019-vstor-144715-shrinker_info_unit-kmem_cache-v3-1-0fb061e09bf4@virtuozzo.com
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: Muchun Song <muchun.song@linux.dev>
Assisted-by: LLM
Cc: Dave Chinner <david@fromorbit.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
---

 include/linux/memcontrol.h |    1 +
 mm/memcontrol.c            |    2 ++
 mm/shrinker.c              |   11 +++++++++--
 3 files changed, 12 insertions(+), 2 deletions(-)

--- a/include/linux/memcontrol.h~mm-shrinker-allocate-shrinker_info_unit-from-a-dedicated-kmem_cache
+++ a/include/linux/memcontrol.h
@@ -1717,6 +1717,7 @@ static inline u64 mem_cgroup_get_socket_
 }
 #endif
 
+void shrinker_unit_cache_init(void);
 int alloc_shrinker_info(struct mem_cgroup *memcg);
 void free_shrinker_info(struct mem_cgroup *memcg);
 void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id);
--- a/mm/memcontrol.c~mm-shrinker-allocate-shrinker_info_unit-from-a-dedicated-kmem_cache
+++ a/mm/memcontrol.c
@@ -5984,6 +5984,8 @@ int __init mem_cgroup_init(void)
 	memcg_pn_cachep = KMEM_CACHE(mem_cgroup_per_node,
 				     SLAB_PANIC | SLAB_HWCACHE_ALIGN);
 
+	shrinker_unit_cache_init();
+
 	return 0;
 }
 
--- a/mm/shrinker.c~mm-shrinker-allocate-shrinker_info_unit-from-a-dedicated-kmem_cache
+++ a/mm/shrinker.c
@@ -12,6 +12,12 @@ DEFINE_MUTEX(shrinker_mutex);
 
 #ifdef CONFIG_MEMCG
 static int shrinker_nr_max;
+static struct kmem_cache *shrinker_unit_cachep;
+
+void __init shrinker_unit_cache_init(void)
+{
+	shrinker_unit_cachep = KMEM_CACHE(shrinker_info_unit, SLAB_PANIC);
+}
 
 static inline int shrinker_unit_size(int nr_items)
 {
@@ -33,7 +39,7 @@ static inline void shrinker_unit_free(st
 		if (!unit[i])
 			break;
 
-		kfree(unit[i]);
+		kmem_cache_free(shrinker_unit_cachep, unit[i]);
 		unit[i] = NULL;
 	}
 }
@@ -47,7 +53,8 @@ static inline int shrinker_unit_alloc(st
 	int i;
 
 	for (i = start; i < nr; i++) {
-		unit = kzalloc_node(sizeof(*unit), GFP_KERNEL, nid);
+		unit = kmem_cache_alloc_node(shrinker_unit_cachep,
+					     GFP_KERNEL | __GFP_ZERO, nid);
 		if (!unit) {
 			shrinker_unit_free(new, start);
 			return -ENOMEM;
_

Patches currently in -mm which might be from khorenko@virtuozzo.com are


