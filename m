Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C051C433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:55:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F54061468
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:55:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbhD3F4g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:56:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230210AbhD3F4d (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:56:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3004961462;
        Fri, 30 Apr 2021 05:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762136;
        bh=ftcX+ufGcMXEiHImLzdCEFJrI18MfPrMiKEu+QQLgzs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GPslyA231uOHTQyQs78pkqZFgPclUqamO55gOVMwXRytSfkiKDDrjqrA5Ojfi2AUT
         WfnKXbN2WrmaYE0vRf9CBNrTI9a7S3mybMXp9mefKnzMSUMiUv53QBfurdIjGcbTMr
         P5G+mE4UY+0JfJIBhNMFc8p1XHe8ElwrlXn9X97I=
Date:   Thu, 29 Apr 2021 22:55:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, willy@infradead.org,
        ying.huang@intel.com
Subject:  [patch 047/178] mm: move page_mapping_file to pagemap.h
Message-ID: <20210430055535.NuG7Hiuq_%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: move page_mapping_file to pagemap.h

page_mapping_file() is only used by some architectures, and then it
is usually only used in one place.  Make it a static inline function
so other architectures don't have to carry this dead code.

Link: https://lkml.kernel.org/r/20210317123011.350118-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/copypage-v4mc.c   |    1 +
 arch/arm/mm/copypage-v6.c     |    1 +
 arch/arm/mm/copypage-xscale.c |    1 +
 arch/csky/abiv1/cacheflush.c  |    1 +
 arch/mips/mm/cache.c          |    1 +
 arch/nios2/mm/cacheflush.c    |    1 +
 arch/sh/mm/cache-sh4.c        |    1 +
 arch/sh/mm/cache-sh7705.c     |    1 +
 arch/sparc/mm/tlb.c           |    1 +
 include/linux/mm.h            |    1 -
 include/linux/pagemap.h       |   10 ++++++++++
 mm/util.c                     |   10 ----------
 12 files changed, 19 insertions(+), 11 deletions(-)

--- a/arch/arm/mm/copypage-v4mc.c~mm-move-page_mapping_file-to-pagemaph
+++ a/arch/arm/mm/copypage-v4mc.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
+#include <linux/pagemap.h>
 
 #include <asm/tlbflush.h>
 #include <asm/cacheflush.h>
--- a/arch/arm/mm/copypage-v6.c~mm-move-page_mapping_file-to-pagemaph
+++ a/arch/arm/mm/copypage-v6.c
@@ -8,6 +8,7 @@
 #include <linux/spinlock.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
+#include <linux/pagemap.h>
 
 #include <asm/shmparam.h>
 #include <asm/tlbflush.h>
--- a/arch/arm/mm/copypage-xscale.c~mm-move-page_mapping_file-to-pagemaph
+++ a/arch/arm/mm/copypage-xscale.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
+#include <linux/pagemap.h>
 
 #include <asm/tlbflush.h>
 #include <asm/cacheflush.h>
--- a/arch/csky/abiv1/cacheflush.c~mm-move-page_mapping_file-to-pagemaph
+++ a/arch/csky/abiv1/cacheflush.c
@@ -4,6 +4,7 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/fs.h>
+#include <linux/pagemap.h>
 #include <linux/syscalls.h>
 #include <linux/spinlock.h>
 #include <asm/page.h>
--- a/arch/mips/mm/cache.c~mm-move-page_mapping_file-to-pagemaph
+++ a/arch/mips/mm/cache.c
@@ -15,6 +15,7 @@
 #include <linux/syscalls.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
+#include <linux/pagemap.h>
 
 #include <asm/cacheflush.h>
 #include <asm/processor.h>
--- a/arch/nios2/mm/cacheflush.c~mm-move-page_mapping_file-to-pagemaph
+++ a/arch/nios2/mm/cacheflush.c
@@ -11,6 +11,7 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/fs.h>
+#include <linux/pagemap.h>
 
 #include <asm/cacheflush.h>
 #include <asm/cpuinfo.h>
--- a/arch/sh/mm/cache-sh4.c~mm-move-page_mapping_file-to-pagemaph
+++ a/arch/sh/mm/cache-sh4.c
@@ -16,6 +16,7 @@
 #include <linux/mutex.h>
 #include <linux/fs.h>
 #include <linux/highmem.h>
+#include <linux/pagemap.h>
 #include <asm/mmu_context.h>
 #include <asm/cache_insns.h>
 #include <asm/cacheflush.h>
--- a/arch/sh/mm/cache-sh7705.c~mm-move-page_mapping_file-to-pagemaph
+++ a/arch/sh/mm/cache-sh7705.c
@@ -13,6 +13,7 @@
 #include <linux/mman.h>
 #include <linux/mm.h>
 #include <linux/fs.h>
+#include <linux/pagemap.h>
 #include <linux/threads.h>
 #include <asm/addrspace.h>
 #include <asm/page.h>
--- a/arch/sparc/mm/tlb.c~mm-move-page_mapping_file-to-pagemaph
+++ a/arch/sparc/mm/tlb.c
@@ -9,6 +9,7 @@
 #include <linux/mm.h>
 #include <linux/swap.h>
 #include <linux/preempt.h>
+#include <linux/pagemap.h>
 
 #include <asm/tlbflush.h>
 #include <asm/cacheflush.h>
--- a/include/linux/mm.h~mm-move-page_mapping_file-to-pagemaph
+++ a/include/linux/mm.h
@@ -1629,7 +1629,6 @@ static inline pgoff_t page_index(struct
 
 bool page_mapped(struct page *page);
 struct address_space *page_mapping(struct page *page);
-struct address_space *page_mapping_file(struct page *page);
 
 /*
  * Return true only if the page has been allocated with
--- a/include/linux/pagemap.h~mm-move-page_mapping_file-to-pagemaph
+++ a/include/linux/pagemap.h
@@ -158,6 +158,16 @@ static inline void filemap_nr_thps_dec(s
 void release_pages(struct page **pages, int nr);
 
 /*
+ * For file cache pages, return the address_space, otherwise return NULL
+ */
+static inline struct address_space *page_mapping_file(struct page *page)
+{
+	if (unlikely(PageSwapCache(page)))
+		return NULL;
+	return page_mapping(page);
+}
+
+/*
  * speculatively take a reference to a page.
  * If the page is free (_refcount == 0), then _refcount is untouched, and 0
  * is returned. Otherwise, _refcount is incremented by 1 and 1 is returned.
--- a/mm/util.c~mm-move-page_mapping_file-to-pagemaph
+++ a/mm/util.c
@@ -711,16 +711,6 @@ struct address_space *page_mapping(struc
 }
 EXPORT_SYMBOL(page_mapping);
 
-/*
- * For file cache pages, return the address_space, otherwise return NULL
- */
-struct address_space *page_mapping_file(struct page *page)
-{
-	if (unlikely(PageSwapCache(page)))
-		return NULL;
-	return page_mapping(page);
-}
-
 /* Slow path of page_mapcount() for compound pages */
 int __page_mapcount(struct page *page)
 {
_
