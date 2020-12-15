Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EF0BC4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:05:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 167A020709
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:05:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbgLODFk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:05:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:33368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727230AbgLODF1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:05:27 -0500
Date:   Mon, 14 Dec 2020 19:04:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001487;
        bh=9/KqSwdzkfcUHkStUu1UHXpR6NWCr6++8nUX5YFL9aw=;
        h=From:To:Subject:In-Reply-To:From;
        b=iNyo+DfhmBAqc/or7tHoQ9XMrVrKbIlyB2p04gWyVxDSQEbqLYS+Uil0QFGIh4qr7
         Vb2ApjbZRjBGamI5c/tDucrXh1aqfVUqWFLgw6BKJEefypA0z1C184idErmWPN+FCn
         47WYMMaPGfEf3Tc5Mui7KdEH2/fb/RZlMyEbn1zg=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, iamjoonsoo.kim@lge.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        zhenhuah@codeaurora.org
Subject:  [patch 026/200] mm: fix page_owner initializing issue for
 arm32
Message-ID: <20201215030446.-BoX8ii9r%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Zhenhua Huang <zhenhuah@codeaurora.org>
Subject: mm: fix page_owner initializing issue for arm32

Page owner of pages used by page owner itself used is missing on arm32
targets.  The reason is dummy_handle and failure_handle is not initialized
correctly.  Buddy allocator is used to initialize these two handles. 
However, buddy allocator is not ready when page owner calls it.  This
change fixed that by initializing page owner after buddy initialization.

The working flow before and after this change are:
original logic:
1. allocated memory for page_ext(using memblock).
2. invoke the init callback of page_ext_ops like
page_owner(using buddy allocator).
3. initialize buddy.

after this change:
1. allocated memory for page_ext(using memblock).
2. initialize buddy.
3. invoke the init callback of page_ext_ops like
page_owner(using buddy allocator).

with the change, failure/dummy_handle can get its correct value and page
owner output for example has the one for page owner itself:

Page allocated via order 2, mask 0x6202c0(GFP_USER|__GFP_NOWARN), pid 1006, ts
67278156558 ns
PFN 543776 type Unmovable Block 531 type Unmovable Flags 0x0()
 init_page_owner+0x28/0x2f8
 invoke_init_callbacks_flatmem+0x24/0x34
 start_kernel+0x33c/0x5d8
   (null)

Link: https://lkml.kernel.org/r/1603104925-5888-1-git-send-email-zhenhuah@codeaurora.org
Signed-off-by: Zhenhua Huang <zhenhuah@codeaurora.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_ext.h |    8 ++++++++
 init/main.c              |    2 ++
 mm/page_ext.c            |   10 ++++++++--
 3 files changed, 18 insertions(+), 2 deletions(-)

--- a/include/linux/page_ext.h~mm-fix-page_owner-initializing-issue-for-arm32
+++ a/include/linux/page_ext.h
@@ -44,8 +44,12 @@ static inline void page_ext_init_flatmem
 {
 }
 extern void page_ext_init(void);
+static inline void page_ext_init_flatmem_late(void)
+{
+}
 #else
 extern void page_ext_init_flatmem(void);
+extern void page_ext_init_flatmem_late(void);
 static inline void page_ext_init(void)
 {
 }
@@ -76,6 +80,10 @@ static inline void page_ext_init(void)
 {
 }
 
+static inline void page_ext_init_flatmem_late(void)
+{
+}
+
 static inline void page_ext_init_flatmem(void)
 {
 }
--- a/init/main.c~mm-fix-page_owner-initializing-issue-for-arm32
+++ a/init/main.c
@@ -828,6 +828,8 @@ static void __init mm_init(void)
 	init_debug_pagealloc();
 	report_meminit();
 	mem_init();
+	/* page_owner must be initialized after buddy is ready */
+	page_ext_init_flatmem_late();
 	kmem_cache_init();
 	kmemleak_init();
 	pgtable_init();
--- a/mm/page_ext.c~mm-fix-page_owner-initializing-issue-for-arm32
+++ a/mm/page_ext.c
@@ -99,12 +99,19 @@ static void __init invoke_init_callbacks
 	}
 }
 
+#ifndef CONFIG_SPARSEMEM
+void __init page_ext_init_flatmem_late(void)
+{
+	invoke_init_callbacks();
+}
+#endif
+
 static inline struct page_ext *get_entry(void *base, unsigned long index)
 {
 	return base + page_ext_size * index;
 }
 
-#if !defined(CONFIG_SPARSEMEM)
+#ifndef CONFIG_SPARSEMEM
 
 
 void __meminit pgdat_page_ext_init(struct pglist_data *pgdat)
@@ -177,7 +184,6 @@ void __init page_ext_init_flatmem(void)
 			goto fail;
 	}
 	pr_info("allocated %ld bytes of page_ext\n", total_usage);
-	invoke_init_callbacks();
 	return;
 
 fail:
_
