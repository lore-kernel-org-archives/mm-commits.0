Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEAD32571BA;
	Sat, 13 Sep 2025 20:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757794169; cv=none; b=AVqsIkMS3Ez0sj4LKc+jdrqSDwqZfMJ+kg4/kk5ewTjX6xbt73fmT3/N0Gu5yL26WXzzmWO17/3RHVal56NyQrCvv3jgoWVmvAYpOlrGb1HgFWvCldc8hSBxThUR+o9MM1kuVRWoI1pQIlMRGC00I7f7ghWhlwLBqx5Zw+lZZJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757794169; c=relaxed/simple;
	bh=euD3nkTU6AvjaoI/vnLCE0wNaswRZWvlszPapKNqook=;
	h=Date:To:From:Subject:Message-Id; b=GgqmQMYjhISymYmCBnXnDEDLWWhFXBq9RyrO5By/27Uj5rD1qsnB9WzVKzUo5BdODTPr0prmD7Xb3VAezpyBNrpsUwe6uuuoj6Yz9JNfAmCUqYNghX0IaFv1OWobWJgdHI8HBKeBkvnopslSgucC/AX/GmcPp4hkvBYtZFu6Qkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SFu6D1qt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SFu6D1qt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4355EC4CEEB;
	Sat, 13 Sep 2025 20:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757794168;
	bh=euD3nkTU6AvjaoI/vnLCE0wNaswRZWvlszPapKNqook=;
	h=Date:To:From:Subject:From;
	b=SFu6D1qtl4g+hEoUMK5HJ+8uCPXh8fiqBW9P+KH+TAgT/8TJCM9TMmYlf+RlGeRX0
	 bLDK/S2JLHemR4NX8N0QdBEqtLAC869CjV6Z/h+VFjetzUX5pZuhlHhF6Uhr6te2jC
	 XylPK5ZiSP3T+16hddkHkLrhUFE+5nZUTU8Ei7IU=
Date: Sat, 13 Sep 2025 13:09:27 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,yangge1116@126.com,willy@infradead.org,will@kernel.org,weixugc@google.com,vbabka@suse.cz,stable@vger.kernel.org,shivankg@amd.com,riel@surriel.com,peterx@redhat.com,lizhe.67@bytedance.com,koct9i@gmail.com,keirf@google.com,jhubbard@nvidia.com,jgg@ziepe.ca,hch@infradead.org,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,axelrasmussen@google.com,aneesh.kumar@kernel.org,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-folio_may_be_lru_cached-unless-folio_test_large.patch removed from -mm tree
Message-Id: <20250913200928.4355EC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: folio_may_be_lru_cached() unless folio_test_large()
has been removed from the -mm tree.  Its filename was
     mm-folio_may_be_lru_cached-unless-folio_test_large.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: folio_may_be_lru_cached() unless folio_test_large()
Date: Mon, 8 Sep 2025 15:23:15 -0700 (PDT)

mm/swap.c and mm/mlock.c agree to drain any per-CPU batch as soon as a
large folio is added: so collect_longterm_unpinnable_folios() just wastes
effort when calling lru_add_drain[_all]() on a large folio.

But although there is good reason not to batch up PMD-sized folios, we
might well benefit from batching a small number of low-order mTHPs (though
unclear how that "small number" limitation will be implemented).

So ask if folio_may_be_lru_cached() rather than !folio_test_large(), to
insulate those particular checks from future change.  Name preferred to
"folio_is_batchable" because large folios can well be put on a batch: it's
just the per-CPU LRU caches, drained much later, which need care.

Marked for stable, to counter the increase in lru_add_drain_all()s from
"mm/gup: check ref_count instead of lru before migration".

