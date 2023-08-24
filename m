Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F21B2EE49BB
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:22:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232576AbjHXXVx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241203AbjHXXVX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:21:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EAE8A1
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:21:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A81665314
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF05BC433C8;
        Thu, 24 Aug 2023 23:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919280;
        bh=QKZ1kHTTmiml6ZuXbHX9grutE6iIXm/COVcq0cu+pIE=;
        h=Date:To:From:Subject:From;
        b=lo0tqQJvzaCewVvgoMO+2K37HIfDy25k9nBsD2pgYS//ogxIOvdb8xoMRsKX/BmXI
         evC/xeycTJVTYn4yZTPDKvNhJbsE/eogT8Jz5DunbHNIWrKc8KdYtKLFUyyNLk3YmN
         MH7su2qPnx7CW6qfyeAUlSwCTDYuzNadFUHjFfJ0=
Date:   Thu, 24 Aug 2023 16:21:19 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org,
        richard.henderson@linaro.org, mattst88@gmail.com,
        ink@jurassic.park.msu.ru, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] alpha-implement-the-new-page-table-range-api.patch removed from -mm tree
Message-Id: <20230824232119.EF05BC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: alpha: implement the new page table range API
has been removed from the -mm tree.  Its filename was
     alpha-implement-the-new-page-table-range-api.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: alpha: implement the new page table range API
Date: Wed, 2 Aug 2023 16:13:35 +0100

Add PFN_PTE_SHIFT, update_mmu_cache_range() and flush_icache_pages().

Link: https://lkml.kernel.org/r/20230802151406.3735276-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/cacheflush.h |   10 ++++++++++
 arch/alpha/include/asm/pgtable.h    |   10 ++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

--- a/arch/alpha/include/asm/cacheflush.h~alpha-implement-the-new-page-table-range-api
+++ a/arch/alpha/include/asm/cacheflush.h
@@ -57,6 +57,16 @@ extern void flush_icache_user_page(struc
 #define flush_icache_page(vma, page) \
 	flush_icache_user_page((vma), (page), 0, 0)
 
+/*
+ * Both implementations of flush_icache_user_page flush the entire
+ * address space, so one call, no matter how many pages.
+ */
+static inline void flush_icache_pages(struct vm_area_struct *vma,
+		struct page *page, unsigned int nr)
+{
+	flush_icache_user_page(vma, page, 0, 0);
+}
+
 #include <asm-generic/cacheflush.h>
 
 #endif /* _ALPHA_CACHEFLUSH_H */
--- a/arch/alpha/include/asm/pgtable.h~alpha-implement-the-new-page-table-range-api
+++ a/arch/alpha/include/asm/pgtable.h
@@ -26,7 +26,6 @@ struct vm_area_struct;
  * hook is made available.
  */
 #define set_pte(pteptr, pteval) ((*(pteptr)) = (pteval))
-#define set_pte_at(mm,addr,ptep,pteval) set_pte(ptep,pteval)
 
 /* PMD_SHIFT determines the size of the area a second-level page table can map */
 #define PMD_SHIFT	(PAGE_SHIFT + (PAGE_SHIFT-3))
@@ -189,7 +188,8 @@ extern unsigned long __zero_page(void);
  * and a page entry and page directory to the page they refer to.
  */
 #define page_to_pa(page)	(page_to_pfn(page) << PAGE_SHIFT)
-#define pte_pfn(pte)	(pte_val(pte) >> 32)
+#define PFN_PTE_SHIFT		32
+#define pte_pfn(pte)		(pte_val(pte) >> PFN_PTE_SHIFT)
 
 #define pte_page(pte)	pfn_to_page(pte_pfn(pte))
 #define mk_pte(page, pgprot)						\
@@ -303,6 +303,12 @@ extern inline void update_mmu_cache(stru
 {
 }
 
+static inline void update_mmu_cache_range(struct vm_fault *vmf,
+		struct vm_area_struct *vma, unsigned long address,
+		pte_t *ptep, unsigned int nr)
+{
+}
+
 /*
  * Encode/decode swap entries and swap PTEs. Swap PTEs are all PTEs that
  * are !pte_none() && !pte_present().
_

Patches currently in -mm which might be from willy@infradead.org are


