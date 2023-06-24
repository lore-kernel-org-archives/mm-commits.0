Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56810C0015E
	for <mm-commits@archiver.kernel.org>; Sat, 24 Jun 2023 00:00:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbjFXAAQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 20:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbjFXAAJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 20:00:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F7D2707
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 17:00:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D599615DE
        for <mm-commits@vger.kernel.org>; Sat, 24 Jun 2023 00:00:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE26AC433C0;
        Sat, 24 Jun 2023 00:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687564806;
        bh=Db6B3oQRrKuOkA5tn9c0YjyL2ubyuLgYmpow0rzcWNM=;
        h=Date:To:From:Subject:From;
        b=OjJkHotlCfVciefdoOdsscGZbZqsQzH6RxwvfbJzAuD6wuqeIDav11Pje1Z+wDV9l
         cxsnJwWFSaggtIW5fIYJj2DdBUyZDYq1/iH2qm+Z2yl6wFVBqsJP2CKrArOArHi63v
         cgPUm94MtfnrzzYHzv5DpNKjP7SMIBEW2I9eeowQ=
Date:   Fri, 23 Jun 2023 17:00:06 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        vincenzo.frascino@arm.com, vbabka@suse.cz,
        syzbot+ece2915262061d6e0ac1@syzkaller.appspotmail.com,
        ryabinin.a.a@gmail.com, mgorman@techsingularity.net,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@gmail.com, penguin-kernel@I-love.SAKURA.ne.jp,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasankmsan-remove-__gfp_kswapd_reclaim-usage-from-kasan-kmsan.patch removed from -mm tree
Message-Id: <20230624000006.AE26AC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan,kmsan: remove __GFP_KSWAPD_RECLAIM usage from kasan/kmsan
has been removed from the -mm tree.  Its filename was
     kasankmsan-remove-__gfp_kswapd_reclaim-usage-from-kasan-kmsan.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: kasan,kmsan: remove __GFP_KSWAPD_RECLAIM usage from kasan/kmsan
Date: Sun, 28 May 2023 00:25:31 +0900

syzbot is reporting lockdep warning in __stack_depot_save(), for
the caller of __stack_depot_save() (i.e. __kasan_record_aux_stack() in
this report) is responsible for masking __GFP_KSWAPD_RECLAIM flag in
order not to wake kswapd which in turn wakes kcompactd.

Since kasan/kmsan functions might be called with arbitrary locks held,
mask __GFP_KSWAPD_RECLAIM flag from all GFP_NOWAIT/GFP_ATOMIC allocations
in kasan/kmsan.

Note that kmsan_save_stack_with_flags() is changed to mask both
__GFP_DIRECT_RECLAIM flag and __GFP_KSWAPD_RECLAIM flag, for
wakeup_kswapd() from wake_all_kswapds() from __alloc_pages_slowpath()
calls wakeup_kcompactd() if __GFP_KSWAPD_RECLAIM flag is set and
__GFP_DIRECT_RECLAIM flag is not set.

Link: https://lkml.kernel.org/r/656cb4f5-998b-c8d7-3c61-c2d37aa90f9a@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reported-by: syzbot <syzbot+ece2915262061d6e0ac1@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=ece2915262061d6e0ac1
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/generic.c         |    4 ++--
 mm/kasan/tags.c            |    2 +-
 mm/kmsan/core.c            |    6 +++---
 mm/kmsan/instrumentation.c |    2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

--- a/mm/kasan/generic.c~kasankmsan-remove-__gfp_kswapd_reclaim-usage-from-kasan-kmsan
+++ a/mm/kasan/generic.c
@@ -488,7 +488,7 @@ static void __kasan_record_aux_stack(voi
 		return;
 
 	alloc_meta->aux_stack[1] = alloc_meta->aux_stack[0];
-	alloc_meta->aux_stack[0] = kasan_save_stack(GFP_NOWAIT, can_alloc);
+	alloc_meta->aux_stack[0] = kasan_save_stack(0, can_alloc);
 }
 
 void kasan_record_aux_stack(void *addr)
@@ -518,7 +518,7 @@ void kasan_save_free_info(struct kmem_ca
 	if (!free_meta)
 		return;
 
-	kasan_set_track(&free_meta->free_track, GFP_NOWAIT);
+	kasan_set_track(&free_meta->free_track, 0);
 	/* The object was freed and has free track set. */
 	*(u8 *)kasan_mem_to_shadow(object) = KASAN_SLAB_FREETRACK;
 }
--- a/mm/kasan/tags.c~kasankmsan-remove-__gfp_kswapd_reclaim-usage-from-kasan-kmsan
+++ a/mm/kasan/tags.c
@@ -140,5 +140,5 @@ void kasan_save_alloc_info(struct kmem_c
 
 void kasan_save_free_info(struct kmem_cache *cache, void *object)
 {
-	save_stack_info(cache, object, GFP_NOWAIT, true);
+	save_stack_info(cache, object, 0, true);
 }
--- a/mm/kmsan/core.c~kasankmsan-remove-__gfp_kswapd_reclaim-usage-from-kasan-kmsan
+++ a/mm/kmsan/core.c
@@ -74,7 +74,7 @@ depot_stack_handle_t kmsan_save_stack_wi
 	nr_entries = stack_trace_save(entries, KMSAN_STACK_DEPTH, 0);
 
 	/* Don't sleep. */
-	flags &= ~__GFP_DIRECT_RECLAIM;
+	flags &= ~(__GFP_DIRECT_RECLAIM | __GFP_KSWAPD_RECLAIM);
 
 	handle = __stack_depot_save(entries, nr_entries, flags, true);
 	return stack_depot_set_extra_bits(handle, extra);
@@ -245,7 +245,7 @@ depot_stack_handle_t kmsan_internal_chai
 	extra_bits = kmsan_extra_bits(depth, uaf);
 
 	entries[0] = KMSAN_CHAIN_MAGIC_ORIGIN;
-	entries[1] = kmsan_save_stack_with_flags(GFP_ATOMIC, 0);
+	entries[1] = kmsan_save_stack_with_flags(__GFP_HIGH, 0);
 	entries[2] = id;
 	/*
 	 * @entries is a local var in non-instrumented code, so KMSAN does not
@@ -253,7 +253,7 @@ depot_stack_handle_t kmsan_internal_chai
 	 * positives when __stack_depot_save() passes it to instrumented code.
 	 */
 	kmsan_internal_unpoison_memory(entries, sizeof(entries), false);
-	handle = __stack_depot_save(entries, ARRAY_SIZE(entries), GFP_ATOMIC,
+	handle = __stack_depot_save(entries, ARRAY_SIZE(entries), __GFP_HIGH,
 				    true);
 	return stack_depot_set_extra_bits(handle, extra_bits);
 }
--- a/mm/kmsan/instrumentation.c~kasankmsan-remove-__gfp_kswapd_reclaim-usage-from-kasan-kmsan
+++ a/mm/kmsan/instrumentation.c
@@ -282,7 +282,7 @@ void __msan_poison_alloca(void *address,
 
 	/* stack_depot_save() may allocate memory. */
 	kmsan_enter_runtime();
-	handle = stack_depot_save(entries, ARRAY_SIZE(entries), GFP_ATOMIC);
+	handle = stack_depot_save(entries, ARRAY_SIZE(entries), __GFP_HIGH);
 	kmsan_leave_runtime();
 
 	kmsan_internal_set_shadow_origin(address, size, -1, handle,
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are


