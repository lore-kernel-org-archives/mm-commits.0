Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6E94C3526B
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:05:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8ADC723BAB
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:05:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgLRWFw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Dec 2020 17:05:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:39544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726504AbgLRWFv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Dec 2020 17:05:51 -0500
Date:   Fri, 18 Dec 2020 14:05:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608329111;
        bh=DHvmhn7Z9vTJP2KW1DOx07RPN/cMcwd6mWA3WswqlMQ=;
        h=From:To:Subject:In-Reply-To:From;
        b=GMFDQOkosCB9Wvu/VEi/44DJZRyXSi2pHf4YN8KiQhrJSv8gO7IYukf7NNmoZahql
         DBikFuGQlR9SG5NLnc0lrcRjvrcl2wfJYC7y13FOEnBORQzu7iJMy/S0EeJsQf2pBP
         t/I14R+i5IdDPIKQ5Fp8ilAO3uVqaSxbxhHvzR5Y=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        eugenis@google.com, glider@google.com, gor@linux.ibm.com,
        kevin.brodsky@arm.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [patch 68/78] kasan: don't round_up too much
Message-ID: <20201218220510.q8idAv5xN%akpm@linux-foundation.org>
In-Reply-To: <20201218140046.497484741326828e5b5d46ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -83,6 +83,7 @@ void poison_range(const void *address, s
 	 * addresses to this function.
 	 */
 	address = kasan_reset_tag(address);
+	size = round_up(size, KASAN_GRANULE_SIZE);
 
 	/* Skip KFENCE memory if called explicitly outside of sl*b. */
 	if (is_kfence_address(address))
_
