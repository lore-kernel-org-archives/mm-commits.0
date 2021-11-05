Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B296EC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:35:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CB2B6125F
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:35:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbhKEUi1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:38:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:33232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232269AbhKEUi1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:38:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C0DA611EE;
        Fri,  5 Nov 2021 20:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144547;
        bh=IjxZzy+5Jjm2z5NmidHT1xCLtqR0xj3arDGEfT2tB/o=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=1a+ceE147I3cV2+XGnIIQoKSVlEEIowOg36l/53/j4FJThhXZRjnHik25stMwGqAm
         1d/3cPKN5HIhgGTEvb3Q1/+Vkbpa3HD5f9LXheIiETM1NefnjcfzAi6y7V93sn52Xg
         nNYaNB6C0o8gXwmt6eonhKguY7X41CwgPMVMKUyI=
Date:   Fri, 05 Nov 2021 13:35:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        bigeasy@linutronix.de, dvyukov@google.com, elver@google.com,
        glider@google.com, gustavoars@kernel.org, jiangshanlai@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        ryabinin.a.a@gmail.com, skhan@linuxfoundation.org,
        tarasmadan@google.com, tglx@linutronix.de, tj@kernel.org,
        torvalds@linux-foundation.org, vinmenon@codeaurora.org,
        vjitta@codeaurora.org, walter-zh.wu@mediatek.com
Subject:  [patch 023/262] kasan: generic: introduce
 kasan_record_aux_stack_noalloc()
Message-ID: <20211105203546.DpiM4aEip%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Marco Elver <elver@google.com>
Subject: kasan: generic: introduce kasan_record_aux_stack_noalloc()

Introduce a variant of kasan_record_aux_stack() that does not do any
memory allocation through stackdepot.  This will permit using it in
contexts that cannot allocate any memory.

Link: https://lkml.kernel.org/r/20210913112609.2651084-6-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Tested-by: Shuah Khan <skhan@linuxfoundation.org>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
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
