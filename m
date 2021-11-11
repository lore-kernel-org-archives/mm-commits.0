Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CF18C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:49:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 503CF61108
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234472AbhKKCwM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:52:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:56350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234469AbhKKCwM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:52:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B58F5610A2;
        Thu, 11 Nov 2021 02:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598964;
        bh=0zIf+QrmQ/0x7F6M0zAxz4FUzTgXRHS9EuKncetbDqA=;
        h=Date:From:To:Subject:From;
        b=H8ZM53lmn3Ws5JRUMzd9F1TLKs1ZaW5S0sBVQ51mUzdZqdzieEDAIf7F1ceUI1pqW
         4Msl+eV0kf1kdifQtMFA36XT9PmPeq2vrxYleJtvJ+WwGPpdvnKb0SAK+Y/b0qsjPv
         LCHORE+UfJtfbGh3R55Bp9giZF//kPCYhyNd/2/w=
Date:   Wed, 10 Nov 2021 18:49:23 -0800
From:   akpm@linux-foundation.org
To:     amit@kernel.org, benh@kernel.crashing.org,
        brendanhiggins@google.com, corbet@lwn.net, david@redhat.com,
        dwmw@amazon.com, elver@google.com, foersleo@amazon.de,
        gthelen@google.com, Jonathan.Cameron@huawei.com, markubo@amazon.de,
        mm-commits@vger.kernel.org, rientjes@google.com,
        shakeelb@google.com, shuah@kernel.org, sj@kernel.org
Subject:  [merged]
 mm-damon-vaddr-separate-commonly-usable-functions.patch removed from -mm
 tree
Message-ID: <20211111024923.flAhYKQRk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/vaddr: separate commonly usable functions
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-separate-commonly-usable-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/vaddr: separate commonly usable functions

This commit moves functions in the default virtual address spaces
monitoring primitives that commonly usable from other address spaces like
physical address space into a header file.  Those will be reused by the
physical address space monitoring primitives which will be implemented by
the following commit.

[sj@kernel.org: include 'highmem.h' to fix a build failure]
  Link: https://lkml.kernel.org/r/20211014110848.5204-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20211012205711.29216-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Amit Shah <amit@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rienjes <rientjes@google.com>
Cc: David Woodhouse <dwmw@amazon.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Leonard Foerster <foersleo@amazon.de>
Cc: Marco Elver <elver@google.com>
Cc: Markus Boehme <markubo@amazon.de>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/Makefile       |    2 
 mm/damon/prmtv-common.c |   87 +++++++++++++++++++++++++++++++++++++
 mm/damon/prmtv-common.h |   17 +++++++
 mm/damon/vaddr.c        |   88 +-------------------------------------
 4 files changed, 108 insertions(+), 86 deletions(-)

--- a/mm/damon/Makefile~mm-damon-vaddr-separate-commonly-usable-functions
+++ a/mm/damon/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
 
 obj-$(CONFIG_DAMON)		:= core.o
-obj-$(CONFIG_DAMON_VADDR)	+= vaddr.o
+obj-$(CONFIG_DAMON_VADDR)	+= prmtv-common.o vaddr.o
 obj-$(CONFIG_DAMON_DBGFS)	+= dbgfs.o
--- /dev/null
+++ a/mm/damon/prmtv-common.c
@@ -0,0 +1,87 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Common Primitives for Data Access Monitoring
+ *
+ * Author: SeongJae Park <sj@kernel.org>
+ */
+
+#include <linux/mmu_notifier.h>
+#include <linux/page_idle.h>
+#include <linux/pagemap.h>
+#include <linux/rmap.h>
+
+#include "prmtv-common.h"
+
+/*
+ * Get an online page for a pfn if it's in the LRU list.  Otherwise, returns
+ * NULL.
+ *
+ * The body of this function is stolen from the 'page_idle_get_page()'.  We
+ * steal rather than reuse it because the code is quite simple.
+ */
+struct page *damon_get_page(unsigned long pfn)
+{
+	struct page *page = pfn_to_online_page(pfn);
+
+	if (!page || !PageLRU(page) || !get_page_unless_zero(page))
+		return NULL;
+
+	if (unlikely(!PageLRU(page))) {
+		put_page(page);
+		page = NULL;
+	}
+	return page;
+}
+
+void damon_ptep_mkold(pte_t *pte, struct mm_struct *mm, unsigned long addr)
+{
+	bool referenced = false;
+	struct page *page = damon_get_page(pte_pfn(*pte));
+
+	if (!page)
+		return;
+
+	if (pte_young(*pte)) {
+		referenced = true;
+		*pte = pte_mkold(*pte);
+	}
+
+#ifdef CONFIG_MMU_NOTIFIER
+	if (mmu_notifier_clear_young(mm, addr, addr + PAGE_SIZE))
+		referenced = true;
+#endif /* CONFIG_MMU_NOTIFIER */
+
+	if (referenced)
+		set_page_young(page);
+
+	set_page_idle(page);
+	put_page(page);
+}
+
+void damon_pmdp_mkold(pmd_t *pmd, struct mm_struct *mm, unsigned long addr)
+{
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	bool referenced = false;
+	struct page *page = damon_get_page(pmd_pfn(*pmd));
+
+	if (!page)
+		return;
+
+	if (pmd_young(*pmd)) {
+		referenced = true;
+		*pmd = pmd_mkold(*pmd);
+	}
+
+#ifdef CONFIG_MMU_NOTIFIER
+	if (mmu_notifier_clear_young(mm, addr,
+				addr + ((1UL) << HPAGE_PMD_SHIFT)))
+		referenced = true;
+#endif /* CONFIG_MMU_NOTIFIER */
+
+	if (referenced)
+		set_page_young(page);
+
+	set_page_idle(page);
+	put_page(page);
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+}
--- /dev/null
+++ a/mm/damon/prmtv-common.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Common Primitives for Data Access Monitoring
+ *
+ * Author: SeongJae Park <sj@kernel.org>
+ */
+
+#include <linux/damon.h>
+#include <linux/random.h>
+
+/* Get a random number in [l, r) */
+#define damon_rand(l, r) (l + prandom_u32_max(r - l))
+
+struct page *damon_get_page(unsigned long pfn);
+
+void damon_ptep_mkold(pte_t *pte, struct mm_struct *mm, unsigned long addr);
+void damon_pmdp_mkold(pmd_t *pmd, struct mm_struct *mm, unsigned long addr);
--- a/mm/damon/vaddr.c~mm-damon-vaddr-separate-commonly-usable-functions
+++ a/mm/damon/vaddr.c
@@ -8,25 +8,19 @@
 #define pr_fmt(fmt) "damon-va: " fmt
 
 #include <asm-generic/mman-common.h>
