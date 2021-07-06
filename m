Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2385C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:09:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 974CA61C84
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:09:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbhGFTLl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:11:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:46320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231590AbhGFTLk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:11:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9799961C85;
        Tue,  6 Jul 2021 19:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598541;
        bh=keouKWTbFGlRzVLoxo69LmkRfJvcVoqLp731Vimyft0=;
        h=Date:From:To:Subject:From;
        b=bkssJwyHNu2nHpX4LErQkBYURgAME+pqO8d2nprIZV+75td+6Z0aRc6RK9R3EpJ7B
         KJKr1RGf/YFzd/7icEZlSR/raioJWJzbgWBa/IV+ARCCwsWZ7C0OF/QhxYUEut7s4T
         ByFr5hVEjeIOQTkeXga3uQ/hWwRa/cX0hKdiYgIQ=
Date:   Tue, 06 Jul 2021 12:09:01 -0700
From:   akpm@linux-foundation.org
To:     brendanhiggins@google.com, cl@linux.com, dlatypov@google.com,
        elver@google.com, glittao@gmail.com, iamjoonsoo.kim@lge.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz
Subject:  [merged] slub-remove-resiliency_test-function.patch
 removed from -mm tree
Message-ID: <20210706190901.2UwvWxY3O%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: slub: remove resiliency_test() function
has been removed from the -mm tree.  Its filename was
     slub-remove-resiliency_test-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oliver Glitta <glittao@gmail.com>
Subject: slub: remove resiliency_test() function

Function resiliency_test() is hidden behind #ifdef SLUB_RESILIENCY_TEST
that is not part of Kconfig, so nobody runs it.

This function is replaced with KUnit test for SLUB added by the previous
patch "selftests: add a KUnit test for SLUB debugging functionality".

Link: https://lkml.kernel.org/r/20210511150734.3492-3-glittao@gmail.com
Signed-off-by: Oliver Glitta <glittao@gmail.com>
Reviewed-by: Marco Elver <elver@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Oliver Glitta <glittao@gmail.com>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Daniel Latypov <dlatypov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   64 ----------------------------------------------------
 1 file changed, 64 deletions(-)

--- a/mm/slub.c~slub-remove-resiliency_test-function
+++ a/mm/slub.c
@@ -155,9 +155,6 @@ static inline bool kmem_cache_has_cpu_pa
  * - Variable sizing of the per node arrays
  */
 
-/* Enable to test recovery from slab corruption on boot */
-#undef SLUB_RESILIENCY_TEST
-
 /* Enable to log cmpxchg failures */
 #undef SLUB_DEBUG_CMPXCHG
 
@@ -4938,66 +4935,6 @@ static int list_locations(struct kmem_ca
 }
 #endif	/* CONFIG_SLUB_DEBUG */
 
-#ifdef SLUB_RESILIENCY_TEST
-static void __init resiliency_test(void)
-{
-	u8 *p;
-	int type = KMALLOC_NORMAL;
-
-	BUILD_BUG_ON(KMALLOC_MIN_SIZE > 16 || KMALLOC_SHIFT_HIGH < 10);
-
-	pr_err("SLUB resiliency testing\n");
-	pr_err("-----------------------\n");
-	pr_err("A. Corruption after allocation\n");
-
-	p = kzalloc(16, GFP_KERNEL);
-	p[16] = 0x12;
-	pr_err("\n1. kmalloc-16: Clobber Redzone/next pointer 0x12->0x%p\n\n",
-	       p + 16);
-
-	validate_slab_cache(kmalloc_caches[type][4]);
-
-	/* Hmmm... The next two are dangerous */
-	p = kzalloc(32, GFP_KERNEL);
-	p[32 + sizeof(void *)] = 0x34;
-	pr_err("\n2. kmalloc-32: Clobber next pointer/next slab 0x34 -> -0x%p\n",
-	       p);
-	pr_err("If allocated object is overwritten then not detectable\n\n");
-
-	validate_slab_cache(kmalloc_caches[type][5]);
-	p = kzalloc(64, GFP_KERNEL);
-	p += 64 + (get_cycles() & 0xff) * sizeof(void *);
-	*p = 0x56;
-	pr_err("\n3. kmalloc-64: corrupting random byte 0x56->0x%p\n",
-	       p);
-	pr_err("If allocated object is overwritten then not detectable\n\n");
-	validate_slab_cache(kmalloc_caches[type][6]);
-
-	pr_err("\nB. Corruption after free\n");
-	p = kzalloc(128, GFP_KERNEL);
-	kfree(p);
-	*p = 0x78;
-	pr_err("1. kmalloc-128: Clobber first word 0x78->0x%p\n\n", p);
-	validate_slab_cache(kmalloc_caches[type][7]);
-
-	p = kzalloc(256, GFP_KERNEL);
-	kfree(p);
-	p[50] = 0x9a;
-	pr_err("\n2. kmalloc-256: Clobber 50th byte 0x9a->0x%p\n\n", p);
-	validate_slab_cache(kmalloc_caches[type][8]);
-
-	p = kzalloc(512, GFP_KERNEL);
-	kfree(p);
-	p[512] = 0xab;
-	pr_err("\n3. kmalloc-512: Clobber redzone 0xab->0x%p\n\n", p);
-	validate_slab_cache(kmalloc_caches[type][9]);
-}
-#else
-#ifdef CONFIG_SYSFS
-static void resiliency_test(void) {};
-#endif
-#endif	/* SLUB_RESILIENCY_TEST */
-
 #ifdef CONFIG_SYSFS
 enum slab_stat_type {
 	SL_ALL,			/* All slabs */
@@ -5846,7 +5783,6 @@ static int __init slab_sysfs_init(void)
 	}
 
 	mutex_unlock(&slab_mutex);
-	resiliency_test();
 	return 0;
 }
 
_

Patches currently in -mm which might be from glittao@gmail.com are

mm-slub-use-stackdepot-to-save-stack-trace-in-objects.patch

