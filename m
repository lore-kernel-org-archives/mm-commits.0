Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CAB5C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:56:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16CC42223F
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633366;
	bh=VfQN9E6poNj/sdDbidNqV36Gaxlw/gWKlBTqZOr3+CY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=MWGBY48RVPn/NB9pz2GnyerTzqvua03OIw1Gz5U7+n3gFjDdUqh2foqU20Ticw3CE
	 mZbo3CWUCoS56U2Xs0gP9FC5/7285YufKn7KmzvLUX3CF7Fa9e3Sf/6EEdc85EWLPN
	 Nc48Z796oKQ38u6LVWsKnuqu3N9xaRApAkSbXqfs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388596AbgJMX4F (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:56:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387742AbgJMX4F (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:56:05 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A88A2222E;
        Tue, 13 Oct 2020 23:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633364;
        bh=VfQN9E6poNj/sdDbidNqV36Gaxlw/gWKlBTqZOr3+CY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=hAH2HHVdU0nCem90B+a5Mdt+mP8bt5eR8+ag5tYaDLKOqkmJ7iaAG4AnZOU+TWaAE
         Sspx/+FX2DW/yUj+D/rH8fLYw3sA36GIE3uiwX44ZKWwWGV4EMlj9XNyC9p13jTBv4
         thqohzIDZiE2zNkVEy2VNUGiJ7woPgDBVVBnZoPY=
Date:   Tue, 13 Oct 2020 16:56:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hughd@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, npiggin@gmail.com,
        peterz@infradead.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 139/181] mm/page_alloc.c: fix freeing non-compound
 pages
Message-ID: <20201013235604.YBEl7k9r2%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
