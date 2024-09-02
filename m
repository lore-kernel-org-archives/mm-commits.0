Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA31C3EA76
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247670; cv=none; b=tzrju6t05ZNqSEUxRuYGSpgpW9wuwHoC4QntC9HOUoZbmni7V0UIwKWHGGkv5unzcKbsRx3udFB4TYlk7ApFXq3pk5N2/fOip9b1G52BSkiSf8kMD5KphS6d9VScfBRAKe8wTuvxRigmYdNnantaFZZX+GGmNitmo+SfNKUCOfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247670; c=relaxed/simple;
	bh=ys5cSgPBBXyfZP9OMkYukfo/os7wq71O6HjPooFwB8k=;
	h=Date:To:From:Subject:Message-Id; b=ohSmpazk260MIdr7Xyk4pFN0UnRNFINeR9r7Rut8/a9h2qiH2pUTq7iWECU2SH8IesSl2b+Bsp85vIKPEPC2qYs3a8TOroBLnhMOGQLHLF5tR/SOJKB6ZBBnz5DggX23ywiIcCsbgcp6BuDAltSE8772Kc0NNpgnVWBmDdOGVB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JAekzGTa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JAekzGTa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1097C4CEC2;
	Mon,  2 Sep 2024 03:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247670;
	bh=ys5cSgPBBXyfZP9OMkYukfo/os7wq71O6HjPooFwB8k=;
	h=Date:To:From:Subject:From;
	b=JAekzGTaB3KgcrGG41wkaAs4DteZt5wm8rzJPee7UsKyruO0SLHwyPDz1eWyS0m+L
	 wg8lAavlI1iY5OhTkV4zzNzhWoK46Qg+h9twGPmFqATdM7hH9cDBZMNnUCnRXUuQuU
	 KlhYxnJgON9zeEctmV+23dVEub3trIsMZ+VY54vo=
Date: Sun, 01 Sep 2024 20:27:50 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmem-remove-mem_cgroup_from_obj.patch removed from -mm tree
Message-Id: <20240902032750.A1097C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: kmem: remove mem_cgroup_from_obj()
has been removed from the -mm tree.  Its filename was
     mm-kmem-remove-mem_cgroup_from_obj.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: kmem: remove mem_cgroup_from_obj()
Date: Thu, 18 Jul 2024 17:18:21 +0800

There is no user of mem_cgroup_from_obj(), remove it.

Link: https://lkml.kernel.org/r/20240718091821.44740-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 ------
 mm/memcontrol.c            |   32 +-------------------------------
 2 files changed, 1 insertion(+), 37 deletions(-)

--- a/include/linux/memcontrol.h~mm-kmem-remove-mem_cgroup_from_obj
+++ a/include/linux/memcontrol.h
@@ -1717,7 +1717,6 @@ static inline int memcg_kmem_id(struct m
 	return memcg ? memcg->kmemcg_id : -1;
 }
 
-struct mem_cgroup *mem_cgroup_from_obj(void *p);
 struct mem_cgroup *mem_cgroup_from_slab_obj(void *p);
 
 static inline void count_objcg_event(struct obj_cgroup *objcg,
@@ -1780,11 +1779,6 @@ static inline int memcg_kmem_id(struct m
 	return -1;
 }
 
-static inline struct mem_cgroup *mem_cgroup_from_obj(void *p)
-{
-	return NULL;
-}
-
 static inline struct mem_cgroup *mem_cgroup_from_slab_obj(void *p)
 {
 	return NULL;
--- a/mm/memcontrol.c~mm-kmem-remove-mem_cgroup_from_obj
+++ a/mm/memcontrol.c
@@ -2446,37 +2446,7 @@ struct mem_cgroup *mem_cgroup_from_obj_f
 
 /*
  * Returns a pointer to the memory cgroup to which the kernel object is charged.
- *
- * A passed kernel object can be a slab object, vmalloc object or a generic
- * kernel page, so different mechanisms for getting the memory cgroup pointer
- * should be used.
- *
- * In certain cases (e.g. kernel stacks or large kmallocs with SLUB) the caller
- * can not know for sure how the kernel object is implemented.
- * mem_cgroup_from_obj() can be safely used in such cases.
- *
- * The caller must ensure the memcg lifetime, e.g. by taking rcu_read_lock(),
- * cgroup_mutex, etc.
- */
-struct mem_cgroup *mem_cgroup_from_obj(void *p)
-{
-	struct folio *folio;
-
-	if (mem_cgroup_disabled())
-		return NULL;
-
-	if (unlikely(is_vmalloc_addr(p)))
-		folio = page_folio(vmalloc_to_page(p));
-	else
-		folio = virt_to_folio(p);
-
-	return mem_cgroup_from_obj_folio(folio, p);
-}
-
-/*
- * Returns a pointer to the memory cgroup to which the kernel object is charged.
- * Similar to mem_cgroup_from_obj(), but faster and not suitable for objects,
- * allocated using vmalloc().
+ * It is not suitable for objects allocated using vmalloc().
  *
  * A passed kernel object must be a slab object or a generic kernel page.
  *
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


