Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794102573;
	b=WgJS0qHcB7CaAn4A35hS6FPS/pInAtb3834ujE/y2pUxj5KLuC9LNvN/9WhNAk4gOWiS
	 l0d/5IrKGhryBFpVUNgIoGPEDg492g4KB58x8bLjLfTyvFzwdQv/E7RQr1zYMxp6HzwnE
	 S9Njhcapbrch5EcWuE2W8gtZIiZZvdSgUhvS9j+HIrOoq7t35d3d2IP7KWc3IiGpS++LM
	 dVkL9XK3W3C23kwBUU++oQkFXtKNlQkBcoDUox1Z+QmXGLf3UoJN+z5B3Axo+C2gHn1Y1
	 d12epmCgARh2VGdhkb51hiD6CYKz64RNHH00ND0Vq8nAEujH/dbIfw0fDtjpPpoJuDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794102573;
	h=Received:DKIM-Signature:Date:To:Cc:From:Subject:Message-Id;
	bh=5/CjP3MncBHHmbzlFmRz0vqQ8mCJR+tNJvnOJsrj4MI=;
	b=d2gGcdQ3EE86XCvbJUmQv5cxdjkZXh5N6EqXC2GKnSnYRIT0F87fBFalOVqewRZsV8ck
	 aVYbL6mMF5ioulKFrp+FCdtczQexB2SXaj2QOpVPU17gtGbZGTZLpNdc3Mhosdn8q8Pzy
	 J154IRU5vOCUKwQXTMHDKZ853LuJkvzwI5zPjsPu0koW9cXH+xrOLew2ljTIMXkYdkPFq
	 7J0zN7FfStP/PxybPymyjHb1Y6PwaLTGR+Tpg4+KyP49/Wsce3e3RIrJlo1QWONfa28/u
	 TN1bGMOVK6dMOhImO+cn6/0006FFWVOE+Nt5eneoXXPKNYF0AUa5TAu0en3V+qjU8KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=kgofydUA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D946606A31C
	for <mm-commits@vger.kernel.org>; Sun,  8 Nov 2026 01:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=kgofydUA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D26931F0089F;
	Sun,  8 Nov 2026 01:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794102572;
	bh=5/CjP3MncBHHmbzlFmRz0vqQ8mCJR+tNJvnOJsrj4MI=;
	h=Date:To:Cc:From:Subject;
	b=kgofydUAEYmLVU8zi5G/BVnSZy7QhBphKBb488Udue5taaydQWcfNdJQkTncYbir+
	 fOGTQYUJPxrEiQuGG7CCTrPykfKO3MIU2W2DmMJ6WIQGjGpWvypcbw2nVuUI6MoV01
	 Bpxt2fVhijMA/xyddz5MLTf7scohHDebGNAtVzDk=
Date: Sat, 07 Nov 2026 17:49:32 -0800
To:
 mm-commits@vger.kernel.org, joannelkoong@gmail.com, akpm@linux-foundation.org
Cc: David Hildenbrand <david@kernel.org>
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-add-anonymous-mthp-folios-to-the-deferred-split-list.patch removed from -mm tree
Message-Id: <20261108014932.D26931F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: add anonymous mTHP folios to the deferred split list
has been removed from the -mm tree.  Its filename was
     mm-add-anonymous-mthp-folios-to-the-deferred-split-list.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Joanne Koong <joannelkoong@gmail.com>
Subject: mm: add anonymous mTHP folios to the deferred split list
Date: Tue, 03 Nov 2026 13:20:04 -0800

Unlike for PMD-sized folios, an anonymous mTHP folio doesn't get added
to the deferred split list at fault or collapse time. As a result, a
fully mapped mTHP folio that is mostly zero-filled doesn't get split by
the deferred split shrinker when the system is under memory pressure.

