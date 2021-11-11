Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E422DC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:40:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C60C0610F7
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:40:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233897AbhKKCnI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:43:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:48746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233061AbhKKCnH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:43:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 887506187A;
        Thu, 11 Nov 2021 02:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598419;
        bh=FB731x6PTxcbh63RqU8fCx43QODagtdPMl12taVw9pI=;
        h=Date:From:To:Subject:From;
        b=R5QAx88EM/vlSDKcLsvlGjGyNbsBkecrPk2fmJJEXPcUuB4M+fbzFKG4OOgMvTlUE
         v8qpkhu4MaIZajV18GXYzArRvwcMySVVIGUZa85ifAthfc4Gzjmn1E1VuVZzW88TFL
         9aWrU0QNqKFDKZ5qUm5kz7HFkLP2OALuW6FNpXPs=
Date:   Wed, 10 Nov 2021 18:40:18 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, bigeasy@linutronix.de, dvyukov@google.com,
        elver@google.com, glider@google.com, gustavoars@kernel.org,
        jiangshanlai@gmail.com, mm-commits@vger.kernel.org,
        ryabinin.a.a@gmail.com, skhan@linuxfoundation.org,
        tarasmadan@google.com, tglx@linutronix.de, tj@kernel.org,
        vinmenon@codeaurora.org, vjitta@codeaurora.org,
        walter-zh.wu@mediatek.com
Subject:  [merged]
 kasan-common-provide-can_alloc-in-kasan_save_stack.patch removed from -mm
 tree
Message-ID: <20211111024018.LxbJOnFYv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: common: provide can_alloc in kasan_save_stack()
has been removed from the -mm tree.  Its filename was
     kasan-common-provide-can_alloc-in-kasan_save_stack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


