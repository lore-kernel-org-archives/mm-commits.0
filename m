Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F9F4C77B61
	for <mm-commits@archiver.kernel.org>; Thu, 13 Apr 2023 21:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbjDMVdY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Apr 2023 17:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjDMVdX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Apr 2023 17:33:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B724269E
        for <mm-commits@vger.kernel.org>; Thu, 13 Apr 2023 14:33:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 012C564004
        for <mm-commits@vger.kernel.org>; Thu, 13 Apr 2023 21:33:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 299F9C433EF;
        Thu, 13 Apr 2023 21:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681421601;
        bh=nL9TzRgFv8FDN1zJPMGjmBW5EPD6ngrxD00dUfxdtfc=;
        h=Date:To:From:Subject:From;
        b=eS0SV4Ogkua5EMOAUal0REnef+0GQB+Ako/iuJMjCG4m5LSEZERQh4FDJYOgSat/h
         FyjdXDz83sW085foc1tZKyivgOKRUMokoe+3vO/xmg1h+2NMgeuAd70gkbrkZzhRlK
         RW3FyQeilf/fIJlFjWbEsBwDnT1x9/80FWSdHKvE=
Date:   Thu, 13 Apr 2023 14:33:20 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com,
        mail.dipanjan.das@gmail.com, hch@infradead.org, elver@google.com,
        dvyukov@google.com, glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmsan-apply-__must_check-to-non-void-functions.patch added to mm-unstable branch
Message-Id: <20230413213321.299F9C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmsan: apply __must_check to non-void functions
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmsan-apply-__must_check-to-non-void-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmsan-apply-__must_check-to-non-void-functions.patch

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
From: Alexander Potapenko <glider@google.com>
Subject: mm: kmsan: apply __must_check to non-void functions
Date: Thu, 13 Apr 2023 15:12:22 +0200

Non-void KMSAN hooks may return error codes that indicate that KMSAN
failed to reflect the changed memory state in the metadata (e.g.  it could
not create the necessary memory mappings).  In such cases the callers
should handle the errors to prevent the tool from using the inconsistent
metadata in the future.

We mark non-void hooks with __must_check so that error handling is not
skipped.

Link: https://lkml.kernel.org/r/20230413131223.4135168-3-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dipanjan Das <mail.dipanjan.das@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kmsan.h |   43 ++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

--- a/include/linux/kmsan.h~mm-kmsan-apply-__must_check-to-non-void-functions
+++ a/include/linux/kmsan.h
@@ -54,7 +54,8 @@ void __init kmsan_init_runtime(void);
  * Freed pages are either returned to buddy allocator or held back to be used
  * as metadata pages.
  */
-bool __init kmsan_memblock_free_pages(struct page *page, unsigned int order);
+bool __init __must_check kmsan_memblock_free_pages(struct page *page,
+						   unsigned int order);
 
 /**
  * kmsan_alloc_page() - Notify KMSAN about an alloc_pages() call.
@@ -137,9 +138,11 @@ void kmsan_kfree_large(const void *ptr);
  * vmalloc metadata address range. Returns 0 on success, callers must check
  * for non-zero return value.
  */
-int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
-				   pgprot_t prot, struct page **pages,
-				   unsigned int page_shift);
+int __must_check kmsan_vmap_pages_range_noflush(unsigned long start,
+						unsigned long end,
+						pgprot_t prot,
+						struct page **pages,
+						unsigned int page_shift);
 
 /**
  * kmsan_vunmap_kernel_range_noflush() - Notify KMSAN about a vunmap.
@@ -163,9 +166,9 @@ void kmsan_vunmap_range_noflush(unsigned
  * virtual memory. Returns 0 on success, callers must check for non-zero return
  * value.
  */
-int kmsan_ioremap_page_range(unsigned long addr, unsigned long end,
-			     phys_addr_t phys_addr, pgprot_t prot,
-			     unsigned int page_shift);
+int __must_check kmsan_ioremap_page_range(unsigned long addr, unsigned long end,
+					  phys_addr_t phys_addr, pgprot_t prot,
+					  unsigned int page_shift);
 
 /**
  * kmsan_iounmap_page_range() - Notify KMSAN about a iounmap_page_range() call.
@@ -237,8 +240,8 @@ static inline void kmsan_init_runtime(vo
 {
 }
 
-static inline bool kmsan_memblock_free_pages(struct page *page,
-					     unsigned int order)
+static inline bool __must_check kmsan_memblock_free_pages(struct page *page,
+							  unsigned int order)
 {
 	return true;
 }
@@ -251,10 +254,9 @@ static inline void kmsan_task_exit(struc
 {
 }
 
-static inline int kmsan_alloc_page(struct page *page, unsigned int order,
-				   gfp_t flags)
+static inline void kmsan_alloc_page(struct page *page, unsigned int order,
+				    gfp_t flags)
 {
-	return 0;
 }
 
 static inline void kmsan_free_page(struct page *page, unsigned int order)
@@ -283,11 +285,9 @@ static inline void kmsan_kfree_large(con
 {
 }
 
-static inline int kmsan_vmap_pages_range_noflush(unsigned long start,
-						 unsigned long end,
-						 pgprot_t prot,
-						 struct page **pages,
-						 unsigned int page_shift)
+static inline int __must_check kmsan_vmap_pages_range_noflush(
+	unsigned long start, unsigned long end, pgprot_t prot,
+	struct page **pages, unsigned int page_shift)
 {
 	return 0;
 }
@@ -297,10 +297,11 @@ static inline void kmsan_vunmap_range_no
 {
 }
 
-static inline int kmsan_ioremap_page_range(unsigned long start,
-					   unsigned long end,
-					   phys_addr_t phys_addr, pgprot_t prot,
-					   unsigned int page_shift)
+static inline int __must_check kmsan_ioremap_page_range(unsigned long start,
+							unsigned long end,
+							phys_addr_t phys_addr,
+							pgprot_t prot,
+							unsigned int page_shift)
 {
 	return 0;
 }
_

Patches currently in -mm which might be from glider@google.com are

mm-kmsan-handle-alloc-failures-in-kmsan_vmap_pages_range_noflush.patch
mm-kmsan-handle-alloc-failures-in-kmsan_ioremap_page_range.patch
mm-kmsan-apply-__must_check-to-non-void-functions.patch
mm-apply-__must_check-to-vmap_pages_range_noflush.patch

