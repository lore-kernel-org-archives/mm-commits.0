Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FFC34250E
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622819; cv=none; b=iUsxfXMFGckOR2owVGDQUaF9zzHopLtdoNLTXLvvRoPmJEbUbGO47vWX2fsM1/MJztTgKoVQzA0Q0OlOktK1fKWZxrI5WTYKTI475GCQiVyzt1yA1/lRbT2K+E3k37kbXrz8qpf2Ui3GMeUo4BRb0i3LA5lNZ8uWAxsoNYhUfgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622819; c=relaxed/simple;
	bh=K6KRzyZnF8EeVtxsxacrQGCAhH4adbeBEIzsXmydNB0=;
	h=Date:To:From:Subject:Message-Id; b=MCCGD3JjpwA1ibzd6JiHlBoSTEshoiFktxs5gSBgzHDHXaoqId2kePjzkUG9o02T4fJpkDCiocXiIFIoLdW3uCjAAbLWXn7u5VK9CUXbe6k8FfMiLBDdxq09rsNA3kV6smy8IuYYCD2VnPRZYAaI3ktv1wREx3sW0jMUywLD3JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DiL/6xfC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DiL/6xfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58AD1F000E9;
	Tue, 25 Aug 2026 01:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622817;
	bh=xIWFXqiKA/7wsKiZxDmHqjsTbQTBPDe5tHmoMJzx8pc=;
	h=Date:To:From:Subject;
	b=DiL/6xfCkhAkEIChhel4Hw5YQDYJPo8jKVdvlmyz3cuX2CBSA5/xvopDoEKxrRYuC
	 mIYVWsxUTFlneGy70UfBB1pacLn6hWq5ZASKTZmGa/URzpk4J0YXCbe65QCauUWFL0
	 53izFLWXpyN9uDWvLnUOzgXwG2pIGAdqGhEqfBvg=
Date: Mon, 24 Aug 2026 18:53:37 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shikemeng@huaweicloud.com,seanjc@google.com,rppt@kernel.org,peterx@redhat.com,nphamcs@gmail.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,jhubbard@nvidia.com,jgg@ziepe.ca,fuad.tabba@linux.dev,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,ackerleytng@google.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-factor-out-lru-cache-draining-for-folio-into-lru_cache_drain_for_folio.patch removed from -mm tree
Message-Id: <20260825015337.B58AD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: factor out LRU cache draining for folio into lru_cache_drain_for_folio()
has been removed from the -mm tree.  Its filename was
     mm-gup-factor-out-lru-cache-draining-for-folio-into-lru_cache_drain_for_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/gup: factor out LRU cache draining for folio into lru_cache_drain_for_folio()
Date: Thu, 06 Aug 2026 20:09:06 +0200

KVM with guest_memfd wants to remove any folio references due to LRU
caches, as it really must only allow to convert folios from shared to
private when there are no unexpected folio references (e.g., from GUP
references).

So, to drive the refcount down, it needs a way to flush the LRU caches. 
Let's factor out what we have in lru_cache_drain_for_folio().  Document
it, and also mention that concurrent folio (un)mapping might, in theory,
miss detecting LRU cache references.  Keep obtaining the expected refcount
twice to minimize the possibility.  For the current and future user that
should work, and we don't really have a better alternative: we could
detect if the mapcount changed, but it would still be racy and add more
complexity with questionable benefit.

Maybe there is a chance to avoid the draining entirely in the future, by
avoiding extra references from the LRU cache: Hugh thinks there might be a
way.  But for the time being, this handling is unfortunately required.

Make folio_may_be_lru_cached() accept a const pointer so
lru_cache_drain_for_folio() can accept a const pointer as well.

Link: https://lore.kernel.org/20260806-lru_cache_drain_for_folio-v1-1-c6287d295e99@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    8 +++++++
 mm/folio.c           |   46 +++++++++++++++++++++++++++++++++++++++++
 mm/gup.c             |   15 +------------
 mm/internal.h        |    2 -
 4 files changed, 57 insertions(+), 14 deletions(-)

--- a/include/linux/swap.h~mm-gup-factor-out-lru-cache-draining-for-folio-into-lru_cache_drain_for_folio
+++ a/include/linux/swap.h
@@ -298,6 +298,14 @@ void folio_add_lru(struct folio *folio);
 void folio_mark_accessed(struct folio *folio);
 void lru_add_drain_all(void);
 
