Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90129C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  2 Mar 2022 00:33:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237220AbiCBAd7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Mar 2022 19:33:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiCBAd7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Mar 2022 19:33:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701EB1DA4C
        for <mm-commits@vger.kernel.org>; Tue,  1 Mar 2022 16:33:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1CB0614A7
        for <mm-commits@vger.kernel.org>; Wed,  2 Mar 2022 00:33:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B336C340EE;
        Wed,  2 Mar 2022 00:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646181196;
        bh=pnZ2vF2xLUR0du+lWA3OZHrSX7AX9+Ipr2ohNR+clQI=;
        h=Date:To:From:Subject:From;
        b=wS6vt6usOolG9YepwTHapBbYJbxycgjchRqhHDZaw4CSKalpZPG2PyySUZo5SUiK8
         7xB+MoD9EgNykYxTcaGDJBiy2EJhj2Vut2ZHU5mX9OlK6lF+woqsACYseQFuVJd5ii
         Y4FVnEY5kirpDNKnY4y057akAjUvwYSa+BpcW8As=
Date:   Tue, 01 Mar 2022 16:33:15 -0800
To:     mm-commits@vger.kernel.org, yury.norov@gmail.com, vbabka@suse.cz,
        roman.gushchin@linux.dev, rientjes@google.com,
        qiang.zhang@windriver.com, penberg@kernel.org,
        mcroce@microsoft.com, johannes.berg@intel.com, jarkko@kernel.org,
        James.Bottomley@hansenpartnership.com, imran.f.khan@oracle.com,
        iamjoonsoo.kim@lge.com, glittao@gmail.com, faiyazm@codeaurora.org,
        elver@google.com, edumazet@google.com, dvyukov@google.com,
        cl@linux.com, arnd@arndb.de, andreyknvl@gmail.com,
        42.hyeyoo@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] lib-stackdepot-use-page-allocator-if-both-slab-and-memblock-is-unavailable.patch removed from -mm tree
Message-Id: <20220302003316.4B336C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: use page allocator if both slab and memblock is unavailable
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-use-page-allocator-if-both-slab-and-memblock-is-unavailable.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Subject: lib/stackdepot: use page allocator if both slab and memblock is unavailable

After commit 2dba5eb1c73b ("lib/stackdepot: allow optional init and
stack_table allocation by kvmalloc()"), stack_depot_init() is called later
if CONFIG_STACKDEPOT_ALWAYS_INIT=n to remove unnecessary memory usage.  It
allocates stack_table using memblock_alloc() or kvmalloc() depending on
availability of slab allocator.

But when stack_depot_init() is called while creating boot slab caches,
both slab allocator and memblock is not available.  So kernel crashes. 
Allocate stack_table from page allocator when both slab allocator and
memblock is unavailable.

Limit size of stack_table when using page allocator because vmalloc() is
also unavailable in kmem_cache_init().  It must not be larger than
(PAGE_SIZE << (MAX_ORDER - 1)).

This patch was tested on both CONFIG_STACKDEPOT_ALWAYS_INIT=y and n.

[lkp@intel.com: fix W=1 build warning]
Link: https://lkml.kernel.org/r/YhtDCoHWsF11rwze@ip-172-31-19-208.ap-northeast-1.compute.internal
Fixes: 2dba5eb1c73b ("lib/stackdepot: allow optional init and stack_table allocation by kvmalloc()")
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Oliver Glitta <glittao@gmail.com>
Cc: Faiyaz Mohammed <faiyazm@codeaurora.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Yury Norov <yury.norov@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Matteo Croce <mcroce@microsoft.com>
Cc: Marco Elver <elver@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Imran Khan <imran.f.khan@oracle.com>
Cc: Zqiang <qiang.zhang@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |   28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

--- a/lib/stackdepot.c~lib-stackdepot-use-page-allocator-if-both-slab-and-memblock-is-unavailable
+++ a/lib/stackdepot.c
@@ -73,6 +73,14 @@ static int next_slab_inited;
 static size_t depot_offset;
 static DEFINE_RAW_SPINLOCK(depot_lock);
 
+static size_t stack_hash_size = (1 << CONFIG_STACK_HASH_ORDER);
+static inline size_t stack_hash_mask(void)
+{
+	return stack_hash_size - 1;
+}
+
+#define STACK_HASH_SEED 0x9747b28c
+
 static bool init_stack_slab(void **prealloc)
 {
 	if (!*prealloc)
@@ -142,10 +150,6 @@ depot_alloc_stack(unsigned long *entries
 	return stack;
 }
 
-#define STACK_HASH_SIZE (1L << CONFIG_STACK_HASH_ORDER)
-#define STACK_HASH_MASK (STACK_HASH_SIZE - 1)
-#define STACK_HASH_SEED 0x9747b28c
-
 static bool stack_depot_disable;
 static struct stack_record **stack_table;
 
@@ -172,18 +176,28 @@ __ref int stack_depot_init(void)
 
 	mutex_lock(&stack_depot_init_mutex);
 	if (!stack_depot_disable && !stack_table) {
-		size_t size = (STACK_HASH_SIZE * sizeof(struct stack_record *));
+		size_t size = (stack_hash_size * sizeof(struct stack_record *));
 		int i;
 
 		if (slab_is_available()) {
 			pr_info("Stack Depot allocating hash table with kvmalloc\n");
 			stack_table = kvmalloc(size, GFP_KERNEL);
+		} else if (totalram_pages() > 0) {
+			/* Reduce size because vmalloc may be unavailable */
+			size = min_t(size_t, size, PAGE_SIZE << (MAX_ORDER - 1));
+			stack_hash_size = size / sizeof(struct stack_record *);
+
+			pr_info("Stack Depot allocating hash table with __get_free_pages\n");
+			stack_table = (struct stack_record **)
+				      __get_free_pages(GFP_KERNEL, get_order(size));
 		} else {
 			pr_info("Stack Depot allocating hash table with memblock_alloc\n");
 			stack_table = memblock_alloc(size, SMP_CACHE_BYTES);
 		}
+
 		if (stack_table) {
-			for (i = 0; i < STACK_HASH_SIZE;  i++)
+			pr_info("Stack Depot hash table size=%zu\n", stack_hash_size);
+			for (i = 0; i < stack_hash_size;  i++)
 				stack_table[i] = NULL;
 		} else {
 			pr_err("Stack Depot hash table allocation failed, disabling\n");
@@ -363,7 +377,7 @@ depot_stack_handle_t __stack_depot_save(
 		goto fast_exit;
 
 	hash = hash_stack(entries, nr_entries);
-	bucket = &stack_table[hash & STACK_HASH_MASK];
+	bucket = &stack_table[hash & stack_hash_mask()];
 
 	/*
 	 * Fast path: look the stack trace up without locking.
_

Patches currently in -mm which might be from 42.hyeyoo@gmail.com are


