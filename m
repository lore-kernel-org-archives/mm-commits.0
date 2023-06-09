Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F0C5C87FDD
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:28:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232791AbjFIX2l (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbjFIX1y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:27:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97AEA3C02
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:27:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28A9165CF4
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:27:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767C0C4339C;
        Fri,  9 Jun 2023 23:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353263;
        bh=oTv4DBQ6tekPA8l35+YewVzAwB/X5qkrlChPTZtNlbI=;
        h=Date:To:From:Subject:From;
        b=kQgbC3CvaazqFdLRqwyXNVYajqYgYDp52XMItH/1Nw4woNUXt1xkTaYlKCfJlDkQk
         kXupVw6dyPfw28jz24J1gCQhvBEINwMaxqVSjp+cdOotL5jY3En+RXdslnONN1WG29
         dosYmyaDiHrpC9QyITPdBXzRxzbF8OmtgQ5c9cD0=
Date:   Fri, 09 Jun 2023 16:27:42 -0700
To:     mm-commits@vger.kernel.org, yzaikin@google.com,
        ying.huang@intel.com, rppt@kernel.org, rafael@kernel.org,
        pavel@ucw.cz, osalvador@suse.de, mcgrof@kernel.org,
        len.brown@intel.com, keescook@chromium.org, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-split-out-fail_page_alloc.patch removed from -mm tree
Message-Id: <20230609232743.767C0C4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: page_alloc: split out FAIL_PAGE_ALLOC
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-split-out-fail_page_alloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: page_alloc: split out FAIL_PAGE_ALLOC
Date: Tue, 16 May 2023 14:38:15 +0800

... to a single file to reduce a bit of page_alloc.c.

Link: https://lkml.kernel.org/r/20230516063821.121844-8-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fault-inject.h |    9 ++++
 mm/Makefile                  |    1 
 mm/fail_page_alloc.c         |   66 +++++++++++++++++++++++++++++
 mm/page_alloc.c              |   74 ---------------------------------
 4 files changed, 76 insertions(+), 74 deletions(-)

--- a/include/linux/fault-inject.h~mm-page_alloc-split-out-fail_page_alloc
+++ a/include/linux/fault-inject.h
@@ -93,6 +93,15 @@ struct kmem_cache;
 
 bool should_fail_alloc_page(gfp_t gfp_mask, unsigned int order);
 
+#ifdef CONFIG_FAIL_PAGE_ALLOC
+bool __should_fail_alloc_page(gfp_t gfp_mask, unsigned int order);
+#else
+static inline bool __should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
+{
+	return false;
+}
+#endif /* CONFIG_FAIL_PAGE_ALLOC */
+
 int should_failslab(struct kmem_cache *s, gfp_t gfpflags);
 #ifdef CONFIG_FAILSLAB
 extern bool __should_failslab(struct kmem_cache *s, gfp_t gfpflags);
--- /dev/null
+++ a/mm/fail_page_alloc.c
@@ -0,0 +1,66 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/fault-inject.h>
+#include <linux/mm.h>
+
+static struct {
+	struct fault_attr attr;
+
+	bool ignore_gfp_highmem;
+	bool ignore_gfp_reclaim;
+	u32 min_order;
+} fail_page_alloc = {
+	.attr = FAULT_ATTR_INITIALIZER,
+	.ignore_gfp_reclaim = true,
+	.ignore_gfp_highmem = true,
+	.min_order = 1,
+};
+
+static int __init setup_fail_page_alloc(char *str)
+{
+	return setup_fault_attr(&fail_page_alloc.attr, str);
+}
+__setup("fail_page_alloc=", setup_fail_page_alloc);
+
+bool __should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
+{
+	int flags = 0;
+
+	if (order < fail_page_alloc.min_order)
+		return false;
+	if (gfp_mask & __GFP_NOFAIL)
+		return false;
+	if (fail_page_alloc.ignore_gfp_highmem && (gfp_mask & __GFP_HIGHMEM))
+		return false;
+	if (fail_page_alloc.ignore_gfp_reclaim &&
+			(gfp_mask & __GFP_DIRECT_RECLAIM))
+		return false;
+
+	/* See comment in __should_failslab() */
+	if (gfp_mask & __GFP_NOWARN)
+		flags |= FAULT_NOWARN;
+
+	return should_fail_ex(&fail_page_alloc.attr, 1 << order, flags);
+}
+
+#ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
+
+static int __init fail_page_alloc_debugfs(void)
+{
+	umode_t mode = S_IFREG | 0600;
+	struct dentry *dir;
+
+	dir = fault_create_debugfs_attr("fail_page_alloc", NULL,
+					&fail_page_alloc.attr);
+
+	debugfs_create_bool("ignore-gfp-wait", mode, dir,
+			    &fail_page_alloc.ignore_gfp_reclaim);
+	debugfs_create_bool("ignore-gfp-highmem", mode, dir,
+			    &fail_page_alloc.ignore_gfp_highmem);
+	debugfs_create_u32("min-order", mode, dir, &fail_page_alloc.min_order);
+
+	return 0;
+}
+
+late_initcall(fail_page_alloc_debugfs);
+
+#endif /* CONFIG_FAULT_INJECTION_DEBUG_FS */
--- a/mm/Makefile~mm-page_alloc-split-out-fail_page_alloc
+++ a/mm/Makefile
@@ -89,6 +89,7 @@ obj-$(CONFIG_KASAN)	+= kasan/
 obj-$(CONFIG_KFENCE) += kfence/
 obj-$(CONFIG_KMSAN)	+= kmsan/
 obj-$(CONFIG_FAILSLAB) += failslab.o
+obj-$(CONFIG_FAIL_PAGE_ALLOC) += fail_page_alloc.o
 obj-$(CONFIG_MEMTEST)		+= memtest.o
 obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_NUMA) += memory-tiers.o
