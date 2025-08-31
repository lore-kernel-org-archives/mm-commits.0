Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A7A6D1A7;
	Sun, 31 Aug 2025 19:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756669391; cv=none; b=c++LlRTN0qlU6xiWC0y1knnLEIvg/KxVQ97X/6XhqBZsutCXkqN1nCVIb/DEtcMezz0lD+TmsiVUdgD8Cjb9bNPX1DcVnh9NomnHt6mD7RCVbJZsjs14op3gHXT/LyNEKcmKn5GJQr5lpN/BcnwY7JVVYBO3l63qKa08Vj0RYGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756669391; c=relaxed/simple;
	bh=ewc+EUIcFpibNUXNnku3PQ2CazvgDqDrjIS4F1qL+XU=;
	h=Date:To:From:Subject:Message-Id; b=YbyVcCA3qg+PPCbH62ymRNBqft+R30F0ap9oFdl48kSUsl0LixYWdJH+K5OYhO4FCq2ABuN3ekCjJDKY2/I+RFWDEqwDzQHWhmW3RQp8PD58BI3Y1UvKggN05B1JAHOyb5ldBoB+wbf2tOimnKAX1/RZ99kjqxcojisPGXRRbx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DqN02cpg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DqN02cpg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898A4C4CEED;
	Sun, 31 Aug 2025 19:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756669391;
	bh=ewc+EUIcFpibNUXNnku3PQ2CazvgDqDrjIS4F1qL+XU=;
	h=Date:To:From:Subject:From;
	b=DqN02cpg/qDflh9TfisyHR7KxhZd4Gi26Fcm6Dbxi1pvedke6XG6oga+4045/lo0U
	 tJSDXFx9zOAn0pLzdigzGzaOFXBflBxe61ojxmSxmWS1TxZkSUAwdtpXCOh6D4jiBC
	 d+Hor7D1AqWf3hcW9ud9TmQpHaTkKlyPazjk9pGQ=
Date: Sun, 31 Aug 2025 12:43:11 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,yangge1116@126.com,willy@infradead.org,will@kernel.org,weixugc@google.com,vbabka@suse.cz,stable@vger.kernel.org,shivankg@amd.com,peterx@redhat.com,lizhe.67@bytedance.com,koct9i@gmail.com,keirf@google.com,jhubbard@nvidia.com,jgg@ziepe.ca,hch@infradead.org,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,axelrasmussen@google.com,aneesh.kumar@kernel.org,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-folio_may_be_cached-unless-folio_test_large.patch added to mm-new branch
Message-Id: <20250831194311.898A4C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: folio_may_be_cached() unless folio_test_large()
has been added to the -mm mm-new branch.  Its filename is
     mm-folio_may_be_cached-unless-folio_test_large.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-folio_may_be_cached-unless-folio_test_large.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Hugh Dickins <hughd@google.com>
Subject: mm: folio_may_be_cached() unless folio_test_large()
Date: Sun, 31 Aug 2025 02:16:25 -0700 (PDT)

mm/swap.c and mm/mlock.c agree to drain any per-CPU batch as soon as a
large folio is added: so collect_longterm_unpinnable_folios() just wastes
effort when calling lru_add_drain_all() on a large folio.

But although there is good reason not to batch up PMD-sized folios, we
might well benefit from batching a small number of low-order mTHPs (though
unclear how that "small number" limitation will be implemented).

So ask if folio_may_be_cached() rather than !folio_test_large(), to
insulate those particular checks from future change.  Name preferred to
"folio_is_batchable" because large folios can well be put on a batch: it's
just the per-CPU LRU caches, drained much later, which need care.

Marked for stable, to counter the increase in lru_add_drain_all()s from
"mm/gup: check ref_count instead of lru before migration".

