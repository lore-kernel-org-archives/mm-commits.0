Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFD0BC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 21 Apr 2022 18:25:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391453AbiDUS2O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Apr 2022 14:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391543AbiDUS1t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2022 14:27:49 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80ED6B8A
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 11:24:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 85761CE25E6
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 18:24:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C103AC385A1;
        Thu, 21 Apr 2022 18:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650565489;
        bh=Zr3fN8qI94hRhO4I5hj3Z+QKvtwp30K51MXh2DQ2JDk=;
        h=Date:To:From:Subject:From;
        b=Dby2/dH01grvZlZyLzNYdtslOA55pcQM+hVo0CpWiL9Ae8t1Na7u6kNBd6k6+k5XS
         WUAXBGIyVMxWZw/Qk90v4VotH1CJOj8tsYzirQGPFmRhN894D6VCdsdAAWIQ8fNOjr
         3jrreD6TfBJoOOBc+Dpa35ua6F4BibDoRM1ndAd4=
Date:   Thu, 21 Apr 2022 11:24:48 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        vbabka@suse.cz, rppt@linux.ibm.com, pcc@google.com,
        ira.weiny@intel.com, catalin.marinas@arm.com,
        bigeasy@linutronix.de, fmdefrancesco@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-highmem-fix-kernel-doc-warnings-in-highmemh.patch removed from -mm tree
Message-Id: <20220421182449.C103AC385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/highmem: fix kernel-doc warnings in highmem*.h
has been removed from the -mm tree.  Its filename was
     mm-highmem-fix-kernel-doc-warnings-in-highmemh.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Subject: mm/highmem: fix kernel-doc warnings in highmem*.h

`scripts/kernel-doc -none include/linux/highmem*` reports the following
warnings:

include/linux/highmem.h:160: warning: expecting prototype for kunmap_atomic(). Prototype was for nr_free_highpages() instead
include/linux/highmem-internal.h:256: warning: Function parameter or member '__addr' not described in 'kunmap_atomic'
include/linux/highmem-internal.h:256: warning: Excess function parameter 'addr' description in 'kunmap_atomic'

Fix these warnings by (1) move the kernel-doc comments from highmem.h to
highmem-internal.h (which is the file were the kunmap_atomic() macro is
actually defined), (2) merge it with the comment which already was in
highmem-internal.h, and (3) use correct parameter names.

Link: https://lkml.kernel.org/r/20220418175638.30018-1-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Will Deacon <will@kernel.org>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem-internal.h |   14 +++++++++++---
 include/linux/highmem.h          |   13 +------------
 2 files changed, 12 insertions(+), 15 deletions(-)

--- a/include/linux/highmem.h~mm-highmem-fix-kernel-doc-warnings-in-highmemh
+++ a/include/linux/highmem.h
@@ -37,7 +37,7 @@ static inline void *kmap(struct page *pa
 
 /**
  * kunmap - Unmap the virtual address mapped by kmap()
- * @addr:	Virtual address to be unmapped
+ * @page:	Virtual address to be unmapped
  *
  * Counterpart to kmap(). A NOOP for CONFIG_HIGHMEM=n and for mappings of
  * pages in the low memory area.
@@ -145,17 +145,6 @@ static inline void *kmap_local_folio(str
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
--- a/include/linux/highmem-internal.h~mm-highmem-fix-kernel-doc-warnings-in-highmemh
+++ a/include/linux/highmem-internal.h
@@ -236,9 +236,17 @@ static inline unsigned long totalhigh_pa
 
 #endif /* CONFIG_HIGHMEM */
 
-/*
- * Prevent people trying to call kunmap_atomic() as if it were kunmap()
- * kunmap_atomic() should get the return value of kmap_atomic, not the page.
+/**
+ * kunmap_atomic - Unmap the virtual address mapped by kmap_atomic()
+ * @__addr:       Virtual address to be unmapped
+ *
+ * Counterpart to kmap_atomic().
+ *
+ * Effectively a wrapper around kunmap_local() which additionally undoes
+ * the side effects of kmap_atomic(), i.e. reenabling pagefaults and
+ * preemption. Prevent people trying to call kunmap_atomic() as if it
+ * were kunmap() because kunmap_atomic() should get the return value of
+ * kmap_atomic(), not its argument which is a pointer to struct page.
  */
 #define kunmap_atomic(__addr)					\
 do {								\
_

Patches currently in -mm which might be from fmdefrancesco@gmail.com are


