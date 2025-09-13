Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1452580D7;
	Sat, 13 Sep 2025 20:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757794165; cv=none; b=q/2sCH6X6JPZ2Zz3eJ3pIhfRBXBMazAVv/raB09OudLHh2zvIhPKrLT8ZvggQ1v3xFPz6J7RInbI9Ov1xP/TidLEmHmU8z2y/QRQlSWbd22mLRXtMamZk4xXukD9lNq/gFBD8G07YJPlvYnQQQiUG7am1z5U3ToFaumZM/cCNdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757794165; c=relaxed/simple;
	bh=COvO7k8dn7JjYVZ2mOoF40umF684m9+HvsU3jTRHRGY=;
	h=Date:To:From:Subject:Message-Id; b=OMQTbe0gLB6VnWPK88sZSy5feHzwlpTblLs8qqLgXXsLoXAZ+GXmpp5F3dFZqTSPiL2K2DU7GD7XnfhRouyq+vKx0fNOU+oZ162wG968f5ccak/tLmFH7Pm1D2Cu6wayIEGMkydspIQgw9oj7XsFuSi9lWKfQgaskCOIWEERKUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yGPwsNn0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yGPwsNn0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44E5C4CEEB;
	Sat, 13 Sep 2025 20:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757794164;
	bh=COvO7k8dn7JjYVZ2mOoF40umF684m9+HvsU3jTRHRGY=;
	h=Date:To:From:Subject:From;
	b=yGPwsNn0VVUOen8kEiJ7jARZAfKUhAaRaGvIeMyKk/XzgxqU8yEF7N8vxAJ6oCM6T
	 PHWK6Eo7hmS9QWXkg6mXV1bX+PalJ1I1AAdrW/epwkgKj5WOYY7+YStlYew9xtsM2X
	 cSuIT0oHgxUsUJvSvvXHBCywDCD6c5Zfcs8ouaQg=
Date: Sat, 13 Sep 2025 13:09:24 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,yangge1116@126.com,willy@infradead.org,will@kernel.org,weixugc@google.com,vbabka@suse.cz,stable@vger.kernel.org,shivankg@amd.com,riel@surriel.com,peterx@redhat.com,lizhe.67@bytedance.com,koct9i@gmail.com,keirf@google.com,jhubbard@nvidia.com,jgg@ziepe.ca,hch@infradead.org,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,axelrasmussen@google.com,aneesh.kumar@kernel.org,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-revert-mm-gup-clear-the-lru-flag-of-a-page-before-adding-to-lru-batch.patch removed from -mm tree
Message-Id: <20250913200924.A44E5C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: revert "mm/gup: clear the LRU flag of a page before adding to LRU batch"
has been removed from the -mm tree.  Its filename was
     mm-revert-mm-gup-clear-the-lru-flag-of-a-page-before-adding-to-lru-batch.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: revert "mm/gup: clear the LRU flag of a page before adding to LRU batch"
Date: Mon, 8 Sep 2025 15:19:17 -0700 (PDT)

This reverts commit 33dfe9204f29: now that
collect_longterm_unpinnable_folios() is checking ref_count instead of lru,
and mlock/munlock do not participate in the revised LRU flag clearing,
those changes are misleading, and enlarge the window during which
mlock/munlock may miss an mlock_count update.

