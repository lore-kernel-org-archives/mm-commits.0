Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2AD442B3E
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 03:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788234006; cv=none; b=CfShZRNUI0QdFbwj4DFIkCh7jUDVluIo7Xfvho/Mf9N9VJblFEeYMbywCuDIBzqCPmTjkWmD3VV51a2SQ3DZoBzjC30Bv5LCZedSq38kMX+6ZTWH8cxOkM6k1LkWTF/blUHPtnBMY3TxS7/HpKx3KqX44h8O9QZl+e2AWS80VEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788234006; c=relaxed/simple;
	bh=g6JKp/w2iLrZqzXIhkfLDfxbTjUQAlLG9deKzVQAZGY=;
	h=Date:To:From:Subject:Message-Id; b=SWqupzFP1QUPFVaNRz/62XBssLVUe99a70NUjQbICrKdnAthg4TwelZVfFnkjW5WLrE4/vTGCGDKxfNMd9Y2qMCOz+89EtDh45WgKJuI4jw92YAI/gBoh0QcG6fNaSZuRiHNR7Nq5RPxJHJpz081u/4sudQoO/qXTJbiyr6QFr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yCcHjeq9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yCcHjeq9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8DD1F000E9;
	Tue,  1 Sep 2026 03:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788234004;
	bh=KtZBsas7Ow6zHTi56biPsNVy1JCHnBQtuCpZ0OPtroc=;
	h=Date:To:From:Subject;
	b=yCcHjeq9aP/e5uiOaiABpUTJkKpFfSPfN71y/p/zfdfX330P7GMkpDy554CUwSCuq
	 E908rsxXpqWknwfIo6K5sMw4CmiVQQXo9S2rr5c+GS6+byGBah1sXwpUO7g2f6/V5p
	 T96yvEtKoueFUO+fRCZEMtayyyrHFWQfktxvvBZA=
Date: Mon, 31 Aug 2026 20:40:04 -0700
To: mm-commits@vger.kernel.org,zhaonanzhe@xiaomi.com,youngjun.park@lge.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,ryncsn@gmail.com,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,hughd@google.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,xueyuan.chen21@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-distinguish-large-folio-swap-allocation-failures.patch added to mm-new branch
Message-Id: <20260901034004.6B8DD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: distinguish large folio swap allocation failures
has been added to the -mm mm-new branch.  Its filename is
     mm-distinguish-large-folio-swap-allocation-failures.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-distinguish-large-folio-swap-allocation-failures.patch

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
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: mm: distinguish large folio swap allocation failures
Date: Sun, 30 Aug 2026 12:29:18 +0800

folio_alloc_swap() reports most failures with generic negative error
codes.  Reclaim callers consequently cannot tell whether splitting a large
folio could make progress, or whether no swap space is available for even
a single page.

Classify failures using both the global free swap count and the remaining
capacity in the folio's memcg swap hierarchy.  Return -ENOSPC when global
swap space is exhausted, -ENOMEM when splitting cannot overcome the
failure, and -E2BIG for a large folio when allocating or charging a
smaller folio might still succeed.

Use this classification for all folio_alloc_swap() failure paths,
including capability rejection, swap slot allocation failure, and memcg
swap charge failure.  Callers are updated separately to split large folios
only on -E2BIG.

Link: https://lore.kernel.org/20260830042920.2280454-3-xueyuan.chen21@gmail.com
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Suggested-by: Kairui Song <ryncsn@gmail.com>
Suggested-by: Barry Song <baohua@kernel.org>
Suggested-by: Youngjun Park <youngjun.park@lge.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    6 ++++++
 mm/memcontrol.c      |   23 +++++++++++++++++++++++
 mm/swapfile.c        |   26 +++++++++++++++++++-------
 3 files changed, 48 insertions(+), 7 deletions(-)

--- a/include/linux/swap.h~mm-distinguish-large-folio-swap-allocation-failures
+++ a/include/linux/swap.h
@@ -508,6 +508,7 @@ static inline void mem_cgroup_uncharge_s
 	__mem_cgroup_uncharge_swap(id, nr_pages);
 }
 
