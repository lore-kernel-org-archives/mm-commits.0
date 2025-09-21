Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064B821D3C0
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489961; cv=none; b=AFtEUvbpBVWtoms9O0dtywu7fHp9ugQCvsv6aP6LQ6hpy5PT2nHX2lIyHwXgmLoXMwbEHPBOKRLE3HyxcOI8q51XG9McihL9rw5gUZ7G5UcWSKU4XPQcUYPopVAdRv3wo3I/TvgzvLrIIC1wmaNJL4o5y5rMFLdI2TkaOyQGTF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489961; c=relaxed/simple;
	bh=WTvl5mwLn3nTnKdzGutKTRqQZkjxswRvffeGjnalcXY=;
	h=Date:To:From:Subject:Message-Id; b=cRTSvbzo3DWHt3/dlRCAa+k9C7MP9hf2gFlrc8jqm4WIh4h9GXWrfVAyuHi0Yp8VOTb1t57f3zVgmhQIh2ixlHVsyPB6zPpy7Z6GLyRwT8G997MzMTY+FvrrKWi0QNYHFf8gL41E4hHV3kq3J69AgAg7xJZSBqHZbRqrUbQDxqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dJirgIA3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dJirgIA3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D394FC4CEE7;
	Sun, 21 Sep 2025 21:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489960;
	bh=WTvl5mwLn3nTnKdzGutKTRqQZkjxswRvffeGjnalcXY=;
	h=Date:To:From:Subject:From;
	b=dJirgIA3l7w0jNPUGOg/4v8uCJnnoVnLRhJBmqtIsfluZ8kVMM0BJfwoL8gTPAFKj
	 hKq+wOIBHYPwOXkYp9PqjnQ3bDJeu++qXmpXTayx4h0Bk4v3chf3B9jkHTUqyhT0CU
	 i09lA/onPpsReTtb6vHLN3T899sXZlxldduiYx/s=
Date: Sun, 21 Sep 2025 14:26:00 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ptdesc-remove-ptdesc_to_virt.patch removed from -mm tree
Message-Id: <20250921212600.D394FC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ptdesc: remove ptdesc_to_virt()
has been removed from the -mm tree.  Its filename was
     ptdesc-remove-ptdesc_to_virt.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: ptdesc: remove ptdesc_to_virt()
Date: Mon, 8 Sep 2025 18:11:02 +0100

This has the same effect as ptdesc_address() so convert the callers to use
that and delete the function.  Add kernel-doc for ptdesc_address().

Link: https://lkml.kernel.org/r/20250908171104.2409217-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/mmu.c      |    2 +-
 arch/s390/mm/pgalloc.c |    6 +++---
 include/linux/mm.h     |   11 ++++++-----
 3 files changed, 10 insertions(+), 9 deletions(-)

--- a/arch/arm/mm/mmu.c~ptdesc-remove-ptdesc_to_virt
+++ a/arch/arm/mm/mmu.c
@@ -737,7 +737,7 @@ static void *__init late_alloc(unsigned
 
 	if (!ptdesc || !pagetable_pte_ctor(NULL, ptdesc))
 		BUG();
-	return ptdesc_to_virt(ptdesc);
+	return ptdesc_address(ptdesc);
 }
 
 static pte_t * __init arm_pte_alloc(pmd_t *pmd, unsigned long addr,
--- a/arch/s390/mm/pgalloc.c~ptdesc-remove-ptdesc_to_virt
+++ a/arch/s390/mm/pgalloc.c
@@ -21,7 +21,7 @@ unsigned long *crst_table_alloc(struct m
 
 	if (!ptdesc)
 		return NULL;
-	table = ptdesc_to_virt(ptdesc);
+	table = ptdesc_address(ptdesc);
 	__arch_set_page_dat(table, 1UL << CRST_ALLOC_ORDER);
 	return table;
 }
@@ -119,7 +119,7 @@ struct ptdesc *page_table_alloc_pgste(st
 
 	ptdesc = pagetable_alloc(GFP_KERNEL, 0);
 	if (ptdesc) {
-		table = (u64 *)ptdesc_to_virt(ptdesc);
+		table = (u64 *)ptdesc_address(ptdesc);
 		__arch_set_page_dat(table, 1);
 		memset64(table, _PAGE_INVALID, PTRS_PER_PTE);
 		memset64(table + PTRS_PER_PTE, 0, PTRS_PER_PTE);
@@ -146,7 +146,7 @@ unsigned long *page_table_alloc(struct m
 		pagetable_free(ptdesc);
 		return NULL;
 	}
-	table = ptdesc_to_virt(ptdesc);
+	table = ptdesc_address(ptdesc);
 	__arch_set_page_dat(table, 1);
 	memset64((u64 *)table, _PAGE_INVALID, PTRS_PER_PTE);
 	memset64((u64 *)table + PTRS_PER_PTE, 0, PTRS_PER_PTE);
--- a/include/linux/mm.h~ptdesc-remove-ptdesc_to_virt
+++ a/include/linux/mm.h
@@ -2944,11 +2944,12 @@ static inline struct ptdesc *virt_to_ptd
 	return page_ptdesc(virt_to_page(x));
 }
 
-static inline void *ptdesc_to_virt(const struct ptdesc *pt)
-{
-	return page_to_virt(ptdesc_page(pt));
-}
-
+/**
+ * ptdesc_address - Virtual address of page table.
+ * @pt: Page table descriptor.
+ *
+ * Return: The first byte of the page table described by @pt.
+ */
 static inline void *ptdesc_address(const struct ptdesc *pt)
 {
 	return folio_address(ptdesc_folio(pt));
_

Patches currently in -mm which might be from willy@infradead.org are

ksm-use-a-folio-inside-cmp_and_merge_page.patch

