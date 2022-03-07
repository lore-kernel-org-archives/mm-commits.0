Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F957C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  7 Mar 2022 02:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234682AbiCGCMm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 6 Mar 2022 21:12:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232565AbiCGCMk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 6 Mar 2022 21:12:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36496E0E7
        for <mm-commits@vger.kernel.org>; Sun,  6 Mar 2022 18:11:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A019661122
        for <mm-commits@vger.kernel.org>; Mon,  7 Mar 2022 02:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04313C340F4;
        Mon,  7 Mar 2022 02:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646619106;
        bh=rEwbwcfzOfxASim5A3YUNr0D5pWXVtnlAo+pL6ZrvOo=;
        h=Date:To:From:Subject:From;
        b=Aet7nyMrZfIxKTWKrq7aof0XxRnsnppe7YeXkWGbREPEvUtaLYpmTnNx4i380FGjH
         KO3siKmjjbCqNi9XgVES1tkLFuurp6a9nKmyk7toV+mb4F44vFsVr27mNbtE0MIDtG
         1lw4wtBVxi8jmUWLP+fVNPb32EmjvDbP+8HypIo8=
Date:   Sun, 06 Mar 2022 18:11:45 -0800
To:     mm-commits@vger.kernel.org, glider@google.com, elver@google.com,
        dvyukov@google.com, dtcccc@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kfence-alloc-kfence_pool-after-system-startup.patch removed from -mm tree
Message-Id: <20220307021146.04313C340F4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: alloc kfence_pool after system startup
has been removed from the -mm tree.  Its filename was
     kfence-alloc-kfence_pool-after-system-startup.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Tianchen Ding <dtcccc@linux.alibaba.com>
Subject: kfence: alloc kfence_pool after system startup

Allow enabling KFENCE after system startup by allocating its pool via the
page allocator.  This provides the flexibility to enable KFENCE even if it
wasn't enabled at boot time.

Link: https://lkml.kernel.org/r/20220305144858.17040-3-dtcccc@linux.alibaba.com
Signed-off-by: Tianchen Ding <dtcccc@linux.alibaba.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |   99 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 78 insertions(+), 21 deletions(-)

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
@@ -623,6 +637,22 @@ err:
 	return false;
 }
 
+static bool kfence_init_pool_late(void)
+{
+	unsigned long addr, free_pages;
+
+	addr = kfence_init_pool();
+
+	if (!addr)
+		return true;
+
+	/* Same as above. */
+	free_pages = (KFENCE_POOL_SIZE - (addr - (unsigned long)__kfence_pool)) / PAGE_SIZE;
+	free_contig_range(page_to_pfn(virt_to_page(addr)), free_pages);
+	__kfence_pool = NULL;
+	return false;
+}
+
 /* === DebugFS Interface ==================================================== */
 
 static int stats_show(struct seq_file *seq, void *v)
@@ -771,31 +801,58 @@ void __init kfence_alloc_pool(void)
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
+	struct page *pages;
+
+	pages = alloc_contig_pages(nr_pages, GFP_KERNEL, first_online_node, NULL);
+
+	if (!pages)
+		return -ENOMEM;
+
+	__kfence_pool = page_to_virt(pages);
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

Patches currently in -mm which might be from dtcccc@linux.alibaba.com are


