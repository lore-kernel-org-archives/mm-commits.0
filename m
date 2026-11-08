Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794102571;
	b=dH3gg9sr5iJn9Ay6sekQO+MtJUBPj5Dikn1X5LlqG3PPDcevWttYo3cYi+kEz8+NzwjO
	 9oXkFUemyvmYy4nPFudjiaC93JlQS7Sqlv+TvR8JPt1fJu1OSBl46u8yLfVgscl9JEvP2
	 LYQLmqHRvT3IOcJzXTHIEsbP5NXDtPfMDTgjD4mcxciH1os/J+c4lUtYZr4F5WHC8hfgT
	 MsyNyqPrzFBg4tUlDfCm51kN7nGGrWhqnKeYVWriZbbvv7rMtATCd0R3uyC3TMZd4trb8
	 lD190DjX3WNQ0945IjyMkpCGGGPYBdzmISiyPVEu4726aqqdP5JBzmLGrpwE51O+s4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794102571;
	h=Received:DKIM-Signature:Date:To:Cc:From:Subject:Message-Id;
	bh=gW6jcZOhyfa9k5z3yjwKkgfZv+BIgHS0TC7+urWNEFs=;
	b=WQ/zJVE1zQeYFyewG+QszKDiwBLHjjgOicNWkbDUBsbzbccoqzP8XAzJuC7DPjNG00ea
	 T1/b8DzGQ8M5Z8bHyVLa/baauvhWCTmRTc2PbZAxEmyX0rPF317sj1l2UVtRfjLqAkDu2
	 IkP5MFMOt/i4hgu5epg7rggT6M6TFuQJh0zcnPC/XAXi4i0B5zMZ5Vk8uOnH3pmyi5YEe
	 Co9dr7/9X1IuOfY49axNEnJxVo4Pdh+iS9hR9Hv0ZBhWRMiWNg81uOFi2WX333znJw2dH
	 FSgn+lY1/HeZrs3gQQxtEyl7R7SDyEL/1AEigi1g/N4jVKqoA5JioLpoTx64bInSLYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="bPkbMK/K";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0BD606A334
	for <mm-commits@vger.kernel.org>; Sun,  8 Nov 2026 01:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=bPkbMK/K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1AA1F008A1;
	Sun,  8 Nov 2026 01:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794102570;
	bh=gW6jcZOhyfa9k5z3yjwKkgfZv+BIgHS0TC7+urWNEFs=;
	h=Date:To:Cc:From:Subject;
	b=bPkbMK/KrHv5pfIpSoIHBqI0r4FGRoPTyMRnt7R6Yk0/G10LxgOLqErZwYOcyNdir
	 UF83DKXG1R4OUWh1mqkJ0PH+2KiXxHOD/5wS5JfS3EcEi+f8Ajxn2UgLul6HhRRzne
	 dieUKhbaBBOob5E1oZP0rChOipA/vNS3KPxEcJCE=
Date: Sat, 07 Nov 2026 17:49:30 -0800
To:
 mm-commits@vger.kernel.org, joannelkoong@gmail.com, akpm@linux-foundation.org
Cc: David Hildenbrand <david@kernel.org>
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-huge_memory-add-a-per-order-counter-for-underused-splits.patch removed from -mm tree
Message-Id: <20261108014930.8B1AA1F008A1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/huge_memory: add a per-order counter for underused splits
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-add-a-per-order-counter-for-underused-splits.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Joanne Koong <joannelkoong@gmail.com>
Subject: mm/huge_memory: add a per-order counter for underused splits
Date: Tue, 03 Nov 2026 13:20:03 -0800

thp_underused_split_page counts every folio that the deferred split
shrinker splits for being underused. Today that is only ever a
PMD-sized folio, but a later patch queues anonymous mTHP folios for
underused splitting too, at which point this counter would start
counting mTHP splits as well.

thp_underused_split_page could then end up larger than thp_split_page,
and there would be no per-order count of underused splits. That doesn't
match how the other THP split stats work. In /proc/vmstat,
thp_split_page and thp_deferred_split_page only count PMD-sized folios.
Splits of every size, PMD included, are counted per order in the split
and split_deferred stats under hugepages-<size>/stats/.

