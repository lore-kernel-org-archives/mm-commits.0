Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6914C43381
	for <mm-commits@archiver.kernel.org>; Wed, 17 Mar 2021 22:16:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80B3264F45
	for <mm-commits@archiver.kernel.org>; Wed, 17 Mar 2021 22:16:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbhCQWP7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Mar 2021 18:15:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229944AbhCQWP2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Mar 2021 18:15:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98B6E64F2A;
        Wed, 17 Mar 2021 22:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616019328;
        bh=8fUbT3oRlN4N/4EVGlR3Z3ATrhd5A788lVKonNyEubQ=;
        h=Date:From:To:Subject:From;
        b=M+9YvVeu04YT51o/lRBI6IFNIh1Xt4I99IV3bldFwzJ6pat8pzKrhoYHvskTqDgZq
         6VAsG5PQpyTQQQMrC0oRc7TTjo4JAps8gSEVIZwhz1/5WN+xmmp5H/7FBm3dJh+vPc
         5vgnTa37U7OpleiD7f0cWZnZ62eOPWP/zH1Ec8G8=
Date:   Wed, 17 Mar 2021 15:15:25 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, bp@alien8.de, catalin.marinas@arm.com, cl@linux.com,
        dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        david@redhat.com, elena.reshetova@intel.com, guro@fb.com,
        hagen@jauu.net, hpa@zytor.com, jejb@linux.ibm.com,
        kirill@shutemov.name, luto@kernel.org, mark.rutland@arm.com,
        mingo@redhat.com, mm-commits@vger.kernel.org,
        mtk.manpages@gmail.com, palmer@dabbelt.com,
        palmerdabbelt@google.com, paul.walmsley@sifive.com,
        peterz@infradead.org, rick.p.edgecombe@intel.com,
        rppt@linux.ibm.com, shakeelb@google.com, shuah@kernel.org,
        tglx@linutronix.de, tycho@tycho.ws, viro@zeniv.linux.org.uk,
        will@kernel.org, willy@infradead.org
Subject:  +
 set_memory-allow-set_direct_map__noflush-for-multiple-pages.patch added to
 -mm tree
Message-ID: <20210317221525.M-bOzM7J-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: set_memory: allow set_direct_map_*_noflush() for multiple pages
has been added to the -mm tree.  Its filename is
     set_memory-allow-set_direct_map__noflush-for-multiple-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/set_memory-allow-set_direct_map__noflush-for-multiple-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/set_memory-allow-set_direct_map__noflush-for-multiple-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: set_memory: allow set_direct_map_*_noflush() for multiple pages

The underlying implementations of set_direct_map_invalid_noflush() and
set_direct_map_default_noflush() allow updating multiple contiguous pages
at once.

Add numpages parameter to set_direct_map_*_noflush() to expose this
ability with these APIs.

Link: https://lkml.kernel.org/r/20210303162209.8609-5-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>	[arm64]
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christopher Lameter <cl@linux.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Elena Reshetova <elena.reshetova@intel.com>
Cc: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Bottomley <jejb@linux.ibm.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Palmer Dabbelt <palmerdabbelt@google.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tycho Andersen <tycho@tycho.ws>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/cacheflush.h |    4 ++--
 arch/arm64/mm/pageattr.c            |   10 ++++++----
 arch/riscv/include/asm/set_memory.h |    4 ++--
 arch/riscv/mm/pageattr.c            |    8 ++++----
 arch/x86/include/asm/set_memory.h   |    4 ++--
 arch/x86/mm/pat/set_memory.c        |    8 ++++----
 include/linux/set_memory.h          |    4 ++--
 kernel/power/snapshot.c             |    4 ++--
 mm/vmalloc.c                        |    5 +++--
 9 files changed, 27 insertions(+), 24 deletions(-)

--- a/arch/arm64/include/asm/cacheflush.h~set_memory-allow-set_direct_map__noflush-for-multiple-pages
+++ a/arch/arm64/include/asm/cacheflush.h
@@ -133,8 +133,8 @@ static __always_inline void __flush_icac
 
 int set_memory_valid(unsigned long addr, int numpages, int enable);
 