+long mem_cgroup_get_folio_swap_margin(struct folio *folio);
 extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
 extern bool mem_cgroup_swap_full(struct folio *folio);
 #else
@@ -521,6 +522,11 @@ static inline void mem_cgroup_uncharge_s
 {
 }
 
+static inline long mem_cgroup_get_folio_swap_margin(struct folio *folio)
+{
+	return PAGE_COUNTER_MAX;
+}
+
 static inline long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 {
 	return get_nr_swap_pages();
--- a/mm/memcontrol.c~mm-distinguish-large-folio-swap-allocation-failures
+++ a/mm/memcontrol.c
@@ -5832,6 +5832,29 @@ long mem_cgroup_get_nr_swap_pages(struct
 	return nr_swap_pages;
 }
 
+/**
+ * mem_cgroup_get_folio_swap_margin - get a folio's memcg swap margin
+ * @folio: folio whose memcg margin is queried
+ *
+ * Return: Remaining chargeable pages in the folio's memcg hierarchy.
+ */
+long mem_cgroup_get_folio_swap_margin(struct folio *folio)
+{
+	struct mem_cgroup *memcg;
+	long margin;
+
+	if (mem_cgroup_disabled() || do_memsw_account() ||
+	    !folio_memcg_charged(folio))
+		return PAGE_COUNTER_MAX;
+
+	rcu_read_lock();
+	memcg = folio_memcg(folio);
+	margin = page_counter_margin(&memcg->swap);
+	rcu_read_unlock();
+
+	return margin;
+}
+
 bool mem_cgroup_swap_full(struct folio *folio)
 {
 	struct mem_cgroup *memcg;
--- a/mm/swapfile.c~mm-distinguish-large-folio-swap-allocation-failures
+++ a/mm/swapfile.c
@@ -1735,7 +1735,9 @@ failed:
  * swap cache.
  *
  * Context: Caller needs to hold the folio lock.
- * Return: Whether the folio was added to the swap cache.
+ * Return: %0 on success, %-E2BIG if splitting the folio might allow swapout,
+ * %-ENOSPC if no global swap space is available, or %-ENOMEM if splitting
+ * would not help.
  */
 int folio_alloc_swap(struct folio *folio)
 {
@@ -1747,11 +1749,11 @@ int folio_alloc_swap(struct folio *folio
 
 	if (order) {
 		/*
-		 * Reject large allocation when THP_SWAP is disabled,
-		 * the caller should split the folio and try again.
+		 * Reject large allocation when THP_SWAP is disabled. Check below
+		 * whether splitting and retrying can make progress.
 		 */
 		if (!IS_ENABLED(CONFIG_THP_SWAP))
-			return -EAGAIN;
+			goto failed;
 
 		/*
 		 * Allocation size should never exceed cluster size
@@ -1759,7 +1761,7 @@ int folio_alloc_swap(struct folio *folio
 		 */
 		if (size > SWAPFILE_CLUSTER) {
 			VM_WARN_ON_ONCE(1);
-			return -EINVAL;
+			goto failed;
 		}
 	}
 
@@ -1775,13 +1777,23 @@ again:
 	}
 
 	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
-	if (unlikely(mem_cgroup_try_charge_swap(folio)))
+	if (unlikely(mem_cgroup_try_charge_swap(folio))) {
 		swap_cache_del_folio(folio);
+		goto failed;
+	}
 
 	if (unlikely(!folio_test_swapcache(folio)))
-		return -ENOMEM;
+		goto failed;
 
 	return 0;
+
+failed:
+	if (get_nr_swap_pages() <= 0)
+		return -ENOSPC;
+	if (mem_cgroup_get_folio_swap_margin(folio) <= 0)
+		return -ENOMEM;
+
+	return order ? -E2BIG : -ENOMEM;
 }
 
 /**
_

Patches currently in -mm which might be from xueyuan.chen21@gmail.com are

mm-distinguish-large-folio-swap-allocation-failures.patch
mm-shmem-split-large-folios-only-on-e2big.patch

