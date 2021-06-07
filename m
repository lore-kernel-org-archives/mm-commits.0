Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12840C47094
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 20:41:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB5B9611BD
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 20:41:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbhFGUnb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Jun 2021 16:43:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230389AbhFGUnb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Jun 2021 16:43:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE3E360FEF;
        Mon,  7 Jun 2021 20:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623098500;
        bh=cHCzimNTTz6EEZc7DB82oGOX9cuZWqCQrTAuLCzrn68=;
        h=Date:From:To:Subject:From;
        b=EiM8O/BQLEnia9BKwMI13eg1K2jtZXdAy6t5rfZJbzqmcDDVb3TpbF565afh2ybM/
         l1ssLhneoZrmu+t2WvuWCdfKVCNh3zIk47SwiwCc6wHlncTM5vHvYxWRdRfH0Twp8+
         3/Pr9u6x8hUQfQ5mmsUKbC06CqpE+neg9cru/+88=
Date:   Mon, 07 Jun 2021 13:41:39 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, catalin.marinas@arm.com, eugenis@google.com,
        glider@google.com, jannh@google.com, mm-commits@vger.kernel.org,
        pcc@google.com, vincenzo.frascino@arm.com
Subject:  [merged]
 arm64-mte-handle-tags-zeroing-at-page-allocation-time.patch removed from
 -mm tree
Message-ID: <20210607204139.O9dbSEDtK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: mte: handle tags zeroing at page allocation time
has been removed from the -mm tree.  Its filename was
     arm64-mte-handle-tags-zeroing-at-page-allocation-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Collingbourne <pcc@google.com>
Subject: arm64: mte: handle tags zeroing at page allocation time

Currently, on an anonymous page fault, the kernel allocates a zeroed page
and maps it in user space.  If the mapping is tagged (PROT_MTE),
set_pte_at() additionally clears the tags.  It is, however, more efficient
to clear the tags at the same time as zeroing the data on allocation.  To
avoid clearing the tags on any page (which may not be mapped as tagged),
only do this if the vma flags contain VM_MTE.  This requires introducing a
new GFP flag that is used to determine whether to clear the tags.

The DC GZVA instruction with a 0 top byte (and 0 tag) requires
top-byte-ignore.  Set the TCR_EL1.{TBI1,TBID1} bits irrespective of
whether KASAN_HW is enabled.

Link: https://lkml.kernel.org/r/20210602235230.3928842-4-pcc@google.com
Link: https://linux-review.googlesource.com/id/Id46dc94e30fe11474f7e54f5d65e7658dbdddb26
Signed-off-by: Peter Collingbourne <pcc@google.com>
Co-developed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/mte.h  |    4 ++++
 arch/arm64/include/asm/page.h |    8 ++++++--
 arch/arm64/lib/mte.S          |   20 ++++++++++++++++++++
 arch/arm64/mm/fault.c         |   26 ++++++++++++++++++++++++++
 arch/arm64/mm/proc.S          |   10 +++++++---
 include/linux/gfp.h           |    9 +++++++--
 include/linux/highmem.h       |    8 ++++++++
 mm/kasan/hw_tags.c            |    9 ++++++++-
 mm/page_alloc.c               |   13 ++++++++++---
 9 files changed, 96 insertions(+), 11 deletions(-)

--- a/arch/arm64/include/asm/mte.h~arm64-mte-handle-tags-zeroing-at-page-allocation-time
+++ a/arch/arm64/include/asm/mte.h
@@ -37,6 +37,7 @@ void mte_free_tag_storage(char *storage)
 /* track which pages have valid allocation tags */
 #define PG_mte_tagged	PG_arch_2
 
+void mte_zero_clear_page_tags(void *addr);
 void mte_sync_tags(pte_t *ptep, pte_t pte);
 void mte_copy_page_tags(void *kto, const void *kfrom);
 void mte_thread_init_user(void);
