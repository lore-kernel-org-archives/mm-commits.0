Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792686813;
	b=efDa+Gudy64qBRW3baDJckKMjcCOkYkbvSGTbkrBJYY9YPms/BLCErnAtvpEQSqxYxT3
	 SpI6FMJ9FTCl+njLeBgSsSmiR7MEQhZK6iUaHN1AQ4kQ96hjIUizegioKBrg8mxAUtdlU
	 SlFQT6W2mK2tkocwnt9mIrAm/pVmCJNVcsb7PAjXgeNZkYrISvXDYSzgbYcl4rgriKUNX
	 fRa2dzmnoBXm+lrlWN7zR9zxQOdofmVQubx1RhBs156ArD54wpQxjGzSeyqndfsK2pvQZ
	 Ru0sel9WFnwW+4GG2ko7TD59J+wirDwDBKDaKEOlnx0Hw6lXqsPVgMUVRm3ge5r7A6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792686813;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Jra6vwfFJoJgBBbvOxpVOEvGYDp9HxQqbq5v4awEj3U=;
	b=nbp7e/9GwWmAh9V+JCJQMXVHXfpQRcXMEAoaCV7h6N8x68bMzXflWXgliTdabuwdjPCA
	 CQKuq8j81iJc++OyQB1n7OqVJ6L7FWSNb/Of81vCTColPQ1hpOscR/dBSDMjXoiq+BKXu
	 jl4yA7tmKLzKuedzChY0wnpDPbv+4y/OMwv0KMe9QAB4EzLbXjErZYiCQsYJabP+XfQia
	 FtBlx51KTXmgaN5UIE5wHzaVe6z0kDzpVzklEClrwfvZ7lUHgfMXCA8aQDeWJLeoWQ3ym
	 szTKB6rEhJ9at1m+vzoC8eFIM+3MMj0Mf7bri+/xpxTxIIJZEQ6QRE9vzKiThuLuxtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ShbDaLcL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A3D606A319;
	Thu, 22 Oct 2026 16:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ShbDaLcL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990531F01829;
	Thu, 22 Oct 2026 16:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792686812;
	bh=Jra6vwfFJoJgBBbvOxpVOEvGYDp9HxQqbq5v4awEj3U=;
	h=Date:To:From:Subject;
	b=ShbDaLcLH9rcANzm5H2Aub48M0JyeW3++jgZn0vvxUUWCzhNjOWOdRX9Q5LBJBuh0
	 q6cd/N7yDvEyI5uWWG6/A9TncVkXKLWz9iGdNt3YslzDHIQoS+5VnyKmIxNTh1grG1
	 uRAt6VAla1ngEfO3oFiQgloDfQcXaIUOAkQc46CA=
Date: Thu, 22 Oct 2026 09:33:32 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,peterx@redhat.com,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,azpijr@gmail.com,lizhe.67@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-mremap-deadlock-when-pmd-sharing-is-possible.patch added to mm-unstable branch
Message-Id: <20261022163332.990531F01829@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/hugetlb: fix mremap deadlock when PMD sharing is possible
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-fix-mremap-deadlock-when-pmd-sharing-is-possible.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-mremap-deadlock-when-pmd-sharing-is-possible.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Li Zhe <lizhe.67@bytedance.com>
Subject: mm/hugetlb: fix mremap deadlock when PMD sharing is possible
Date: Thu, 22 Oct 2026 11:45:43 +0800

move_hugetlb_page_tables() holds the mapping's i_mmap_rwsem for
write while moving hugetlb PTEs. This prevents races with truncation
and protects huge_pmd_unshare(), but the move loop must not call
helpers that can acquire the same rwsem for read.

huge_pte_alloc() can do that when the destination can use PMD
sharing: it may call huge_pmd_share(), which takes i_mmap_rwsem for
read while searching for a shareable PMD table. Calling it while the
move path already holds i_mmap_rwsem for write can deadlock.

Avoid that path for PMD-sized hugetlb mappings that can use PMD
sharing. Instead of allocating or sharing the destination page table
while moving, zap the source range and let the destination fault path
populate or share the PMD lazily.

Reuse the hugetlb unmap logic for the source-side zap by splitting
the core loop out of __unmap_hugepage_range(). The wrapper keeps the
existing tlb_start_vma(), tlb_end_vma() and huge_pmd_unshare_flush()
behavior, while move_hugetlb_page_tables() can reuse the unmap loop
with its existing mmu_gather.

