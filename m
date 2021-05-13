Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65996C433B4
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 02:52:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40ACC61396
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 02:52:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbhEMCxx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 May 2021 22:53:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:52406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230385AbhEMCxw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 May 2021 22:53:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98D8B61417;
        Thu, 13 May 2021 02:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620874363;
        bh=PSdyCelbj6JldGT7ACTR7NIhbuHs80JtX12rGHHNULw=;
        h=Date:From:To:Subject:From;
        b=lyOe3C/E3AQT5LxNY05nBh8zkcx5N3HeRpVfO3EpeEpFDjRohLo1dBzWyeWm6R5J0
         RJrmziiY95w+uzunrG/BuXiLTg4TAWBrE1YylaPT80y+7OhG9c+NxtJnhtZWcT9h5u
         uvPcs8pCmW1VkKm63kgfLZTheRAcrXaWVEJqNpMs=
Date:   Wed, 12 May 2021 19:52:43 -0700
From:   akpm@linux-foundation.org
To:     42.hyeyoo@gmail.com, cl@linux.com, iamjoonsoo.kim@lge.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz
Subject:  [failures]
 mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time.patch
 removed from -mm tree
Message-ID: <20210513025243.wJRHv-O6N%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: change run-time assertion in kmalloc_index() to compile-time
has been removed from the -mm tree.  Its filename was
     mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Subject: mm, slub: change run-time assertion in kmalloc_index() to compile-time

Currently when size is not supported by kmalloc_index, compiler will
generate a run-time BUG() while compile-time error is also possible, and
better.  So change BUG to BUILD_BUG_ON_MSG to make compile-time check
possible.

Also remove code that allocates more than 32MB because current
implementation supports only up to 32MB.

Link: https://lkml.kernel.org/r/20210511173448.GA54466@hyeyoo
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    7 +++++--
 mm/slab_common.c     |    7 +++----
 2 files changed, 8 insertions(+), 6 deletions(-)

--- a/include/linux/slab.h~mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time
+++ a/include/linux/slab.h
@@ -346,6 +346,9 @@ static __always_inline enum kmalloc_cach
  * 1 =  65 .. 96 bytes
  * 2 = 129 .. 192 bytes
  * n = 2^(n-1)+1 .. 2^n
+ *
+ * Note: there's no need to optimize kmalloc_index because it's evaluated
+ * in compile-time.
  */
 static __always_inline unsigned int kmalloc_index(size_t size)
 {
@@ -382,8 +385,8 @@ static __always_inline unsigned int kmal
 	if (size <=  8 * 1024 * 1024) return 23;
 	if (size <=  16 * 1024 * 1024) return 24;
 	if (size <=  32 * 1024 * 1024) return 25;
-	if (size <=  64 * 1024 * 1024) return 26;
-	BUG();
+
+	BUILD_BUG_ON_MSG(1, "unexpected size in kmalloc_index()");
 
 	/* Will never be reached. Needed because the compiler may complain */
 	return -1;
--- a/mm/slab_common.c~mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time
+++ a/mm/slab_common.c
@@ -755,8 +755,8 @@ struct kmem_cache *kmalloc_slab(size_t s
 
 /*
  * kmalloc_info[] is to make slub_debug=,kmalloc-xx option work at boot time.
- * kmalloc_index() supports up to 2^26=64MB, so the final entry of the table is
- * kmalloc-67108864.
+ * kmalloc_index() supports up to 2^25=32MB, so the final entry of the table is
+ * kmalloc-32M.
  */
 const struct kmalloc_info_struct kmalloc_info[] __initconst = {
 	INIT_KMALLOC_INFO(0, 0),
@@ -784,8 +784,7 @@ const struct kmalloc_info_struct kmalloc
 	INIT_KMALLOC_INFO(4194304, 4M),
 	INIT_KMALLOC_INFO(8388608, 8M),
 	INIT_KMALLOC_INFO(16777216, 16M),
-	INIT_KMALLOC_INFO(33554432, 32M),
-	INIT_KMALLOC_INFO(67108864, 64M)
+	INIT_KMALLOC_INFO(33554432, 32M)
 };
 
 /*
_

Patches currently in -mm which might be from 42.hyeyoo@gmail.com are

mm-fix-typos-and-grammar-error-in-comments.patch

