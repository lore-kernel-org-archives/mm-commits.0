Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2C28C433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:03:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AEEE221FF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709383;
	bh=c9A5aONVgXWgFc5n+CxTM9SJIGfdRFBMNHql759pizg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=TuzFrMTtxlmbyBbn7sSiLQUPpVdw/Gjj2rzfpWlh2dSDXHq/AKDk2B8Mp4K2dwUtp
	 GyDJqRFJUNfTF+X2aQC0mcfETv79ERiT9e37unmL8z29IRUNQn17hrBe6tsqWlMLyv
	 Bg3i0ZlEbdxQSA4d5gsfNMMx9pg1ZG02PLizCZEw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730511AbgJNVDD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:03:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgJNVDD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:03:03 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9195E206B2;
        Wed, 14 Oct 2020 21:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709381;
        bh=c9A5aONVgXWgFc5n+CxTM9SJIGfdRFBMNHql759pizg=;
        h=Date:From:To:Subject:From;
        b=XixIiHjszmzVNvdAsx9HLqNBC7YyRc/sSrITJVjSWjdktJhGfDRbLp3TL5dTtTnRb
         TIylKV6fBqQOEQ6PobUarB06Kh+1ijQMNbYO1wx7yhnuHnyU5lLuLbDqXnT09KHgMA
         mDImMqqEBA5gNzStLBZsiDc7+3CTs3AqDe7nPZhE=
Date:   Wed, 14 Oct 2020 14:03:01 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, mm-commits@vger.kernel.org, npiggin@gmail.com,
        peterz@infradead.org, rppt@linux.ibm.com, willy@infradead.org
Subject:  [merged] page_alloc-fix-freeing-non-compound-pages.patch
 removed from -mm tree
Message-ID: <20201014210301.w32vWqDux%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: fix freeing non-compound pages
has been removed from the -mm tree.  Its filename was
     page_alloc-fix-freeing-non-compound-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/page_alloc.c: fix freeing non-compound pages

Here is a very rare race which leaks memory:

Page P0 is allocated to the page cache.  Page P1 is free.

Thread A                Thread B                Thread C
find_get_entry():
xas_load() returns P0
						Removes P0 from page cache
						P0 finds its buddy P1
			alloc_pages(GFP_KERNEL, 1) returns P0
			P0 has refcount 1
page_cache_get_speculative(P0)
P0 has refcount 2
			__free_pages(P0)
			P0 has refcount 1
put_page(P0)
P1 is not freed

Fix this by freeing all the pages in __free_pages() that won't be freed
by the call to put_page().  It's usually not a good idea to split a page,
but this is a very unlikely scenario.

Link: https://lkml.kernel.org/r/20200926213919.26642-1-willy@infradead.org
Fixes: e286781d5f2e ("mm: speculative page references")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Nick Piggin <npiggin@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug     |    9 ++++++++
 lib/Makefile          |    1 
 lib/test_free_pages.c |   42 ++++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c       |    3 ++
 4 files changed, 55 insertions(+)

--- a/lib/Kconfig.debug~page_alloc-fix-freeing-non-compound-pages
+++ a/lib/Kconfig.debug
@@ -2367,6 +2367,15 @@ config TEST_HMM
 
 	  If unsure, say N.
 
+config TEST_FREE_PAGES
+	tristate "Test freeing pages"
+	help
+	  Test that a memory leak does not occur due to a race between
+	  freeing a block of pages and a speculative page reference.
+	  Loading this module is safe if your kernel has the bug fixed.
+	  If the bug is not fixed, it will leak gigabytes of memory and
+	  probably OOM your system.
+
 config TEST_FPU
 	tristate "Test floating point operations in kernel space"
 	depends on X86 && !KCOV_INSTRUMENT_ALL
