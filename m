Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63337C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:48:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236700AbiCVVt6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236965AbiCVVtp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:49:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7CF024BF4
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:48:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53529B81DC6
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58EBC340EE;
        Tue, 22 Mar 2022 21:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985694;
        bh=gt5kXwgl0T06KlyAH23RaCVOLJostPIhoWTjCfUT7sw=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=gevX4wpPCX2PtcxnL5L2RUNbkgMBVYf5rIwlyRFFJDReZbKQlJjNxGNzsEvLmfKbJ
         mE9kwIrQKciOIBmSatot0svCt67SZG2qlioLS8bFsQDAXMKNHiEakXEK93c+BNWP5K
         l/pAgj9RPlj7rkprOLG6zGLFbcCgs0ge4v+HsvZo=
Date:   Tue, 22 Mar 2022 14:48:13 -0700
To:     liupeng256@huawei.com, glider@google.com, elver@google.com,
        dvyukov@google.com, dtcccc@linux.alibaba.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 191/227] kfence: alloc kfence_pool after system startup
Message-Id: <20220322214813.E58EBC340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Tianchen Ding <dtcccc@linux.alibaba.com>
Subject: kfence: alloc kfence_pool after system startup

Allow enabling KFENCE after system startup by allocating its pool via the
page allocator. This provides the flexibility to enable KFENCE even if it
wasn't enabled at boot time.

Link: https://lkml.kernel.org/r/20220307074516.6920-3-dtcccc@linux.alibaba.com
Signed-off-by: Tianchen Ding <dtcccc@linux.alibaba.com>
Reviewed-by: Marco Elver <elver@google.com>
Tested-by: Peng Liu <liupeng256@huawei.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |  111 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 90 insertions(+), 21 deletions(-)

--- a/mm/kfence/core.c~kfence-alloc-kfence_pool-after-system-startup
+++ a/mm/kfence/core.c
@@ -96,7 +96,7 @@ static unsigned long kfence_skip_covered
 module_param_named(skip_covered_thresh, kfence_skip_covered_thresh, ulong, 0644);
 
 /* The pool of pages used for guard pages and objects. */
