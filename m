Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC2E7C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 14 Sep 2021 02:56:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99FE960F92
	for <mm-commits@archiver.kernel.org>; Tue, 14 Sep 2021 02:56:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238376AbhINC6O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Sep 2021 22:58:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238114AbhINC6B (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Sep 2021 22:58:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E827061108;
        Tue, 14 Sep 2021 02:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631588204;
        bh=MMVkeVkXVG/jpdyjLKqzIk2Lr8RzMYB9TDNQ/zRbYx0=;
        h=Date:From:To:Subject:From;
        b=PZYrPOTtowjqpUwIYgZwyQZ4BAubyYxpCnpuZIV5Ce/aLrqQybZKXkTj+MvKtVb1/
         DHHjCpW1891ZGrDw/0cTwt3d3GuF9z4RlmX992XWYTtlylNfb5himemj9JSFUEQfct
         ui1PJcfV371/qhAAaNReYk1/wuVdEIpy+v2YRECw=
Date:   Mon, 13 Sep 2021 19:56:43 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, bigeasy@linutronix.de, dvyukov@google.com,
        elver@google.com, glider@google.com, gustavoars@kernel.org,
        jiangshanlai@gmail.com, mm-commits@vger.kernel.org,
        ryabinin.a.a@gmail.com, skhan@linuxfoundation.org,
        tarasmadan@google.com, tglx@linutronix.de, tj@kernel.org,
        vinmenon@codeaurora.org, vjitta@codeaurora.org,
        walter-zh.wu@mediatek.com
Subject:  +
 kasan-generic-introduce-kasan_record_aux_stack_noalloc.patch added to -mm
 tree
Message-ID: <20210914025643.mE2kgFHmc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: generic: introduce kasan_record_aux_stack_noalloc()
has been added to the -mm tree.  Its filename is
     kasan-generic-introduce-kasan_record_aux_stack_noalloc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-generic-introduce-kasan_record_aux_stack_noalloc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-generic-introduce-kasan_record_aux_stack_noalloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kasan: generic: introduce kasan_record_aux_stack_noalloc()

Introduce a variant of kasan_record_aux_stack() that does not do any
memory allocation through stackdepot.  This will permit using it in
contexts that cannot allocate any memory.

Link: https://lkml.kernel.org/r/20210913112609.2651084-6-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Tested-by: Shuah Khan <skhan@linuxfoundation.org>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Taras Madan <tarasmadan@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: Walter Wu <walter-zh.wu@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |    2 ++
 mm/kasan/generic.c    |   14 ++++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

--- a/include/linux/kasan.h~kasan-generic-introduce-kasan_record_aux_stack_noalloc
+++ a/include/linux/kasan.h
@@ -370,12 +370,14 @@ static inline void kasan_unpoison_task_s
 void kasan_cache_shrink(struct kmem_cache *cache);
 void kasan_cache_shutdown(struct kmem_cache *cache);
 void kasan_record_aux_stack(void *ptr);
+void kasan_record_aux_stack_noalloc(void *ptr);
 
 #else /* CONFIG_KASAN_GENERIC */
 
 static inline void kasan_cache_shrink(struct kmem_cache *cache) {}
 static inline void kasan_cache_shutdown(struct kmem_cache *cache) {}
 static inline void kasan_record_aux_stack(void *ptr) {}
+static inline void kasan_record_aux_stack_noalloc(void *ptr) {}
 
 #endif /* CONFIG_KASAN_GENERIC */
 
--- a/mm/kasan/generic.c~kasan-generic-introduce-kasan_record_aux_stack_noalloc
+++ a/mm/kasan/generic.c
@@ -328,7 +328,7 @@ DEFINE_ASAN_SET_SHADOW(f3);
 DEFINE_ASAN_SET_SHADOW(f5);
 DEFINE_ASAN_SET_SHADOW(f8);
 
-void kasan_record_aux_stack(void *addr)
+static void __kasan_record_aux_stack(void *addr, bool can_alloc)
 {
 	struct page *page = kasan_addr_to_page(addr);
 	struct kmem_cache *cache;
@@ -345,7 +345,17 @@ void kasan_record_aux_stack(void *addr)
 		return;
 
 	alloc_meta->aux_stack[1] = alloc_meta->aux_stack[0];
-	alloc_meta->aux_stack[0] = kasan_save_stack(GFP_NOWAIT, true);
+	alloc_meta->aux_stack[0] = kasan_save_stack(GFP_NOWAIT, can_alloc);
+}
+
+void kasan_record_aux_stack(void *addr)
+{
+	return __kasan_record_aux_stack(addr, true);
+}
+
+void kasan_record_aux_stack_noalloc(void *addr)
+{
+	return __kasan_record_aux_stack(addr, false);
 }
 
 void kasan_set_free_info(struct kmem_cache *cache,
_

Patches currently in -mm which might be from elver@google.com are

kasan-fix-kconfig-check-of-cc_has_working_nosanitize_address.patch
lib-stackdepot-include-gfph.patch
lib-stackdepot-remove-unused-function-argument.patch
lib-stackdepot-introduce-__stack_depot_save.patch
kasan-common-provide-can_alloc-in-kasan_save_stack.patch
kasan-generic-introduce-kasan_record_aux_stack_noalloc.patch
workqueue-kasan-avoid-alloc_pages-when-recording-stack.patch
mm-fix-data-race-in-pagepoisoned.patch

