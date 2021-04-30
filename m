Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 759EBC43461
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:01:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59FD76157E
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:01:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbhD3GBz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:01:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229508AbhD3GBz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:01:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91A8D61490;
        Fri, 30 Apr 2021 06:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762467;
        bh=2MFjjrq89kI4cUJX1BLZr0ucRoC25cR7kxfEYG6g4m4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=cYCkeBGXFFic20mM9JQPatdYWYcyLJPBpHsP/TcvkN95rnnFiSoEl6r9gKi4NrHsh
         pH2HZVJnbHZBteo0lEbDLXLUI/9D+eo26UBte60XeNdNEWNfsI55+HaQTnIVWDp8UJ
         GsoVllUKfN0vWGiWqt+0Bac2DXiZBddq70qthjAw=
Date:   Thu, 29 Apr 2021 23:01:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org, yuzhao@google.com
Subject:  [patch 154/178] include/linux/page-flags-layout.h:
 cleanups
Message-ID: <20210430060107.wOmM4qlXZ%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