+enum lru_cache_drained {
+	LRU_CACHE_NOT_DRAINED,
+	LRU_CACHE_DRAINED,
+	LRU_CACHE_DRAINED_ALL,
+};
+void lru_cache_drain_for_folio(const struct folio *folio,
+		unsigned int extra_refs, enum lru_cache_drained *drained);
+
 /* linux/mm/folio-compat.c */
 void mark_page_accessed(struct page *page);
 
--- a/mm/folio.c~mm-gup-factor-out-lru-cache-draining-for-folio-into-lru_cache_drain_for_folio
+++ a/mm/folio.c
@@ -881,6 +881,52 @@ void lru_add_drain_all(void)
 }
 #endif /* CONFIG_SMP */
 
+/**
+ * lru_cache_drain_for_folio() - drain LRU caches if the caches might hold
+ *				 folio references
+ * @folio: The folio.
+ * @extra_refs: Extra folio references held by the caller.
+ * @drained: Drain status for batch folio processing.
+ *
+ * Drain LRU caches if the caches might hold folio references. Start
+ * with a local LRU cache drain, to then drain LRU caches on all CPUs if
+ * local draining was insufficient.
+ *
+ * This function detects LRU cache references by comparing the folio refcount
+ * with the sum of the expected folio refcount + extra references held by the
+ * caller. Note that we cannot rely on PG_lru to reliably detect all LRU
+ * cache references, and there are rare scenarios (concurrent folio (un)mapping)
+ * where this function might miss detecting LRU cache references.
+ *
+ * If @drained is not NULL, the function will avoid re-draining LRU caches
+ * when processing multiple folios in a row. In that case, the variable
+ * @drained points at must be initialized to LRU_CACHE_NOT_DRAINED before
+ * the first invocation by the caller.
+ */
+void lru_cache_drain_for_folio(const struct folio *folio,
+		unsigned int extra_refs, enum lru_cache_drained *drained)
+{
+	if (!folio_may_be_lru_cached(folio))
+		return;
+
+	if (!drained || *drained == LRU_CACHE_NOT_DRAINED) {
+		if (folio_ref_count(folio) ==
+		    folio_expected_ref_count(folio) + extra_refs)
+			return;
+		lru_add_drain();
+		if (drained)
+			*drained = LRU_CACHE_DRAINED;
+	}
+	if (!drained || *drained == LRU_CACHE_DRAINED) {
+		if (folio_ref_count(folio) ==
+		    folio_expected_ref_count(folio) + extra_refs)
+			return;
+		lru_add_drain_all();
+		if (drained)
+			*drained = LRU_CACHE_DRAINED_ALL;
+	}
+}
+
 atomic_t lru_disable_count = ATOMIC_INIT(0);
 
 /*
--- a/mm/gup.c~mm-gup-factor-out-lru-cache-draining-for-folio-into-lru_cache_drain_for_folio
+++ a/mm/gup.c
@@ -2266,9 +2266,9 @@ static unsigned long collect_longterm_un
 		struct list_head *movable_folio_list,
 		struct pages_or_folios *pofs)
 {
+	enum lru_cache_drained drained = LRU_CACHE_NOT_DRAINED;
 	unsigned long collected = 0;
 	struct folio *folio;
-	int drained = 0;
 	long i = 0;
 
 	for (folio = pofs_get_folio(pofs, i); folio;
@@ -2293,18 +2293,7 @@ static unsigned long collect_longterm_un
 		 * but also to remove any other folio references from LRU
 		 * caches.
 		 */
-		if (drained == 0 && folio_may_be_lru_cached(folio) &&
-				folio_ref_count(folio) !=
-				folio_expected_ref_count(folio) + pin_refs) {
-			lru_add_drain();
-			drained = 1;
-		}
-		if (drained == 1 && folio_may_be_lru_cached(folio) &&
-				folio_ref_count(folio) !=
-				folio_expected_ref_count(folio) + pin_refs) {
-			lru_add_drain_all();
-			drained = 2;
-		}
+		lru_cache_drain_for_folio(folio, pin_refs, &drained);
 
 		if (!folio_isolate_lru(folio))
 			continue;
--- a/mm/internal.h~mm-gup-factor-out-lru-cache-draining-for-folio-into-lru_cache_drain_for_folio
+++ a/mm/internal.h
@@ -43,7 +43,7 @@ void workingset_activation(struct folio
 /* mm/folio.c */
 void folio_add_lru_vma(struct folio *folio, struct vm_area_struct *vma);
 
-static inline bool folio_may_be_lru_cached(struct folio *folio)
+static inline bool folio_may_be_lru_cached(const struct folio *folio)
 {
 	/*
 	 * Holding PMD-sized folios in per-CPU LRU cache unbalances accounting.
_

Patches currently in -mm which might be from david@kernel.org are


