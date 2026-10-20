Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792535813;
	b=eIXHVKQVAs+H50GuJvLQHR7Zbhl49bYNLJV+iWE/BSgbDywab32EFmvSaAr+WNp6fgPM
	 JXLmwyVnATidJkgSYn5iBlzjNmyAwcBIvsAoWqOdKBRK1hHufL8ff6W5tptvJkx2dR0vn
	 RT/MSLgo0qv+sR2Sy6ml0Yys5F4poUtaNG3zRZloQJEkBYQ6IJXs2zgq1ZtzHig2wMuZW
	 vRpPi4jBTFQ1+0VC08su6c3vTbyZa3G/vkvS1lW48+uclY80BIAg2wqiC2tM4NYR79tQx
	 zlBuo/IWqk18fGtS80aYRk01bhrG64xlB3DhmbIRoioc/r1C+az5TlDMbS4aT22uKUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792535813;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=ngIO8ahvSq5umYjN+4TebOsio88hz/4GXs2AmAQEOyI=;
	b=1Aym5/lWXObvhzg/Sn9zyc7zuTvZ6CULqmGsHi8WcNvHvkTy0UYnIIu4Rv/VPYhDZMkP
	 B4IkT/gD4eOXZPgsj70eyMSJMnrd0yTW8Fy9dExCMItTsNYV5p+AsbSoQCUETPt/qtLIF
	 D9Bz5/kxD45/XvK5bpwlHvKKPvry1PnRBepC4P3eD1SHRYzHT17T/7mzY7US/9EQbrOVl
	 27NgSEDCGU3+G6OlCipyB12Pq/FOZjaEKp4IiZlSy1+NGPeSVc3hFLo0lSuR9+zp6Ypey
	 kho0GwuzjrJ5MDsPkkLRab7U0fkW7mpIUI3glVOBBbPLZXULWTTHC6A74yJxcfCjIvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1+CvZRJi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF60F606A31A
	for <mm-commits@vger.kernel.org>; Tue, 20 Oct 2026 22:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1+CvZRJi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB751F000CA;
	Tue, 20 Oct 2026 22:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792535812;
	bh=ngIO8ahvSq5umYjN+4TebOsio88hz/4GXs2AmAQEOyI=;
	h=Date:To:From:Subject;
	b=1+CvZRJiDzfcY/czLBc2x5z0LA5kDZkjWT76X0MOvLORRGq9/NnuNazvTE1P1u60V
	 KbFZ+pCaI0SD4TGRF+5fu4bg+nBCEGpbNqUDrAnF6Dc7qayN+igCNHGxmKU8z+OfiD
	 sr8K7q82cCBlIZrenNBHdn0lXFjVD6qsxTp57jBE=
Date: Tue, 20 Oct 2026 15:36:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,roman.gushchin@linux.dev,qi.zheng@linux.dev,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,hughd@google.com,hannes@cmpxchg.org,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,joannelkoong@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-unqueue-deferred-split-folios-outside-the-lruvec-lock.patch added to mm-new branch
Message-Id: <20261020223652.AFB751F000CA@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: unqueue deferred split folios outside the lruvec lock
has been added to the -mm mm-new branch.  Its filename is
     mm-unqueue-deferred-split-folios-outside-the-lruvec-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-unqueue-deferred-split-folios-outside-the-lruvec-lock.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Joanne Koong <joannelkoong@gmail.com>
Subject: mm: unqueue deferred split folios outside the lruvec lock
Date: Mon, 19 Oct 2026 16:06:46 -0700

move_folios_to_lru(), folio_batch_move_lru() and folios_put_refs() call
folio_unqueue_deferred_split() on folios where the refcount has dropped to
zero.  In these paths, folio_unqueue_deferred_split() is called with the
lruvec lock often held (move_folios_to_lru() always holds it and
folio_batch_move_lru()/folios_put_refs() usually hold it for every folio
in the batch except the first).  However, it's not needed to hold the
lruvec lock.

The lruvec lock protects folio->lru and the reclaim LRU lists whereas the
deferred split queue lives on folio->_deferred_list in deferred_split_lru.
The deferred_split_lru is a list_lru with its own per-memcg per-node
lock.

There are already other existing callers that call
folio_unqueue_deferred_split() without holding the lruvec lock (eg
__folio_put(), shrink_folio_list(), __folio_migrate_mapping(), ...).

Add folio_batch_unqueue_deferred_split() and use it in
move_folios_to_lru(), folio_batch_move_lru(), and folios_put_refs() to
unqueue each batch of zero-refcount folios from the deferred split list
after the lruvec lock is released and before mem_cgroup_uncharge_folios().
This helps shorten the lruvec lock's critical sections, which run with
IRQs disabled and are highly contended.

This came out of the discussion on v2 of the mTHP shrinker series [1],
where queueing small mTHP folios on the deferred split queue was found to
regress Barry's fault microbenchmark.  With [1] applied and
khugepaged/max_ptes_none=0 so that every folio is queued, perf lock
contention showed that the extra cost came from waiting on the lruvec lock
in the free path.

