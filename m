Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1B21494A8
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 03:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765855398; cv=none; b=cUnFRuzsipzj/kCcNXNF+/avhI9qdSF/Pmk5uk/yTfwC59xEbLs695HrCAcsizFEB7OP6T/PCdikCEUSQ16yeXGASfhWKT9vwLpJ0Y2aRuuI72oQjPTukDwwtxoBm8wjRXmWr02TlL07kIuHsoXyqc8NSb9ryp1E4on8HzkGy1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765855398; c=relaxed/simple;
	bh=SUTSqUxv1UdD6ZQyCKGHZnGeQl9+JI+YJvwzSwVJgko=;
	h=Date:To:From:Subject:Message-Id; b=miYZ1yQ0wVH/6NtGkyLsSDTjHxUZqTT1WPpdlShvrVnPRfISCgTD/iOUTJA66jC4O6Gc+sLmjqah+1W5pCsm5PT70K/e+vnCJwmiGE8C8QUyj+iR7nMM5WBV2rN2AnjBESZs7RjK0u6NO9EJCY/+sZVK7JQ4X8nMnXZIfAdLsFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xmN04kIk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xmN04kIk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E67C4CEF5;
	Tue, 16 Dec 2025 03:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765855398;
	bh=SUTSqUxv1UdD6ZQyCKGHZnGeQl9+JI+YJvwzSwVJgko=;
	h=Date:To:From:Subject:From;
	b=xmN04kIkhZoqzidAqfbQrXYX7RAESrQuJW3Je4blSuWLyzmkpyARQoFIWSw6JejwJ
	 8veuTY9/kj7U/n2+wzt5pGkXQrTivdxvS67+W5M4TEpfEDY0OWFbinha140oxbOr3S
	 Wp4kPPaAJqzMTKJrUPEccqgS3vTMQZk1KlizZYx4=
Date: Mon, 15 Dec 2025 19:23:17 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,anshuman.khandual@arm.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-rename-mem_cgroup_from_slab_obj.patch added to mm-new branch
Message-Id: <20251216032317.E7E67C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcontrol: rename mem_cgroup_from_slab_obj()
has been added to the -mm mm-new branch.  Its filename is
     mm-memcontrol-rename-mem_cgroup_from_slab_obj.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-rename-mem_cgroup_from_slab_obj.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-zswap-delete-unused-acomp-is_sleepable.patch
mm-memcontrol-rename-mem_cgroup_from_slab_obj.patch

