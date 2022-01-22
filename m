Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A89DC433EF
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 06:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233484AbiAVGPN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Jan 2022 01:15:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45186 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233480AbiAVGPM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 22 Jan 2022 01:15:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C76B610F4
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 06:15:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F5DAC004E1;
        Sat, 22 Jan 2022 06:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642832111;
        bh=byke5gvD6vU1fqcJ7HiHO7pEo3bLWIsrALlGM28YuRw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=bdeLFIjFcRthH8EnwHuzZSwKbmDZ3MoPx+FAM8vURLWI4LpV/IGygV8lSCyvKHnYA
         RUtOuSbEiUQdtT+qVYlThEEs+Sqmo/RmWmiWn0qh8vdUZxAiLzLcVp5xnmmerbx6px
         KtZE5FxHL/1oKX+Sf/vbo3uhezZwRiH1VuyiDv4I=
Date:   Fri, 21 Jan 2022 22:15:10 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ddstreet@ieee.org, geert@linux-m68k.org,
        hch@lst.de, hughd@google.com, jgross@suse.com,
        Konrad.wilk@oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sjenning@redhat.com,
        torvalds@linux-foundation.org, vitaly.wool@konsulko.com,
        willy@infradead.org
Subject:  [patch 68/69] frontswap: remove support for multiple ops
Message-ID: <20220122061510.qSQFUJsbL%akpm@linux-foundation.org>
In-Reply-To: <20220121221021.60533b009c357d660791476e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Subject: frontswap: remove support for multiple ops

There is only a single instance of frontswap ops in the kernel, so
simplify the frontswap code by removing support for multiple operations.

Link: https://lkml.kernel.org/r/20211224062246.1258487-13-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Konrad Rzeszutek Wilk <Konrad.wilk@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/frontswap.h |    3 --
 mm/frontswap.c            |   50 ++++++++----------------------------
 mm/zswap.c                |    8 ++++-
 3 files changed, 19 insertions(+), 42 deletions(-)

--- a/include/linux/frontswap.h~frontswap-remove-support-for-multiple-ops
+++ a/include/linux/frontswap.h
@@ -13,10 +13,9 @@ struct frontswap_ops {
 	int (*load)(unsigned, pgoff_t, struct page *); /* load a page */
 	void (*invalidate_page)(unsigned, pgoff_t); /* page no longer needed */
 	void (*invalidate_area)(unsigned); /* swap type just swapoff'ed */
-	struct frontswap_ops *next; /* private pointer to next ops */
 };
 
-extern void frontswap_register_ops(struct frontswap_ops *ops);
+int frontswap_register_ops(const struct frontswap_ops *ops);
 
 extern void frontswap_init(unsigned type, unsigned long *map);
 extern int __frontswap_store(struct page *page);
