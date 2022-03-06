Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6A88C433EF
	for <mm-commits@archiver.kernel.org>; Sun,  6 Mar 2022 23:44:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234479AbiCFXpR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 6 Mar 2022 18:45:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233054AbiCFXpR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 6 Mar 2022 18:45:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBF0F41331
        for <mm-commits@vger.kernel.org>; Sun,  6 Mar 2022 15:44:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7043BB80F9A
        for <mm-commits@vger.kernel.org>; Sun,  6 Mar 2022 23:44:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EDEDC340EC;
        Sun,  6 Mar 2022 23:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646610261;
        bh=tLvQy1MiaW6RGs84UbjD1qAFQCjruUNGXSDptsVASbU=;
        h=Date:To:From:Subject:From;
        b=jgewj0RbNtiAwpP580sWAgpdzBGQLE3LVMcKQ51JLxPo4BjNuw7YzyG4BTe5fsxDn
         lRKejD01xjcNwXDX3qkD5IGVwbdIYoI4IRowyttbljomo6G11LmCkGXm5FxAeBC4Ep
         Xpx2eSg8Ge1G7gmiglzd9/LoTw1tnOd85jJ/LS4g=
Date:   Sun, 06 Mar 2022 15:44:20 -0800
To:     mm-commits@vger.kernel.org, glider@google.com, elver@google.com,
        dvyukov@google.com, dtcccc@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kfence-alloc-kfence_pool-after-system-startup.patch added to -mm tree
Message-Id: <20220306234421.2EDEDC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: alloc kfence_pool after system startup
has been added to the -mm tree.  Its filename is
     kfence-alloc-kfence_pool-after-system-startup.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kfence-alloc-kfence_pool-after-system-startup.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kfence-alloc-kfence_pool-after-system-startup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kfence-allow-re-enabling-kfence-after-system-startup.patch
kfence-alloc-kfence_pool-after-system-startup.patch

