Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F351E4AB
	for <mm-commits@vger.kernel.org>; Sat,  6 Dec 2025 21:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765056867; cv=none; b=HaLOZ9dirXyTuGfAZbawmDF/mqkfBvHI/vWBS+GOO/s18arC2Tqj7VQo5rRPSlguCn0S6oJiWmbrpdb3jEH0k7urcuwHUXiexP+DsKEFyfSFXObaSitfT81MfXB6B2hKXs1PhwhYFAgb3HVXTyuIRyF/DdPv0wTZj1ac8Zy3REA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765056867; c=relaxed/simple;
	bh=bDN8h9goKjAYB50fDyIl2eAOBhrJusGSNmbwLsUVbWA=;
	h=Date:To:From:Subject:Message-Id; b=mIhfkdAHc26UxY10xsDFU2eyrrXyAHM8TqSsr4yITPMZnfEjy1I4AqM4bpdumPq3GPpH399CBqRGr6Hp//Uh5eTfRz3JGhqZZ524tT+rWyNTeGqCCxwd4gDBiigzYu/kOOpWasibWh2ZDL/GP5WPy3y1MUalpTpZARaxCadWfns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RFyUeKo1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RFyUeKo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE567C4CEF5;
	Sat,  6 Dec 2025 21:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765056867;
	bh=bDN8h9goKjAYB50fDyIl2eAOBhrJusGSNmbwLsUVbWA=;
	h=Date:To:From:Subject:From;
	b=RFyUeKo14NKxdzm5ecG7jFnE0U6nNyAufJaEj4tkgo8QujCRSA74EOwX27nvwviqN
	 OkO3XF4QmJfDunpGcf9QgWfxRf8mzRAHGAIJ+0sGvDfjei/pawMlAPHHmE8NVyBlhh
	 gIkEP38dfcJ91KVn4h0ctUFSzud/aCWpQb4Coi+0=
Date: Sat, 06 Dec 2025 13:34:26 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@suse.cz,suschako@amazon.de,riel@surriel.com,prakash.sangappa@oracle.com,peterz@infradead.org,osalvador@suse.de,npiggin@gmail.com,nadav.amit@gmail.com,muchun.song@linux.dev,lorenzo.stoakes@oracle.com,loberman@redhat.com,liushixin2@huawei.com,liam.howlett@oracle.com,lance.yang@linux.dev,jannh@google.com,arnd@arndb.de,aneesh.kumar@kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-two-comments-related-to-huge_pmd_unshare.patch added to mm-unstable branch
Message-Id: <20251206213426.EE567C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: fix two comments related to huge_pmd_unshare()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-fix-two-comments-related-to-huge_pmd_unshare.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-two-comments-related-to-huge_pmd_unshare.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-hugetlb-fix-hugetlb_pmd_shared.patch
mm-hugetlb-fix-two-comments-related-to-huge_pmd_unshare.patch
mm-rmap-fix-two-comments-related-to-huge_pmd_unshare.patch
mm-hugetlb-fix-excessive-ipi-broadcasts-when-unsharing-pmd-tables-using-mmu_gather.patch