It is possible (I'd hesitate to claim probable) that the greater
likelihood of missed mlock_count updates would explain the "Realtime
threads delayed due to kcompactd0" observed on 6.12 in the Link below.  If
that is the case, this reversion will help; but a complete solution needs
also a further patch, beyond the scope of this series.

Included some 80-column cleanup around folio_batch_add_and_move().

The role of folio_test_clear_lru() (before taking per-memcg lru_lock) is
questionable since 6.13 removed mem_cgroup_move_account() etc; but perhaps
there are still some races which need it - not examined here.

Link: https://lore.kernel.org/linux-mm/DU0PR01MB10385345F7153F334100981888259A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com/
Link: https://lkml.kernel.org/r/05905d7b-ed14-68b1-79d8-bdec30367eba@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Keir Fraser <keirf@google.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Li Zhe <lizhe.67@bytedance.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shivank Garg <shivankg@amd.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: yangge <yangge1116@126.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   50 ++++++++++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 24 deletions(-)

--- a/mm/swap.c~mm-revert-mm-gup-clear-the-lru-flag-of-a-page-before-adding-to-lru-batch
+++ a/mm/swap.c
@@ -164,6 +164,10 @@ static void folio_batch_move_lru(struct
 	for (i = 0; i < folio_batch_count(fbatch); i++) {
 		struct folio *folio = fbatch->folios[i];
 
+		/* block memcg migration while the folio moves between lru */
+		if (move_fn != lru_add && !folio_test_clear_lru(folio))
+			continue;
+
 		folio_lruvec_relock_irqsave(folio, &lruvec, &flags);
 		move_fn(lruvec, folio);
 
@@ -176,14 +180,10 @@ static void folio_batch_move_lru(struct
 }
 
 static void __folio_batch_add_and_move(struct folio_batch __percpu *fbatch,
-		struct folio *folio, move_fn_t move_fn,
-		bool on_lru, bool disable_irq)
+		struct folio *folio, move_fn_t move_fn, bool disable_irq)
 {
 	unsigned long flags;
 
-	if (on_lru && !folio_test_clear_lru(folio))
-		return;
-
 	folio_get(folio);
 
 	if (disable_irq)
@@ -191,8 +191,8 @@ static void __folio_batch_add_and_move(s
 	else
 		local_lock(&cpu_fbatches.lock);
 
-	if (!folio_batch_add(this_cpu_ptr(fbatch), folio) || folio_test_large(folio) ||
-	    lru_cache_disabled())
+	if (!folio_batch_add(this_cpu_ptr(fbatch), folio) ||
+			folio_test_large(folio) || lru_cache_disabled())
 		folio_batch_move_lru(this_cpu_ptr(fbatch), move_fn);
 
 	if (disable_irq)
@@ -201,13 +201,13 @@ static void __folio_batch_add_and_move(s
 		local_unlock(&cpu_fbatches.lock);
 }
 
-#define folio_batch_add_and_move(folio, op, on_lru)						\
-	__folio_batch_add_and_move(								\
-		&cpu_fbatches.op,								\
-		folio,										\
-		op,										\
-		on_lru,										\
-		offsetof(struct cpu_fbatches, op) >= offsetof(struct cpu_fbatches, lock_irq)	\
+#define folio_batch_add_and_move(folio, op)		\
+	__folio_batch_add_and_move(			\
+		&cpu_fbatches.op,			\
+		folio,					\
+		op,					\
+		offsetof(struct cpu_fbatches, op) >=	\
+		offsetof(struct cpu_fbatches, lock_irq)	\
 	)
 
 static void lru_move_tail(struct lruvec *lruvec, struct folio *folio)
@@ -231,10 +231,10 @@ static void lru_move_tail(struct lruvec
 void folio_rotate_reclaimable(struct folio *folio)
 {
 	if (folio_test_locked(folio) || folio_test_dirty(folio) ||
-	    folio_test_unevictable(folio))
+	    folio_test_unevictable(folio) || !folio_test_lru(folio))
 		return;
 
-	folio_batch_add_and_move(folio, lru_move_tail, true);
+	folio_batch_add_and_move(folio, lru_move_tail);
 }
 
 void lru_note_cost_unlock_irq(struct lruvec *lruvec, bool file,
@@ -328,10 +328,11 @@ static void folio_activate_drain(int cpu
 
 void folio_activate(struct folio *folio)
 {
-	if (folio_test_active(folio) || folio_test_unevictable(folio))
+	if (folio_test_active(folio) || folio_test_unevictable(folio) ||
+	    !folio_test_lru(folio))
 		return;
 
-	folio_batch_add_and_move(folio, lru_activate, true);
+	folio_batch_add_and_move(folio, lru_activate);
 }
 
 #else
@@ -507,7 +508,7 @@ void folio_add_lru(struct folio *folio)
 	    lru_gen_in_fault() && !(current->flags & PF_MEMALLOC))
 		folio_set_active(folio);
 
-	folio_batch_add_and_move(folio, lru_add, false);
+	folio_batch_add_and_move(folio, lru_add);
 }
 EXPORT_SYMBOL(folio_add_lru);
 
@@ -685,13 +686,13 @@ void lru_add_drain_cpu(int cpu)
 void deactivate_file_folio(struct folio *folio)
 {
 	/* Deactivating an unevictable folio will not accelerate reclaim */
-	if (folio_test_unevictable(folio))
+	if (folio_test_unevictable(folio) || !folio_test_lru(folio))
 		return;
 
 	if (lru_gen_enabled() && lru_gen_clear_refs(folio))
 		return;
 
-	folio_batch_add_and_move(folio, lru_deactivate_file, true);
+	folio_batch_add_and_move(folio, lru_deactivate_file);
 }
 
 /*
@@ -704,13 +705,13 @@ void deactivate_file_folio(struct folio
  */
 void folio_deactivate(struct folio *folio)
 {
-	if (folio_test_unevictable(folio))
+	if (folio_test_unevictable(folio) || !folio_test_lru(folio))
 		return;
 
 	if (lru_gen_enabled() ? lru_gen_clear_refs(folio) : !folio_test_active(folio))
 		return;
 
-	folio_batch_add_and_move(folio, lru_deactivate, true);
+	folio_batch_add_and_move(folio, lru_deactivate);
 }
 
 /**
@@ -723,10 +724,11 @@ void folio_deactivate(struct folio *foli
 void folio_mark_lazyfree(struct folio *folio)
 {
 	if (!folio_test_anon(folio) || !folio_test_swapbacked(folio) ||
+	    !folio_test_lru(folio) ||
 	    folio_test_swapcache(folio) || folio_test_unevictable(folio))
 		return;
 
-	folio_batch_add_and_move(folio, lru_lazyfree, true);
+	folio_batch_add_and_move(folio, lru_lazyfree);
 }
 
 void lru_add_drain(void)
_

Patches currently in -mm which might be from hughd@google.com are

mm-lru_add_drain_all-do-local-lru_add_drain-first.patch

