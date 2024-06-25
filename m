Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F81143741
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291593; cv=none; b=ZmqEEU4JeXnaLOlm0+VZBsUPw4TiHQ2BLpuJ1RePngdFZ3A91JDtPUdPD1fSmjMPNxQnytgWt9WI8LlijavT1hCzPCwJ70zqWNBGpzSUHZ0p5m2viyN4ZOgXVrpRXlXRuRkMrYSU4T4BWta8ue5P9atgJFSdaZFLu1vXElalROc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291593; c=relaxed/simple;
	bh=1GZRxbpZsaF1VapopRrG35VkyQwtmV/pK0Z3Ia4oxlA=;
	h=Date:To:From:Subject:Message-Id; b=WhMkrPKWadZRlXxZSQWkwLwV1q3NrBUPqlva++NCsdmBUxkVgLK0xeuiuCMOPqkYb/cVWGPavaZ8etLj3tZppk5agMttY+IV9DW42tXas7RPy0OCIJkleSKX1SFaRT+tmxoRPHkbW2FfRuwWFZ2Jghi9WDdJ6l9N+02+I23Ru/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BYC6oAna; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BYC6oAna"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF23C32782;
	Tue, 25 Jun 2024 04:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291593;
	bh=1GZRxbpZsaF1VapopRrG35VkyQwtmV/pK0Z3Ia4oxlA=;
	h=Date:To:From:Subject:From;
	b=BYC6oAnah3QczEkpfBjsfKqQpZ2WKafpzUcvjDltPLuWZXQuLpxwu1TUR0/KNPH0A
	 HEgBmNWe00sxmEKsXxfHaZPN/DQS0+wvRp3wKQPD6Xpwx+aqCkN1pib8hBeZHnd6DJ
	 sTcSMZag2VSoPIApjLCEou8PzuMFSD7P1Q4qaHf0=
Date: Mon, 24 Jun 2024 21:59:52 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-remove-page_memcg.patch removed from -mm tree
Message-Id: <20240625045953.0CF23C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcontrol: remove page_memcg()
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-remove-page_memcg.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -3807,7 +3807,7 @@ void __memcg_slab_free_hook(struct kmem_
 #endif /* CONFIG_MEMCG_KMEM */
 
 /*
- * Because page_memcg(head) is not set on tails, set it now.
+ * Because folio_memcg(head) is not set on tails, set it now.
  */
 void split_page_memcg(struct page *head, int old_order, int new_order)
 {
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

fs-proc-task_mmu-use-folio-api-in-pte_is_pinned.patch
mm-remove-page_maybe_dma_pinned.patch
mm-remove-page_maybe_dma_pinned-fix.patch
fb_defio-use-a-folio-in-fb_deferred_io_work.patch
mm-remove-page_mkclean.patch
mm-move-memory_failure_queue-into-copy_mc__highpage.patch
mm-add-folio_mc_copy.patch
mm-migrate-split-folio_migrate_mapping.patch
mm-migrate-support-poisoned-recover-from-migrate-folio.patch
fs-hugetlbfs-support-poison-recover-from-hugetlbfs_migrate_folio.patch
mm-migrate-remove-folio_migrate_copy.patch
mm-memory-convert-clear_huge_page-to-folio_zero_user.patch
mm-memory-use-folio-in-struct-copy_subpage_arg.patch
mm-memory-improve-copy_user_large_folio.patch
mm-memory-rename-pages_per_huge_page-to-nr_pages.patch

