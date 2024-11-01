Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B61225757;
	Fri,  1 Nov 2024 01:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730423361; cv=none; b=KmonNWF0ycmxxeUgRuakQ1ckTzvbum/sFGYG6plHTpKBAS8rNj2q2e6QBXdnKgYM7Pq6idqGmuWQLe6A54M25jcOpPOJrkDaj5FK3nVwajl5C04nh/uUSnGy9UWGUfQyVGLU1KEpzoy3eG2PuVaeikcbtKLp8Bo+XSlU7xRuQvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730423361; c=relaxed/simple;
	bh=RPGVrunkfYoDRrPP0KJbhLi00OiX645JGLMlwQZVNcg=;
	h=Date:To:From:Subject:Message-Id; b=gBgc8c2UiT9wPR6LVJ7wrIbNFtcOxYyV4hPaXGSzFRW9Az7edC039zGX+9GMgNePGLqt/pFchQJRWOlNtPEGFuA1UaYElS6R+SM0IJ8a2FPubEoJZN9pzXmiEUBlfFNswPbPsJd2ll/sSdgocr3kfp9ouGfLYdA4MzAereKaAIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y/DzVrEj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y/DzVrEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A88C4CEC3;
	Fri,  1 Nov 2024 01:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730423360;
	bh=RPGVrunkfYoDRrPP0KJbhLi00OiX645JGLMlwQZVNcg=;
	h=Date:To:From:Subject:From;
	b=y/DzVrEjR4CED75V7sCkDOZ15uPle40G5owAea8MqETKbhsBKoo4enycGBkkMewdo
	 6WVHfpTitn+fLD3jPRMqfMHpzPlNZ6kmfWXfQrdfYTtXnrjGDGya0ykT7u4NxH5wOc
	 tMaKKUymo564cTEh4kNJYB4jARyBk3f6Ti8tEGR8=
Date: Thu, 31 Oct 2024 18:09:20 -0700
To: mm-commits@vger.kernel.org,weixugc@google.com,stevensd@google.com,stable@vger.kernel.org,seanjc@google.com,rientjes@google.com,pbonzini@redhat.com,oliver.upton@linux.dev,lkp@intel.com,jthoughton@google.com,dmatlack@google.com,axelrasmussen@google.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-multi-gen-lru-use-pteppmdp_clear_young_notify.patch added to mm-hotfixes-unstable branch
Message-Id: <20241101010920.C8A88C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: multi-gen LRU: use {ptep,pmdp}_clear_young_notify()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-multi-gen-lru-use-pteppmdp_clear_young_notify.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-multi-gen-lru-use-pteppmdp_clear_young_notify.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Yu Zhao <yuzhao@google.com>
Subject: mm: multi-gen LRU: use {ptep,pmdp}_clear_young_notify()
Date: Sat, 19 Oct 2024 01:29:39 +0000

When the MM_WALK capability is enabled, memory that is mostly accessed by
a VM appears younger than it really is, therefore this memory will be less
likely to be evicted.  Therefore, the presence of a running VM can
significantly increase swap-outs for non-VM memory, regressing the
performance for the rest of the system.

Fix this regression by always calling {ptep,pmdp}_clear_young_notify()
whenever we clear the young bits on PMDs/PTEs.

Link: https://lkml.kernel.org/r/20241019012940.3656292-3-jthoughton@google.com
Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
Signed-off-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
Reported-by: David Stevens <stevensd@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Matlack <dmatlack@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: <stable@vger.kernel.org>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    5 +-
 mm/rmap.c              |    9 +--
 mm/vmscan.c            |   91 +++++++++++++++++++++------------------
 3 files changed, 55 insertions(+), 50 deletions(-)

--- a/include/linux/mmzone.h~mm-multi-gen-lru-use-pteppmdp_clear_young_notify
+++ a/include/linux/mmzone.h
@@ -555,7 +555,7 @@ struct lru_gen_memcg {
 
 void lru_gen_init_pgdat(struct pglist_data *pgdat);
 void lru_gen_init_lruvec(struct lruvec *lruvec);
-void lru_gen_look_around(struct page_vma_mapped_walk *pvmw);
+bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw);
 
 void lru_gen_init_memcg(struct mem_cgroup *memcg);
 void lru_gen_exit_memcg(struct mem_cgroup *memcg);