@@ -53,6 +54,9 @@ int mte_ptrace_copy_tags(struct task_str
 /* unused if !CONFIG_ARM64_MTE, silence the compiler */
 #define PG_mte_tagged	0
 
+static inline void mte_zero_clear_page_tags(void *addr)
+{
+}
 static inline void mte_sync_tags(pte_t *ptep, pte_t pte)
 {
 }
--- a/arch/arm64/include/asm/page.h~arm64-mte-handle-tags-zeroing-at-page-allocation-time
+++ a/arch/arm64/include/asm/page.h
@@ -13,6 +13,7 @@
 #ifndef __ASSEMBLY__
 
 #include <linux/personality.h> /* for READ_IMPLIES_EXEC */
+#include <linux/types.h> /* for gfp_t */
 #include <asm/pgtable-types.h>
 
 struct page;
@@ -28,10 +29,13 @@ void copy_user_highpage(struct page *to,
 void copy_highpage(struct page *to, struct page *from);
 #define __HAVE_ARCH_COPY_HIGHPAGE
 
-#define alloc_zeroed_user_highpage_movable(vma, vaddr) \
-	alloc_page_vma(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, vma, vaddr)
+struct page *alloc_zeroed_user_highpage_movable(struct vm_area_struct *vma,
+						unsigned long vaddr);
 #define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE_MOVABLE
 
+void tag_clear_highpage(struct page *to);
+#define __HAVE_ARCH_TAG_CLEAR_HIGHPAGE
+
 #define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
--- a/arch/arm64/lib/mte.S~arm64-mte-handle-tags-zeroing-at-page-allocation-time
+++ a/arch/arm64/lib/mte.S
@@ -37,6 +37,26 @@ SYM_FUNC_START(mte_clear_page_tags)
 SYM_FUNC_END(mte_clear_page_tags)
 
 /*
+ * Zero the page and tags at the same time
+ *
+ * Parameters:
+ *	x0 - address to the beginning of the page
+ */
+SYM_FUNC_START(mte_zero_clear_page_tags)
+	mrs	x1, dczid_el0
+	and	w1, w1, #0xf
+	mov	x2, #4
+	lsl	x1, x2, x1
+	and	x0, x0, #(1 << MTE_TAG_SHIFT) - 1	// clear the tag
+
+1:	dc	gzva, x0
+	add	x0, x0, x1
+	tst	x0, #(PAGE_SIZE - 1)
+	b.ne	1b
+	ret
+SYM_FUNC_END(mte_zero_clear_page_tags)
+
+/*
  * Copy the tags from the source page to the destination one
  *   x0 - address of the destination page
  *   x1 - address of the source page
--- a/arch/arm64/mm/fault.c~arm64-mte-handle-tags-zeroing-at-page-allocation-time
+++ a/arch/arm64/mm/fault.c
@@ -921,3 +921,29 @@ void do_debug_exception(unsigned long ad
 	debug_exception_exit(regs);
 }
 NOKPROBE_SYMBOL(do_debug_exception);
+
+/*
+ * Used during anonymous page fault handling.
+ */
+struct page *alloc_zeroed_user_highpage_movable(struct vm_area_struct *vma,
+						unsigned long vaddr)
+{
+	gfp_t flags = GFP_HIGHUSER_MOVABLE | __GFP_ZERO;
+
+	/*
+	 * If the page is mapped with PROT_MTE, initialise the tags at the
+	 * point of allocation and page zeroing as this is usually faster than
+	 * separate DC ZVA and STGM.
+	 */
+	if (vma->vm_flags & VM_MTE)
+		flags |= __GFP_ZEROTAGS;
+
+	return alloc_page_vma(flags, vma, vaddr);
+}
+
+void tag_clear_highpage(struct page *page)
+{
+	mte_zero_clear_page_tags(page_address(page));
+	page_kasan_tag_reset(page);
+	set_bit(PG_mte_tagged, &page->flags);
+}
--- a/arch/arm64/mm/proc.S~arm64-mte-handle-tags-zeroing-at-page-allocation-time
+++ a/arch/arm64/mm/proc.S
@@ -46,9 +46,13 @@
 #endif
 
 #ifdef CONFIG_KASAN_HW_TAGS
-#define TCR_KASAN_HW_FLAGS SYS_TCR_EL1_TCMA1 | TCR_TBI1 | TCR_TBID1
+#define TCR_MTE_FLAGS SYS_TCR_EL1_TCMA1 | TCR_TBI1 | TCR_TBID1
 #else
-#define TCR_KASAN_HW_FLAGS 0
+/*
+ * The mte_zero_clear_page_tags() implementation uses DC GZVA, which relies on
+ * TBI being enabled at EL1.
+ */
+#define TCR_MTE_FLAGS TCR_TBI1 | TCR_TBID1
 #endif
 
 /*
@@ -454,7 +458,7 @@ SYM_FUNC_START(__cpu_setup)
 	msr_s	SYS_TFSRE0_EL1, xzr
 
 	/* set the TCR_EL1 bits */
-	mov_q	x10, TCR_KASAN_HW_FLAGS
+	mov_q	x10, TCR_MTE_FLAGS
 	orr	tcr, tcr, x10
 1:
 #endif
--- a/include/linux/gfp.h~arm64-mte-handle-tags-zeroing-at-page-allocation-time
+++ a/include/linux/gfp.h
@@ -53,8 +53,9 @@ struct vm_area_struct;
 #define ___GFP_HARDWALL		0x100000u
 #define ___GFP_THISNODE		0x200000u
 #define ___GFP_ACCOUNT		0x400000u
+#define ___GFP_ZEROTAGS		0x800000u
 #ifdef CONFIG_LOCKDEP
-#define ___GFP_NOLOCKDEP	0x800000u
+#define ___GFP_NOLOCKDEP	0x1000000u
 #else
 #define ___GFP_NOLOCKDEP	0
 #endif
@@ -229,16 +230,20 @@ struct vm_area_struct;
  * %__GFP_COMP address compound page metadata.
  *
  * %__GFP_ZERO returns a zeroed page on success.
+ *
+ * %__GFP_ZEROTAGS returns a page with zeroed memory tags on success, if
+ * __GFP_ZERO is set.
  */
 #define __GFP_NOWARN	((__force gfp_t)___GFP_NOWARN)
 #define __GFP_COMP	((__force gfp_t)___GFP_COMP)
 #define __GFP_ZERO	((__force gfp_t)___GFP_ZERO)
+#define __GFP_ZEROTAGS	((__force gfp_t)___GFP_ZEROTAGS)
 
 /* Disable lockdep for GFP context tracking */
 #define __GFP_NOLOCKDEP ((__force gfp_t)___GFP_NOLOCKDEP)
 
 /* Room for N __GFP_FOO bits */
-#define __GFP_BITS_SHIFT (23 + IS_ENABLED(CONFIG_LOCKDEP))
+#define __GFP_BITS_SHIFT (24 + IS_ENABLED(CONFIG_LOCKDEP))
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
 
 /**
--- a/include/linux/highmem.h~arm64-mte-handle-tags-zeroing-at-page-allocation-time
+++ a/include/linux/highmem.h
@@ -185,6 +185,14 @@ static inline void clear_highpage(struct
 	kunmap_local(kaddr);
 }
 
+#ifndef __HAVE_ARCH_TAG_CLEAR_HIGHPAGE
+
+static inline void tag_clear_highpage(struct page *page)
+{
+}
+
+#endif
+
 /*
  * If we pass in a base or tail page, we can zero up to PAGE_SIZE.
  * If we pass in a head page, we can zero up to the size of the compound page.
--- a/mm/kasan/hw_tags.c~arm64-mte-handle-tags-zeroing-at-page-allocation-time
+++ a/mm/kasan/hw_tags.c
@@ -246,7 +246,14 @@ void kasan_alloc_pages(struct page *page
 	 */
 	bool init = !want_init_on_free() && want_init_on_alloc(flags);
 
-	kasan_unpoison_pages(page, order, init);
+	if (flags & __GFP_ZEROTAGS) {
+		int i;
+
+		for (i = 0; i != 1 << order; ++i)
+			tag_clear_highpage(page + i);
+	} else {
+		kasan_unpoison_pages(page, order, init);
+	}
 }
 
 void kasan_free_pages(struct page *page, unsigned int order)
--- a/mm/page_alloc.c~arm64-mte-handle-tags-zeroing-at-page-allocation-time
+++ a/mm/page_alloc.c
@@ -1288,10 +1288,16 @@ out:
 	return ret;
 }
 
