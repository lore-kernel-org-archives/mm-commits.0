Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D34913AA26
	for <mm-commits@vger.kernel.org>; Thu, 15 Feb 2024 19:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708026147; cv=none; b=hqxaEOF4fzIuyDeu7agOkG+M/+1o7UHMxXi5oKCT7h+kXmW80Gpy0FuK+4sPTofBVxngw4Di8eMbblOuT+O9se9XGvg4OQLcZ2NItDIGDluj9yzrAnZjL+KmeaTlEBClwrX+8+OodUOY3r27eFIkc4UpQjCoS1SElsgWC9HTVbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708026147; c=relaxed/simple;
	bh=2vaGahZFyuDZCd+kbTR26NwmSOePj7Q1t8TwqPnps/k=;
	h=Date:To:From:Subject:Message-Id; b=LreLu+CrwwbCB7MM9LM7f40JRKFMPXz/HD0F5IpzV4jfZCjkUlhicJgVQzB6TxHl2ngY0iQag6/xiSK6o+PKYqmLwOwNM0XWW+VyxkUIcms2cymiSJnJZlQsDPuR5ZzzokTgeMu1wj+sZHy+E8VqXw104AGsyaeEJg8IL5Ftr0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fjVtIOEn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fjVtIOEn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14FBEC43390;
	Thu, 15 Feb 2024 19:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708026147;
	bh=2vaGahZFyuDZCd+kbTR26NwmSOePj7Q1t8TwqPnps/k=;
	h=Date:To:From:Subject:From;
	b=fjVtIOEnal2WH55p7XpMtmFWNYlz35qUxuvl/v7kXLrN9YiJN9uwSqy4vijiNAUdh
	 ls3qgkoe74FWFsjsfe5ZOIJt074K7S95Jcsahsrb/YVcnEyzG3Zubr2m+w5o6yDt2L
	 4Caeln8mOw0wiX3k7+RKjut0qT/pgNktqNVhTnLU=
Date: Thu, 15 Feb 2024 11:42:26 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,svens@linux.ibm.com,ryan.roberts@arm.com,peterz@infradead.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mhocko@suse.com,hca@linux.ibm.com,gor@linux.ibm.com,fengwei.yin@intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,borntraeger@linux.ibm.com,arnd@arndb.de,aneesh.kumar@linux.ibm.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmu_gather-improve-cond_resched-handling-with-large-folios-and-expensive-page-freeing.patch added to mm-unstable branch
Message-Id: <20240215194227.14FBEC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mmu_gather: improve cond_resched() handling with large folios and expensive page freeing
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmu_gather-improve-cond_resched-handling-with-large-folios-and-expensive-page-freeing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmu_gather-improve-cond_resched-handling-with-large-folios-and-expensive-page-freeing.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/mmu_gather: improve cond_resched() handling with large folios and expensive page freeing
Date: Wed, 14 Feb 2024 21:44:34 +0100

In tlb_batch_pages_flush(), we can end up freeing up to 512 pages or now
up to 256 folio fragments that span more than one page, before we
conditionally reschedule.

It's a pain that we have to handle cond_resched() in
tlb_batch_pages_flush() manually and cannot simply handle it in
release_pages() -- release_pages() can be called from atomic context. 
Well, in a perfect world we wouldn't have to make our code more
complicated at all.

With page poisoning and init_on_free, we might now run into soft lockups
when we free a lot of rather large folio fragments, because page freeing
time then depends on the actual memory size we are freeing instead of on
the number of folios that are involved.

In the absolute (unlikely) worst case, on arm64 with 64k we will be able
to free up to 256 folio fragments that each span 512 MiB: zeroing out 128
GiB does sound like it might take a while.  But instead of ignoring this
unlikely case, let's just handle it.

So, let's teach tlb_batch_pages_flush() that there are some configurations
where page freeing is horribly slow, and let's reschedule more frequently
-- similarly like we did for now before we had large folio fragments in
there.  Avoid yet another loop over all encoded pages in the common case
by handling that separately.

Note that with page poisoning/zeroing, we might now end up freeing only a
single folio fragment at a time that might exceed the old 512 pages limit:
but if we cannot even free a single MAX_ORDER page on a system without
running into soft lockups, something else is already completely bogus. 
Freeing a PMD-mapped THP would similarly cause trouble.

In theory, we might even free 511 order-0 pages + a single MAX_ORDER page,
effectively having to zero out 8703 pages on arm64 with 64k, translating
to ~544 MiB of memory: however, if 512 MiB doesn't result in soft lockups,
544 MiB is unlikely to result in soft lockups, so we won't care about that
for the time being.

In the future, we might want to detect if handling cond_resched() is
required at all, and just not do any of that with full preemption enabled.

Link: https://lkml.kernel.org/r/20240214204435.167852-10-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_gather.c |   58 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 43 insertions(+), 15 deletions(-)

