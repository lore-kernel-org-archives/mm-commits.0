Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C131C4161F
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 01:09:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4742964EEC
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 01:09:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241802AbhCDA7B (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:59:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:39418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1382298AbhCDALk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 19:11:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D096364F11;
        Wed,  3 Mar 2021 23:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614813381;
        bh=XJdbOF+7FCJbj2cA0xHe+uqOD4eyXN3oZGevUwLibQA=;
        h=Date:From:To:Subject:From;
        b=kVQhjzFyYXytBZyfBPmlGJRxBU9T9g5el+FEIwBq2gY2yj3KJL9LDdzZUpoH2n/ib
         Xgbpm8nBNAJ3Gtu7I+35J91/UaLLBmrHdAWYtgOcxOStiEDLdRgAPvgZ/WMsLlLYal
         1sSpq6PCL19Y4R5qH4I5SaZWFT8PBIKiWEQyD4Rs=
Date:   Wed, 03 Mar 2021 15:16:20 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, yuzhao@google.com
Subject:  + mm-clean-up-include-linux-page-flags-layouth.patch
 added to -mm tree
Message-ID: <20210303231620.AsGuXThO6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/page-flags-layout.h: cleanups
has been added to the -mm tree.  Its filename is
     mm-clean-up-include-linux-page-flags-layouth.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-clean-up-include-linux-page-flags-layouth.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-clean-up-include-linux-page-flags-layouth.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: include/linux/page-flags-layout.h: cleanups

Tidy things up and delete comments stating the obvious with typos or
making no sense.

Link: https://lkml.kernel.org/r/20210303071609.797782-2-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags-layout.h |   62 +++++++++++++---------------
 mm/mm_init.c                      |    4 -
 2 files changed, 29 insertions(+), 37 deletions(-)

--- a/include/linux/page-flags-layout.h~mm-clean-up-include-linux-page-flags-layouth
+++ a/include/linux/page-flags-layout.h
@@ -21,16 +21,17 @@
 #elif MAX_NR_ZONES <= 8
 #define ZONES_SHIFT 3
 #else
-#error ZONES_SHIFT -- too many zones configured adjust calculation
+#error ZONES_SHIFT "Too many zones configured"
 #endif
 
+#define ZONES_WIDTH		ZONES_SHIFT
+
 #ifdef CONFIG_SPARSEMEM
 #include <asm/sparsemem.h>
-
-/* SECTION_SHIFT	#bits space required to store a section # */
 #define SECTIONS_SHIFT	(MAX_PHYSMEM_BITS - SECTION_SIZE_BITS)
-
-#endif /* CONFIG_SPARSEMEM */
+#else
+#define SECTIONS_SHIFT	0
+#endif
 
 #ifndef BUILD_VDSO32_64
 /*
@@ -54,17 +55,28 @@
 #define SECTIONS_WIDTH		0
 #endif
 
-#define ZONES_WIDTH		ZONES_SHIFT
-
-#if SECTIONS_WIDTH+ZONES_WIDTH+NODES_SHIFT <= BITS_PER_LONG - NR_PAGEFLAGS
+#if ZONES_WIDTH + SECTIONS_WIDTH + NODES_SHIFT <= BITS_PER_LONG - NR_PAGEFLAGS
 #define NODES_WIDTH		NODES_SHIFT
-#else
-#ifdef CONFIG_SPARSEMEM_VMEMMAP
+#elif defined(CONFIG_SPARSEMEM_VMEMMAP)
 #error "Vmemmap: No space for nodes field in page flags"
-#endif
+#else
 #define NODES_WIDTH		0
 #endif
 
+/*
+ * Note that this #define MUST have a value so that it can be tested with
+ * the IS_ENABLED() macro.
+ */
+#if NODES_SHIFT != 0 && NODES_WIDTH == 0
+#define NODE_NOT_IN_PAGE_FLAGS	1
+#endif
+
+#if defined(CONFIG_KASAN_SW_TAGS) || defined(CONFIG_KASAN_HW_TAGS)
+#define KASAN_TAG_WIDTH 8
+#else
+#define KASAN_TAG_WIDTH 0
+#endif
+
 #ifdef CONFIG_NUMA_BALANCING
 #define LAST__PID_SHIFT 8
 #define LAST__PID_MASK  ((1 << LAST__PID_SHIFT)-1)
@@ -77,36 +89,20 @@
 #define LAST_CPUPID_SHIFT 0
 #endif
 
-#if defined(CONFIG_KASAN_SW_TAGS) || defined(CONFIG_KASAN_HW_TAGS)
-#define KASAN_TAG_WIDTH 8
-#else
-#define KASAN_TAG_WIDTH 0
-#endif
-
-#if SECTIONS_WIDTH+ZONES_WIDTH+NODES_WIDTH+LAST_CPUPID_SHIFT+KASAN_TAG_WIDTH \
+#if ZONES_WIDTH + SECTIONS_WIDTH + NODES_WIDTH + KASAN_TAG_WIDTH + LAST_CPUPID_SHIFT \
 	<= BITS_PER_LONG - NR_PAGEFLAGS
 #define LAST_CPUPID_WIDTH LAST_CPUPID_SHIFT
 #else
 #define LAST_CPUPID_WIDTH 0
 #endif
 
-#if SECTIONS_WIDTH+NODES_WIDTH+ZONES_WIDTH+LAST_CPUPID_WIDTH+KASAN_TAG_WIDTH \
-	> BITS_PER_LONG - NR_PAGEFLAGS
-#error "Not enough bits in page flags"
-#endif
-
-/*
- * We are going to use the flags for the page to node mapping if its in
- * there.  This includes the case where there is no node, so it is implicit.
- * Note that this #define MUST have a value so that it can be tested with
- * the IS_ENABLED() macro.
- */
-#if !(NODES_WIDTH > 0 || NODES_SHIFT == 0)
-#define NODE_NOT_IN_PAGE_FLAGS 1
+#if LAST_CPUPID_SHIFT != 0 && LAST_CPUPID_WIDTH == 0
+#define LAST_CPUPID_NOT_IN_PAGE_FLAGS
 #endif
 
-#if defined(CONFIG_NUMA_BALANCING) && LAST_CPUPID_WIDTH == 0
-#define LAST_CPUPID_NOT_IN_PAGE_FLAGS
+#if ZONES_WIDTH + SECTIONS_WIDTH + NODES_WIDTH + KASAN_TAG_WIDTH + LAST_CPUPID_WIDTH \
+	> BITS_PER_LONG - NR_PAGEFLAGS
+#error "Not enough bits in page flags"
 #endif
 
 #endif
--- a/mm/mm_init.c~mm-clean-up-include-linux-page-flags-layouth
+++ a/mm/mm_init.c
@@ -19,10 +19,6 @@
 #ifdef CONFIG_DEBUG_MEMORY_INIT
 int __meminitdata mminit_loglevel;
 
-#ifndef SECTIONS_SHIFT
-#define SECTIONS_SHIFT	0
-#endif
-
 /* The zonelists are simply reported, validation is manual. */
 void __init mminit_verify_zonelist(void)
 {
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-correctly-determine-last_cpupid_width.patch
mm-clean-up-include-linux-page-flags-layouth.patch