--- a/mm/frontswap.c~frontswap-remove-support-for-multiple-ops
+++ a/mm/frontswap.c
@@ -27,10 +27,7 @@ DEFINE_STATIC_KEY_FALSE(frontswap_enable
  * may be registered, but implementations can never deregister.  This
  * is a simple singly-linked list of all registered implementations.
  */
-static struct frontswap_ops *frontswap_ops __read_mostly;
-
-#define for_each_frontswap_ops(ops)		\
-	for ((ops) = frontswap_ops; (ops); (ops) = (ops)->next)
+static const struct frontswap_ops *frontswap_ops __read_mostly;
 
 #ifdef CONFIG_DEBUG_FS
 /*
@@ -97,18 +94,14 @@ static inline void inc_frontswap_invalid
 /*
  * Register operations for frontswap
  */
-void frontswap_register_ops(struct frontswap_ops *ops)
+int frontswap_register_ops(const struct frontswap_ops *ops)
 {
-	/*
-	 * Setting frontswap_ops must happen after the ops->init() calls
-	 * above; cmpxchg implies smp_mb() which will ensure the init is
-	 * complete at this point.
-	 */
-	do {
-		ops->next = frontswap_ops;
-	} while (cmpxchg(&frontswap_ops, ops->next, ops) != ops->next);
+	if (frontswap_ops)
+		return -EINVAL;
 
+	frontswap_ops = ops;
 	static_branch_inc(&frontswap_enabled_key);
+	return 0;
 }
 
 /*
@@ -117,7 +110,6 @@ void frontswap_register_ops(struct front
 void frontswap_init(unsigned type, unsigned long *map)
 {
 	struct swap_info_struct *sis = swap_info[type];
-	struct frontswap_ops *ops;
 
 	VM_BUG_ON(sis == NULL);
 
@@ -133,9 +125,7 @@ void frontswap_init(unsigned type, unsig
 	 * p->frontswap set to something valid to work properly.
 	 */
 	frontswap_map_set(sis, map);
-
-	for_each_frontswap_ops(ops)
-		ops->init(type);
+	frontswap_ops->init(type);
 }
 
 static bool __frontswap_test(struct swap_info_struct *sis,
@@ -174,7 +164,6 @@ int __frontswap_store(struct page *page)
 	int type = swp_type(entry);
 	struct swap_info_struct *sis = swap_info[type];
 	pgoff_t offset = swp_offset(entry);
-	struct frontswap_ops *ops;
 
 	VM_BUG_ON(!frontswap_ops);
 	VM_BUG_ON(!PageLocked(page));
@@ -188,16 +177,10 @@ int __frontswap_store(struct page *page)
 	 */
 	if (__frontswap_test(sis, offset)) {
 		__frontswap_clear(sis, offset);
-		for_each_frontswap_ops(ops)
-			ops->invalidate_page(type, offset);
+		frontswap_ops->invalidate_page(type, offset);
 	}
 
-	/* Try to store in each implementation, until one succeeds. */
-	for_each_frontswap_ops(ops) {
-		ret = ops->store(type, offset, page);
-		if (!ret) /* successful store */
-			break;
-	}
+	ret = frontswap_ops->store(type, offset, page);
 	if (ret == 0) {
 		__frontswap_set(sis, offset);
 		inc_frontswap_succ_stores();
@@ -220,7 +203,6 @@ int __frontswap_load(struct page *page)
 	int type = swp_type(entry);
 	struct swap_info_struct *sis = swap_info[type];
 	pgoff_t offset = swp_offset(entry);
-	struct frontswap_ops *ops;
 
 	VM_BUG_ON(!frontswap_ops);
 	VM_BUG_ON(!PageLocked(page));
@@ -230,11 +212,7 @@ int __frontswap_load(struct page *page)
 		return -1;
 
 	/* Try loading from each implementation, until one succeeds. */
-	for_each_frontswap_ops(ops) {
-		ret = ops->load(type, offset, page);
-		if (!ret) /* successful load */
-			break;
-	}
+	ret = frontswap_ops->load(type, offset, page);
 	if (ret == 0)
 		inc_frontswap_loads();
 	return ret;
@@ -247,7 +225,6 @@ int __frontswap_load(struct page *page)
 void __frontswap_invalidate_page(unsigned type, pgoff_t offset)
 {
 	struct swap_info_struct *sis = swap_info[type];
-	struct frontswap_ops *ops;
 
 	VM_BUG_ON(!frontswap_ops);
 	VM_BUG_ON(sis == NULL);
@@ -255,8 +232,7 @@ void __frontswap_invalidate_page(unsigne
 	if (!__frontswap_test(sis, offset))
 		return;
 
-	for_each_frontswap_ops(ops)
-		ops->invalidate_page(type, offset);
+	frontswap_ops->invalidate_page(type, offset);
 	__frontswap_clear(sis, offset);
 	inc_frontswap_invalidates();
 }
@@ -268,7 +244,6 @@ void __frontswap_invalidate_page(unsigne
 void __frontswap_invalidate_area(unsigned type)
 {
 	struct swap_info_struct *sis = swap_info[type];
-	struct frontswap_ops *ops;
 
 	VM_BUG_ON(!frontswap_ops);
 	VM_BUG_ON(sis == NULL);
@@ -276,8 +251,7 @@ void __frontswap_invalidate_area(unsigne
 	if (sis->frontswap_map == NULL)
 		return;
 
-	for_each_frontswap_ops(ops)
-		ops->invalidate_area(type);
+	frontswap_ops->invalidate_area(type);
 	atomic_set(&sis->frontswap_pages, 0);
 	bitmap_zero(sis->frontswap_map, sis->max);
 }
--- a/mm/zswap.c~frontswap-remove-support-for-multiple-ops
+++ a/mm/zswap.c
@@ -1378,7 +1378,7 @@ static void zswap_frontswap_init(unsigne
 	zswap_trees[type] = tree;
 }
 
-static struct frontswap_ops zswap_frontswap_ops = {
+static const struct frontswap_ops zswap_frontswap_ops = {
 	.store = zswap_frontswap_store,
 	.load = zswap_frontswap_load,
 	.invalidate_page = zswap_frontswap_invalidate_page,
@@ -1475,11 +1475,15 @@ static int __init init_zswap(void)
 	if (!shrink_wq)
 		goto fallback_fail;
 
-	frontswap_register_ops(&zswap_frontswap_ops);
+	ret = frontswap_register_ops(&zswap_frontswap_ops);
+	if (ret)
+		goto destroy_wq;
 	if (zswap_debugfs_init())
 		pr_warn("debugfs initialization failed\n");
 	return 0;
 
+destroy_wq:
+	destroy_workqueue(shrink_wq);
 fallback_fail:
 	if (pool)
 		zswap_pool_destroy(pool);
_