-int set_direct_map_invalid_noflush(struct page *page);
-int set_direct_map_default_noflush(struct page *page);
+int set_direct_map_invalid_noflush(struct page *page, int numpages);
+int set_direct_map_default_noflush(struct page *page, int numpages);
 bool kernel_page_present(struct page *page);
 
 #include <asm-generic/cacheflush.h>
--- a/arch/arm64/mm/pageattr.c~set_memory-allow-set_direct_map__noflush-for-multiple-pages
+++ a/arch/arm64/mm/pageattr.c
@@ -148,34 +148,36 @@ int set_memory_valid(unsigned long addr,
 					__pgprot(PTE_VALID));
 }
 
-int set_direct_map_invalid_noflush(struct page *page)
+int set_direct_map_invalid_noflush(struct page *page, int numpages)
 {
 	struct page_change_data data = {
 		.set_mask = __pgprot(0),
 		.clear_mask = __pgprot(PTE_VALID),
 	};
+	unsigned long size = PAGE_SIZE * numpages;
 
 	if (!debug_pagealloc_enabled() && !rodata_full)
 		return 0;
 
 	return apply_to_page_range(&init_mm,
 				   (unsigned long)page_address(page),
-				   PAGE_SIZE, change_page_range, &data);
+				   size, change_page_range, &data);
 }
 
-int set_direct_map_default_noflush(struct page *page)
+int set_direct_map_default_noflush(struct page *page, int numpages)
 {
 	struct page_change_data data = {
 		.set_mask = __pgprot(PTE_VALID | PTE_WRITE),
 		.clear_mask = __pgprot(PTE_RDONLY),
 	};
+	unsigned long size = PAGE_SIZE * numpages;
 
 	if (!debug_pagealloc_enabled() && !rodata_full)
 		return 0;
 
 	return apply_to_page_range(&init_mm,
 				   (unsigned long)page_address(page),
-				   PAGE_SIZE, change_page_range, &data);
+				   size, change_page_range, &data);
 }
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
--- a/arch/riscv/include/asm/set_memory.h~set_memory-allow-set_direct_map__noflush-for-multiple-pages
+++ a/arch/riscv/include/asm/set_memory.h
@@ -26,8 +26,8 @@ static inline void protect_kernel_text_d
 static inline int set_memory_rw_nx(unsigned long addr, int numpages) { return 0; }
 #endif
 
-int set_direct_map_invalid_noflush(struct page *page);
-int set_direct_map_default_noflush(struct page *page);
+int set_direct_map_invalid_noflush(struct page *page, int numpages);
+int set_direct_map_default_noflush(struct page *page, int numpages);
 bool kernel_page_present(struct page *page);
 
 #endif /* __ASSEMBLY__ */
--- a/arch/riscv/mm/pageattr.c~set_memory-allow-set_direct_map__noflush-for-multiple-pages
+++ a/arch/riscv/mm/pageattr.c
@@ -156,11 +156,11 @@ int set_memory_nx(unsigned long addr, in
 	return __set_memory(addr, numpages, __pgprot(0), __pgprot(_PAGE_EXEC));
 }
 