Link: https://lkml.kernel.org/r/861c061c-51cd-b940-49df-9f55e1fee2c8@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
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
Cc: Shivank Garg <shivankg@amd.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: yangge <yangge1116@126.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   10 ++++++++++
 mm/gup.c             |    5 +++--
 mm/mlock.c           |    6 +++---
 mm/swap.c            |    2 +-
 4 files changed, 17 insertions(+), 6 deletions(-)

--- a/include/linux/swap.h~mm-folio_may_be_cached-unless-folio_test_large
+++ a/include/linux/swap.h
@@ -381,6 +381,16 @@ void folio_add_lru_vma(struct folio *, s
 void mark_page_accessed(struct page *);
 void folio_mark_accessed(struct folio *);
 
+static inline bool folio_may_be_cached(struct folio *folio)
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
--- a/mm/gup.c~mm-folio_may_be_cached-unless-folio_test_large
+++ a/mm/gup.c
@@ -2309,8 +2309,9 @@ static unsigned long collect_longterm_un
 			continue;
 		}
 
-		if (drain_allow && folio_ref_count(folio) !=
-				   folio_expected_ref_count(folio) + 1) {
+		if (drain_allow && folio_may_be_cached(folio) &&
+				folio_ref_count(folio) !=
+				folio_expected_ref_count(folio) + 1) {
 			lru_add_drain_all();
 			drain_allow = false;
 		}
--- a/mm/mlock.c~mm-folio_may_be_cached-unless-folio_test_large
+++ a/mm/mlock.c
@@ -255,7 +255,7 @@ void mlock_folio(struct folio *folio)
 
 	folio_get(folio);
 	if (!folio_batch_add(fbatch, mlock_lru(folio)) ||
-	    folio_test_large(folio) || lru_cache_disabled())
+	    !folio_may_be_cached(folio) || lru_cache_disabled())
 		mlock_folio_batch(fbatch);
 	local_unlock(&mlock_fbatch.lock);
 }
@@ -278,7 +278,7 @@ void mlock_new_folio(struct folio *folio
 
 	folio_get(folio);
 	if (!folio_batch_add(fbatch, mlock_new(folio)) ||
-	    folio_test_large(folio) || lru_cache_disabled())
+	    !folio_may_be_cached(folio) || lru_cache_disabled())
 		mlock_folio_batch(fbatch);
 	local_unlock(&mlock_fbatch.lock);
 }
@@ -299,7 +299,7 @@ void munlock_folio(struct folio *folio)
 	 */
 	folio_get(folio);
 	if (!folio_batch_add(fbatch, folio) ||
-	    folio_test_large(folio) || lru_cache_disabled())
+	    !folio_may_be_cached(folio) || lru_cache_disabled())
 		mlock_folio_batch(fbatch);
 	local_unlock(&mlock_fbatch.lock);
 }
--- a/mm/swap.c~mm-folio_may_be_cached-unless-folio_test_large
+++ a/mm/swap.c
@@ -192,7 +192,7 @@ static void __folio_batch_add_and_move(s
 		local_lock(&cpu_fbatches.lock);
 
 	if (!folio_batch_add(this_cpu_ptr(fbatch), folio) ||
-			folio_test_large(folio) || lru_cache_disabled())
+			!folio_may_be_cached(folio) || lru_cache_disabled())
 		folio_batch_move_lru(this_cpu_ptr(fbatch), move_fn);
 
 	if (disable_irq)
_

Patches currently in -mm which might be from hughd@google.com are

mm-fix-folio_expected_ref_count-when-pg_private_2.patch
mm-gup-check-ref_count-instead-of-lru-before-migration.patch
mm-gup-local-lru_add_drain-to-avoid-lru_add_drain_all.patch
mm-revert-mm-gup-clear-the-lru-flag-of-a-page-before-adding-to-lru-batch.patch
mm-revert-mm-vmscanc-fix-oom-on-swap-stress-test.patch
mm-folio_may_be_cached-unless-folio_test_large.patch
mm-lru_add_drain_all-do-local-lru_add_drain-first.patch

