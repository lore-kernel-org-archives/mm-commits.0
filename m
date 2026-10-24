Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832338;
	b=bSzEHJttMkCcWopHiG/ZezVgeqLeBl+TXOpf2+SpoJ5oEpblVPf4psQXl62q7vNS8vnm
	 6fQLkGMFq4quGoT14qI/O5FQjKnxbPiKUXWooSyMA31Izn3ZSVbSLkcJry+29D8pK95Ez
	 cuVp+OsPrZVsABWmc0oemlZsYf92V2j9y67EQBewoxnYYczWKtjZ84ZHgKWp4UscgkGOd
	 +/VDZK49LTCKHO7arhmscelR1F+tkCLIyOIqWbz6Ad9MAUurPBIhzEW4dtLEGbO/Gb+cF
	 hIcE0bU5xoPsk5OkAy7VuBST4ddRyBRRkIO4JAjC6y8DfPHGHz8llKrOdoEDxDPKlQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832338;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=dVa4eT8Aa2mtlBmnOj2vrigDoXIDemBKJfUuGRGEj+I=;
	b=oDx/OP3Vq2g8HC9/4NMPoQzMvQzUJfSfWRacyQcmBnB9vUQSU2VTxvYyxpDCl0fKqRb1
	 IzcHdqI1J1iZ+z/Tpm2v1pFBVUc1zzwSZMJcxVuXuObC9W2p58nNBkngrTWMZNVMHBobu
	 cfbdTona+zdaS2ZUivCTLA1y1hJv2p4//1JbEJs7xAH4Qaeju3mcwQxOdMQhsk3cEgXS3
	 VpwkpkRihU4TxtAzyCh+ng5QBb/Lfc0mh/NTcDaV13YDofzD2aexuN2uvLAzjqDlAqGwf
	 /VUKyLxvKRL08V9UuBcS+9YkdqalGz499ewts+ysCDqD//EoqRKlARsDL64cxYdtIgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=13X6HlRW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8389F606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=13X6HlRW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47FDA1F01828;
	Sat, 24 Oct 2026 08:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832338;
	bh=dVa4eT8Aa2mtlBmnOj2vrigDoXIDemBKJfUuGRGEj+I=;
	h=Date:To:From:Subject;
	b=13X6HlRWi/tQweS/sT6OIV7WG7ekaiFsVfbiu4YCHt4Yn8glZOLZMWzC3i/V1TD6x
	 2fXxu6gFEbO7LHv4BhWIL2wDG/UWPVng6zBU/YwNRQ9/q6WI8cIiTrYu5c19se14YC
	 gYh8SpfOyGmvwbLXbZp6awE2baExHITCCYGcY8S8=
Date: Sat, 24 Oct 2026 01:58:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rafael@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kbingham@kernel.org,kasong@tencent.com,jan.kiszka@siemens.com,hannes@cmpxchg.org,gregkh@linuxfoundation.org,dakr@kernel.org,brendan.jackman@linux.dev,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-rename-and-cleanup-sparse_init_nid.patch removed from -mm tree
Message-Id: <20261024085858.47FDA1F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/sparse: rename and cleanup sparse_init_nid()
has been removed from the -mm tree.  Its filename was
     mm-sparse-rename-and-cleanup-sparse_init_nid.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/sparse: rename and cleanup sparse_init_nid()
Date: Mon, 21 Sep 2026 21:58:56 +0200

Let's rename it to "sparse_metadata_init_nid", avoid the "pnum"
terminology and drop the function comment.  Further, rename the "map"
variable to "mem_map" for consistency with other functions.

Link: https://lore.kernel.org/20260921-b4-sparsemem_cleanups-v2-4-54d81d65e125@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
---

 mm/sparse.c |   41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

--- a/mm/sparse.c~mm-sparse-rename-and-cleanup-sparse_init_nid
+++ a/mm/sparse.c
@@ -221,36 +221,33 @@ void __weak __meminit vmemmap_populate_p
 {
 }
 
-/*
- * Initialize sparse on a specific node. The node spans [pnum_begin, pnum_end)
- * And number of present sections in this node is map_count.
- */
-static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
-				   unsigned long pnum_end,
-				   unsigned long map_count)
+static void __init sparse_metadata_init_nid(int nid,
+		unsigned long start_section_nr, unsigned long end_section_nr,
+		unsigned long nr_sections)
 {
-	unsigned long pnum;
 	struct mem_section_usage *usage;
+	unsigned long section_nr;
 
-	usage = memblock_alloc_node(map_count * mem_section_usage_size(),
+	usage = memblock_alloc_node(nr_sections * mem_section_usage_size(),
 				    SMP_CACHE_BYTES, nid);
 	if (!usage)
 		panic("Failed to allocate usemap for node %d\n", nid);
 
-	for_each_present_section_nr(pnum_begin, pnum) {
-		unsigned long pfn = section_nr_to_pfn(pnum);
-		struct page *map;
+	for_each_present_section_nr(start_section_nr, section_nr) {
+		const unsigned long pfn = section_nr_to_pfn(section_nr);
+		struct page *mem_map;
 
-		if (pnum >= pnum_end)
+		if (section_nr >= end_section_nr)
 			break;
 
-		map = __populate_section_memmap(pfn, PAGES_PER_SECTION,
-						nid, NULL, NULL);
-		if (!map)
-			panic("Failed to allocate memmap for section %lu\n", pnum);
+		mem_map = __populate_section_memmap(pfn, PAGES_PER_SECTION, nid,
+						    NULL, NULL);
+		if (!mem_map)
+			panic("Failed to allocate memmap for section %lu\n",
+			      section_nr);
 		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION));
-		sparse_init_one_section(__nr_to_section(pnum), pnum, map, usage,
-					SECTION_IS_EARLY);
+		sparse_init_one_section(__nr_to_section(section_nr), section_nr,
+					mem_map, usage, SECTION_IS_EARLY);
 		usage = (void *)usage + mem_section_usage_size();
 	}
 }
@@ -268,12 +265,14 @@ static void __init sparse_metadata_init(
 			nr_sections++;
 			continue;
 		}
-		sparse_init_nid(nid_begin, start_section_nr, section_nr, nr_sections);
+		sparse_metadata_init_nid(nid_begin, start_section_nr,
+					 section_nr, nr_sections);
 		nid_begin = nid;
 		start_section_nr = section_nr;
 		nr_sections = 1;
 	}
-	sparse_init_nid(nid_begin, start_section_nr, section_nr, nr_sections);
+	sparse_metadata_init_nid(nid_begin, start_section_nr, section_nr,
+				 nr_sections);
 }
 
 /*
_

Patches currently in -mm which might be from david@kernel.org are

mm-fix-address-wraparound-when-scanning-large-folio-ptes.patch
mm-hugetlb-disable-pmd-sharing-for-uffd-missing-mode.patch
mm-vma-write-lock-source-vma-before-duplicating-it-in-__split_vma.patch
mm-madvise-preserve-vma_softdirty_bit-when-changing-anonymous-names.patch

