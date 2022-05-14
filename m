Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2EAAC433EF
	for <mm-commits@archiver.kernel.org>; Sat, 14 May 2022 19:55:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234969AbiENTzT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 May 2022 15:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234937AbiENTzS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 14 May 2022 15:55:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 381C55FD2
        for <mm-commits@vger.kernel.org>; Sat, 14 May 2022 12:55:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 428A1B80AF4
        for <mm-commits@vger.kernel.org>; Sat, 14 May 2022 19:55:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF90C340EE;
        Sat, 14 May 2022 19:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652558113;
        bh=59t/JOh6PxAtyVUgUzrFkXnFF9OfJdQ30ZJ1d/3cCTE=;
        h=Date:To:From:Subject:From;
        b=KMx4W1n40eLoqeGow459d2aMMlsVRta+J2Km/Uuk3Xu6kgP3+Girg6il64MVqnG97
         7Hg4tYYXbVimBQP6aPyD/b0yDceLsiMrs8sa3X9jku05PifUPgR8+GG+XXEDryN4Vw
         ZJAq5ZN7MvipZJTHCAw2GHMAGRgr+2MvEAUpcfLs=
Date:   Sat, 14 May 2022 12:55:12 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        vbabka@suse.cz, tglx@linutronix.de, rppt@linux.ibm.com,
        peterz@infradead.org, pcc@google.com, ira.weiny@intel.com,
        corbet@lwn.net, catalin.marinas@arm.com, bigeasy@linutronix.de,
        fmdefrancesco@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-highmem-fix-kernel-doc-warnings-in-highmemh.patch removed from -mm tree
Message-Id: <20220514195512.DEF90C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/highmem: fix kernel-doc warnings in highmem*.h
has been removed from the -mm tree.  Its filename was
     mm-highmem-fix-kernel-doc-warnings-in-highmemh.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Subject: mm/highmem: fix kernel-doc warnings in highmem*.h

Patch series "Extend and reorganize Highmem's documentation", v4.

This series has the purpose to extend and reorganize Highmem's
documentation.

This is a work in progress because some information should still be moved
from highmem.rst to highmem.h and highmem-internal.h.  Specifically I'm
talking about moving the "how to" information to the relevant headers, as
it as been suggested by Ira Weiny (Intel).

Also, this is a work in progress because some kdocs in highmem.h and
highmem-internal.h should be improved.


This patch (of 4):

`scripts/kernel-doc -v -none include/linux/highmem*` reports the following
warnings:

include/linux/highmem.h:160: warning: expecting prototype for kunmap_atomic(). Prototype was for nr_free_highpages() instead
include/linux/highmem.h:204: warning: No description found for return value of 'alloc_zeroed_user_highpage_movable'
include/linux/highmem-internal.h:256: warning: Function parameter or member '__addr' not described in 'kunmap_atomic'
include/linux/highmem-internal.h:256: warning: Excess function parameter 'addr' description in 'kunmap_atomic'

Fix these warnings by (1) moving the kernel-doc comments from highmem.h to
highmem-internal.h (which is the file were the kunmap_atomic() macro is
actually defined), (2) extending and merging it with the comment which was
already in highmem-internal.h, and (3) using correct parameter names (4)
correcting a few technical inaccuracies in comments, and (5) adding a
deprecation notice in kunmap_atomic() for consistency with kmap_atomic().

Link: https://lkml.kernel.org/r/20220428212455.892-1-fmdefrancesco@gmail.com
Link: https://lkml.kernel.org/r/20220428212455.892-2-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem-internal.h |   18 +++++++++++++++---
 include/linux/highmem.h          |   22 ++++++++--------------
 2 files changed, 23 insertions(+), 17 deletions(-)

--- a/include/linux/highmem.h~mm-highmem-fix-kernel-doc-warnings-in-highmemh
+++ a/include/linux/highmem.h
@@ -37,7 +37,7 @@ static inline void *kmap(struct page *pa
 
 /**
  * kunmap - Unmap the virtual address mapped by kmap()
- * @addr:	Virtual address to be unmapped
+ * @page:	Pointer to the page which was mapped by kmap()
  *
  * Counterpart to kmap(). A NOOP for CONFIG_HIGHMEM=n and for mappings of
  * pages in the low memory area.
@@ -138,24 +138,16 @@ static inline void *kmap_local_folio(str
  *
  * Returns: The virtual address of the mapping
  *
- * Effectively a wrapper around kmap_local_page() which disables pagefaults
- * and preemption.
+ * In fact a wrapper around kmap_local_page() which also disables pagefaults
+ * and, depending on PREEMPT_RT configuration, also CPU migration and
+ * preemption. Therefore users should not count on the latter two side effects.
+ *
+ * Mappings should always be released by kunmap_atomic().
  *
  * Do not use in new code. Use kmap_local_page() instead.
  */
 static inline void *kmap_atomic(struct page *page);
 
-/**
- * kunmap_atomic - Unmap the virtual address mapped by kmap_atomic()
- * @addr:	Virtual address to be unmapped
- *
- * Counterpart to kmap_atomic().
- *
- * Effectively a wrapper around kunmap_local() which additionally undoes
- * the side effects of kmap_atomic(), i.e. reenabling pagefaults and
- * preemption.
- */
-
 /* Highmem related interfaces for management code */
 static inline unsigned int nr_free_highpages(void);
 static inline unsigned long totalhigh_pages(void);
@@ -191,6 +183,8 @@ static inline void clear_user_highpage(s
  * @vma: The VMA the page is to be allocated for
  * @vaddr: The virtual address the page will be inserted into
  *
+ * Returns: The allocated and zeroed HIGHMEM page
+ *
  * This function will allocate a page for a VMA that the caller knows will
  * be able to migrate in the future using move_pages() or reclaimed
  *
--- a/include/linux/highmem-internal.h~mm-highmem-fix-kernel-doc-warnings-in-highmemh
+++ a/include/linux/highmem-internal.h
@@ -236,9 +236,21 @@ static inline unsigned long totalhigh_pa
 
 #endif /* CONFIG_HIGHMEM */
 
-/*
- * Prevent people trying to call kunmap_atomic() as if it were kunmap()
- * kunmap_atomic() should get the return value of kmap_atomic, not the page.
+/**
+ * kunmap_atomic - Unmap the virtual address mapped by kmap_atomic() - deprecated!
+ * @__addr:       Virtual address to be unmapped
+ *
+ * Unmaps an address previously mapped by kmap_atomic() and re-enables
+ * pagefaults. Depending on PREEMP_RT configuration, re-enables also
+ * migration and preemption. Users should not count on these side effects.
+ *
+ * Mappings should be unmapped in the reverse order that they were mapped.
+ * See kmap_local_page() for details on nesting.
+ *
+ * @__addr can be any address within the mapped page, so there is no need
+ * to subtract any offset that has been added. In contrast to kunmap(),
+ * this function takes the address returned from kmap_atomic(), not the
+ * page passed to it. The compiler will warn you if you pass the page.
  */
 #define kunmap_atomic(__addr)					\
 do {								\
_

Patches currently in -mm which might be from fmdefrancesco@gmail.com are