Test setup: 2-socket Intel Skylake, 40 cores / 80 threads, memory bound to
node 0 so that all threads contend on one lruvec, with each of 80 threads
faulting in and unmapping 16 MB of anonymous memory 200 times.  With only
16K mTHP enabled, this patch reduces the queueing cost from 15% runtime to
noise, and lruvec lock wait time (summed across threads) drops from 491
seconds to 38 seconds.  Most of the remaining contention moves to the
deferred split list_lru lock, but runtime still drops back to the unqueued
baseline.  This test uses a worst-case configuration ([1] is expected to
only queue folios of 2M and larger).

Link: https://lore.kernel.org/20261019230646.3510790-1-joannelkoong@gmail.com
Link: https://lore.kernel.org/linux-mm/CAJnrk1a2PpUGTsCgS7jct2KET4K2zAL+_h+te8G1MaU9bXs99w@mail.gmail.com/ [1]
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
---

 mm/folio.c    |   24 +++++++++++++++++++-----
 mm/internal.h |    1 +
 mm/vmscan.c   |    3 ++-
 3 files changed, 22 insertions(+), 6 deletions(-)

--- a/mm/folio.c~mm-unqueue-deferred-split-folios-outside-the-lruvec-lock
+++ a/mm/folio.c
@@ -109,6 +109,19 @@ EXPORT_SYMBOL(__folio_put);
 
 typedef void (*move_fn_t)(struct lruvec *lruvec, struct folio *folio);
 
+/*
+ * Unqueue a batch of folios from the deferred split queue. This must be
+ * called after the folios' refcounts have dropped to zero and before they
+ * are uncharged (see comment above __folio_unqueue_deferred_split() for why).
+ */
+void folio_batch_unqueue_deferred_split(struct folio_batch *fbatch)
+{
+	unsigned int i;
+
+	for (i = 0; i < folio_batch_count(fbatch); i++)
+		folio_unqueue_deferred_split(fbatch->folios[i]);
+}
+
 static void lru_add(struct lruvec *lruvec, struct folio *folio)
 {
 	int was_unevictable = folio_test_clear_unevictable(folio);
@@ -177,14 +190,10 @@ static void folio_batch_move_lru(struct
 		 *
 		 * We're bypassing normal cleanup. Clear flags that are not
 		 * applicable to dead folios.
-		 *
-		 * Since the folio may be part of a huge page, unqueue from
-		 * deferred split list to avoid a dangling list entry.
 		 */
 		if (is_lru_add && folio_ref_freeze(folio, 1)) {
 			__folio_clear_active(folio);
 			__folio_clear_unevictable(folio);
-			folio_unqueue_deferred_split(folio);
 			fbatch->folios[i] = NULL;
 			folio_batch_add(&free_fbatch, folio);
 			continue;
@@ -201,6 +210,11 @@ static void folio_batch_move_lru(struct
 
 	/* Cleanup filtered dead folios. */
 	if (is_lru_add) {
+		/*
+		 * Unqueue any large folios from the deferred split queue to
+		 * avoid a dangling list entry once the folios are freed.
+		 */
+		folio_batch_unqueue_deferred_split(&free_fbatch);
 		mem_cgroup_uncharge_folios(&free_fbatch);
 		free_unref_folios(&free_fbatch);
 	}
@@ -1020,7 +1034,6 @@ void folios_put_refs(struct folio_batch
 			free_huge_folio(folio);
 			continue;
 		}
-		folio_unqueue_deferred_split(folio);
 		__page_cache_release(folio, &lruvec, &flags);
 
 		if (j != i)
@@ -1035,6 +1048,7 @@ void folios_put_refs(struct folio_batch
 	}
 
 	folios->nr = j;
+	folio_batch_unqueue_deferred_split(folios);
 	mem_cgroup_uncharge_folios(folios);
 	free_unref_folios(folios);
 }
--- a/mm/internal.h~mm-unqueue-deferred-split-folios-outside-the-lruvec-lock
+++ a/mm/internal.h
@@ -761,6 +761,7 @@ static inline bool folio_unqueue_deferre
 
 	return __folio_unqueue_deferred_split(folio);
 }
+void folio_batch_unqueue_deferred_split(struct folio_batch *fbatch);
 
 static inline struct folio *page_rmappable_folio(struct page *page)
 {
--- a/mm/vmscan.c~mm-unqueue-deferred-split-folios-outside-the-lruvec-lock
+++ a/mm/vmscan.c
@@ -2007,9 +2007,9 @@ static unsigned int move_folios_to_lru(s
 		if (unlikely(folio_put_testzero(folio))) {
 			__folio_clear_lru_flags(folio);
 
-			folio_unqueue_deferred_split(folio);
 			if (folio_batch_add(&free_folios, folio) == 0) {
 				lruvec_unlock_irq(lruvec);
+				folio_batch_unqueue_deferred_split(&free_folios);
 				mem_cgroup_uncharge_folios(&free_folios);
 				free_unref_folios(&free_folios);
 				lruvec = NULL;
@@ -2041,6 +2041,7 @@ static unsigned int move_folios_to_lru(s
 		lruvec_unlock_irq(lruvec);
 
 	if (free_folios.nr) {
+		folio_batch_unqueue_deferred_split(&free_folios);
 		mem_cgroup_uncharge_folios(&free_folios);
 		free_unref_folios(&free_folios);
 	}
_

Patches currently in -mm which might be from joannelkoong@gmail.com are

mm-unqueue-deferred-split-folios-outside-the-lruvec-lock.patch