Link: https://lkml.kernel.org/r/57d2eaf8-3607-f318-e0c5-be02dce61ad0@google.com
Fixes: 9a4e9f3b2d73 ("mm: update get_user_pages_longterm to migrate pages allocated from CMA region")
Signed-off-by: Hugh Dickins <hughd@google.com>
Suggested-by: David Hildenbrand <david@redhat.com>
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

 include/linux/swap.h |   10 ++++++++++
 mm/gup.c             |    4 ++--
 mm/mlock.c           |    6 +++---
 mm/swap.c            |    2 +-
 4 files changed, 16 insertions(+), 6 deletions(-)

--- a/include/linux/swap.h~mm-folio_may_be_lru_cached-unless-folio_test_large
+++ a/include/linux/swap.h
@@ -385,6 +385,16 @@ void folio_add_lru_vma(struct folio *, s
 void mark_page_accessed(struct page *);
 void folio_mark_accessed(struct folio *);
 
+static inline bool folio_may_be_lru_cached(struct folio *folio)
+{
+	/*
+	 * Holding PMD-sized folios in per-CPU LRU cache unbalances accounting.
+	 * Holding small numbers of low-order mTHP folios in per-CPU LRU cache
+	 * will be sensible, but nobody has implemented and tested that yet.
+	 */
+	return !folio_test_large(folio);
+}
+
 extern atomic_t lru_disable_count;
 
 static inline bool lru_cache_disabled(void)
--- a/mm/gup.c~mm-folio_may_be_lru_cached-unless-folio_test_large
+++ a/mm/gup.c
@@ -2307,13 +2307,13 @@ static unsigned long collect_longterm_un
 			continue;
 		}
 
-		if (drained == 0 &&
+		if (drained == 0 && folio_may_be_lru_cached(folio) &&
 				folio_ref_count(folio) !=
 				folio_expected_ref_count(folio) + 1) {
 			lru_add_drain();
 			drained = 1;
 		}
-		if (drained == 1 &&
+		if (drained == 1 && folio_may_be_lru_cached(folio) &&
 				folio_ref_count(folio) !=
 				folio_expected_ref_count(folio) + 1) {
 			lru_add_drain_all();
--- a/mm/mlock.c~mm-folio_may_be_lru_cached-unless-folio_test_large
+++ a/mm/mlock.c
@@ -255,7 +255,7 @@ void mlock_folio(struct folio *folio)
 
 	folio_get(folio);
 	if (!folio_batch_add(fbatch, mlock_lru(folio)) ||
-	    folio_test_large(folio) || lru_cache_disabled())
+	    !folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		mlock_folio_batch(fbatch);
 	local_unlock(&mlock_fbatch.lock);
 }
@@ -278,7 +278,7 @@ void mlock_new_folio(struct folio *folio
 
 	folio_get(folio);
 	if (!folio_batch_add(fbatch, mlock_new(folio)) ||
-	    folio_test_large(folio) || lru_cache_disabled())
+	    !folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		mlock_folio_batch(fbatch);
 	local_unlock(&mlock_fbatch.lock);
 }
@@ -299,7 +299,7 @@ void munlock_folio(struct folio *folio)
 	 */
 	folio_get(folio);
 	if (!folio_batch_add(fbatch, folio) ||
-	    folio_test_large(folio) || lru_cache_disabled())
+	    !folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		mlock_folio_batch(fbatch);
 	local_unlock(&mlock_fbatch.lock);
 }
--- a/mm/swap.c~mm-folio_may_be_lru_cached-unless-folio_test_large
+++ a/mm/swap.c
@@ -192,7 +192,7 @@ static void __folio_batch_add_and_move(s
 		local_lock(&cpu_fbatches.lock);
 
 	if (!folio_batch_add(this_cpu_ptr(fbatch), folio) ||
-			folio_test_large(folio) || lru_cache_disabled())
+			!folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		folio_batch_move_lru(this_cpu_ptr(fbatch), move_fn);
 
 	if (disable_irq)
_

Patches currently in -mm which might be from hughd@google.com are

mm-lru_add_drain_all-do-local-lru_add_drain-first.patch

