Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74C123D2
	for <mm-commits@vger.kernel.org>; Fri, 24 May 2024 02:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716518848; cv=none; b=lLeQlO1aXwozusLIzGd6UC438iIE9XhhoL5Jy4alVjlX92YVji6VHR0bFgncEjPE0Feo3bE+T4M5hUMltfFtiiqdjiRbOnOYvfbAK0S3FLNFBeJ8BMSzZo4rMEVYBi3SGP2ZGYC23f5VfBvcZWlpOk+sn0ilzDGkzVRxdWqtUm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716518848; c=relaxed/simple;
	bh=kHYR3dof7HlnHqxtwFgY1m8CmzAaB7RNbtS1BUpV88o=;
	h=Date:To:From:Subject:Message-Id; b=OkSDfqN9+Im7EZKwSH4cA0EyjloE+6YbqvcB1wW13U1MVUJshCFySVioDqYx2uWSv0+sr8SKbqF+dM3wT7NAG48w8E1ec8fZt17+xnWEZX/ORn8RNMngvYEjruQgcuC8AAnFr3acVvMmxY1ID4KUsQWtUZBSIGB6Vde2rZPWYTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b/0H/fZE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b/0H/fZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AB14C2BD10;
	Fri, 24 May 2024 02:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716518848;
	bh=kHYR3dof7HlnHqxtwFgY1m8CmzAaB7RNbtS1BUpV88o=;
	h=Date:To:From:Subject:From;
	b=b/0H/fZEMIiQszFyq2jRKvF5l+LrYns4Or/JBPBDlaTvdVDSKisGrG//OmTtIBHgh
	 fiJExlp6+TLFwu0l8PtzS0el6/OnXkOQUE5R1m4x0TF9yghT06cQhim5pneELsyAtQ
	 u2+2F0sA70JIcgzRV/jCkjZVZakSEEjXy9fUoApQ=
Date: Thu, 23 May 2024 19:47:27 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-remove-page_memcg.patch added to mm-unstable branch
Message-Id: <20240524024728.4AB14C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcontrol: remove page_memcg()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-remove-page_memcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-remove-page_memcg.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memcontrol: remove page_memcg()
Date: Fri, 24 May 2024 09:49:50 +0800

The page_memcg() only called by mod_memcg_page_state(), so squash it to
cleanup page_memcg().

Link: https://lkml.kernel.org/r/20240524014950.187805-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   14 ++------------
 mm/memcontrol.c            |    2 +-
 2 files changed, 3 insertions(+), 13 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-remove-page_memcg
+++ a/include/linux/memcontrol.h
@@ -443,11 +443,6 @@ static inline struct mem_cgroup *folio_m
 	return __folio_memcg(folio);
 }
 
-static inline struct mem_cgroup *page_memcg(struct page *page)
-{
-	return folio_memcg(page_folio(page));
-}
-
 /**
  * folio_memcg_rcu - Locklessly get the memory cgroup associated with a folio.
  * @folio: Pointer to the folio.
@@ -1014,7 +1009,7 @@ static inline void mod_memcg_page_state(
 		return;
 
 	rcu_read_lock();
-	memcg = page_memcg(page);
+	memcg = folio_memcg(page_folio(page));
 	if (memcg)
 		mod_memcg_state(memcg, idx, val);
 	rcu_read_unlock();
@@ -1133,11 +1128,6 @@ static inline struct mem_cgroup *folio_m
 	return NULL;
 }
 
-static inline struct mem_cgroup *page_memcg(struct page *page)
-{
-	return NULL;
-}
-
 static inline struct mem_cgroup *folio_memcg_rcu(struct folio *folio)
 {
 	WARN_ON_ONCE(!rcu_read_lock_held());
@@ -1636,7 +1626,7 @@ static inline void unlock_page_lruvec_ir
 	spin_unlock_irqrestore(&lruvec->lru_lock, flags);
 }
 
-/* Test requires a stable page->memcg binding, see page_memcg() */
+/* Test requires a stable folio->memcg binding, see folio_memcg() */
 static inline bool folio_matches_lruvec(struct folio *folio,
 		struct lruvec *lruvec)
 {
--- a/mm/memcontrol.c~mm-memcontrol-remove-page_memcg
+++ a/mm/memcontrol.c
@@ -3809,7 +3809,7 @@ void __memcg_slab_free_hook(struct kmem_
 #endif /* CONFIG_MEMCG_KMEM */
 
 /*
- * Because page_memcg(head) is not set on tails, set it now.
+ * Because folio_memcg(head) is not set on tails, set it now.
  */
 void split_page_memcg(struct page *head, int old_order, int new_order)
 {
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-add-folio_alloc_mpol.patch
mm-mempolicy-use-folio_alloc_mpol_noprof-in-vma_alloc_folio_noprof.patch
mm-mempolicy-use-folio_alloc_mpol-in-alloc_migration_target_by_mpol.patch
mm-shmem-use-folio_alloc_mpol-in-shmem_alloc_folio.patch
mm-refactor-folio_undo_large_rmappable.patch
mm-memcontrol-remove-page_memcg.patch

