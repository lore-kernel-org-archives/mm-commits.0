Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82FD93FDBF8
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525403; cv=none; b=tr0xpm2JrpLRyB3pQnX7AFXsENWofn1ZvxiXUDDiObrDV7JUThqeuzUx/iGaDFmNxW6dBPR0jarSAWr592JCQnhgEwFDoPy72lurcl3zdHsUAHzUgPjVLI8r0qkjqhPxRhVJ/5q9xVmdLsWjk5KCowwvFJyf6VH36aYBJvLVdwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525403; c=relaxed/simple;
	bh=rJngrUPINrZLII/kbJwC4QbDmI3yJFqe7AQNK50FvuQ=;
	h=Date:To:From:Subject:Message-Id; b=XUGkzSJ6sFgf/oI0Y6Qg78AkL6fY+iPj3shM2kyjwuWCs2wbSYF9umAIYpnDVeA7EA236DgR+8Q9M+hR9YT0GlQT5OqLgY/NaMRQqXvY6I7BbLcphwv8V2ufcQKX15104IHUZMT9ksPO+y5N7Vy93wheRv36a+6/tEZ8NCk6e0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RS5SHtPq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RS5SHtPq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43FB81F000FF;
	Fri,  9 Oct 2026 05:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525402;
	bh=b8Ql1oK4O2VmVZk3jDn6QXPu5Bt0S0PlBiSCTPdXiAI=;
	h=Date:To:From:Subject;
	b=RS5SHtPqQTpR8VAQB+LxAn/LmqII+TYdIIY8zsfTaxyxBgv7Q5Q7TE9o4N2qsLFQr
	 n261PviknSnNqtjl0rk3FwYgAj/KiTqCoiOPZegxUiLviQZnS8mOWYvnpDSAETVWZL
	 RROZbTI8HgE7tap8ep7lFtroooPJ+19aOUNQcw3U=
Date: Thu, 08 Oct 2026 22:56:41 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,shakeel.butt@linux.dev,ryncsn@gmail.com,roman.gushchin@linux.dev,ridong.chen@linux.dev,qi.zheng@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,lianux.mm@gmail.com,liam@infradead.org,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-move-max_seq-read-into-walk_update_folio.patch removed from -mm tree
Message-Id: <20261009055642.43FB81F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: move max_seq read into walk_update_folio
has been removed from the -mm tree.  Its filename was
     mm-mglru-move-max_seq-read-into-walk_update_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/mglru: move max_seq read into walk_update_folio
Date: Sun, 06 Sep 2026 00:51:09 +0800

walk_pte_range(), walk_pmd_range_locked(), and lru_gen_look_around() each
read lrugen->max_seq to compute the target generation used by
walk_update_folio(), then pass it as a parameter.  Move the read into
walk_update_folio() itself so the callers no longer need to compute or
pass the value.

The max_seq read now happens once per folio update rather than once per
walk range, so folios always get promoted to the current youngest
generation.

Link: https://lore.kernel.org/20260906-mglru-flags-cleanup-v6-4-9aacbd77d4ca@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
---

 mm/vmscan.c |   29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

