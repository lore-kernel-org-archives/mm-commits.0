Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832336;
	b=1qfjHc5vna74AJetr8OZneBjuxvLbj2/4WClpiZlFBIvEfCpFMfVuXLepqoQwnJwWhyC
	 m7VbXWTSQajIsiYOyjGEGKp3PVGRePHwa5qBbXCc3jjLz+2VVDjzCpBdWB0ZmGpt8ByHj
	 i7vMdF+/QmnoLosSxZeJmVAkMYsis3Oum5Q0YB9brJN2JUz4ajh0CJ7Kmx3Dm716rxQgW
	 Y5I7r0ukHMEOlbfrV2VOSj+um6Js6QqKlXNauL6Dwxe/BJG3/NfoY1DPDmbJR3zb9l4Sa
	 rJWALXGuYbGA/osBEPsTC4mP/gGFG23ZjCgF0jzm7iNNVLlOjVEEBXvmg5lh26xjyKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832336;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=KhblCQWNT95QO8fWkPPFHqBagBsqnvFH3jQipCCYdZs=;
	b=fXDc8o62D9IDS/93+ANpL/Rj9jsDfRtZO+cqSmb7IFGyvh5nygaNWq/HqI2i90LE8xzx
	 q07VCnfZOTBuWwBvMi3gY8B05PD/Gwa1AveIw+1iyZ1UARH/TrMqA9NPGpQP4o0bKZOlv
	 9oEfS68Vu4snK/n9w5SuuZ9WIwAhKtzlwYet2cUc+yrbtY3LrN3Dcdv+NHI5Mi1KIiyxM
	 bpdDL8JCc1lsA5g5OF0KEYihZtIu2svK1DyZRs96lKsw3rDHH0GbN9s6dhymakBaaLfqR
	 lzVzzMp7lt1CDU1mN+AtHEvPs0VmIfz7gVajrNdps97qns8VO0Uvn0JYjBCwVNLMTqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=iwLSgggc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F6D606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=iwLSgggc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2750C1F01828;
	Sat, 24 Oct 2026 08:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832336;
	bh=KhblCQWNT95QO8fWkPPFHqBagBsqnvFH3jQipCCYdZs=;
	h=Date:To:From:Subject;
	b=iwLSgggcdcw4dKwDWT4P3sgnbpKUUGau8I000YEey7DHWVhKFGNz+CbdK424AjPRh
	 Jq3OLNb2qb7KX73jOupnyiOHpS0QZ6tuSfh15JYZuzyaxn+YJdwFOjKdChNAaTIH8o
	 yHSqWqW+HLPUyrtnejsPRrFw2lz6nuH77+e2owN0=
Date: Sat, 24 Oct 2026 01:58:55 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rafael@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kbingham@kernel.org,kasong@tencent.com,jan.kiszka@siemens.com,hannes@cmpxchg.org,gregkh@linuxfoundation.org,dakr@kernel.org,brendan.jackman@linux.dev,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-refactor-sparse_sections_init.patch removed from -mm tree
Message-Id: <20261024085856.2750C1F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/sparse: refactor sparse_sections_init()
has been removed from the -mm tree.  Its filename was
     mm-sparse-refactor-sparse_sections_init.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/sparse: refactor sparse_sections_init()
Date: Mon, 21 Sep 2026 21:58:54 +0200

memory_present() really identifies+prepares all early sections so the
initialization in sparse_init() can properly iterating them to initialize
metadata.

Let's just inline memory_present() into sparse_sections_init() and
cleaning up the code a bit while at it: make it clear that we are
operating on pfns.

Note that we call set_section_nid() now only if the section was not
already created earlier.  Now, there is no more inconsistency between what
we (temporarily) store in ms->section_mem_map and what we store in our
section->nid array.

Link: https://lore.kernel.org/20260921-b4-sparsemem_cleanups-v2-2-54d81d65e125@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
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

 mm/sparse.c |   41 +++++++++++++++++------------------------
 1 file changed, 17 insertions(+), 24 deletions(-)

--- a/mm/sparse.c~mm-sparse-refactor-sparse_sections_init
+++ a/mm/sparse.c
@@ -179,40 +179,33 @@ static inline unsigned long first_presen
 	return next_present_section_nr(-1);
 }
 
-/* Record a memory area against a node. */
-static void __init memory_present(int nid, unsigned long start, unsigned long end)
+void __init sparse_sections_init(void)
 {
-	unsigned long pfn;
+	unsigned long pfn, start_pfn, end_pfn;
+	int i, nid;
 
-	start &= PAGE_SECTION_MASK;
-	mminit_validate_memmodel_limits(&start, &end);
-	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION) {
-		unsigned long section_nr = pfn_to_section_nr(pfn);
-		struct mem_section *ms;
+	sparse_extreme_init();
 
-		sparse_index_init(section_nr, nid);
-		set_section_nid(section_nr, nid);
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
+		start_pfn &= PAGE_SECTION_MASK;
+		mminit_validate_memmodel_limits(&start_pfn, &end_pfn);
+
+		for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
+			unsigned long section_nr = pfn_to_section_nr(pfn);
+			struct mem_section *ms;
+
+			sparse_index_init(section_nr, nid);
+			ms = __nr_to_section(section_nr);
+			if (ms->section_mem_map)
+				continue;
 
-		ms = __nr_to_section(section_nr);
-		if (!ms->section_mem_map) {
+			set_section_nid(section_nr, nid);
 			ms->section_mem_map = sparse_encode_early_nid(nid) |
 							SECTION_IS_ONLINE;
 			__section_mark_present(ms, section_nr);
 		}
 	}
 }
-
-void __init sparse_sections_init(void)
-{
-	unsigned long start, end;
-	int i, nid;
-
-	sparse_extreme_init();
-
-	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, &nid)
-		memory_present(nid, start, end);
-}
-
 #ifndef CONFIG_SPARSEMEM_VMEMMAP
 struct page __init *__populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
_

Patches currently in -mm which might be from david@kernel.org are

mm-fix-address-wraparound-when-scanning-large-folio-ptes.patch
mm-hugetlb-disable-pmd-sharing-for-uffd-missing-mode.patch
mm-vma-write-lock-source-vma-before-duplicating-it-in-__split_vma.patch
mm-madvise-preserve-vma_softdirty_bit-when-changing-anonymous-names.patch