--- a/mm/mmu_gather.c~mm-mmu_gather-improve-cond_resched-handling-with-large-folios-and-expensive-page-freeing
+++ a/mm/mmu_gather.c
@@ -91,18 +91,21 @@ void tlb_flush_rmaps(struct mmu_gather *
 }
 #endif
 
-static void tlb_batch_pages_flush(struct mmu_gather *tlb)
-{
-	struct mmu_gather_batch *batch;
+/*
+ * We might end up freeing a lot of pages. Reschedule on a regular
+ * basis to avoid soft lockups in configurations without full
+ * preemption enabled. The magic number of 512 folios seems to work.
+ */
+#define MAX_NR_FOLIOS_PER_FREE		512
 
-	for (batch = &tlb->local; batch && batch->nr; batch = batch->next) {
-		struct encoded_page **pages = batch->encoded_pages;
+static void __tlb_batch_free_encoded_pages(struct mmu_gather_batch *batch)
+{
+	struct encoded_page **pages = batch->encoded_pages;
+	unsigned int nr, nr_pages;
 
-		while (batch->nr) {
-			/*
-			 * limit free batch count when PAGE_SIZE > 4K
-			 */
-			unsigned int nr = min(512U, batch->nr);
+	while (batch->nr) {
+		if (!page_poisoning_enabled_static() && !want_init_on_free()) {
+			nr = min(MAX_NR_FOLIOS_PER_FREE, batch->nr);
 
 			/*
 			 * Make sure we cover page + nr_pages, and don't leave
@@ -111,14 +114,39 @@ static void tlb_batch_pages_flush(struct
 			if (unlikely(encoded_page_flags(pages[nr - 1]) &
 				     ENCODED_PAGE_BIT_NR_PAGES_NEXT))
 				nr++;
+		} else {
+			/*
+			 * With page poisoning and init_on_free, the time it
+			 * takes to free memory grows proportionally with the
+			 * actual memory size. Therefore, limit based on the
+			 * actual memory size and not the number of involved
+			 * folios.
+			 */
+			for (nr = 0, nr_pages = 0;
+			     nr < batch->nr && nr_pages < MAX_NR_FOLIOS_PER_FREE;
+			     nr++) {
+				if (unlikely(encoded_page_flags(pages[nr]) &
+					     ENCODED_PAGE_BIT_NR_PAGES_NEXT))
+					nr_pages += encoded_nr_pages(pages[++nr]);
+				else
+					nr_pages++;
+			}
+		}
 
-			free_pages_and_swap_cache(pages, nr);
-			pages += nr;
-			batch->nr -= nr;
+		free_pages_and_swap_cache(pages, nr);
+		pages += nr;
+		batch->nr -= nr;
 
-			cond_resched();
-		}
+		cond_resched();
 	}
+}
+
+static void tlb_batch_pages_flush(struct mmu_gather *tlb)
+{
+	struct mmu_gather_batch *batch;
+
+	for (batch = &tlb->local; batch && batch->nr; batch = batch->next)
+		__tlb_batch_free_encoded_pages(batch);
 	tlb->active = &tlb->local;
 }
 
_

Patches currently in -mm which might be from david@redhat.com are

arm-pgtable-define-pfn_pte_shift.patch
nios2-pgtable-define-pfn_pte_shift.patch
powerpc-pgtable-define-pfn_pte_shift.patch
riscv-pgtable-define-pfn_pte_shift.patch
s390-pgtable-define-pfn_pte_shift.patch
sparc-pgtable-define-pfn_pte_shift.patch
mm-pgtable-make-pte_next_pfn-independent-of-set_ptes.patch
arm-mm-use-pte_next_pfn-in-set_ptes.patch
powerpc-mm-use-pte_next_pfn-in-set_ptes.patch
mm-memory-factor-out-copying-the-actual-pte-in-copy_present_pte.patch
mm-memory-pass-pte-to-copy_present_pte.patch
mm-memory-optimize-fork-with-pte-mapped-thp.patch
mm-memory-ignore-dirty-accessed-soft-dirty-bits-in-folio_pte_batch.patch
mm-memory-ignore-writable-bit-in-folio_pte_batch.patch
mm-memory-factor-out-zapping-of-present-pte-into-zap_present_pte.patch
mm-memory-handle-page-case-in-zap_present_pte-separately.patch
mm-memory-further-separate-anon-and-pagecache-folio-handling-in-zap_present_pte.patch
mm-memory-factor-out-zapping-folio-pte-into-zap_present_folio_pte.patch
mm-mmu_gather-pass-delay_rmap-instead-of-encoded-page-to-__tlb_remove_page_size.patch
mm-mmu_gather-define-encoded_page_flag_delay_rmap.patch
mm-mmu_gather-add-tlb_remove_tlb_entries.patch
mm-mmu_gather-add-__tlb_remove_folio_pages.patch
mm-mmu_gather-improve-cond_resched-handling-with-large-folios-and-expensive-page-freeing.patch
mm-memory-optimize-unmap-zap-with-pte-mapped-thp.patch