Do the same for underused splits. Only count PMD-sized folios in
thp_underused_split_page, and add a per-order split_underused stat that
counts underused splits of every size. The folio's order has to be read
before splitting it, since the folio is no longer large once the split
succeeds.

There is no functional change to thp_underused_split_page yet, as only
PMD-sized folios are split for being underused today.

Link: https://lore.kernel.org/20261103212004.1356327-4-joannelkoong@gmail.com
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
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

 Documentation/admin-guide/mm/transhuge.rst |    6 ++++++
 include/linux/huge_mm.h                    |    1 +
 mm/huge_memory.c                           |    9 +++++++--
 3 files changed, 14 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-huge_memory-add-a-per-order-counter-for-underused-splits
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -719,6 +719,12 @@ split_deferred
         it would free up some memory. Pages on split queue are going to
         be split under memory pressure, if splitting is possible.
 
+split_underused
+	is incremented when a huge page on the split queue was split
+	because it was underused. This happens when the number of zero-filled
+	pages in the huge page is above a certain threshold scaled from
+	/sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none.
+
 nr_anon
        the number of anonymous THP we have in the whole system. These THPs
        might be currently entirely mapped or have partially unmapped/unused
--- a/include/linux/huge_mm.h~mm-huge_memory-add-a-per-order-counter-for-underused-splits
+++ a/include/linux/huge_mm.h
@@ -141,6 +141,7 @@ enum mthp_stat_item {
 	MTHP_STAT_SPLIT,
 	MTHP_STAT_SPLIT_FAILED,
 	MTHP_STAT_SPLIT_DEFERRED,
+	MTHP_STAT_SPLIT_UNDERUSED,
 	MTHP_STAT_NR_ANON,
 	MTHP_STAT_NR_ANON_PARTIALLY_MAPPED,
 	MTHP_STAT_COLLAPSE_EXCEED_SWAP,
--- a/mm/huge_memory.c~mm-huge_memory-add-a-per-order-counter-for-underused-splits
+++ a/mm/huge_memory.c
@@ -822,6 +822,7 @@ DEFINE_MTHP_STAT_ATTR(shmem_fallback_cha
 DEFINE_MTHP_STAT_ATTR(split, MTHP_STAT_SPLIT);
 DEFINE_MTHP_STAT_ATTR(split_failed, MTHP_STAT_SPLIT_FAILED);
 DEFINE_MTHP_STAT_ATTR(split_deferred, MTHP_STAT_SPLIT_DEFERRED);
+DEFINE_MTHP_STAT_ATTR(split_underused, MTHP_STAT_SPLIT_UNDERUSED);
 DEFINE_MTHP_STAT_ATTR(nr_anon, MTHP_STAT_NR_ANON);
 DEFINE_MTHP_STAT_ATTR(nr_anon_partially_mapped, MTHP_STAT_NR_ANON_PARTIALLY_MAPPED);
 DEFINE_MTHP_STAT_ATTR(collapse_exceed_swap_pte, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
@@ -842,6 +843,7 @@ static struct attribute *anon_stats_attr
 	&swpout_fallback_attr.attr,
 #endif
 	&split_deferred_attr.attr,
+	&split_underused_attr.attr,
 	&nr_anon_attr.attr,
 	&nr_anon_partially_mapped_attr.attr,
 	&collapse_exceed_swap_pte_attr.attr,
@@ -4788,8 +4790,11 @@ static unsigned long deferred_split_scan
 			goto requeue;
 		if (!split_folio(folio)) {
 			did_split = true;
-			if (underused)
-				count_vm_event(THP_UNDERUSED_SPLIT_PAGE);
+			if (underused) {
+				if (is_pmd_order(order))
+					count_vm_event(THP_UNDERUSED_SPLIT_PAGE);
+				count_mthp_stat(order, MTHP_STAT_SPLIT_UNDERUSED);
+			}
 			split++;
 		}
 		folio_unlock(folio);
_

Patches currently in -mm which might be from joannelkoong@gmail.com are

memcg-reduce-cacheline-contention-between-lruvec-stat-updates-and-lru-lists.patch
memcg-dont-go-through-the-lruvec-for-folio-and-kmem-lruvec-stat-updates.patch
mm-add-anonymous-mthp-folios-to-the-deferred-split-list.patch

