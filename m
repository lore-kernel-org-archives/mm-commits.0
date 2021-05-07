Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1EB1C433ED
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:03:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FCB1613C5
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:03:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234050AbhEGBEl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:04:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:44742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234033AbhEGBEk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:04:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD0CB61041;
        Fri,  7 May 2021 01:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349421;
        bh=/Ag2ny397ztCYmPFHA0Z5BKfd9/NvGqpYah+7hAZ/xQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=j0btk90dz5L9OWccNWOceCUdzXTCXN1fisoogdSiS/S6lVvH+jM7UXEVmo83GYxwJ
         CnKUFjwO49+Pq3687ItHMs0R441XiC3lO3BJKEmA0oLUn0dqhL1sYgvmPhVgG8Hn56
         kkLxqVjs1FM6I5vhF3GfA81+PdZOuaZBdL0l3KS8=
Date:   Thu, 06 May 2021 18:03:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     ahalaney@redhat.com, akpm@linux-foundation.org, glider@google.com,
        gustavoars@kernel.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, qiang.zhang@windriver.com,
        torvalds@linux-foundation.org, vinmenon@codeaurora.org,
        vjitta@codeaurora.org, ylal@codeaurora.org
Subject:  [patch 31/91] lib: stackdepot: turn depot_lock spinlock
 to raw_spinlock
Message-ID: <20210507010340.F_WznFAje%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Zqiang <qiang.zhang@windriver.com>
Subject: lib: stackdepot: turn depot_lock spinlock to raw_spinlock

[    2.670635] BUG: sleeping function called from invalid context
at kernel/locking/rtmutex.c:951
[    2.670638] in_atomic(): 0, irqs_disabled(): 1, non_block: 0,
pid: 19, name: pgdatinit0
[    2.670768] Call Trace:
[    2.670800]  dump_stack+0x93/0xc2
[    2.670826]  ___might_sleep.cold+0x1b2/0x1f1
[    2.670838]  rt_spin_lock+0x3b/0xb0
[    2.670838]  stack_depot_save+0x1b9/0x440
[    2.670838]  kasan_save_stack+0x32/0x40
[    2.670838]  kasan_record_aux_stack+0xa5/0xb0
[    2.670838]  __call_rcu+0x117/0x880
[    2.670838]  __exit_signal+0xafb/0x1180
[    2.670838]  release_task+0x1d6/0x480
[    2.670838]  exit_notify+0x303/0x750
[    2.670838]  do_exit+0x678/0xcf0
[    2.670838]  kthread+0x364/0x4f0
[    2.670838]  ret_from_fork+0x22/0x30

In RT system, the spin_lock will be replaced by sleepable rt_mutex lock,
in __call_rcu(), disable interrupts before calling
kasan_record_aux_stack(), will trigger above calltrace, replace spinlock
with raw_spinlock.

Link: https://lkml.kernel.org/r/20210329084009.27013-1-qiang.zhang@windriver.com
Signed-off-by: Zqiang <qiang.zhang@windriver.com>
Reported-by: Andrew Halaney <ahalaney@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: Yogesh Lal <ylal@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/stackdepot.c~lib-stackdepot-turn-depot_lock-spinlock-to-raw_spinlock
+++ a/lib/stackdepot.c
@@ -71,7 +71,7 @@ static void *stack_slabs[STACK_ALLOC_MAX
 static int depot_index;
 static int next_slab_inited;
 static size_t depot_offset;
-static DEFINE_SPINLOCK(depot_lock);
+static DEFINE_RAW_SPINLOCK(depot_lock);
 
 static bool init_stack_slab(void **prealloc)
 {
@@ -305,7 +305,7 @@ depot_stack_handle_t stack_depot_save(un
 			prealloc = page_address(page);
 	}
 
-	spin_lock_irqsave(&depot_lock, flags);
+	raw_spin_lock_irqsave(&depot_lock, flags);
 
 	found = find_stack(*bucket, entries, nr_entries, hash);
 	if (!found) {
@@ -329,7 +329,7 @@ depot_stack_handle_t stack_depot_save(un
 		WARN_ON(!init_stack_slab(&prealloc));
 	}
 
-	spin_unlock_irqrestore(&depot_lock, flags);
+	raw_spin_unlock_irqrestore(&depot_lock, flags);
 exit:
 	if (prealloc) {
 		/* Nobody used this memory, ok to free it. */
_
