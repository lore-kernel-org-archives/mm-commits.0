Return-Path: <SRS0=qjDH=DG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 186FCC2D0A8
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 01:03:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE1A0208FE
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 01:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601341434;
	bh=VQv+RbHOWabOsan3yiU41hgGD6qUX2sRCiGvhVW8VB4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=HfBwQtybOVtrEDAmRKNgbBqVQ7LQVhIOiToRvT/Om3iXGsIZ4Mzk4x7cMeARRxBrA
	 Ox7UAr2lU60msD2dVVZl83K3i27AfANX6zg9/PW4qEuZ0kvje8qynPPAzY+iktgePT
	 BvxBUzQvYFolyMOqQVQkNbGSd/dW8tz50NNjsCVY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbgI2BDy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Sep 2020 21:03:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727043AbgI2BDy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Sep 2020 21:03:54 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0BDD207C4;
        Tue, 29 Sep 2020 01:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601341432;
        bh=VQv+RbHOWabOsan3yiU41hgGD6qUX2sRCiGvhVW8VB4=;
        h=Date:From:To:Subject:From;
        b=lPGriK5PfdNtzonqOt/H+aKMwMigyBR7rO4ikEqRPo+x3jZAmsiEz0YtRr+q6yYcG
         wxbU37QWH9d+FtrrRqGNDt/NajxCrNcDTuEJNGXHmg9NWO+Rn/TBWgL4enx5PolJsx
         WB6EdqWR2zdibe33SkPQNGgKkKhVhjMxsUUXSCWY=
Date:   Mon, 28 Sep 2020 18:03:51 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, mm-commits@vger.kernel.org, npiggin@gmail.com,
        peterz@infradead.org, willy@infradead.org
Subject:  + page_alloc-fix-freeing-non-compound-pages.patch added
 to -mm tree
Message-ID: <20200929010351.1aZ9Es30h%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: fix freeing non-compound pages
has been added to the -mm tree.  Its filename is
     page_alloc-fix-freeing-non-compound-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/page_alloc-fix-freeing-non-compound-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/page_alloc-fix-freeing-non-compound-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -4938,6 +4938,9 @@ void __free_pages(struct page *page, uns
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

mm-debug-do-not-dereference-i_ino-blindly.patch
mm-factor-find_get_incore_page-out-of-mincore_page.patch
mm-use-find_get_incore_page-in-memcontrol.patch
mm-optimise-madvise-willneed.patch
mm-optimise-madvise-willneed-fix.patch
proc-optimise-smaps-for-shmem-entries.patch
i915-use-find_lock_page-instead-of-find_lock_entry.patch
mm-convert-find_get_entry-to-return-the-head-page.patch
mm-convert-find_get_entry-to-return-the-head-page-fix.patch
mm-shmem-return-head-page-from-find_lock_entry.patch
mm-shmem-return-head-page-from-find_lock_entry-fix.patch
mm-add-find_lock_head.patch
mm-filemap-fix-filemap_map_pages-for-thp.patch
mm-account-pmd-tables-like-pte-tables.patch
mm-move-pagedoublemap-bit.patch
mm-simplify-pagedoublemap-with-pf_second-policy.patch
page_alloc-fix-freeing-non-compound-pages.patch
xarray-add-xa_get_order.patch
xarray-add-xas_split.patch
xarray-add-xas_split-fix-2.patch
mm-filemap-fix-storing-to-a-thp-shadow-entry.patch
mm-filemap-fix-page-cache-removal-for-arbitrary-sized-thps.patch
mm-memory-remove-page-fault-assumption-of-compound-page-size.patch
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
harden-autofs-ioctl-table.patch