-#include <linux/damon.h>
+#include <linux/highmem.h>
 #include <linux/hugetlb.h>
-#include <linux/mm.h>
 #include <linux/mmu_notifier.h>
-#include <linux/highmem.h>
 #include <linux/page_idle.h>
 #include <linux/pagewalk.h>
-#include <linux/random.h>
-#include <linux/sched/mm.h>
-#include <linux/slab.h>
+
+#include "prmtv-common.h"
 
 #ifdef CONFIG_DAMON_VADDR_KUNIT_TEST
 #undef DAMON_MIN_REGION
 #define DAMON_MIN_REGION 1
 #endif
 
-/* Get a random number in [l, r) */
-#define damon_rand(l, r) (l + prandom_u32_max(r - l))
-
 /*
  * 't->id' should be the pointer to the relevant 'struct pid' having reference
  * count.  Caller must put the returned task, unless it is NULL.
@@ -373,82 +367,6 @@ void damon_va_update(struct damon_ctx *c
 	}
 }
 
-/*
- * Get an online page for a pfn if it's in the LRU list.  Otherwise, returns
- * NULL.
- *
- * The body of this function is stolen from the 'page_idle_get_page()'.  We
- * steal rather than reuse it because the code is quite simple.
- */
-static struct page *damon_get_page(unsigned long pfn)
-{
-	struct page *page = pfn_to_online_page(pfn);
-
-	if (!page || !PageLRU(page) || !get_page_unless_zero(page))
-		return NULL;
-
-	if (unlikely(!PageLRU(page))) {
-		put_page(page);
-		page = NULL;
-	}
-	return page;
-}
-
-static void damon_ptep_mkold(pte_t *pte, struct mm_struct *mm,
-			     unsigned long addr)
-{
-	bool referenced = false;
-	struct page *page = damon_get_page(pte_pfn(*pte));
-
-	if (!page)
-		return;
-
-	if (pte_young(*pte)) {
-		referenced = true;
-		*pte = pte_mkold(*pte);
-	}
-
-#ifdef CONFIG_MMU_NOTIFIER
-	if (mmu_notifier_clear_young(mm, addr, addr + PAGE_SIZE))
-		referenced = true;
-#endif /* CONFIG_MMU_NOTIFIER */
-
-	if (referenced)
-		set_page_young(page);
-
-	set_page_idle(page);
-	put_page(page);
-}
-
-static void damon_pmdp_mkold(pmd_t *pmd, struct mm_struct *mm,
-			     unsigned long addr)
-{
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	bool referenced = false;
-	struct page *page = damon_get_page(pmd_pfn(*pmd));
-
-	if (!page)
-		return;
-
-	if (pmd_young(*pmd)) {
-		referenced = true;
-		*pmd = pmd_mkold(*pmd);
-	}
-
-#ifdef CONFIG_MMU_NOTIFIER
-	if (mmu_notifier_clear_young(mm, addr,
-				addr + ((1UL) << HPAGE_PMD_SHIFT)))
-		referenced = true;
-#endif /* CONFIG_MMU_NOTIFIER */
-
-	if (referenced)
-		set_page_young(page);
-
-	set_page_idle(page);
-	put_page(page);
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
-}
-
 static int damon_mkold_pmd_entry(pmd_t *pmd, unsigned long addr,
 		unsigned long next, struct mm_walk *walk)
 {
_

Patches currently in -mm which might be from sj@kernel.org are


