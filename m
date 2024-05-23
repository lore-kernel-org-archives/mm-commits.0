Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02CD82D66
	for <mm-commits@vger.kernel.org>; Thu, 23 May 2024 19:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716491188; cv=none; b=Qb7DOAw3Qxjven3YnZiYWqThsxPSoyF5kdCHUOZSvxGrxnophWD5hUKaB+xVFStYlSYnA/zWWR9CSGfQyF3MNANocpKwU2h9rOkt0samULE0ZYJY1mk7MYJfx2ZbhtuPZBRloAruSrx73vPVfNHXxlqgqHP3bkd1nKzLohwjipc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716491188; c=relaxed/simple;
	bh=2XKcUSP+PGPERRxQITI/P14DoxhXk9QSXf+2mGkx678=;
	h=Date:To:From:Subject:Message-Id; b=QLLs/H9rmJaVylacDbEbbgzrlyuJuKS34PuyjiXmlE+oNCk5qGe1u2sJKylGY5/KUfrRzBrF1MF/WEPYXhO6Gg16+MxgKNFwIjdtKk83TVQYusvhKkgvHPb+89SXliYlLpboty0TF4U3VqSF2pnrzZcLqOXWy322aSvpbCv8pjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0n7DUSJF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0n7DUSJF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB5DC32789;
	Thu, 23 May 2024 19:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716491188;
	bh=2XKcUSP+PGPERRxQITI/P14DoxhXk9QSXf+2mGkx678=;
	h=Date:To:From:Subject:From;
	b=0n7DUSJFxJHMhQcRdjzuO/qlZONzVXxiQN9vPFHN4Or0npYZiBMWcfTk4zaXWjYym
	 zaKvDD0vxibsUBQIswZQhxkNbDQNGCfdYj7El1BMsCzYtZ0fL1R1pYtYZo3mYBZmJs
	 +LkD2ZpqUea97qwYq6dhri8Kwr1rZGJmGLa3v5ck=
Date: Thu, 23 May 2024 12:06:27 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memcontrol-remove-page_memcg.patch removed from -mm tree
Message-Id: <20240523190628.1CB5DC32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcontrol: remove page_memcg()
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-remove-page_memcg.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memcontrol: remove page_memcg()
Date: Tue, 21 May 2024 21:15:56 +0800

The page_memcg() only called by mod_memcg_page_state(), so squash it to
cleanup page_memcg().

Link: https://lkml.kernel.org/r/20240521131556.142176-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Matthew Wilcox <willy@infradead.org>
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
+/* Test requires a stable page->memcg binding, see folio_memcg() */
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

