Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AA56C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:10:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355801AbiCYBLu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357157AbiCYBLj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:11:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D1B65781
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:10:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4E376186B
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:10:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26CAAC340EE;
        Fri, 25 Mar 2022 01:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170605;
        bh=5u/tJ2WdJd5MUC5awQ6xdQ27v6TkrckI49rq4SpD9HA=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=tnNIoZTEVvt4AU3Pv3w5DAIB/5w7dvnPf6LxiAS0nB/7sYehuLszSh7+VCSF6RBoX
         4Gkgtujs3jijzkgn3rw+8ORIO5G5LDrZR0BVfmDzRMjaUqmRWPimP8/KnIlh27Ye43
         T/XknwVKR+t802PWDpBtCmfVWqyjbLGGOX8RHOS4=
Date:   Thu, 24 Mar 2022 18:10:04 -0700
To:     will@kernel.org, vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com,
        pcc@google.com, mark.rutland@arm.com, glider@google.com,
        eugenis@google.com, elver@google.com, dvyukov@google.com,
        catalin.marinas@arm.com, andreyknvl@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 030/114] kasan, page_alloc: deduplicate should_skip_kasan_poison
Message-Id: <20220325011005.26CAAC340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, page_alloc: deduplicate should_skip_kasan_poison

Patch series "kasan, vmalloc, arm64: add vmalloc tagging support for SW/HW_TAGS", v6.

This patchset adds vmalloc tagging support for SW_TAGS and HW_TAGS
KASAN modes.

About half of patches are cleanups I went for along the way.  None of them
seem to be important enough to go through stable, so I decided not to
split them out into separate patches/series.

The patchset is partially based on an early version of the HW_TAGS
patchset by Vincenzo that had vmalloc support.  Thus, I added a
Co-developed-by tag into a few patches.

SW_TAGS vmalloc tagging support is straightforward.  It reuses all of the
generic KASAN machinery, but uses shadow memory to store tags instead of
magic values.  Naturally, vmalloc tagging requires adding a few
kasan_reset_tag() annotations to the vmalloc code.

HW_TAGS vmalloc tagging support stands out.  HW_TAGS KASAN is based on Arm
MTE, which can only assigns tags to physical memory.  As a result, HW_TAGS
KASAN only tags vmalloc() allocations, which are backed by page_alloc
memory.  It ignores vmap() and others.


This patch (of 39):

Currently, should_skip_kasan_poison() has two definitions: one for when
CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled, one for when it's not.

Instead of duplicating the checks, add a deferred_pages_enabled() helper
and use it in a single should_skip_kasan_poison() definition.

Also move should_skip_kasan_poison() closer to its caller and clarify all
conditions in the comment.

Link: https://lkml.kernel.org/r/cover.1643047180.git.andreyknvl@google.com
Link: https://lkml.kernel.org/r/658b79f5fb305edaf7dc16bc52ea870d3220d4a8.1643047180.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   55 +++++++++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 22 deletions(-)

--- a/mm/page_alloc.c~kasan-page_alloc-deduplicate-should_skip_kasan_poison
+++ a/mm/page_alloc.c
@@ -378,25 +378,9 @@ int page_group_by_mobility_disabled __re
  */
 static DEFINE_STATIC_KEY_TRUE(deferred_pages);
 
-/*
- * Calling kasan_poison_pages() only after deferred memory initialization
- * has completed. Poisoning pages during deferred memory init will greatly
- * lengthen the process and cause problem in large memory systems as the
- * deferred pages initialization is done with interrupt disabled.
- *
- * Assuming that there will be no reference to those newly initialized
- * pages before they are ever allocated, this should have no effect on
- * KASAN memory tracking as the poison will be properly inserted at page
- * allocation time. The only corner case is when pages are allocated by
- * on-demand allocation and then freed again before the deferred pages
- * initialization is done, but this is not likely to happen.
- */
-static inline bool should_skip_kasan_poison(struct page *page, fpi_t fpi_flags)
+static inline bool deferred_pages_enabled(void)
 {
-	return static_branch_unlikely(&deferred_pages) ||
-	       (!IS_ENABLED(CONFIG_KASAN_GENERIC) &&
-		(fpi_flags & FPI_SKIP_KASAN_POISON)) ||
-	       PageSkipKASanPoison(page);
+	return static_branch_unlikely(&deferred_pages);
 }
 
 /* Returns true if the struct page for the pfn is uninitialised */
@@ -447,11 +431,9 @@ defer_init(int nid, unsigned long pfn, u
 	return false;
 }
 #else
-static inline bool should_skip_kasan_poison(struct page *page, fpi_t fpi_flags)
+static inline bool deferred_pages_enabled(void)
 {
-	return (!IS_ENABLED(CONFIG_KASAN_GENERIC) &&
-		(fpi_flags & FPI_SKIP_KASAN_POISON)) ||
-	       PageSkipKASanPoison(page);
+	return false;
 }
 
 static inline bool early_page_uninitialised(unsigned long pfn)
@@ -1267,6 +1249,35 @@ out:
 	return ret;
 }
 
+/*
+ * Skip KASAN memory poisoning when either:
+ *
+ * 1. Deferred memory initialization has not yet completed,
+ *    see the explanation below.
+ * 2. Skipping poisoning is requested via FPI_SKIP_KASAN_POISON,
+ *    see the comment next to it.
+ * 3. Skipping poisoning is requested via __GFP_SKIP_KASAN_POISON,
+ *    see the comment next to it.
+ *
+ * Poisoning pages during deferred memory init will greatly lengthen the
+ * process and cause problem in large memory systems as the deferred pages
+ * initialization is done with interrupt disabled.
+ *
+ * Assuming that there will be no reference to those newly initialized
+ * pages before they are ever allocated, this should have no effect on
+ * KASAN memory tracking as the poison will be properly inserted at page
+ * allocation time. The only corner case is when pages are allocated by
+ * on-demand allocation and then freed again before the deferred pages
+ * initialization is done, but this is not likely to happen.
+ */
+static inline bool should_skip_kasan_poison(struct page *page, fpi_t fpi_flags)
+{
+	return deferred_pages_enabled() ||
+	       (!IS_ENABLED(CONFIG_KASAN_GENERIC) &&
+		(fpi_flags & FPI_SKIP_KASAN_POISON)) ||
+	       PageSkipKASanPoison(page);
+}
+
 static void kernel_init_free_pages(struct page *page, int numpages, bool zero_tags)
 {
 	int i;
_
