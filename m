Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C2E4C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:40:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4328D61354
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:40:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233888AbhKKCm6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:42:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:48566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233571AbhKKCm6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:42:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DE84610F7;
        Thu, 11 Nov 2021 02:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598410;
        bh=dYoxVGxHTAHWYn9t9MUVEHM4LumywNVAlAumttIUsvY=;
        h=Date:From:To:Subject:From;
        b=b/DJEc0bvRtuaRLdOE1iyDvC8r4mNmYsnuGpTNVyI8nfFACusNN0KlKmEse09UJI6
         fpNyIFGr0eWSiM1tLfYzZzva4zzVuXccGQIk3mll8ArrfOaLTTbmR3sc1Gc9XAhai8
         Jk6r6W5CGQjxroOTV0mze1HnJSzWI05RL9hbA5Vk=
Date:   Wed, 10 Nov 2021 18:40:09 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, bigeasy@linutronix.de, dvyukov@google.com,
        elver@google.com, glider@google.com, gustavoars@kernel.org,
        jiangshanlai@gmail.com, mm-commits@vger.kernel.org,
        ryabinin.a.a@gmail.com, skhan@linuxfoundation.org,
        tarasmadan@google.com, tglx@linutronix.de, tj@kernel.org,
        vinmenon@codeaurora.org, vjitta@codeaurora.org,
        walter-zh.wu@mediatek.com
Subject:  [merged] lib-stackdepot-include-gfph.patch removed from
 -mm tree
Message-ID: <20211111024009.gMoUkcoCe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: include gfp.h
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-include-gfph.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: lib/stackdepot: include gfp.h

Patch series "stackdepot, kasan, workqueue: Avoid expanding stackdepot slabs when holding raw_spin_lock", v2.

Shuah Khan reported [1]:

 | When CONFIG_PROVE_RAW_LOCK_NESTING=y and CONFIG_KASAN are enabled,
 | kasan_record_aux_stack() runs into "BUG: Invalid wait context" when
 | it tries to allocate memory attempting to acquire spinlock in page
 | allocation code while holding workqueue pool raw_spinlock.
 |
 | There are several instances of this problem when block layer tries
 | to __queue_work(). Call trace from one of these instances is below:
 |
 |     kblockd_mod_delayed_work_on()
 |       mod_delayed_work_on()
 |         __queue_delayed_work()
 |           __queue_work() (rcu_read_lock, raw_spin_lock pool->lock held)
 |             insert_work()
 |               kasan_record_aux_stack()
 |                 kasan_save_stack()
 |                   stack_depot_save()
 |                     alloc_pages()
 |                       __alloc_pages()
 |                         get_page_from_freelist()
 |                           rm_queue()
 |                             rm_queue_pcplist()
 |                               local_lock_irqsave(&pagesets.lock, flags);
 |                               [ BUG: Invalid wait context triggered ]

PROVE_RAW_LOCK_NESTING is pointing out that (on RT kernels) the locking
rules are being violated.  More generally, memory is being allocated from
a non-preemptive context (raw_spin_lock'd c-s) where it is not allowed.

To properly fix this, we must prevent stackdepot from replenishing its
"stack slab" pool if memory allocations cannot be done in the current
context: it's a bug to use either GFP_ATOMIC nor GFP_NOWAIT in certain
non-preemptive contexts, including raw_spin_locks (see gfp.h and
ab00db216c9c7).

The only downside is that saving a stack trace may fail if: stackdepot
runs out of space AND the same stack trace has not been recorded before. 
I expect this to be unlikely, and a simple experiment (boot the kernel)
didn't result in any failure to record stack trace from insert_work().

The series includes a few minor fixes to stackdepot that I noticed in
preparing the series.  It then introduces __stack_depot_save(), which
exposes the option to force stackdepot to not allocate any memory. 
Finally, KASAN is changed to use the new stackdepot interface and provide
kasan_record_aux_stack_noalloc(), which is then used by workqueue code.

[1] https://lkml.kernel.org/r/20210902200134.25603-1-skhan@linuxfoundation.org


This patch (of 6):

<linux/stackdepot.h> refers to gfp_t, but doesn't include gfp.h.

Fix it by including <linux/gfp.h>.

Link: https://lkml.kernel.org/r/20210913112609.2651084-1-elver@google.com
Link: https://lkml.kernel.org/r/20210913112609.2651084-2-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Tested-by: Shuah Khan <skhan@linuxfoundation.org>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Walter Wu <walter-zh.wu@mediatek.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Taras Madan <tarasmadan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/stackdepot.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/stackdepot.h~lib-stackdepot-include-gfph
+++ a/include/linux/stackdepot.h
@@ -11,6 +11,8 @@
 #ifndef _LINUX_STACKDEPOT_H
 #define _LINUX_STACKDEPOT_H
 
+#include <linux/gfp.h>
+
 typedef u32 depot_stack_handle_t;
 
 depot_stack_handle_t stack_depot_save(unsigned long *entries,
_

Patches currently in -mm which might be from elver@google.com are


