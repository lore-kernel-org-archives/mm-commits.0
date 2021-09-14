Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24B63C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 14 Sep 2021 02:56:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AB3F60F6F
	for <mm-commits@archiver.kernel.org>; Tue, 14 Sep 2021 02:56:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238145AbhINC6O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Sep 2021 22:58:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238399AbhINC56 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Sep 2021 22:57:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA05060FA0;
        Tue, 14 Sep 2021 02:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631588201;
        bh=BYazDYv2c/esHha6EYYffdm1dmMPTwp+ByqzHu2lAkg=;
        h=Date:From:To:Subject:From;
        b=wt94zaMPSLypDV9JmDiPnzAKfXWG7JwbKLrgnfju0yWalRvjqSQ1XGR2qXCPxZXzU
         cl15Y9MtVMmiPfvxufjFrtWKX9/grCBSfqIXHnyBZby8ipX+w8yjPthI+A/wwpchwv
         PaTvb9fR5OT5MUmwtuGO3jApS0B6fPDCNLbotM5w=
Date:   Mon, 13 Sep 2021 19:56:40 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, bigeasy@linutronix.de, dvyukov@google.com,
        elver@google.com, glider@google.com, gustavoars@kernel.org,
        jiangshanlai@gmail.com, mm-commits@vger.kernel.org,
        ryabinin.a.a@gmail.com, skhan@linuxfoundation.org,
        tarasmadan@google.com, tglx@linutronix.de, tj@kernel.org,
        vinmenon@codeaurora.org, vjitta@codeaurora.org,
        walter-zh.wu@mediatek.com
Subject:  +
 kasan-common-provide-can_alloc-in-kasan_save_stack.patch added to -mm tree
Message-ID: <20210914025640.FT9bHtpB_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: common: provide can_alloc in kasan_save_stack()
has been added to the -mm tree.  Its filename is
     kasan-common-provide-can_alloc-in-kasan_save_stack.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-common-provide-can_alloc-in-kasan_save_stack.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-common-provide-can_alloc-in-kasan_save_stack.patch

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
Subject: kasan: common: provide can_alloc in kasan_save_stack()

Add another argument, can_alloc, to kasan_save_stack() which is passed
as-is to __stack_depot_save().

No functional change intended.

Link: https://lkml.kernel.org/r/20210913112609.2651084-5-elver@google.com
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

 mm/kasan/common.c  |    6 +++---
 mm/kasan/generic.c |    2 +-
 mm/kasan/kasan.h   |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

--- a/mm/kasan/common.c~kasan-common-provide-can_alloc-in-kasan_save_stack
+++ a/mm/kasan/common.c
@@ -30,20 +30,20 @@
 #include "kasan.h"
 #include "../slab.h"
 
-depot_stack_handle_t kasan_save_stack(gfp_t flags)
+depot_stack_handle_t kasan_save_stack(gfp_t flags, bool can_alloc)
 {
 	unsigned long entries[KASAN_STACK_DEPTH];
 	unsigned int nr_entries;
 
 	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 0);
 	nr_entries = filter_irq_stacks(entries, nr_entries);
-	return stack_depot_save(entries, nr_entries, flags);
+	return __stack_depot_save(entries, nr_entries, flags, can_alloc);
 }
 
 void kasan_set_track(struct kasan_track *track, gfp_t flags)
 {
 	track->pid = current->pid;
-	track->stack = kasan_save_stack(flags);
+	track->stack = kasan_save_stack(flags, true);
 }
 
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
--- a/mm/kasan/generic.c~kasan-common-provide-can_alloc-in-kasan_save_stack
+++ a/mm/kasan/generic.c
@@ -345,7 +345,7 @@ void kasan_record_aux_stack(void *addr)
 		return;
 
 	alloc_meta->aux_stack[1] = alloc_meta->aux_stack[0];
-	alloc_meta->aux_stack[0] = kasan_save_stack(GFP_NOWAIT);
+	alloc_meta->aux_stack[0] = kasan_save_stack(GFP_NOWAIT, true);
 }
 
 void kasan_set_free_info(struct kmem_cache *cache,
--- a/mm/kasan/kasan.h~kasan-common-provide-can_alloc-in-kasan_save_stack
+++ a/mm/kasan/kasan.h
@@ -251,7 +251,7 @@ void kasan_report_invalid_free(void *obj
 
 struct page *kasan_addr_to_page(const void *addr);
 
-depot_stack_handle_t kasan_save_stack(gfp_t flags);
+depot_stack_handle_t kasan_save_stack(gfp_t flags, bool can_alloc);
 void kasan_set_track(struct kasan_track *track, gfp_t flags);
 void kasan_set_free_info(struct kmem_cache *cache, void *object, u8 tag);
 struct kasan_track *kasan_get_free_track(struct kmem_cache *cache,
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

