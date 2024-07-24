Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE18F2F52
	for <mm-commits@vger.kernel.org>; Wed, 24 Jul 2024 00:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721781521; cv=none; b=mEDTpBerFEiD7mBl7QUGwtW31EtTr80yqjdwWV/olkJ6I6VeRXxr8xu0YYtJ5GS0cmtNxQOhL3zB/Gw7H+AmlErcx6Dj841mzShl/WsFKslatxxCkAjmmVhPu/MsDRUG7Iutg5kFaxVQbiJsBH6oxTLIOPj6FkRomLtcgkKI+oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721781521; c=relaxed/simple;
	bh=MZsC9M7sIzFj5xU8L95zxDj6LtI3phcGmcaqJzidTAo=;
	h=Date:To:From:Subject:Message-Id; b=rrh5l5VWaMSHFp1SdAgb9WgLAJ9aOYGxxnU4PqeQHF2JdAeOcbPgmndEgQSf9dyviYp3oD4T6wBSlIE4dRPdKfv141N/SdEEHG0U4YipmttXsCH2PJnG3lsDngHkFgfgo/MMGzQ9zDBK+8hyPbSVrYIXXhPcce+SKxdWAJr6wVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k54H97OX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k54H97OX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323B7C4AF09;
	Wed, 24 Jul 2024 00:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721781521;
	bh=MZsC9M7sIzFj5xU8L95zxDj6LtI3phcGmcaqJzidTAo=;
	h=Date:To:From:Subject:From;
	b=k54H97OX5aP7mpESWnfZ0JKQT1GAMBMQ+ixEzUaKTpjevqCuvdR9C2d7zq5Y1hR5Y
	 icnq+gD50JPL6PLQM3AWdRhC3D4wqBPqpBtNLWQbzw7iI6DlxIWmuz1x8/dSSnrg2X
	 l5/qlLCfXSq5yMNq74dqE3HE8gVogo5JgPJfbcdk=
Date: Tue, 23 Jul 2024 17:38:40 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmem-remove-mem_cgroup_from_obj.patch added to mm-unstable branch
Message-Id: <20240724003841.323B7C4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: kmem: remove mem_cgroup_from_obj()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmem-remove-mem_cgroup_from_obj.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmem-remove-mem_cgroup_from_obj.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-kmem-remove-mem_cgroup_from_obj.patch