-static void kernel_init_free_pages(struct page *page, int numpages)
+static void kernel_init_free_pages(struct page *page, int numpages, bool zero_tags)
 {
 	int i;
 
+	if (zero_tags) {
+		for (i = 0; i < numpages; i++)
+			tag_clear_highpage(page + i);
+		return;
+	}
+
 	/* s390's use of memset() could override KASAN redzones. */
 	kasan_disable_current();
 	for (i = 0; i < numpages; i++) {
@@ -1383,7 +1389,7 @@ static __always_inline bool free_pages_p
 		bool init = want_init_on_free();
 
 		if (init)
-			kernel_init_free_pages(page, 1 << order);
+			kernel_init_free_pages(page, 1 << order, false);
 		if (!skip_kasan_poison)
 			kasan_poison_pages(page, order, init);
 	}
@@ -2437,7 +2443,8 @@ inline void post_alloc_hook(struct page
 
 		kasan_unpoison_pages(page, order, init);
 		if (init)
-			kernel_init_free_pages(page, 1 << order);
+			kernel_init_free_pages(page, 1 << order,
+					       gfp_flags & __GFP_ZEROTAGS);
 	}
 
 	set_page_owner(page, order, gfp_flags);
_

Patches currently in -mm which might be from pcc@google.com are

mm-improve-mprotectrw-efficiency-on-pages-referenced-once.patch
mm-improve-mprotectrw-efficiency-on-pages-referenced-once-v5.patch