--- a/mm/vmscan.c~mm-mglru-move-max_seq-read-into-walk_update_folio
+++ a/mm/vmscan.c
@@ -3557,13 +3557,15 @@ static bool suitable_to_scan(int total,
 }
 
 static void walk_update_folio(struct lru_gen_mm_walk *walk, struct vm_area_struct *vma,
-		struct folio *folio, int new_gen, bool dirty)
+		struct lruvec *lruvec, struct folio *folio, bool dirty)
 {
-	int old_gen;
+	int new_gen, old_gen;
 
 	if (!folio)
 		return;
 
+	new_gen = lru_gen_from_seq(READ_ONCE(lruvec->lrugen.max_seq));
+
 	if (dirty && !folio_test_dirty(folio) &&
 	    !(folio_test_anon(folio) && folio_test_swapbacked(folio) &&
 	      !folio_test_swapcache(folio)))
@@ -3594,8 +3596,6 @@ static bool walk_pte_range(pmd_t *pmd, u
 	struct lru_gen_mm_walk *walk = args->private;
 	struct mem_cgroup *memcg = lruvec_memcg(walk->lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
-	DEFINE_MAX_SEQ(walk->lruvec);
-	int gen = lru_gen_from_seq(max_seq);
 	unsigned int nr;
 	pmd_t pmdval;
 
@@ -3646,7 +3646,7 @@ restart:
 			continue;
 
 		if (last != folio) {
-			walk_update_folio(walk, args->vma, last, gen, dirty);
+			walk_update_folio(walk, args->vma, walk->lruvec, last, dirty);
 
 			last = folio;
 			dirty = false;
@@ -3659,7 +3659,7 @@ restart:
 		walk->mm_stats[MM_LEAF_YOUNG] += nr;
 	}
 
-	walk_update_folio(walk, args->vma, last, gen, dirty);
+	walk_update_folio(walk, args->vma, walk->lruvec, last, dirty);
 	last = NULL;
 
 	if (i < PTRS_PER_PTE && get_next_vma(PMD_MASK, PAGE_SIZE, args, &start, &end))
@@ -3682,8 +3682,6 @@ static void walk_pmd_range_locked(pud_t
 	struct lru_gen_mm_walk *walk = args->private;
 	struct mem_cgroup *memcg = lruvec_memcg(walk->lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
-	DEFINE_MAX_SEQ(walk->lruvec);
-	int gen = lru_gen_from_seq(max_seq);
 
 	VM_WARN_ON_ONCE(pud_leaf(*pud));
 
@@ -3737,7 +3735,7 @@ static void walk_pmd_range_locked(pud_t
 			goto next;
 
 		if (last != folio) {
-			walk_update_folio(walk, vma, last, gen, dirty);
+			walk_update_folio(walk, vma, walk->lruvec, last, dirty);
 
 			last = folio;
 			dirty = false;
@@ -3751,7 +3749,7 @@ next:
 		i = i > MIN_LRU_BATCH ? 0 : find_next_bit(bitmap, MIN_LRU_BATCH, i) + 1;
 	} while (i <= MIN_LRU_BATCH);
 
-	walk_update_folio(walk, vma, last, gen, dirty);
+	walk_update_folio(walk, vma, walk->lruvec, last, dirty);
 
 	lazy_mmu_mode_disable();
 	spin_unlock(ptl);
@@ -4357,8 +4355,6 @@ bool lru_gen_look_around(struct page_vma
 	struct pglist_data *pgdat = folio_pgdat(folio);
 	struct lruvec *lruvec;
 	struct lru_gen_mm_state *mm_state;
-	unsigned long max_seq;
-	int gen;
 
 	lockdep_assert_held(pvmw->ptl);
 	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
@@ -4395,8 +4391,6 @@ bool lru_gen_look_around(struct page_vma
 
 	memcg = get_mem_cgroup_from_folio(folio);
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
-	max_seq = READ_ONCE((lruvec)->lrugen.max_seq);
-	gen = lru_gen_from_seq(max_seq);
 	mm_state = get_mm_state(lruvec);
 
 	lazy_mmu_mode_enable();
@@ -4428,7 +4422,7 @@ bool lru_gen_look_around(struct page_vma
 			continue;
 
 		if (last != folio) {
-			walk_update_folio(walk, vma, last, gen, dirty);
+			walk_update_folio(walk, vma, lruvec, last, dirty);
 
 			last = folio;
 			dirty = false;
@@ -4440,13 +4434,14 @@ bool lru_gen_look_around(struct page_vma
 		young += nr;
 	}
 
-	walk_update_folio(walk, vma, last, gen, dirty);
+	walk_update_folio(walk, vma, lruvec, last, dirty);
 
 	lazy_mmu_mode_disable();
 
 	/* feedback from rmap walkers to page table walkers */
 	if (mm_state && suitable_to_scan(i, young))
-		update_bloom_filter(mm_state, max_seq, pvmw->pmd);
+		update_bloom_filter(mm_state, READ_ONCE(lruvec->lrugen.max_seq),
+				    pvmw->pmd);
 
 	mem_cgroup_put(memcg);
 
_

Patches currently in -mm which might be from kasong@tencent.com are


