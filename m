Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794102569;
	b=Trzs3o/j1nrhsBeaSUkgIvcZT324Q0mxu90fxmSha22UpyKKhxicCpicbJ36EkQZUoXx
	 nKXnjSBaMt3KZIjs2kJr+b88vFuxbzVXHfltArZSgLCfIeUeqFLqVLGeS0ptUXhCmN8Ae
	 ftbdU6bKxOxsyTsa43z8+bxDgwcIBm8DChQE3cE+Wnls+lkm1DoeTIplISFiBRiUJwITB
	 4Nd7TYjV2PUDg6POEzPlheu9KMP9Sgxt4DCmfIpsq/U5GzbHkVSa5Ac9DiUnipSoUYWTE
	 xWAH3MTuzoueWiLff4Nwi05EgdBPu5ruYBFaid3R02JTcNjakjNxh777uNx/PJfqEHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794102569;
	h=Received:DKIM-Signature:Date:To:Cc:From:Subject:Message-Id;
	bh=PzH5O1Rq8jtMw3afyS/aAZhR1XNqFicLFkiQPIsEBak=;
	b=fHsx3jT2r8d3Bv+NJJbRlJTB4Pll/9KpXV0uFI7tbeI6LKXjtfMzFRH+nUyursovWgmg
	 c2FeNmk9D4qUR8bzhxx/9jdi4mivqKtCEL9Pwj/lJYaVBTZJY2HExBdaldQ5VIRwMtbKq
	 7RI2qzE0KkLrzWUom9nR77YX3lGPwQTGGcAd7mBAqgzMbLcRnqrIsWW9dFz5F4cTUVaNU
	 Wgt2E+Lh71KfYpQLkTOJKuRIdmLPM7iECeWA9CBdmpEyKHS4BhocnVEjepLaDru2Sjwe0
	 OyZYQfyJPV5Jl0pP1hN/f9fgAVTkuHvtJnJZEfkVLLcNrif61m+6wJYjVUn/oqLmUnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=wuQLIrid;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5249D606A31C
	for <mm-commits@vger.kernel.org>; Sun,  8 Nov 2026 01:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=wuQLIrid
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 049021F0089F;
	Sun,  8 Nov 2026 01:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794102569;
	bh=PzH5O1Rq8jtMw3afyS/aAZhR1XNqFicLFkiQPIsEBak=;
	h=Date:To:Cc:From:Subject;
	b=wuQLIridhwfjt+GXUPJvafo3Brf2MKZNVcwR9SCXGH9vrtQm1H4SbLzZSz8iitTFc
	 ZEHkaxFp8KVRne3xhzlIcSXwxUw9YJnfM9lhhgVkC2cj/NnKk/cEjNgYsP7kQyyOd4
	 CT8a0hs5gx4tZ2lNFrkL/tv5q3OgPBjd4DwA2opw=
Date: Sat, 07 Nov 2026 17:49:28 -0800
To:
 mm-commits@vger.kernel.org, joannelkoong@gmail.com, akpm@linux-foundation.org
Cc: David Hildenbrand <david@kernel.org>
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-huge_memory-dont-queue-folios-when-underused-splitting-is-inactive.patch removed from -mm tree
Message-Id: <20261108014929.049021F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/huge_memory: don't queue folios when underused splitting is inactive
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-dont-queue-folios-when-underused-splitting-is-inactive.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Joanne Koong <joannelkoong@gmail.com>
Subject: mm/huge_memory: don't queue folios when underused splitting is inactive
Date: Tue, 03 Nov 2026 13:20:02 -0800

Every anonymous PMD-sized folio is put on the deferred split queue when
it is first mapped, so that the shrinker can find it under memory
pressure and split it if it turns out to be mostly zero-filled.

With the default khugepaged/max_ptes_none this is wasted work. The
default is HPAGE_PMD_NR - 1, which tells thp_underused() that any number
of zero-filled pages is tolerable, which means the shrinker will never
split any of these folios for being underused. They take the list_lru
lock at fault time, inflate the object count the shrinker reports, and
are then walked and dropped when they're first scanned.

Skip the queueing when khugepaged/max_ptes_none is at its maximum, and
factor that check out into thp_underused_never() so that
deferred_split_folio() and thp_underused() share it. Since the default
is the maximum, out of the box no folio is queued for underused
splitting at all, PMD-sized ones included. Partially mapped folios are
still queued as before.

This also matters for a subsequent patch that adds anonymous mTHP folios
to the deferred split list, as it keeps systems running the default from
paying for that on every anonymous fault.

Please note that the queue has always been best-effort. A folio that was
queued before khugepaged/max_ptes_none is lowered gets dropped from the
queue by the first scan that finds it's not underused, so changing the
sysctl has never retroactively applied to folios that were already
scanned. Requeueing eligible folios when the sysctl changes will be
addressed in a separate patch.

Link: https://lore.kernel.org/20261103212004.1356327-3-joannelkoong@gmail.com
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: David Hildenbrand <david@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
---

 mm/huge_memory.c |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-dont-queue-folios-when-underused-splitting-is-inactive
+++ a/mm/huge_memory.c
@@ -4556,6 +4556,15 @@ bool __folio_unqueue_deferred_split(stru
 	return unqueued;	/* useful for debug warnings */
 }
 
+/*
+ * At the sysctl maximum the user tolerates any number of zero-filled pages,
+ * so no folio is ever underused.
+ */
+static bool thp_underused_never(unsigned long max_ptes_none)
+{
+	return max_ptes_none == HPAGE_PMD_NR - 1;
+}
+
 /* partially_mapped=false won't clear PG_partially_mapped folio flag */
 void deferred_split_folio(struct folio *folio, bool partially_mapped)
 {
@@ -4571,8 +4580,17 @@ void deferred_split_folio(struct folio *
 	if (folio_order(folio) <= 1)
 		return;
 
-	if (!partially_mapped && !split_underused_thp)
-		return;
+	if (!partially_mapped) {
+		if (!split_underused_thp)
+			return;
+		/*
+		 * Nothing will ever split this folio for being underused, so
+		 * keep it off the queue entirely rather than paying for the
+		 * list_lru lock here and a shrinker scan later.
+		 */
+		if (thp_underused_never(khugepaged_max_ptes_none))
+			return;
+	}
 
 	/*
 	 * Exclude swapcache: originally to avoid a corrupt deferred split
@@ -4622,7 +4640,7 @@ static bool thp_underused(struct folio *
 	unsigned long max_ptes_none = khugepaged_max_ptes_none;
 	unsigned long i;
 
-	if (max_ptes_none == HPAGE_PMD_NR - 1)
+	if (thp_underused_never(max_ptes_none))
 		return false;
 
 	if (folio_contain_hwpoisoned_page(folio))
_

Patches currently in -mm which might be from joannelkoong@gmail.com are

memcg-reduce-cacheline-contention-between-lruvec-stat-updates-and-lru-lists.patch
memcg-dont-go-through-the-lruvec-for-folio-and-kmem-lruvec-stat-updates.patch
mm-huge_memory-add-a-per-order-counter-for-underused-splits.patch
mm-add-anonymous-mthp-folios-to-the-deferred-split-list.patch