Link: https://lore.kernel.org/20261022034543.51226-4-lizhe.67@bytedance.com
Fixes: 550a7d60bd5e ("mm, hugepages: add mremap() support for hugepage backed vma")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Cc: <stable@vger.kernel.org>
---

 mm/hugetlb.c |   47 +++++++++++++++++++++++++++++++++++++----------
 1 file changed, 37 insertions(+), 10 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-mremap-deadlock-when-pmd-sharing-is-possible
+++ a/mm/hugetlb.c
@@ -137,6 +137,10 @@ static int __huge_pmd_unshare(struct mmu
 		bool check_locks);
 static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end, bool take_locks);
+static void hugetlb_unmap_range(struct mmu_gather *tlb,
+				struct vm_area_struct *vma, unsigned long start,
+				unsigned long end, struct folio *folio,
+				zap_flags_t zap_flags);
 static struct resv_map *vma_resv_map(struct vm_area_struct *vma);
 
 static inline bool subpool_is_free(struct hugepage_subpool *spool)
@@ -5238,6 +5242,8 @@ unsigned long move_hugetlb_page_tables(s
 	for (; old_addr < old_end; old_addr += sz, new_addr += sz) {
 		const unsigned long offset_to_last_entry =
 			(old_addr | last_addr_mask) - old_addr;
+		const unsigned long offset_to_last_dst_entry =
+			(new_addr | last_addr_mask) - new_addr;
 
 		src_pte = hugetlb_walk(vma, old_addr, sz);
 		if (!src_pte) {
@@ -5254,6 +5260,24 @@ unsigned long move_hugetlb_page_tables(s
 			continue;
 		}
 
+		/*
+		 * Avoid entering the destination PMD sharing path while holding
+		 * i_mmap_rwsem for write. Leave destination page table
+		 * population to the fault path, which can share the PMD lazily.
+		 */
+		if (sz == PMD_SIZE && want_pmd_share(new_vma, new_addr)) {
+			const unsigned long unmap_size =
+				min(old_end - old_addr,
+				    offset_to_last_dst_entry + sz);
+
+			hugetlb_unmap_range(&tlb, vma, old_addr,
+					    old_addr + unmap_size, NULL,
+					    ZAP_FLAG_DROP_MARKER);
+			old_addr += unmap_size - sz;
+			new_addr += unmap_size - sz;
+			continue;
+		}
+
 		dst_pte = huge_pte_alloc(mm, new_vma, new_addr, sz);
 		if (!dst_pte)
 			break;
@@ -5273,9 +5297,10 @@ unsigned long move_hugetlb_page_tables(s
 	return len + old_addr - old_end;
 }
 
-void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
-			    unsigned long start, unsigned long end,
-			    struct folio *folio, zap_flags_t zap_flags)
+static void hugetlb_unmap_range(struct mmu_gather *tlb,
+				struct vm_area_struct *vma, unsigned long start,
+				unsigned long end, struct folio *folio,
+				zap_flags_t zap_flags)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	const bool folio_provided = !!folio;
@@ -5293,13 +5318,6 @@ void __unmap_hugepage_range(struct mmu_g
 	BUG_ON(start & ~huge_page_mask(h));
 	BUG_ON(end & ~huge_page_mask(h));
 
-	/*
-	 * This is a hugetlb vma, all the pte entries should point
-	 * to huge page.
-	 */
-	tlb_change_page_size(tlb, sz);
-	tlb_start_vma(tlb, vma);
-
 	last_addr_mask = hugetlb_mask_last_page(h);
 	address = start;
 	for (; address < end; address += sz) {
@@ -5428,6 +5446,15 @@ void __unmap_hugepage_range(struct mmu_g
 		if (folio_provided)
 			break;
 	}
+}
+
+void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
+			    unsigned long start, unsigned long end,
+			    struct folio *folio, zap_flags_t zap_flags)
+{
+	tlb_change_page_size(tlb, huge_page_size(hstate_vma(vma)));
+	tlb_start_vma(tlb, vma);
+	hugetlb_unmap_range(tlb, vma, start, end, folio, zap_flags);
 	tlb_end_vma(tlb, vma);
 
 	huge_pmd_unshare_flush(tlb, vma);
_

Patches currently in -mm which might be from lizhe.67@bytedance.com are

mm-hugetlb-fix-overbroad-mmu-notifiers-for-unshared-pmds.patch
mm-hugetlb-fix-mremap-move-length-truncation.patch
mm-hugetlb-fix-mremap-deadlock-when-pmd-sharing-is-possible.patch

