Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA5C1A6814
	for <mm-commits@vger.kernel.org>; Thu,  6 Aug 2026 19:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786044084; cv=none; b=LSdGNrP4dXIRN5KhAnz8h6C12eA8Cx6p6R3yfQf5l4tLNiBAS47B/rOiuM5kEDGdPt382hgoIELDiY7MQ0ASanvSrghS3ESt9b9GLpXv97pM2OBcRMFJVx6RYh3XNomNJjEqw1CAzB5IxVFFqU5RwkfPM6aYV2g4Hh1jKy1RbUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786044084; c=relaxed/simple;
	bh=D4dN7ee63xJkSoy8I+zQlpRkhgKJnXtQRtfMVQSE5/g=;
	h=Date:To:From:Subject:Message-Id; b=OFKZC1S0YHBmiN/rTSub0RZgQD3nwyd56z9jRRSsLkXiUEDJdBKlpuOMlezPmH3Wc5m+yulgHIeb0TXvOkoWMqTS68TyFvOVq0r2QN2foSjTUaKgPHl427utRwqNjwDEJn5rGpvR+Jm26uSqzzvgiqAA/Y3z6q7AuJPhQLX/84Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wwjln+bv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wwjln+bv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 251671F00A3A;
	Thu,  6 Aug 2026 19:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786044082;
	bh=6+VyAtJZgCEPi9feL+ENIW4PugD8bIjQpJuwG8JWcMU=;
	h=Date:To:From:Subject;
	b=wwjln+bvQqc7P/YKJ8LT1tEsqYBtO0aEVfRdwAjrM+KcVspIJXSfobSi/tE6dZCtR
	 6lI+LulPrEcN6K7A/TNLhBUwVoFHJuwqQqRWFBQZf5fAzTL1zNubCG5Fy/98EW1Rny
	 4h1H0vUzieEQStSxIt1yYeU4HkHhByrR9GMZXxrM=
Date: Thu, 06 Aug 2026 12:21:21 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shikemeng@huaweicloud.com,seanjc@google.com,rppt@kernel.org,peterx@redhat.com,nphamcs@gmail.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,jhubbard@nvidia.com,jgg@ziepe.ca,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,ackerleytng@google.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-factor-out-lru-cache-draining-for-folio-into-lru_cache_drain_for_folio.patch added to mm-unstable branch
Message-Id: <20260806192122.251671F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: factor out LRU cache draining for folio into lru_cache_drain_for_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-factor-out-lru-cache-draining-for-folio-into-lru_cache_drain_for_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-factor-out-lru-cache-draining-for-folio-into-lru_cache_drain_for_folio.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-standardize-printing-for-pgtable-entries.patch
mm-gup-fix-always-draining-lru-caches-in-collect_longterm_unpinnable_folios.patch
mm-gup-factor-out-lru-cache-draining-for-folio-into-lru_cache_drain_for_folio.patch