At Meta we would like to deploy 2M THP=always on arm64 with 64k base
pages, as 2M gives the contpte benefits while the PMD size (512M) is too
big to use. Without underused splitting this causes memory regressions,
as the unused parts of those folios can never be broken down and
reclaimed.

Add anonymous mTHP folios to the deferred split list from
map_anon_folio_pte_nopf(), mirroring what map_anon_folio_pmd_nopf()
already does for PMD-sized folios. This covers both the fault path and
the khugepaged mTHP collapse path. If there is memory pressure, a
zero-filled mTHP can then be split with its zero pages remapped to the
shared zero page and reclaimed.

Only queue mTHP folios of at least 2M for underused splitting. With
thp_underused() scaling khugepaged/max_ptes_none to the folio size, any
folio of order 2 or above could in principle be underused, but for small
folios it is unlikely to be worth it. An order-2 folio on 4k base pages
can free at most four pages and on systems that only enable small mTHP
sizes (eg Android's order-2-only configuration) zero-filled subpages
tend to be few and short-lived.

The minimum is hard-coded rather than a knob, since admins have no good
way of choosing it, and is a size rather than an order since what a
split recovers depends on the folio's size in bytes, and the same order
means very different sizes across different base page sizes. It can be
lowered later if data shows smaller sizes are worth it. PMD-sized folios
are exempt from the minimum in order to maintain backwards compatibility
since on some architectures (s390, with a 1M PMD) the PMD size can be
below 2M.

To minimize overhead on the common order-0 fault path, the
deferred_split_folio() call is guarded by an inline folio_test_large()
check.

Link: https://lore.kernel.org/20261103212004.1356327-5-joannelkoong@gmail.com
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
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

 mm/huge_memory.c |   14 ++++++++++++++
 mm/memory.c      |    2 ++
 2 files changed, 16 insertions(+)

--- a/mm/huge_memory.c~mm-add-anonymous-mthp-folios-to-the-deferred-split-list
+++ a/mm/huge_memory.c
@@ -4567,6 +4567,13 @@ static bool thp_underused_never(unsigned
 	return max_ptes_none == HPAGE_PMD_NR - 1;
 }
 
+/*
+ * Smallest mTHP folio that is queued for underused splitting. Kept
+ * conservative, as small folios are unlikely to free enough memory to be
+ * worth queueing and scanning.
+ */
+#define THP_UNDERUSED_MIN_SIZE	SZ_2M
+
 /* partially_mapped=false won't clear PG_partially_mapped folio flag */
 void deferred_split_folio(struct folio *folio, bool partially_mapped)
 {
@@ -4592,6 +4599,13 @@ void deferred_split_folio(struct folio *
 		 */
 		if (thp_underused_never(khugepaged_max_ptes_none))
 			return;
+		/*
+		 * Keep queueing PMD-sized folios as before, even where the PMD
+		 * size is below the minimum (eg 1M on s390).
+		 */
+		if (folio_size(folio) < THP_UNDERUSED_MIN_SIZE &&
+		    !is_pmd_order(folio_order(folio)))
+			return;
 	}
 
 	/*
--- a/mm/memory.c~mm-add-anonymous-mthp-folios-to-the-deferred-split-list
+++ a/mm/memory.c
@@ -5472,6 +5472,8 @@ void map_anon_folio_pte_nopf(struct foli
 	folio_add_lru_vma(folio, vma);
 	set_ptes(vma->vm_mm, addr, pte, entry, nr_pages);
 	update_mmu_cache_range(NULL, vma, addr, pte, nr_pages);
+	if (folio_test_large(folio))
+		deferred_split_folio(folio, false);
 }
 
 static void map_anon_folio_pte_pf(struct folio *folio, pte_t *pte,
_

Patches currently in -mm which might be from joannelkoong@gmail.com are

memcg-reduce-cacheline-contention-between-lruvec-stat-updates-and-lru-lists.patch
memcg-dont-go-through-the-lruvec-for-folio-and-kmem-lruvec-stat-updates.patch

