Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894E741A81
	for <mm-commits@vger.kernel.org>; Thu, 15 Feb 2024 19:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708026138; cv=none; b=f6sR/KBPIa8XQlha/Zj7QX+ndEsAGYyZrX0A2tOP31xLD05tahemVW55hgfnRtEKymOhqhTWRff3l2wqpQXo1KStjpZZtbL/N3xbPSEM/WemihT2giijT5MxlKTXG1dORc8XiFqgUY02m56y2I8C9xCrAUPGm86Gf6y0fRxvAcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708026138; c=relaxed/simple;
	bh=KDH3+W/irxzSg+KjHPbggVeTXZKkVZcUDaDK12HQnVU=;
	h=Date:To:From:Subject:Message-Id; b=NdgMVnCUzEa/fliq+S+gvif9t8uu/IFwpINpfJFx86ir/vw0KIYmEeKxOVdWLsOCDelakcQKPx1ddmc0DfkIspTk9PHedNODYGnDannOf24Dq76OHhDAohiMHkTaCwR/ysBs0w/xDI2x/0r306jl/E0I/85LIwZXXs8DvMfwg5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YPQxkR6F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YPQxkR6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF5CC433F1;
	Thu, 15 Feb 2024 19:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708026138;
	bh=KDH3+W/irxzSg+KjHPbggVeTXZKkVZcUDaDK12HQnVU=;
	h=Date:To:From:Subject:From;
	b=YPQxkR6F9uC11D4LY584x/3NJhm5T/Kse/+OLiZkl/OcxoiuTfj3ENWPsMLb7WtgY
	 MOc/qedBXx8MSWNspgg52SM29phhzNJledsirkFU10bu/fBcCVBVt7Q/tw1uy+QXoX
	 RCDr/+SrdVg7kj6RMi49QHhLHSlDihKXsjNh8F+o=
Date: Thu, 15 Feb 2024 11:42:17 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,svens@linux.ibm.com,ryan.roberts@arm.com,peterz@infradead.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mhocko@suse.com,hca@linux.ibm.com,gor@linux.ibm.com,fengwei.yin@intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,borntraeger@linux.ibm.com,arnd@arndb.de,aneesh.kumar@linux.ibm.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmu_gather-define-encoded_page_flag_delay_rmap.patch added to mm-unstable branch
Message-Id: <20240215194218.4CF5CC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mmu_gather: define ENCODED_PAGE_FLAG_DELAY_RMAP
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmu_gather-define-encoded_page_flag_delay_rmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmu_gather-define-encoded_page_flag_delay_rmap.patch

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
Subject: mm/mmu_gather: define ENCODED_PAGE_FLAG_DELAY_RMAP
Date: Wed, 14 Feb 2024 21:44:31 +0100

Nowadays, encoded pages are only used in mmu_gather handling.  Let's
update the documentation, and define ENCODED_PAGE_BIT_DELAY_RMAP.  While
at it, rename ENCODE_PAGE_BITS to ENCODED_PAGE_BITS.

If encoded page pointers would ever be used in other context again, we'd
likely want to change the defines to reflect their context (e.g.,
ENCODED_PAGE_FLAG_MMU_GATHER_DELAY_RMAP).  For now, let's keep it simple.

This is a preparation for using the remaining spare bit to indicate that
the next item in an array of encoded pages is a "nr_pages" argument and
not an encoded page.

Link: https://lkml.kernel.org/r/20240214204435.167852-7-david@redhat.com
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

 include/linux/mm_types.h |   17 +++++++++++------
 mm/mmu_gather.c          |    5 +++--
 2 files changed, 14 insertions(+), 8 deletions(-)

--- a/include/linux/mm_types.h~mm-mmu_gather-define-encoded_page_flag_delay_rmap
+++ a/include/linux/mm_types.h
@@ -210,8 +210,8 @@ struct page {
  *
  * An 'encoded_page' pointer is a pointer to a regular 'struct page', but
  * with the low bits of the pointer indicating extra context-dependent
- * information. Not super-common, but happens in mmu_gather and mlock
- * handling, and this acts as a type system check on that use.
+ * information. Only used in mmu_gather handling, and this acts as a type
+ * system check on that use.
  *
  * We only really have two guaranteed bits in general, although you could
  * play with 'struct page' alignment (see CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
@@ -220,21 +220,26 @@ struct page {
  * Use the supplied helper functions to endcode/decode the pointer and bits.
  */
 struct encoded_page;
-#define ENCODE_PAGE_BITS 3ul
+
+#define ENCODED_PAGE_BITS			3ul
+
+/* Perform rmap removal after we have flushed the TLB. */
+#define ENCODED_PAGE_BIT_DELAY_RMAP		1ul
+
 static __always_inline struct encoded_page *encode_page(struct page *page, unsigned long flags)
 {
-	BUILD_BUG_ON(flags > ENCODE_PAGE_BITS);
+	BUILD_BUG_ON(flags > ENCODED_PAGE_BITS);
 	return (struct encoded_page *)(flags | (unsigned long)page);
 }
 
 static inline unsigned long encoded_page_flags(struct encoded_page *page)
 {
-	return ENCODE_PAGE_BITS & (unsigned long)page;
+	return ENCODED_PAGE_BITS & (unsigned long)page;
 }
 
 static inline struct page *encoded_page_ptr(struct encoded_page *page)
 {
-	return (struct page *)(~ENCODE_PAGE_BITS & (unsigned long)page);
+	return (struct page *)(~ENCODED_PAGE_BITS & (unsigned long)page);
 }
 
 /*
--- a/mm/mmu_gather.c~mm-mmu_gather-define-encoded_page_flag_delay_rmap
+++ a/mm/mmu_gather.c
@@ -53,7 +53,7 @@ static void tlb_flush_rmap_batch(struct
 	for (int i = 0; i < batch->nr; i++) {
 		struct encoded_page *enc = batch->encoded_pages[i];
 
-		if (encoded_page_flags(enc)) {
+		if (encoded_page_flags(enc) & ENCODED_PAGE_BIT_DELAY_RMAP) {
 			struct page *page = encoded_page_ptr(enc);
 			folio_remove_rmap_pte(page_folio(page), page, vma);
 		}
@@ -119,6 +119,7 @@ static void tlb_batch_list_free(struct m
 bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page,
 		bool delay_rmap, int page_size)
 {
+	int flags = delay_rmap ? ENCODED_PAGE_BIT_DELAY_RMAP : 0;
 	struct mmu_gather_batch *batch;
 
 	VM_BUG_ON(!tlb->end);
@@ -132,7 +133,7 @@ bool __tlb_remove_page_size(struct mmu_g
 	 * Add the page and check if we are full. If so
 	 * force a flush.
 	 */
-	batch->encoded_pages[batch->nr++] = encode_page(page, delay_rmap);
+	batch->encoded_pages[batch->nr++] = encode_page(page, flags);
 	if (batch->nr == batch->max) {
 		if (!tlb_next_batch(tlb))
 			return true;
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