@@ -574,8 +574,9 @@ static inline void lru_gen_init_lruvec(s
 {
 }
 
-static inline void lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
+static inline bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 {
+	return false;
 }
 
 static inline void lru_gen_init_memcg(struct mem_cgroup *memcg)
--- a/mm/rmap.c~mm-multi-gen-lru-use-pteppmdp_clear_young_notify
+++ a/mm/rmap.c
@@ -885,13 +885,10 @@ static bool folio_referenced_one(struct
 			return false;
 		}
 
-		if (pvmw.pte) {
-			if (lru_gen_enabled() &&
-			    pte_young(ptep_get(pvmw.pte))) {
-				lru_gen_look_around(&pvmw);
+		if (lru_gen_enabled() && pvmw.pte) {
+			if (lru_gen_look_around(&pvmw))
 				referenced++;
-			}
-
+		} else if (pvmw.pte) {
 			if (ptep_clear_flush_young_notify(vma, address,
 						pvmw.pte))
 				referenced++;
--- a/mm/vmscan.c~mm-multi-gen-lru-use-pteppmdp_clear_young_notify
+++ a/mm/vmscan.c
@@ -56,6 +56,7 @@
 #include <linux/khugepaged.h>
 #include <linux/rculist_nulls.h>
 #include <linux/random.h>
+#include <linux/mmu_notifier.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -3294,7 +3295,8 @@ static bool get_next_vma(unsigned long m
 	return false;
 }
 
-static unsigned long get_pte_pfn(pte_t pte, struct vm_area_struct *vma, unsigned long addr)
+static unsigned long get_pte_pfn(pte_t pte, struct vm_area_struct *vma, unsigned long addr,
+				 struct pglist_data *pgdat)
 {
 	unsigned long pfn = pte_pfn(pte);
 
@@ -3306,13 +3308,20 @@ static unsigned long get_pte_pfn(pte_t p
 	if (WARN_ON_ONCE(pte_devmap(pte) || pte_special(pte)))
 		return -1;
 
+	if (!pte_young(pte) && !mm_has_notifiers(vma->vm_mm))
+		return -1;
+
 	if (WARN_ON_ONCE(!pfn_valid(pfn)))
 		return -1;
 
+	if (pfn < pgdat->node_start_pfn || pfn >= pgdat_end_pfn(pgdat))
+		return -1;
+
 	return pfn;
 }
 
-static unsigned long get_pmd_pfn(pmd_t pmd, struct vm_area_struct *vma, unsigned long addr)
+static unsigned long get_pmd_pfn(pmd_t pmd, struct vm_area_struct *vma, unsigned long addr,
+				 struct pglist_data *pgdat)
 {
 	unsigned long pfn = pmd_pfn(pmd);
 
@@ -3324,9 +3333,15 @@ static unsigned long get_pmd_pfn(pmd_t p
 	if (WARN_ON_ONCE(pmd_devmap(pmd)))
 		return -1;
 
+	if (!pmd_young(pmd) && !mm_has_notifiers(vma->vm_mm))
+		return -1;
+
 	if (WARN_ON_ONCE(!pfn_valid(pfn)))
 		return -1;
 
+	if (pfn < pgdat->node_start_pfn || pfn >= pgdat_end_pfn(pgdat))
+		return -1;
+
 	return pfn;
 }
 
@@ -3335,10 +3350,6 @@ static struct folio *get_pfn_folio(unsig
 {
 	struct folio *folio;
 
-	/* try to avoid unnecessary memory loads */
-	if (pfn < pgdat->node_start_pfn || pfn >= pgdat_end_pfn(pgdat))
-		return NULL;
-
 	folio = pfn_folio(pfn);
 	if (folio_nid(folio) != pgdat->node_id)
 		return NULL;
@@ -3394,20 +3405,16 @@ restart:
 		total++;
 		walk->mm_stats[MM_LEAF_TOTAL]++;
 
-		pfn = get_pte_pfn(ptent, args->vma, addr);
+		pfn = get_pte_pfn(ptent, args->vma, addr, pgdat);
 		if (pfn == -1)
 			continue;
 
-		if (!pte_young(ptent)) {
-			continue;
-		}
-
 		folio = get_pfn_folio(pfn, memcg, pgdat, walk->can_swap);
 		if (!folio)
 			continue;
 
-		if (!ptep_test_and_clear_young(args->vma, addr, pte + i))
-			VM_WARN_ON_ONCE(true);
+		if (!ptep_clear_young_notify(args->vma, addr, pte + i))
+			continue;
 
 		young++;
 		walk->mm_stats[MM_LEAF_YOUNG]++;
@@ -3473,21 +3480,22 @@ static void walk_pmd_range_locked(pud_t
 		/* don't round down the first address */
 		addr = i ? (*first & PMD_MASK) + i * PMD_SIZE : *first;
 
-		pfn = get_pmd_pfn(pmd[i], vma, addr);
-		if (pfn == -1)
-			goto next;
-
-		if (!pmd_trans_huge(pmd[i])) {
-			if (!walk->force_scan && should_clear_pmd_young())
+		if (pmd_present(pmd[i]) && !pmd_trans_huge(pmd[i])) {
+			if (!walk->force_scan && should_clear_pmd_young() &&
+			    !mm_has_notifiers(args->mm))
 				pmdp_test_and_clear_young(vma, addr, pmd + i);
 			goto next;
 		}
 
+		pfn = get_pmd_pfn(pmd[i], vma, addr, pgdat);
+		if (pfn == -1)
+			goto next;
+
 		folio = get_pfn_folio(pfn, memcg, pgdat, walk->can_swap);
 		if (!folio)
 			goto next;
 
-		if (!pmdp_test_and_clear_young(vma, addr, pmd + i))
+		if (!pmdp_clear_young_notify(vma, addr, pmd + i))
 			goto next;
 
 		walk->mm_stats[MM_LEAF_YOUNG]++;
@@ -3545,24 +3553,18 @@ restart:
 		}
 
 		if (pmd_trans_huge(val)) {
-			unsigned long pfn = pmd_pfn(val);
 			struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
+			unsigned long pfn = get_pmd_pfn(val, vma, addr, pgdat);
 
 			walk->mm_stats[MM_LEAF_TOTAL]++;
 
-			if (!pmd_young(val)) {
-				continue;
-			}
-
-			/* try to avoid unnecessary memory loads */
-			if (pfn < pgdat->node_start_pfn || pfn >= pgdat_end_pfn(pgdat))
-				continue;
-
-			walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
+			if (pfn != -1)
+				walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
 			continue;
 		}
 
-		if (!walk->force_scan && should_clear_pmd_young()) {
+		if (!walk->force_scan && should_clear_pmd_young() &&
+		    !mm_has_notifiers(args->mm)) {
 			if (!pmd_young(val))
 				continue;
 
@@ -4036,13 +4038,13 @@ static void lru_gen_age_node(struct pgli
  * the PTE table to the Bloom filter. This forms a feedback loop between the
  * eviction and the aging.
  */
-void lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
+bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 {
 	int i;
 	unsigned long start;
 	unsigned long end;
 	struct lru_gen_mm_walk *walk;
-	int young = 0;
+	int young = 1;
 	pte_t *pte = pvmw->pte;
 	unsigned long addr = pvmw->address;
 	struct vm_area_struct *vma = pvmw->vma;
@@ -4058,12 +4060,15 @@ void lru_gen_look_around(struct page_vma
 	lockdep_assert_held(pvmw->ptl);
 	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
 
+	if (!ptep_clear_young_notify(vma, addr, pte))
+		return false;
+
 	if (spin_is_contended(pvmw->ptl))
-		return;
+		return true;
 
 	/* exclude special VMAs containing anon pages from COW */
 	if (vma->vm_flags & VM_SPECIAL)
-		return;
+		return true;
 
 	/* avoid taking the LRU lock under the PTL when possible */
 	walk = current->reclaim_state ? current->reclaim_state->mm_walk : NULL;
@@ -4071,6 +4076,9 @@ void lru_gen_look_around(struct page_vma
 	start = max(addr & PMD_MASK, vma->vm_start);
 	end = min(addr | ~PMD_MASK, vma->vm_end - 1) + 1;
 
+	if (end - start == PAGE_SIZE)
+		return true;
+
 	if (end - start > MIN_LRU_BATCH * PAGE_SIZE) {
 		if (addr - start < MIN_LRU_BATCH * PAGE_SIZE / 2)
 			end = start + MIN_LRU_BATCH * PAGE_SIZE;
@@ -4084,7 +4092,7 @@ void lru_gen_look_around(struct page_vma
 
 	/* folio_update_gen() requires stable folio_memcg() */
 	if (!mem_cgroup_trylock_pages(memcg))
-		return;
+		return true;
 
 	arch_enter_lazy_mmu_mode();
 
@@ -4094,19 +4102,16 @@ void lru_gen_look_around(struct page_vma
 		unsigned long pfn;
 		pte_t ptent = ptep_get(pte + i);
 
-		pfn = get_pte_pfn(ptent, vma, addr);
+		pfn = get_pte_pfn(ptent, vma, addr, pgdat);
 		if (pfn == -1)
 			continue;
 
-		if (!pte_young(ptent))
-			continue;
-
 		folio = get_pfn_folio(pfn, memcg, pgdat, can_swap);
 		if (!folio)
 			continue;
 
-		if (!ptep_test_and_clear_young(vma, addr, pte + i))
-			VM_WARN_ON_ONCE(true);
+		if (!ptep_clear_young_notify(vma, addr, pte + i))
+			continue;
 
 		young++;
 
@@ -4136,6 +4141,8 @@ void lru_gen_look_around(struct page_vma
 	/* feedback from rmap walkers to page table walkers */
 	if (mm_state && suitable_to_scan(i, young))
 		update_bloom_filter(mm_state, max_seq, pvmw->pmd);
+
+	return true;
 }
 
 /******************************************************************************
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-multi-gen-lru-remove-mm_leaf_old-and-mm_nonleaf_total-stats.patch
mm-multi-gen-lru-use-pteppmdp_clear_young_notify.patch
mm-page_alloc-keep-track-of-free-highatomic.patch

