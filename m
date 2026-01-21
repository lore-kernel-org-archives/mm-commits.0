Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D8F35CB97
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966061; cv=none; b=Ec1yFqKVZgQvRETl6QKLXArkrJeDAXMOALvgrviJQPnYHyaWH0xEDGf2eIuCFftmAgpbQh6H4E9N4k9S9myVrVTzdZ50oR5l1cQPI6NfIio8/BlnToty/USIUYPoN2PHL3FlxgzUo9RJFn6XLYbvGiEBvGHCU/CTTk7K5+mhWWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966061; c=relaxed/simple;
	bh=kAkk8l/VFqBJrkIMa7UUBgEqOBHpC3XowMZak7kifDk=;
	h=Date:To:From:Subject:Message-Id; b=k2MWhmQSmIu+PnC29UmA9DQuFKVMi0/7I31CmzdrTxjJfB2SKKzwyVxH5uZo9YLBFQMscPwKHrCHFgcN0rh7zJ0ddaKTkdsJoMJCyZTzk0r7twwQ8iLAn1cHrQv8W/xllMIV9MNJZkPl/bAb6VOvyntZZMug55iGkV9V9bJt8Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TnEf4Orb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TnEf4Orb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68F48C16AAE;
	Wed, 21 Jan 2026 03:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966060;
	bh=kAkk8l/VFqBJrkIMa7UUBgEqOBHpC3XowMZak7kifDk=;
	h=Date:To:From:Subject:From;
	b=TnEf4OrbICHN96QuRKph9ACAWbSALWpC1GXhZRl4ie0oXcLxVvBWepgLwU+4qMCKd
	 EwBdoGG/dy1jep9x1bdTdphRy0Cz82kFe9ud+g2nZ/bf4wYnsw2fdDebIO1yziHb2K
	 sfTHmJfqCyskMSlAF+c0ao7wFg1hWUwh0KQv4Q2U=
Date: Tue, 20 Jan 2026 19:27:39 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,anshuman.khandual@arm.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-rename-mem_cgroup_from_slab_obj.patch removed from -mm tree
Message-Id: <20260121032740.68F48C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcontrol: rename mem_cgroup_from_slab_obj()
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-rename-mem_cgroup_from_slab_obj.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: rename mem_cgroup_from_slab_obj()
Date: Wed, 10 Dec 2025 10:43:01 -0500

In addition to slab objects, this function is used for resolving non-slab
kernel pointers.  This has caused confusion in recent refactoring work. 
Rename it to mem_cgroup_from_virt(), sticking with terminology established
by the virt_to_<foo>() converters.

Link: https://lore.kernel.org/linux-mm/20251113161424.GB3465062@cmpxchg.org/
Link: https://lkml.kernel.org/r/20251210154301.720133-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 mm/list_lru.c              |    4 ++--
 mm/memcontrol.c            |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-rename-mem_cgroup_from_slab_obj
+++ a/include/linux/memcontrol.h
@@ -1723,7 +1723,7 @@ static inline int memcg_kmem_id(struct m
 	return memcg ? memcg->kmemcg_id : -1;
 }
 
-struct mem_cgroup *mem_cgroup_from_slab_obj(void *p);
+struct mem_cgroup *mem_cgroup_from_virt(void *p);
 
 static inline void count_objcg_events(struct obj_cgroup *objcg,
 				      enum vm_event_item idx,
@@ -1795,7 +1795,7 @@ static inline int memcg_kmem_id(struct m
 	return -1;
 }
 
-static inline struct mem_cgroup *mem_cgroup_from_slab_obj(void *p)
+static inline struct mem_cgroup *mem_cgroup_from_virt(void *p)
 {
 	return NULL;
 }
--- a/mm/list_lru.c~mm-memcontrol-rename-mem_cgroup_from_slab_obj
+++ a/mm/list_lru.c
@@ -187,7 +187,7 @@ bool list_lru_add_obj(struct list_lru *l
 
 	if (list_lru_memcg_aware(lru)) {
 		rcu_read_lock();
-		ret = list_lru_add(lru, item, nid, mem_cgroup_from_slab_obj(item));
+		ret = list_lru_add(lru, item, nid, mem_cgroup_from_virt(item));
 		rcu_read_unlock();
 	} else {
 		ret = list_lru_add(lru, item, nid, NULL);
@@ -224,7 +224,7 @@ bool list_lru_del_obj(struct list_lru *l
 
 	if (list_lru_memcg_aware(lru)) {
 		rcu_read_lock();
-		ret = list_lru_del(lru, item, nid, mem_cgroup_from_slab_obj(item));
+		ret = list_lru_del(lru, item, nid, mem_cgroup_from_virt(item));
 		rcu_read_unlock();
 	} else {
 		ret = list_lru_del(lru, item, nid, NULL);
--- a/mm/memcontrol.c~mm-memcontrol-rename-mem_cgroup_from_slab_obj
+++ a/mm/memcontrol.c
@@ -806,7 +806,7 @@ void mod_lruvec_kmem_state(void *p, enum
 	struct lruvec *lruvec;
 
 	rcu_read_lock();
-	memcg = mem_cgroup_from_slab_obj(p);
+	memcg = mem_cgroup_from_virt(p);
 
 	/*
 	 * Untracked pages have no memcg, no lruvec. Update only the
@@ -2614,7 +2614,7 @@ struct mem_cgroup *mem_cgroup_from_obj_s
  * The caller must ensure the memcg lifetime, e.g. by taking rcu_read_lock(),
  * cgroup_mutex, etc.
  */
-struct mem_cgroup *mem_cgroup_from_slab_obj(void *p)
+struct mem_cgroup *mem_cgroup_from_virt(void *p)
 {
 	struct slab *slab;
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