--- a/mm/page_alloc.c~mm-page_alloc-split-out-fail_page_alloc
+++ a/mm/page_alloc.c
@@ -2994,80 +2994,6 @@ out:
 	return page;
 }
 
-#ifdef CONFIG_FAIL_PAGE_ALLOC
-
-static struct {
-	struct fault_attr attr;
-
-	bool ignore_gfp_highmem;
-	bool ignore_gfp_reclaim;
-	u32 min_order;
-} fail_page_alloc = {
-	.attr = FAULT_ATTR_INITIALIZER,
-	.ignore_gfp_reclaim = true,
-	.ignore_gfp_highmem = true,
-	.min_order = 1,
-};
-
-static int __init setup_fail_page_alloc(char *str)
-{
-	return setup_fault_attr(&fail_page_alloc.attr, str);
-}
-__setup("fail_page_alloc=", setup_fail_page_alloc);
-
-static bool __should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
-{
-	int flags = 0;
-
-	if (order < fail_page_alloc.min_order)
-		return false;
-	if (gfp_mask & __GFP_NOFAIL)
-		return false;
-	if (fail_page_alloc.ignore_gfp_highmem && (gfp_mask & __GFP_HIGHMEM))
-		return false;
-	if (fail_page_alloc.ignore_gfp_reclaim &&
-			(gfp_mask & __GFP_DIRECT_RECLAIM))
-		return false;
-
-	/* See comment in __should_failslab() */
-	if (gfp_mask & __GFP_NOWARN)
-		flags |= FAULT_NOWARN;
-
-	return should_fail_ex(&fail_page_alloc.attr, 1 << order, flags);
-}
-
-#ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
-
-static int __init fail_page_alloc_debugfs(void)
-{
-	umode_t mode = S_IFREG | 0600;
-	struct dentry *dir;
-
-	dir = fault_create_debugfs_attr("fail_page_alloc", NULL,
-					&fail_page_alloc.attr);
-
-	debugfs_create_bool("ignore-gfp-wait", mode, dir,
-			    &fail_page_alloc.ignore_gfp_reclaim);
-	debugfs_create_bool("ignore-gfp-highmem", mode, dir,
-			    &fail_page_alloc.ignore_gfp_highmem);
-	debugfs_create_u32("min-order", mode, dir, &fail_page_alloc.min_order);
-
-	return 0;
-}
-
-late_initcall(fail_page_alloc_debugfs);
-
-#endif /* CONFIG_FAULT_INJECTION_DEBUG_FS */
-
-#else /* CONFIG_FAIL_PAGE_ALLOC */
-
-static inline bool __should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
-{
-	return false;
-}
-
-#endif /* CONFIG_FAIL_PAGE_ALLOC */
-
 noinline bool should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
 {
 	return __should_fail_alloc_page(gfp_mask, order);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


