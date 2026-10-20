Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792468798;
	b=X1X1UyApC91ij89PawU8nelNFU+zA3ky8nHcuMsLvYyVphiPeu3ZoPd1j4FhEr/GRO9D
	 4IgLNZu8OzMKdrFCuJtvWT+Nqy+pzmH+tr72zdeksoRx8MECTcNzvVC1s/0KViv7j7YJc
	 EInGx7YlV+jYlOvS4Tmw/YOEYsjLWFPB4DG8rxb2CdfRtshJVOma1fKtVnCqrA3bSDXrc
	 IEVErmnQWc7xEh3jln2PlBcnyMNnx7Vdl0mHaCZWmHeItCio1RN1fxmpbs56fXZMydtoK
	 VX0yogK+oNAnB1F8/Y/e3dds47LvoaP6ZfiWbiseEsSXCLdqZucz0mBUVH19X5LTdsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792468798;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=AfHaj+8dQUnNrsK9DsOJBAg4EwTdzh6LAgCXiu28LxM=;
	b=Bkru6fRVhNdrk/MVNouCnRPOW3c9YOrZEK8xrlQvWrsIna08amNcvcaXTO/0LEQ3D+X1
	 iSbYNIQ/fAoPEMABzVVsTsYtsOwk0WYIUZbhdHLxmpTgBPxCZk1b806OxytwxKMNtCe7T
	 fxbNvIlQBD3inhvqDfGO8pOlCgDM3n667uPwODbM7dDsaLc7i7csc7FT7rmshISHDaf3E
	 Jw6peNFmm1frNikQq7Gb4ObMqIeFoth84FgWKnqo/gtodsYjKfWhqsHMZ25cWNuaF/KMq
	 4plwWABeidKR2T9u1spD3kaG+IoGdysHZDSZE37WI6QgaN+gaSmWceocL2Sx3mEUzuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qeh3W2gG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81037606A319
	for <mm-commits@vger.kernel.org>; Tue, 20 Oct 2026 03:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qeh3W2gG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D661F000C4;
	Tue, 20 Oct 2026 03:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792468797;
	bh=AfHaj+8dQUnNrsK9DsOJBAg4EwTdzh6LAgCXiu28LxM=;
	h=Date:To:From:Subject;
	b=qeh3W2gG+jlI9XRGZkcrCqITSGiXPsNq3VYKd8KBust8dA/0q9he26L1P1Azhqxen
	 cxzy/N2HsGfdopT6WkLqd1GgdVO0+WztEOyxtgBZLzim9oI6+P998bqNNpsyzDjTjU
	 EUPOOIHAS21NcJAiyLCdjMmmcRAG45hdRf26URgs=
Date: Mon, 19 Oct 2026 20:59:56 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,qi.zheng@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,harry@kernel.org,hannes@cmpxchg.org,david@fromorbit.com,akpm@linux-foundation.org,khorenko@virtuozzo.com
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shrinker-allocate-shrinker_info_unit-from-a-dedicated-kmem_cache.patch added to mm-unstable branch
Message-Id: <20261020035956.E5D661F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/shrinker: allocate shrinker_info_unit from a dedicated kmem_cache
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shrinker-allocate-shrinker_info_unit-from-a-dedicated-kmem_cache.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shrinker-allocate-shrinker_info_unit-from-a-dedicated-kmem_cache.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-shrinker-allocate-shrinker_info_unit-from-a-dedicated-kmem_cache.patch