-int set_direct_map_invalid_noflush(struct page *page)
+int set_direct_map_invalid_noflush(struct page *page, int numpages)
 {
 	int ret;
 	unsigned long start = (unsigned long)page_address(page);
-	unsigned long end = start + PAGE_SIZE;
+	unsigned long end = start + PAGE_SIZE * numpages;
 	struct pageattr_masks masks = {
 		.set_mask = __pgprot(0),
 		.clear_mask = __pgprot(_PAGE_PRESENT)
@@ -173,11 +173,11 @@ int set_direct_map_invalid_noflush(struc
 	return ret;
 }
 
-int set_direct_map_default_noflush(struct page *page)
+int set_direct_map_default_noflush(struct page *page, int numpages)
 {
 	int ret;
 	unsigned long start = (unsigned long)page_address(page);
-	unsigned long end = start + PAGE_SIZE;
+	unsigned long end = start + PAGE_SIZE * numpages;
 	struct pageattr_masks masks = {
 		.set_mask = PAGE_KERNEL,
 		.clear_mask = __pgprot(0)
--- a/arch/x86/include/asm/set_memory.h~set_memory-allow-set_direct_map__noflush-for-multiple-pages
+++ a/arch/x86/include/asm/set_memory.h
@@ -80,8 +80,8 @@ int set_pages_wb(struct page *page, int
 int set_pages_ro(struct page *page, int numpages);
 int set_pages_rw(struct page *page, int numpages);
 
-int set_direct_map_invalid_noflush(struct page *page);
-int set_direct_map_default_noflush(struct page *page);
+int set_direct_map_invalid_noflush(struct page *page, int numpages);
+int set_direct_map_default_noflush(struct page *page, int numpages);
 bool kernel_page_present(struct page *page);
 
 extern int kernel_set_to_readonly;
--- a/arch/x86/mm/pat/set_memory.c~set_memory-allow-set_direct_map__noflush-for-multiple-pages
+++ a/arch/x86/mm/pat/set_memory.c
@@ -2192,14 +2192,14 @@ static int __set_pages_np(struct page *p
 	return __change_page_attr_set_clr(&cpa, 0);
 }
 
-int set_direct_map_invalid_noflush(struct page *page)
+int set_direct_map_invalid_noflush(struct page *page, int numpages)
 {
-	return __set_pages_np(page, 1);
+	return __set_pages_np(page, numpages);
 }
 
-int set_direct_map_default_noflush(struct page *page)
+int set_direct_map_default_noflush(struct page *page, int numpages)
 {
-	return __set_pages_p(page, 1);
+	return __set_pages_p(page, numpages);
 }
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
--- a/include/linux/set_memory.h~set_memory-allow-set_direct_map__noflush-for-multiple-pages
+++ a/include/linux/set_memory.h
@@ -15,11 +15,11 @@ static inline int set_memory_nx(unsigned
 #endif
 
 #ifndef CONFIG_ARCH_HAS_SET_DIRECT_MAP
-static inline int set_direct_map_invalid_noflush(struct page *page)
+static inline int set_direct_map_invalid_noflush(struct page *page, int numpages)
 {
 	return 0;
 }
-static inline int set_direct_map_default_noflush(struct page *page)
+static inline int set_direct_map_default_noflush(struct page *page, int numpages)
 {
 	return 0;
 }
--- a/kernel/power/snapshot.c~set_memory-allow-set_direct_map__noflush-for-multiple-pages
+++ a/kernel/power/snapshot.c
@@ -86,7 +86,7 @@ static inline void hibernate_restore_unp
 static inline void hibernate_map_page(struct page *page)
 {
 	if (IS_ENABLED(CONFIG_ARCH_HAS_SET_DIRECT_MAP)) {
-		int ret = set_direct_map_default_noflush(page);
+		int ret = set_direct_map_default_noflush(page, 1);
 
 		if (ret)
 			pr_warn_once("Failed to remap page\n");
@@ -99,7 +99,7 @@ static inline void hibernate_unmap_page(
 {
 	if (IS_ENABLED(CONFIG_ARCH_HAS_SET_DIRECT_MAP)) {
 		unsigned long addr = (unsigned long)page_address(page);
-		int ret  = set_direct_map_invalid_noflush(page);
+		int ret = set_direct_map_invalid_noflush(page, 1);
 
 		if (ret)
 			pr_warn_once("Failed to remap page\n");
--- a/mm/vmalloc.c~set_memory-allow-set_direct_map__noflush-for-multiple-pages
+++ a/mm/vmalloc.c
@@ -2195,13 +2195,14 @@ struct vm_struct *remove_vm_area(const v
 }
 
 static inline void set_area_direct_map(const struct vm_struct *area,
-				       int (*set_direct_map)(struct page *page))
+				       int (*set_direct_map)(struct page *page,
+							     int numpages))
 {
 	int i;
 
 	for (i = 0; i < area->nr_pages; i++)
 		if (page_address(area->pages[i]))
-			set_direct_map(area->pages[i]);
+			set_direct_map(area->pages[i], 1);
 }
 
 /* Handle removing and resetting vm mappings related to the vm_struct. */
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-add-definition-of-pmd_page_order.patch
mmap-make-mlock_future_check-global.patch
riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch

