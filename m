Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C07646521
	for <mm-commits@vger.kernel.org>; Tue, 21 May 2024 21:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716326647; cv=none; b=VVotKQmthg/5mA0ZEXM//o2fAjc5g1OQ4/3fd36V9SF/yPmlOrVMZxEP06p3o7o3sbGnDGhRAFzAGYJT4mLtNsJb7K+b8AggWmbdcXk8SPLpdP69J3oAaUA1ewtgIaqUeKn4ZlzFliL6YS8nHVQL46G3qlBe6JJLKpdhmtDAeMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716326647; c=relaxed/simple;
	bh=/aCTDG41DvdfljIaLHOSXAPdEqUGW8h2J7piCa/jeno=;
	h=Date:To:From:Subject:Message-Id; b=N1NHyzL9o2IEF0ApnLfBlkhVhxINnho3pJsrznZ1/l3KWahlseC9s2yzM1Oxot4wX5d0Blt+dULBRCrFeuGzGZFK2JWdsLrdD0weLyLBcRWJ+V4LslQYkjeTzi7S/h8ZNUv03A75p/HC4QLqkh4fDp6KBJ4uLGQOfVX+O9mBpY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bj7S2PKo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bj7S2PKo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083E0C2BD11;
	Tue, 21 May 2024 21:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716326647;
	bh=/aCTDG41DvdfljIaLHOSXAPdEqUGW8h2J7piCa/jeno=;
	h=Date:To:From:Subject:From;
	b=bj7S2PKosGnwM+gUgp/dhquOe1VeS3zxmnKrITAa7uHeem6lJHsX+avWn8uFFKyPf
	 bpAaDxl8CppsGQa/C290O5XrN6WxUhjcwWZOYiwXCeGs13EycDJ+x0cB5WGXXuwMUo
	 0HPW0ey0eo2znNLyKb250Hd8VrbdL/bVfRkK4iTk=
Date: Tue, 21 May 2024 14:24:06 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-remove-page_memcg.patch added to mm-unstable branch
Message-Id: <20240521212407.083E0C2BD11@smtp.kernel.org>
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
mm-memcontrol-remove-page_memcg.patch