--- a/lib/Makefile~page_alloc-fix-freeing-non-compound-pages
+++ a/lib/Makefile
@@ -101,6 +101,7 @@ obj-$(CONFIG_TEST_BLACKHOLE_DEV) += test
 obj-$(CONFIG_TEST_MEMINIT) += test_meminit.o
 obj-$(CONFIG_TEST_LOCKUP) += test_lockup.o
 obj-$(CONFIG_TEST_HMM) += test_hmm.o
+obj-$(CONFIG_TEST_FREE_PAGES) += test_free_pages.o
 
 #
 # CFLAGS for compiling floating point code inside the kernel. x86/Makefile turns
--- /dev/null
+++ a/lib/test_free_pages.c
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * test_free_pages.c: Check that free_pages() doesn't leak memory
+ * Copyright (c) 2020 Oracle
+ * Author: Matthew Wilcox <willy@infradead.org>
+ */
+
+#include <linux/gfp.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+
+static void test_free_pages(gfp_t gfp)
+{
+	unsigned int i;
+
+	for (i = 0; i < 1000 * 1000; i++) {
+		unsigned long addr = __get_free_pages(gfp, 3);
+		struct page *page = virt_to_page(addr);
+
+		/* Simulate page cache getting a speculative reference */
+		get_page(page);
+		free_pages(addr, 3);
+		put_page(page);
+	}
+}
+
+static int m_in(void)
+{
+	test_free_pages(GFP_KERNEL);
+	test_free_pages(GFP_KERNEL | __GFP_COMP);
+
+	return 0;
+}
+
+static void m_ex(void)
+{
+}
+
+module_init(m_in);
+module_exit(m_ex);
+MODULE_AUTHOR("Matthew Wilcox <willy@infradead.org>");
+MODULE_LICENSE("GPL");
--- a/mm/page_alloc.c~page_alloc-fix-freeing-non-compound-pages
+++ a/mm/page_alloc.c
@@ -4952,6 +4952,9 @@ void __free_pages(struct page *page, uns
 {
 	if (put_page_testzero(page))
 		free_the_page(page, order);
+	else if (!PageHead(page))
+		while (order-- > 0)
+			free_the_page(page + (1 << order), order);
 }
 EXPORT_SYMBOL(__free_pages);
 
_

Patches currently in -mm which might be from willy@infradead.org are

xarray-add-xa_get_order.patch
xarray-add-xas_split.patch
xarray-add-xas_split-fix-2.patch
xarray-add-xas_split-fix-3patch.patch
mm-filemap-fix-storing-to-a-thp-shadow-entry.patch
mm-filemap-fix-page-cache-removal-for-arbitrary-sized-thps.patch
mm-memory-remove-page-fault-assumption-of-compound-page-size.patch
mm-memory-remove-page-fault-assumption-of-compound-page-size-fix.patch
mm-page_owner-change-split_page_owner-to-take-a-count.patch
mm-huge_memory-fix-page_trans_huge_mapcount-assumption-of-thp-size.patch
mm-huge_memory-fix-can_split_huge_page-assumption-of-thp-size.patch
mm-rmap-fix-assumptions-of-thp-size.patch
mm-truncate-fix-truncation-for-pages-of-arbitrary-size.patch
mm-page-writeback-support-tail-pages-in-wait_for_stable_page.patch
mm-vmscan-allow-arbitrary-sized-pages-to-be-paged-out.patch
fs-add-a-filesystem-flag-for-thps.patch
fs-do-not-update-nr_thps-for-mappings-which-support-thps.patch
mm-readahead-add-define_readahead.patch
mm-readahead-make-page_cache_ra_unbounded-take-a-readahead_control.patch
mm-readahead-make-do_page_cache_ra-take-a-readahead_control.patch
mm-readahead-add-page_cache_sync_ra-and-page_cache_async_ra.patch
mm-rename-page_order-to-buddy_order.patch
ramfs-fix-nommu-mmap-with-gaps-in-the-page-cache.patch
harden-autofs-ioctl-table.patch
mm-update-the-documentation-for-vfree.patch

