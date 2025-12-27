Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDE8199FBA
	for <mm-commits@vger.kernel.org>; Thu,  1 Jan 2026 02:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767235011; cv=none; b=tlBzx4YmBF2Mv+Lvr0PTCGA3eUDSRzFkC+NdEaUSujigxMyJi5t3j0LoGfy/ha7dUzrKtWpuyoydvtvEJJwsDLI7wsb5G6w3vlu7zTbW9p1xHMslzlVdclf/87F2tYbTVAqn2LsqwYv0rdK814DtZhaOqDmJWrv8ChUgkgYAPsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767235011; c=relaxed/simple;
	bh=Kc4jvKmpEpgdjXqjlkjHdUAbR0Vo3wEzM0HOHLK7e8Q=;
	h=Date:To:From:Subject:Message-Id; b=GTfuCsj7nZ3HIt9ad+Mn4ow2Vlv7qsBABbNWg+zMEPqv7BGKty5fiAHz+/uOylZCQBFf6w8hTCfWOXR8cFBq9JKfkQ5MZVvggY4kAtW4sc0C1YuXPNrMb1szNZWnmskwaxCkDfOAP2AVCppYaxaLXLEwZxFSHeBMwG2VILkN+/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oq6s3mZq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oq6s3mZq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA5CC113D0;
	Thu,  1 Jan 2026 02:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767235009;
	bh=Kc4jvKmpEpgdjXqjlkjHdUAbR0Vo3wEzM0HOHLK7e8Q=;
	h=Date:To:From:Subject:From;
	b=oq6s3mZq+TImo9LFoGA99DSomIpJiR4XVKV6D6/SdO/jWNBSlSOodLf+DcT1YtATY
	 rR7BBAFcFB7+hwJ3/uwrsAtFDUgsyIem9RFXs58EjRmQe9gmEYHSX323oN/fHRyG1Z
	 DWb/El+RpTHAzsHfADn6eGHIK78JvLV4kKtbZM0M=
Date: Wed, 31 Dec 2025 18:36:48 +9900
To: mm-commits@vger.kernel.org,will@kernel.org,svens@linux.ibm.com,sj@kernel.org,peterz@infradead.org,npiggin@gmail.com,hca@linux.ibm.com,gor@linux.ibm.com,david@kernel.org,borntraeger@linux.ibm.com,arnd@arndb.de,aneesh.kumar@kernel.org,agordeev@linux.ibm.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmu_gather-remove-delay_remap-of-__tlb_remove_page_size.patch added to mm-new branch
Message-Id: <20260101023649.5FA5CC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mmu_gather: remove @delay_remap of __tlb_remove_page_size()
has been added to the -mm mm-new branch.  Its filename is
     mm-mmu_gather-remove-delay_remap-of-__tlb_remove_page_size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmu_gather-remove-delay_remap-of-__tlb_remove_page_size.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/mmu_gather: remove @delay_remap of __tlb_remove_page_size()
Date: Wed, 31 Dec 2025 03:00:26 +0000

__tlb_remove_page_size() is only used in tlb_remove_page_size() with
@delay_remap set to false and it is passed directly to
__tlb_remove_folio_pages_size().

Remove @delay_remap of __tlb_remove_page_size() and call
__tlb_remove_folio_pages_size() with false @delay_remap.

Link: https://lkml.kernel.org/r/20251231030026.15938-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: SeongJae Park <sj@kernel.org>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/tlb.h |    6 ++----
 include/asm-generic/tlb.h   |    5 ++---
 mm/mmu_gather.c             |    5 ++---
 3 files changed, 6 insertions(+), 10 deletions(-)

--- a/arch/s390/include/asm/tlb.h~mm-mmu_gather-remove-delay_remap-of-__tlb_remove_page_size
+++ a/arch/s390/include/asm/tlb.h
@@ -24,7 +24,7 @@
 
 static inline void tlb_flush(struct mmu_gather *tlb);
 static inline bool __tlb_remove_page_size(struct mmu_gather *tlb,
-		struct page *page, bool delay_rmap, int page_size);
+		struct page *page, int page_size);
 static inline bool __tlb_remove_folio_pages(struct mmu_gather *tlb,
 		struct page *page, unsigned int nr_pages, bool delay_rmap);
 
@@ -46,10 +46,8 @@ static inline bool __tlb_remove_folio_pa
  * s390 doesn't delay rmap removal.
  */
 static inline bool __tlb_remove_page_size(struct mmu_gather *tlb,
-		struct page *page, bool delay_rmap, int page_size)
+		struct page *page, int page_size)
 {
-	VM_WARN_ON_ONCE(delay_rmap);
-
 	free_folio_and_swap_cache(page_folio(page));
 	return false;
 }
--- a/include/asm-generic/tlb.h~mm-mmu_gather-remove-delay_remap-of-__tlb_remove_page_size
+++ a/include/asm-generic/tlb.h
@@ -287,8 +287,7 @@ struct mmu_gather_batch {
  */
 #define MAX_GATHER_BATCH_COUNT	(10000UL/MAX_GATHER_BATCH)
 
-extern bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page,
-		bool delay_rmap, int page_size);
+extern bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page, int page_size);
 bool __tlb_remove_folio_pages(struct mmu_gather *tlb, struct page *page,
 		unsigned int nr_pages, bool delay_rmap);
 
@@ -510,7 +509,7 @@ static inline void tlb_flush_mmu_tlbonly
 static inline void tlb_remove_page_size(struct mmu_gather *tlb,
 					struct page *page, int page_size)
 {
-	if (__tlb_remove_page_size(tlb, page, false, page_size))
+	if (__tlb_remove_page_size(tlb, page, page_size))
 		tlb_flush_mmu(tlb);
 }
 
--- a/mm/mmu_gather.c~mm-mmu_gather-remove-delay_remap-of-__tlb_remove_page_size
+++ a/mm/mmu_gather.c
@@ -210,10 +210,9 @@ bool __tlb_remove_folio_pages(struct mmu
 					     PAGE_SIZE);
 }
 
-bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page,
-		bool delay_rmap, int page_size)
+bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page, int page_size)
 {
-	return __tlb_remove_folio_pages_size(tlb, page, 1, delay_rmap, page_size);
+	return __tlb_remove_folio_pages_size(tlb, page, 1, false, page_size);
 }
 
 #endif /* MMU_GATHER_NO_GATHER */
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-vmstat-remove-unused-node-and-zone-state-helpers.patch
mm-mmu_gather-remove-delay_remap-of-__tlb_remove_page_size.patch