-char *__kfence_pool __ro_after_init;
+char *__kfence_pool __read_mostly;
 EXPORT_SYMBOL(__kfence_pool); /* Export for test modules. */
 
 /*
@@ -537,17 +537,19 @@ static void rcu_guarded_free(struct rcu_
 	kfence_guarded_free((void *)meta->addr, meta, false);
 }
 
-static bool __init kfence_init_pool(void)
+/*
+ * Initialization of the KFENCE pool after its allocation.
+ * Returns 0 on success; otherwise returns the address up to
+ * which partial initialization succeeded.
+ */
+static unsigned long kfence_init_pool(void)
 {
 	unsigned long addr = (unsigned long)__kfence_pool;
 	struct page *pages;
 	int i;
 
-	if (!__kfence_pool)
-		return false;
-
 	if (!arch_kfence_init_pool())
-		goto err;
+		return addr;
 
 	pages = virt_to_page(addr);
 
@@ -565,7 +567,7 @@ static bool __init kfence_init_pool(void
 
 		/* Verify we do not have a compound head page. */
 		if (WARN_ON(compound_head(&pages[i]) != &pages[i]))
-			goto err;
+			return addr;
 
 		__SetPageSlab(&pages[i]);
 	}
@@ -578,7 +580,7 @@ static bool __init kfence_init_pool(void
 	 */
 	for (i = 0; i < 2; i++) {
 		if (unlikely(!kfence_protect(addr)))
-			goto err;
+			return addr;
 
 		addr += PAGE_SIZE;
 	}
@@ -595,7 +597,7 @@ static bool __init kfence_init_pool(void
 
 		/* Protect the right redzone. */
 		if (unlikely(!kfence_protect(addr + PAGE_SIZE)))
-			goto err;
+			return addr;
 
 		addr += 2 * PAGE_SIZE;
 	}
@@ -608,9 +610,21 @@ static bool __init kfence_init_pool(void
 	 */
 	kmemleak_free(__kfence_pool);
 
-	return true;
+	return 0;
+}
+
+static bool __init kfence_init_pool_early(void)
+{
+	unsigned long addr;
+
+	if (!__kfence_pool)
+		return false;
+
+	addr = kfence_init_pool();
+
+	if (!addr)
+		return true;
 
-err:
 	/*
 	 * Only release unprotected pages, and do not try to go back and change
 	 * page attributes due to risk of failing to do so as well. If changing
@@ -623,6 +637,26 @@ err:
 	return false;
 }
 
+static bool kfence_init_pool_late(void)
+{
+	unsigned long addr, free_size;
+
+	addr = kfence_init_pool();
+
+	if (!addr)
+		return true;
+
+	/* Same as above. */
+	free_size = KFENCE_POOL_SIZE - (addr - (unsigned long)__kfence_pool);
+#ifdef CONFIG_CONTIG_ALLOC
+	free_contig_range(page_to_pfn(virt_to_page(addr)), free_size / PAGE_SIZE);
+#else
+	free_pages_exact((void *)addr, free_size);
+#endif
+	__kfence_pool = NULL;
+	return false;
+}
+
 /* === DebugFS Interface ==================================================== */
 
 static int stats_show(struct seq_file *seq, void *v)
@@ -771,31 +805,66 @@ void __init kfence_alloc_pool(void)
 		pr_err("failed to allocate pool\n");
 }
 
+static void kfence_init_enable(void)
+{
+	if (!IS_ENABLED(CONFIG_KFENCE_STATIC_KEYS))
+		static_branch_enable(&kfence_allocation_key);
+	WRITE_ONCE(kfence_enabled, true);
+	queue_delayed_work(system_unbound_wq, &kfence_timer, 0);
+	pr_info("initialized - using %lu bytes for %d objects at 0x%p-0x%p\n", KFENCE_POOL_SIZE,
+		CONFIG_KFENCE_NUM_OBJECTS, (void *)__kfence_pool,
+		(void *)(__kfence_pool + KFENCE_POOL_SIZE));
+}
+
 void __init kfence_init(void)
 {
+	stack_hash_seed = (u32)random_get_entropy();
+
 	/* Setting kfence_sample_interval to 0 on boot disables KFENCE. */
 	if (!kfence_sample_interval)
 		return;
 
-	stack_hash_seed = (u32)random_get_entropy();
-	if (!kfence_init_pool()) {
+	if (!kfence_init_pool_early()) {
 		pr_err("%s failed\n", __func__);
 		return;
 	}
 
-	if (!IS_ENABLED(CONFIG_KFENCE_STATIC_KEYS))
-		static_branch_enable(&kfence_allocation_key);
-	WRITE_ONCE(kfence_enabled, true);
-	queue_delayed_work(system_unbound_wq, &kfence_timer, 0);
-	pr_info("initialized - using %lu bytes for %d objects at 0x%p-0x%p\n", KFENCE_POOL_SIZE,
-		CONFIG_KFENCE_NUM_OBJECTS, (void *)__kfence_pool,
-		(void *)(__kfence_pool + KFENCE_POOL_SIZE));
+	kfence_init_enable();
+}
+
+static int kfence_init_late(void)
+{
+	const unsigned long nr_pages = KFENCE_POOL_SIZE / PAGE_SIZE;
+#ifdef CONFIG_CONTIG_ALLOC
+	struct page *pages;
+
+	pages = alloc_contig_pages(nr_pages, GFP_KERNEL, first_online_node, NULL);
+	if (!pages)
+		return -ENOMEM;
+	__kfence_pool = page_to_virt(pages);
+#else
+	if (nr_pages > MAX_ORDER_NR_PAGES) {
+		pr_warn("KFENCE_NUM_OBJECTS too large for buddy allocator\n");
+		return -EINVAL;
+	}
+	__kfence_pool = alloc_pages_exact(KFENCE_POOL_SIZE, GFP_KERNEL);
+	if (!__kfence_pool)
+		return -ENOMEM;
+#endif
+
+	if (!kfence_init_pool_late()) {
+		pr_err("%s failed\n", __func__);
+		return -EBUSY;
+	}
+
+	kfence_init_enable();
+	return 0;
 }
 
 static int kfence_enable_late(void)
 {
 	if (!__kfence_pool)
-		return -EINVAL;
+		return kfence_init_late();
 
 	WRITE_ONCE(kfence_enabled, true);
 	queue_delayed_work(system_unbound_wq, &kfence_timer, 0);
_
