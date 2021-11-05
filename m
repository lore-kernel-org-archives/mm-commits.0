Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75256C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:45:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FA806136A
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233648AbhKEUrs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:47:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:42856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233197AbhKEUrr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:47:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03B3761357;
        Fri,  5 Nov 2021 20:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145107;
        bh=2t2jrk+FAx/JnrQYdz4svSTq4zn4cS4XsbnVtB9n3GM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=UToe6SWccJDMl9Xx1vILjt1lLUBtKn6h6CtJMfE0+56Z7chISiUr7BJ9FULYffpf8
         nIN0kzALh+ZMW/5guJAFzq65Hhcs8pXuf3xEaIPVLTV8Z984QicTHdPCZoX+mpIR6d
         A5c6vsA3R8X5UkHcAXDXB53s2yZefwapXIYfZbHs=
Date:   Fri, 05 Nov 2021 13:45:06 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ira.weiny@intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        prathu.baronia@oneplus.com, rdunlap@infradead.org,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 199/262] mm/highmem: remove deprecated kmap_atomic
Message-ID: <20211105204506.UaIZqqzAR%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>
Subject: mm/highmem: remove deprecated kmap_atomic

kmap_atomic() is being deprecated in favor of kmap_local_page().

Replace the uses of kmap_atomic() within the highmem code.

On profiling clear_huge_page() using ftrace an improvement of 62% was
observed on the below setup.

Setup:-
Below data has been collected on Qualcomm's SM7250 SoC THP enabled
(kernel v4.19.113) with only CPU-0(Cortex-A55) and CPU-7(Cortex-A76)
switched on and set to max frequency, also DDR set to perf governor.

FTRACE Data:-

Base data:-
Number of iterations: 48
Mean of allocation time: 349.5 us
std deviation: 74.5 us

v4 data:-
Number of iterations: 48
Mean of allocation time: 131 us
std deviation: 32.7 us

The following simple userspace experiment to allocate
100MB(BUF_SZ) of pages and writing to it gave us a good insight,
we observed an improvement of 42% in allocation and writing timings.
-------------------------------------------------------------
Test code snippet
-------------------------------------------------------------
      clock_start();
      buf = malloc(BUF_SZ); /* Allocate 100 MB of memory */

        for(i=0; i < BUF_SZ_PAGES; i++)
        {
                *((int *)(buf + (i*PAGE_SIZE))) = 1;
        }
      clock_end();
-------------------------------------------------------------

Malloc test timings for 100MB anon allocation:-

Base data:-
Number of iterations: 100
Mean of allocation time: 31831 us
std deviation: 4286 us

v4 data:-
Number of iterations: 100
Mean of allocation time: 18193 us
std deviation: 4915 us

[willy@infradead.org: fix zero_user_segments()]
  Link: https://lkml.kernel.org/r/YYVhHCJcm2DM2G9u@casper.infradead.org
Link: https://lkml.kernel.org/r/20210204073255.20769-2-prathu.baronia@oneplus.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Prathu Baronia <prathu.baronia@oneplus.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |   28 ++++++++++++++--------------
 mm/highmem.c            |    6 +++---
 2 files changed, 17 insertions(+), 17 deletions(-)

--- a/include/linux/highmem.h~mm-highmem-remove-deprecated-kmap_atomic
+++ a/include/linux/highmem.h
@@ -143,9 +143,9 @@ static inline void invalidate_kernel_vma
 #ifndef clear_user_highpage
 static inline void clear_user_highpage(struct page *page, unsigned long vaddr)
 {
-	void *addr = kmap_atomic(page);
+	void *addr = kmap_local_page(page);
 	clear_user_page(addr, vaddr, page);
-	kunmap_atomic(addr);
+	kunmap_local(addr);
 }
 #endif
 
@@ -177,9 +177,9 @@ alloc_zeroed_user_highpage_movable(struc
 
 static inline void clear_highpage(struct page *page)
 {
-	void *kaddr = kmap_atomic(page);
+	void *kaddr = kmap_local_page(page);
 	clear_page(kaddr);
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 }
 
 #ifndef __HAVE_ARCH_TAG_CLEAR_HIGHPAGE
@@ -202,7 +202,7 @@ static inline void zero_user_segments(st
 		unsigned start1, unsigned end1,
 		unsigned start2, unsigned end2)
 {
-	void *kaddr = kmap_atomic(page);
+	void *kaddr = kmap_local_page(page);
 	unsigned int i;
 
 	BUG_ON(end1 > page_size(page) || end2 > page_size(page));
@@ -213,7 +213,7 @@ static inline void zero_user_segments(st
 	if (end2 > start2)
 		memset(kaddr + start2, 0, end2 - start2);
 
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 	for (i = 0; i < compound_nr(page); i++)
 		flush_dcache_page(page + i);
 }
@@ -238,11 +238,11 @@ static inline void copy_user_highpage(st
 {
 	char *vfrom, *vto;
 
-	vfrom = kmap_atomic(from);
-	vto = kmap_atomic(to);
+	vfrom = kmap_local_page(from);
+	vto = kmap_local_page(to);
 	copy_user_page(vto, vfrom, vaddr, to);
-	kunmap_atomic(vto);
-	kunmap_atomic(vfrom);
+	kunmap_local(vto);
+	kunmap_local(vfrom);
 }
 
 #endif
@@ -253,11 +253,11 @@ static inline void copy_highpage(struct
 {
 	char *vfrom, *vto;
 
-	vfrom = kmap_atomic(from);
-	vto = kmap_atomic(to);
+	vfrom = kmap_local_page(from);
+	vto = kmap_local_page(to);
 	copy_page(vto, vfrom);
-	kunmap_atomic(vto);
-	kunmap_atomic(vfrom);
+	kunmap_local(vto);
+	kunmap_local(vfrom);
 }
 
 #endif
--- a/mm/highmem.c~mm-highmem-remove-deprecated-kmap_atomic
+++ a/mm/highmem.c
@@ -383,7 +383,7 @@ void zero_user_segments(struct page *pag
 			unsigned this_end = min_t(unsigned, end1, PAGE_SIZE);
 
 			if (end1 > start1) {
-				kaddr = kmap_atomic(page + i);
+				kaddr = kmap_local_page(page + i);
 				memset(kaddr + start1, 0, this_end - start1);
 			}
 			end1 -= this_end;
@@ -398,7 +398,7 @@ void zero_user_segments(struct page *pag
 
 			if (end2 > start2) {
 				if (!kaddr)
-					kaddr = kmap_atomic(page + i);
+					kaddr = kmap_local_page(page + i);
 				memset(kaddr + start2, 0, this_end - start2);
 			}
 			end2 -= this_end;
@@ -406,7 +406,7 @@ void zero_user_segments(struct page *pag
 		}
 
 		if (kaddr) {
-			kunmap_atomic(kaddr);
+			kunmap_local(kaddr);
 			flush_dcache_page(page + i);
 		}
 
_
