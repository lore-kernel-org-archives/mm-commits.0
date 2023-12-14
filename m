Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF4241776
	for <mm-commits@vger.kernel.org>; Thu, 14 Dec 2023 15:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oFhVlx//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3539BC433C7;
	Thu, 14 Dec 2023 15:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702568135;
	bh=eff+/1ZAyk88zbVDs0M2oet/cL99SldSd4wp6FUIvTI=;
	h=Date:To:From:Subject:From;
	b=oFhVlx//TYZttrIq20eQjZ98lkPzc96dKlrEgl+Q8RLXFnRFgbsqWO990EZmjewnq
	 f/CFcfKjRKzXJulN2uYIcJeSQx1vIQADoL815pRTg1sjCFwiZBrnAb/jCeFC3nz+l6
	 dBarPuM4MTivuwXpErRVDJqLymULh16cGR2Qjon8=
Date: Thu, 14 Dec 2023 07:35:34 -0800
To: mm-commits@vger.kernel.org,nphamcs@gmail.com,lkp@intel.com,hannes@cmpxchg.org,bagasdotme@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-list_lruc-remove-unused-list_lru_from_kmem.patch added to mm-unstable branch
Message-Id: <20231214153535.3539BC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/list_lru.c: remove unused list_lru_from_kmem()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-list_lruc-remove-unused-list_lru_from_kmem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-list_lruc-remove-unused-list_lru_from_kmem.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/list_lru.c: remove unused list_lru_from_kmem()
Date: Thu Dec 14 07:32:58 AM PST 2023

Fixes: 0a97c01cd20bb ("list_lru: allow explicit memcg and NUMA node selection)
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202312141318.q8b5yrAq-lkp@intel.com/
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |   31 -------------------------------
 1 file changed, 31 deletions(-)

--- a/mm/list_lru.c~mm-list_lruc-remove-unused-list_lru_from_kmem
+++ a/mm/list_lru.c
@@ -59,28 +59,6 @@ list_lru_from_memcg_idx(struct list_lru
 	}
 	return &lru->node[nid].lru;
 }
-
-static inline struct list_lru_one *
-list_lru_from_kmem(struct list_lru *lru, int nid, void *ptr,
-		   struct mem_cgroup **memcg_ptr)
-{
-	struct list_lru_node *nlru = &lru->node[nid];
-	struct list_lru_one *l = &nlru->lru;
-	struct mem_cgroup *memcg = NULL;
-
-	if (!list_lru_memcg_aware(lru))
-		goto out;
-
-	memcg = mem_cgroup_from_slab_obj(ptr);
-	if (!memcg)
-		goto out;
-
-	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(memcg));
-out:
-	if (memcg_ptr)
-		*memcg_ptr = memcg;
-	return l;
-}
 #else
 static void list_lru_register(struct list_lru *lru)
 {
@@ -105,15 +83,6 @@ list_lru_from_memcg_idx(struct list_lru
 {
 	return &lru->node[nid].lru;
 }
-
-static inline struct list_lru_one *
-list_lru_from_kmem(struct list_lru *lru, int nid, void *ptr,
-		   struct mem_cgroup **memcg_ptr)
-{
-	if (memcg_ptr)
-		*memcg_ptr = NULL;
-	return &lru->node[nid].lru;
-}
 #endif /* CONFIG_MEMCG_KMEM */
 
 bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-maple_treec-fix-build-error-due-to-hotfix-alteration.patch
mm-list_lruc-remove-unused-list_lru_from_kmem.patch
mm-memcg-restore-subtree-stats-flushing-fix.patch

