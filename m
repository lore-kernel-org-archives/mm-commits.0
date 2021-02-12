Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C808C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 12 Feb 2021 00:17:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3014464DE0
	for <mm-commits@archiver.kernel.org>; Fri, 12 Feb 2021 00:17:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhBLARk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Feb 2021 19:17:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:54962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229647AbhBLARk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Feb 2021 19:17:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB9E364DD5;
        Fri, 12 Feb 2021 00:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613089019;
        bh=Y65PBs4TE1c4vxXH4aMryOq6BXvpF8wOeg2kowNtlXI=;
        h=Date:From:To:Subject:From;
        b=tKUSlEL4LaGyxuCJGJs1YvpwRj2m4GuFHDr9pZC42vM6m06UHzDyyKMz2Tw8YpJnZ
         CMAFim10JX+rNTv7gKbzAkI8Y2BAgN4ffgAz5V7E7wgAM7TCaixLuaAGM2E5bUt4Ue
         ja+nrRSl2IFmbKyIqbJoQTHGy1tJ+do1jiNDyqoA=
Date:   Thu, 11 Feb 2021 16:16:58 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tglx@linutronix.de, rdunlap@infradead.org,
        prathu.baronia@oneplus.com, peterz@infradead.org,
        ira.weiny@intel.com
Subject:  + mm-highmem-remove-deprecated-kmap_atomic.patch added to
 -mm tree
Message-ID: <20210212001658.Ua81b%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/highmem: Remove deprecated kmap_atomic
has been added to the -mm tree.  Its filename is
     mm-highmem-remove-deprecated-kmap_atomic.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-highmem-remove-deprecated-kmap_atomic.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-highmem-remove-deprecated-kmap_atomic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ira Weiny <ira.weiny@intel.com>
Subject: mm/highmem: Remove deprecated kmap_atomic

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

Link: https://lkml.kernel.org/r/20210204073255.20769-2-prathu.baronia@oneplus.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Prathu Baronia <prathu.baronia@oneplus.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/include/linux/highmem.h~mm-highmem-remove-deprecated-kmap_atomic
+++ a/include/linux/highmem.h
@@ -146,9 +146,9 @@ static inline void invalidate_kernel_vma
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
 
@@ -199,9 +199,9 @@ alloc_zeroed_user_highpage_movable(struc
 
 static inline void clear_highpage(struct page *page)
 {
-	void *kaddr = kmap_atomic(page);
+	void *kaddr = kmap_local_page(page);
 	clear_page(kaddr);
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 }
 
 /*
@@ -216,7 +216,7 @@ static inline void zero_user_segments(st
 		unsigned start1, unsigned end1,
 		unsigned start2, unsigned end2)
 {
-	void *kaddr = kmap_atomic(page);
+	void *kaddr = kmap_local_page(page);
 	unsigned int i;
 
 	BUG_ON(end1 > page_size(page) || end2 > page_size(page));
@@ -227,7 +227,7 @@ static inline void zero_user_segments(st
 	if (end2 > start2)
 		memset(kaddr + start2, 0, end2 - start2);
 
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 	for (i = 0; i < compound_nr(page); i++)
 		flush_dcache_page(page + i);
 }
@@ -252,11 +252,11 @@ static inline void copy_user_highpage(st
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
@@ -267,11 +267,11 @@ static inline void copy_highpage(struct
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
_

Patches currently in -mm which might be from ira.weiny@intel.com are

mm-highmem-remove-deprecated-kmap_atomic.patch
fs-coredump-use-kmap_local_page.patch

