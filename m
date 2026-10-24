Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832343;
	b=ixffES7Gvj6jfidC7oKETyBrbvo2G66Su3cxNReJ2uP4c6t733yoFvOOiP2ynTzabmvD
	 zlYeIrPqMcwe4crbZMfgQ5UY8HALY2qyUzujT0mmqIpmPOrk8eUPtd7nnzIhFa6cpJ/Ie
	 hXnZhWigqYpix+wEdSLuM9ZMGOZ3A6xqaTP2oTVqTOsUkS0tK07QeSzhMLYwTGZoSmaJR
	 NmvjQtWpB6y0ehunAvl4zIwsif7EX6Kzb7Ta/e/95i2aI9KXclBJxG6pwza8p2XdV0vLR
	 5ixPctVv5O8a2UwYyDuY7H4iBsk2ZG5rwN10ral+J+0IM+PpiPwD/MLqZVGiL6XVEag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832343;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=3jUGtI0OlgNtvWmTRT6t0W9WvnpWPuTw0n/Hq8CvmWw=;
	b=Pc8XygenQKjhQHRN8DbT0/cm6VHLLiHwYbRxHGMwK+/YhfQbHIHutzeuPCzEE4UD/Ly3
	 CoWjaItD2onk0Mr4GUx3bcYCHHdVZ0TVH05n2jqKEYKucfl2ulrIUIbNxnfDLR+3vGQrZ
	 xXbz0qNIoG8fLau37dLXmDvg7JVy/Qnjr8gagwoiB8oYSwnEX87t2uVxdr5J92eGZPVyW
	 SbQC1yS0zUpGDgSdUksOJWV1YgtgNCdtQdvfhF9tO/QYp9tZahLZV617+cRN+5Ii0GCSS
	 kWT6sIgmsEA0JawZNyXpLibv6KIHM6bEMSeRikiwOhyGTmJrsyq06qV2sHWdpifAiiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=hQRqh0tg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03DB606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=hQRqh0tg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7305C1F01828;
	Sat, 24 Oct 2026 08:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832342;
	bh=3jUGtI0OlgNtvWmTRT6t0W9WvnpWPuTw0n/Hq8CvmWw=;
	h=Date:To:From:Subject;
	b=hQRqh0tgcaYXWfOuquAPSHUphDh5cLOGd9IzqsORX/TJmTtGjKU8e/iBeFgomfmnL
	 4MCLKQGF0klgNhDByJ57iEloFXnOzIJFgYPKffZMY5RKBTSnqMeLi8+l23khrA3QEx
	 pxEd+upolkPJRmP48oZ/2ygquU9oNKjathQQSzZ4=
Date: Sat, 24 Oct 2026 01:59:02 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rafael@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kbingham@kernel.org,kasong@tencent.com,jan.kiszka@siemens.com,hannes@cmpxchg.org,gregkh@linuxfoundation.org,dakr@kernel.org,brendan.jackman@linux.dev,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-move-__highest_used_section_nr-handling.patch removed from -mm tree
Message-Id: <20261024085902.7305C1F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/sparse: move __highest_used_section_nr handling
has been removed from the -mm tree.  Its filename was
     mm-sparse-move-__highest_used_section_nr-handling.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/sparse: move __highest_used_section_nr handling
Date: Mon, 21 Sep 2026 21:59:00 +0200

In preparation for removing __section_mark_present(), let's move
__highest_used_section_nr handling into its callers.  Verify in
sparse_init_one_section() that it was properly updated.

In sparse_sections_init() we can just set it to the last processed
section_nr.

No functional change intended.

Link: https://lore.kernel.org/20260921-b4-sparsemem_cleanups-v2-8-54d81d65e125@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Lorenzo Stoakes <ljs@kernel.org>
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

 mm/sparse-vmemmap.c |    1 +
 mm/sparse.c         |    5 +++--
 mm/sparse.h         |    4 +---
 3 files changed, 5 insertions(+), 5 deletions(-)

--- a/mm/sparse.c~mm-sparse-move-__highest_used_section_nr-handling
+++ a/mm/sparse.c
@@ -177,7 +177,7 @@ static inline unsigned long first_presen
 
 void __init sparse_sections_init(void)
 {
-	unsigned long pfn, start_pfn, end_pfn;
+	unsigned long pfn, start_pfn, end_pfn, section_nr;
 	int i, nid;
 
 	sparse_extreme_init();
@@ -187,9 +187,9 @@ void __init sparse_sections_init(void)
 		mminit_validate_memmodel_limits(&start_pfn, &end_pfn);
 
 		for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
-			unsigned long section_nr = pfn_to_section_nr(pfn);
 			struct mem_section *ms;
 
+			section_nr = pfn_to_section_nr(pfn);
 			sparse_index_init(section_nr, nid);
 			ms = __nr_to_section(section_nr);
 			if (ms->section_mem_map)
@@ -201,6 +201,7 @@ void __init sparse_sections_init(void)
 			__section_mark_present(ms, section_nr);
 		}
 	}
+	__highest_used_section_nr = section_nr;
 }
 #ifndef CONFIG_SPARSEMEM_VMEMMAP
 struct page __init *__populate_section_memmap(unsigned long pfn,
--- a/mm/sparse.h~mm-sparse-move-__highest_used_section_nr-handling
+++ a/mm/sparse.h
@@ -26,6 +26,7 @@ static inline void sparse_init_one_secti
 	unsigned long coded_mem_map;
 
 	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > PFN_SECTION_SHIFT);
+	VM_WARN_ON_ONCE(section_nr > __highest_used_section_nr);
 
 	/*
 	 * We encode the start PFN of the section into the mem_map such that
@@ -44,9 +45,6 @@ static inline void sparse_init_one_secti
 static inline void __section_mark_present(struct mem_section *ms,
 		unsigned long section_nr)
 {
-	if (section_nr > __highest_used_section_nr)
-		__highest_used_section_nr = section_nr;
-
 	ms->section_mem_map |= SECTION_MARKED_PRESENT;
 }
 
--- a/mm/sparse-vmemmap.c~mm-sparse-move-__highest_used_section_nr-handling
+++ a/mm/sparse-vmemmap.c
@@ -904,6 +904,7 @@ int __meminit sparse_add_section(int nid
 		page_init_poison(memmap, sizeof(struct page) * nr_pages);
 
 	__section_mark_present(ms, section_nr);
+	__highest_used_section_nr = max(section_nr, __highest_used_section_nr);
 
 	/* Align memmap to section boundary in the subsection case */
 	if (section_nr_to_pfn(section_nr) != start_pfn)
_

Patches currently in -mm which might be from david@kernel.org are

mm-fix-address-wraparound-when-scanning-large-folio-ptes.patch
mm-hugetlb-disable-pmd-sharing-for-uffd-missing-mode.patch
mm-vma-write-lock-source-vma-before-duplicating-it-in-__split_vma.patch
mm-madvise-preserve-vma_softdirty_bit-when-changing-anonymous-names.patch

