Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792830234;
	b=1YPgYYO9ELuO12Cr1QE0ZonIRY19HUSV1G/PdBqkjNuoZYP16N3D3/gFquk8cRahnLzN
	 bgng3jWV8WoqDTYwooayHm1P1njWMMh/pzeWvzXNyYe6MoAZVr1ABBmViUDAUYqzeDFCR
	 TZvQKEtGoCqUjQ4EbAGZmvBWvxHdRaca2aVmaR2+ziRMBMHpBNb34oyBMZwiSws06Z46j
	 JVUlyphjForr+dVtL6TLcHrDIuIT/gjtA0Uai/onEe61QOt3AiFLnr+XGsukTkzMb7QrL
	 T5aXolD6RvnGadsLeiQabtVkBGG9iOfoMsTHr4D3BSldf3kb+8X14LZNxwnEyHfx/pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792830234;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=tW/YVvB7CLjza3ups6hA303oNLovtE3gQHaFJItj4Us=;
	b=i0Jc1bGCKjbN4RdQUT231Xd67Z/hLn/Ia2soPsXoKXtC1vLpmMhNfVGsfyPFTRh+hVeN
	 4IewYfwoenluImVqZ0EabcaTUlKhb6L4FtwvgV7D6pQ0WvQL0ACuT63cBtFTLJr48ndo0
	 ztRRNPqFmUVI/7cWLF18AHAPo41uv8Truprv8UED4VI/bWq5uLOAQ2AMJeLIyVmH94vzt
	 iBqgvDw82gt6rDilxQh05B3paABi0xieQdTr/rv+CTygqiQZJ/vio2FqTTuIVY8GlD6Lt
	 GqNCll811/1yv/oPbRCPJrvjWwOSeucaKoyqxvsQU0godiJrQPRfLHluYcdV+BbCCbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=aL0xkD1W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8E1606A31A;
	Sat, 24 Oct 2026 08:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=aL0xkD1W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A8E01F01825;
	Sat, 24 Oct 2026 08:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792830233;
	bh=tW/YVvB7CLjza3ups6hA303oNLovtE3gQHaFJItj4Us=;
	h=Date:To:From:Subject;
	b=aL0xkD1WSZa9Q0uw/iiqSj4rKSavh5AS2P43syup8ZjQdNfQPOdDsKUfoYjAMIXEm
	 4ab1ZbmerQu0QHmW7Xrem0rnxAdZ7nEzkV5lqHzpjS07iMF/iJIfH+XqZc16JXJMmJ
	 C4XmqeuxOVkjaHTrLrP7VU79eb7uBR7vLGvy9eSQ=
Date: Sat, 24 Oct 2026 01:23:53 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,mhocko@suse.com,harry@kernel.org,hannes@cmpxchg.org,david@kernel.org,brendan.jackman@linux.dev,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_alloc-make-defrag_mode-retries-follow-the-promoted-order-fix.patch removed from -mm tree
Message-Id: <20261024082353.9A8E01F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: Re: mm: page_alloc: make defrag_mode retries follow the promoted order
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-make-defrag_mode-retries-follow-the-promoted-order-fix.patch

This patch was dropped because it was folded into mm-page_alloc-make-defrag_mode-retries-follow-the-promoted-order.patch

------------------------------------------------------
From: Kiryl Shutsemau <kas@kernel.org>
Subject: Re: mm: page_alloc: make defrag_mode retries follow the promoted order
Date: Thu, 15 Oct 2026 13:50:55 +0100

s/order_nofrag_promoted/order_defrag_promoted/, per hannes

Link: https://lore.kernel.org/atDL-nSFP2KVU7cI@thinkstation
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
---

 mm/page_alloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-make-defrag_mode-retries-follow-the-promoted-order-fix
+++ a/mm/page_alloc.c
@@ -4117,7 +4117,7 @@ out:
 	return page;
 }
 
-static inline bool order_nofrag_promoted(unsigned int order,
+static inline bool order_defrag_promoted(unsigned int order,
 					 const struct alloc_context *ac)
 {
 	return ac->reclaim_compact_order != order;
@@ -4250,7 +4250,7 @@ should_compact_retry(gfp_t gfp_mask, str
 	 * Promoted requests fall back instead.
 	 */
 	if (compact_result == COMPACT_SKIPPED) {
-		if (!order_nofrag_promoted(order, ac))
+		if (!order_defrag_promoted(order, ac))
 			ret = compaction_zonelist_suitable(ac, order,
 							   alloc_flags, gfp_mask);
 		goto out;
@@ -4632,7 +4632,7 @@ should_reclaim_retry(gfp_t gfp_mask, uns
 	 * for compaction without freeing anything.
 	 */
 	if (did_some_progress && order <= PAGE_ALLOC_COSTLY_ORDER &&
-	    !order_nofrag_promoted(order, ac))
+	    !order_defrag_promoted(order, ac))
 		*no_progress_loops = 0;
 	else
 		(*no_progress_loops)++;
@@ -5014,7 +5014,7 @@ retry:
 	if (defrag_mode && (alloc_flags & ALLOC_NOFRAGMENT)) {
 		alloc_flags &= ~ALLOC_NOFRAGMENT;
 		/* Retries went into making blocks, start the fallback afresh */
-		if (order_nofrag_promoted(order, ac)) {
+		if (order_defrag_promoted(order, ac)) {
 			no_progress_loops = 0;
 			compaction_retries = 0;
 		}
_

Patches currently in -mm which might be from kas@kernel.org are

mm-page_alloc-make-defrag_mode-retries-follow-the-promoted-order.patch
mm-khugepaged-drop-redundant-mm_struct-pin-in-madvise_collapse.patch
mm-khugepaged-count-collapses-where-khugepaged-makes-them.patch
mm-khugepaged-rename-mthp_present_ptes-bitmap-to-eligible_ptes.patch
mm-collapse-add-collapseh-for-the-collapse-interface.patch
mm-collapse-state-what-a-collapse-may-do-in-the-policy.patch
mm-collapse-drop-the-collapse_possible-wrapper.patch
mm-collapse-name-the-per-table-scan-reset-for-what-it-resets.patch
mm-collapse-call-collapse_file-from-collapse_single_pmd.patch
mm-collapse-separate-scanning-a-pte-table-from-collapsing-it.patch

