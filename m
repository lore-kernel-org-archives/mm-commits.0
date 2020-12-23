Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47D2BC433DB
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 18:30:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 130F822287
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 18:30:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbgLWSaq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Dec 2020 13:30:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:46520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726384AbgLWSaq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Dec 2020 13:30:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F269223E4;
        Wed, 23 Dec 2020 18:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608748205;
        bh=vzZkIhu6bxCgZUNpuUca0tONvKa9pbJiwoADgDEH1Jk=;
        h=Date:From:To:Subject:From;
        b=mGWhzpSJQ4LWGB/v2XRUX1GMjeOnXikY2YW+096BEGXr2HEYT5/tb2iL044QahRhi
         XOJ/BjLm1uTCFV3cJt3oZXdUyyASCYaFI0lmps1nwqmc3aIcl9qmvz2OfcYHXC1pqy
         Ai/WHgg4+OBmIdujf1qn7Q+vK1vyphhyfndSEVRQ=
Date:   Wed, 23 Dec 2020 10:30:05 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, gor@linux.ibm.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  [merged] kasan-dont-round_up-too-much.patch removed from
 -mm tree
Message-ID: <20201223183005.zaiQUMHKW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: don't round_up too much
has been removed from the -mm tree.  Its filename was
     kasan-dont-round_up-too-much.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: don't round_up too much

For hardware tag-based mode kasan_poison_memory() already rounds up the
size. Do the same for software modes and remove round_up() from the common
code.

Link: https://lkml.kernel.org/r/47b232474f1f89dc072aeda0fa58daa6efade377.1606162397.git.andreyknvl@google.com
Link: https://linux-review.googlesource.com/id/Ib397128fac6eba874008662b4964d65352db4aa4
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Tested-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |    8 ++------
 mm/kasan/shadow.c |    1 +
 2 files changed, 3 insertions(+), 6 deletions(-)

--- a/mm/kasan/common.c~kasan-dont-round_up-too-much
+++ a/mm/kasan/common.c
@@ -213,9 +213,7 @@ void __kasan_unpoison_object_data(struct
 
 void __kasan_poison_object_data(struct kmem_cache *cache, void *object)
 {
-	poison_range(object,
-			round_up(cache->object_size, KASAN_GRANULE_SIZE),
-			KASAN_KMALLOC_REDZONE);
+	poison_range(object, cache->object_size, KASAN_KMALLOC_REDZONE);
 }
 
 /*
@@ -288,7 +286,6 @@ static bool ____kasan_slab_free(struct k
 {
 	u8 tag;
 	void *tagged_object;
-	unsigned long rounded_up_size;
 
 	tag = get_tag(object);
 	tagged_object = object;
@@ -309,8 +306,7 @@ static bool ____kasan_slab_free(struct k
 		return true;
 	}
 
-	rounded_up_size = round_up(cache->object_size, KASAN_GRANULE_SIZE);
-	poison_range(object, rounded_up_size, KASAN_KMALLOC_FREE);
+	poison_range(object, cache->object_size, KASAN_KMALLOC_FREE);
 
 	if (!kasan_stack_collection_enabled())
 		return false;
--- a/mm/kasan/shadow.c~kasan-dont-round_up-too-much
+++ a/mm/kasan/shadow.c
@@ -82,6 +82,7 @@ void poison_range(const void *address, s
 	 * addresses to this function.
 	 */
 	address = kasan_reset_tag(address);
+	size = round_up(size, KASAN_GRANULE_SIZE);
 
 	shadow_start = kasan_mem_to_shadow(address);
 	shadow_end = kasan_mem_to_shadow(address + size);
_

Patches currently in -mm which might be from andreyknvl@google.com are


