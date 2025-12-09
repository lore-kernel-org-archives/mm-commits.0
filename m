Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CD6306B39
	for <mm-commits@vger.kernel.org>; Tue,  9 Dec 2025 19:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765308397; cv=none; b=gM88q6PK4AfPVWEKZQr1+Z4PW6DSrRHTJ2om/BSPwi5rShRhPVN1K70badKyDy71Wfb36kYbEwZPA+GKjLglzRfSvKYxnCDiQLbnzFrdcgrU9kbwW6ks4i95H/bZcQkJMAYE27upUX8WhWo/4wCA3bQ/L1wRbj5fTFZTvMj1zTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765308397; c=relaxed/simple;
	bh=A41ypm1eB1rSUjgkJyvfExKm59YiR2qnvsNa4VjMh/c=;
	h=Date:To:From:Subject:Message-Id; b=C5MejClLDC53jHcb68wtr+0i7kbAkUUEq8T0nFG+XEy1SMkHeNUTn9QQ8H+njsiwYpQW8Gui1+wP8vnF0wyHcTXGM0iKaEpI8i1X1PnWEOHQSt1eJEa4BRSqTqFNNd/8aW7Vqr4ZxrMKEItWNvq52r+DII4pc+qAUbpsDLjVAyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WrwfrkVJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WrwfrkVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA9EC4CEF5;
	Tue,  9 Dec 2025 19:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765308396;
	bh=A41ypm1eB1rSUjgkJyvfExKm59YiR2qnvsNa4VjMh/c=;
	h=Date:To:From:Subject:From;
	b=WrwfrkVJ8bgaatBhuBpv9rIwrIUqpYz+774k35dpYKJjo+88rHG/8A294iv783RXs
	 mTqG1ajfa143Ihf0V0I8KLXb6p5r/8kMm0dieXJKL87lX19RJUzkzifbzsG01JoRQY
	 8DnYFqnMqafwsMzjQTWtP90dpWVcu8T/fX9HqZ48=
Date: Tue, 09 Dec 2025 11:26:36 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@suse.cz,suschako@amazon.de,riel@surriel.com,prakash.sangappa@oracle.com,peterz@infradead.org,osalvador@suse.de,npiggin@gmail.com,nadav.amit@gmail.com,muchun.song@linux.dev,lorenzo.stoakes@oracle.com,loberman@redhat.com,liushixin2@huawei.com,liam.howlett@oracle.com,lance.yang@linux.dev,jannh@google.com,arnd@arndb.de,aneesh.kumar@kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-fix-two-comments-related-to-huge_pmd_unshare.patch removed from -mm tree
Message-Id: <20251209192636.9BA9EC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: fix two comments related to huge_pmd_unshare()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-two-comments-related-to-huge_pmd_unshare.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: mm/hugetlb: fix two comments related to huge_pmd_unshare()
Date: Fri, 5 Dec 2025 22:35:56 +0100

Ever since we stopped using the page count to detect shared PMD page
tables, these comments are outdated.

The only reason we have to flush the TLB early is because once we drop the
i_mmap_rwsem, the previously shared page table could get freed (to then
get reallocated and used for other purpose).  So we really have to flush
the TLB before that could happen.

So let's simplify the comments a bit.

The "If we unshared PMDs, the TLB flush was not recorded in mmu_gather."
part introduced as in commit a4a118f2eead ("hugetlbfs: flush TLBs
correctly after huge_pmd_unshare") was confusing: sure it is recorded in
the mmu_gather, otherwise tlb_flush_mmu_tlbonly() wouldn't do anything. 
So let's drop that comment while at it as well.

We'll centralize these comments in a single helper as we rework the code
next.

Link: https://lkml.kernel.org/r/20251205213558.2980480-3-david@kernel.org
Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count")
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
Tested-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Rik van Riel <riel@surriel.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Prakash Sangappa <prakash.sangappa@oracle.com>
Cc: Uschakow, Stanislav" <suschako@amazon.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-two-comments-related-to-huge_pmd_unshare
+++ a/mm/hugetlb.c
@@ -5304,17 +5304,10 @@ void __unmap_hugepage_range(struct mmu_g
 	tlb_end_vma(tlb, vma);
 
 	/*
-	 * If we unshared PMDs, the TLB flush was not recorded in mmu_gather. We
-	 * could defer the flush until now, since by holding i_mmap_rwsem we
-	 * guaranteed that the last reference would not be dropped. But we must
-	 * do the flushing before we return, as otherwise i_mmap_rwsem will be
-	 * dropped and the last reference to the shared PMDs page might be
-	 * dropped as well.
-	 *
-	 * In theory we could defer the freeing of the PMD pages as well, but
-	 * huge_pmd_unshare() relies on the exact page_count for the PMD page to
-	 * detect sharing, so we cannot defer the release of the page either.
-	 * Instead, do flush now.
+	 * There is nothing protecting a previously-shared page table that we
+	 * unshared through huge_pmd_unshare() from getting freed after we
+	 * release i_mmap_rwsem, so flush the TLB now. If huge_pmd_unshare()
+	 * succeeded, flush the range corresponding to the pud.
 	 */
 	if (force_flush)
 		tlb_flush_mmu_tlbonly(tlb);
@@ -6536,11 +6529,10 @@ next:
 		cond_resched();
 	}
 	/*
-	 * Must flush TLB before releasing i_mmap_rwsem: x86's huge_pmd_unshare
-	 * may have cleared our pud entry and done put_page on the page table:
-	 * once we release i_mmap_rwsem, another task can do the final put_page
-	 * and that page table be reused and filled with junk.  If we actually
-	 * did unshare a page of pmds, flush the range corresponding to the pud.
+	 * There is nothing protecting a previously-shared page table that we
+	 * unshared through huge_pmd_unshare() from getting freed after we
+	 * release i_mmap_rwsem, so flush the TLB now. If huge_pmd_unshare()
+	 * succeeded, flush the range corresponding to the pud.
 	 */
 	if (shared_pmd)
 		flush_hugetlb_tlb_range(vma, range.start, range.end);
_

Patches currently in -mm which might be from david@kernel.org are


