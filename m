Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D198C2BBD5
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:43:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2287E2313C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:43:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725824AbgLPEnv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:43:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:49146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725829AbgLPEnu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:43:50 -0500
Date:   Tue, 15 Dec 2020 20:43:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093794;
        bh=Y7w6aGAqb2tNHLD8eWDBPBDwn5CftXbaJjGXC0fSgg4=;
        h=From:To:Subject:In-Reply-To:From;
        b=b8BovrCa1oUh3xD9/h73p9GKjaAqFKAx4GEMcFed0LOQt/Ir7jENMVgqWSUPpehxP
         AhJOKKYPFi87YSnxj/mx1+mdTtd5TVGV0VpQYn0VgfKJ+ot/xX/kOKN7a8J995IlqX
         7wPYIKVEHbwreIobR98ZOpQtLM9cgxEpkugjYUJs=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        khlebnikov@yandex-team.ru, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        tglx@linutronix.de, torvalds@linux-foundation.org
Subject:  [patch 17/95] lib/test_lockup.c: minimum fix to get it
 compiled on PREEMPT_RT
Message-ID: <20201216044313.-SpiO0P-3%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: lib/test_lockup.c: minimum fix to get it compiled on PREEMPT_RT

On PREEMPT_RT the locks are quite different so they can't be tested as it
is done below.  The alternative is to test for the waitlock within
rtmutex.

This is the bare minimun to get it compiled.  Problems which exist on
PREEMP_RT:

- none of the locks (spinlock_t, rwlock_t, mutex_t, rw_semaphore) may be
  acquired with disabled preemption or interrupts.
  If I read the code correct the it is possible to acquire a mutex_t with
  disabled interrupts.
  I don't know how to obtain a lock pointer. Technically they are not
  exported to userland.

- memory can not be allocated with disabled preemption or interrupts
  even with GFP_ATOMIC.

Link: https://lkml.kernel.org/r/20201028181041.xyeothhkouc3p4md@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_lockup.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/lib/test_lockup.c~lib-test_lockup-minimum-fix-to-get-it-compiled-on-preempt_rt
+++ a/lib/test_lockup.c
@@ -480,6 +480,21 @@ static int __init test_lockup_init(void)
 		return -EINVAL;
 
 #ifdef CONFIG_DEBUG_SPINLOCK
+#ifdef CONFIG_PREEMPT_RT
+	if (test_magic(lock_spinlock_ptr,
+		       offsetof(spinlock_t, lock.wait_lock.magic),
+		       SPINLOCK_MAGIC) ||
+	    test_magic(lock_rwlock_ptr,
+		       offsetof(rwlock_t, rtmutex.wait_lock.magic),
+		       SPINLOCK_MAGIC) ||
+	    test_magic(lock_mutex_ptr,
+		       offsetof(struct mutex, lock.wait_lock.magic),
+		       SPINLOCK_MAGIC) ||
+	    test_magic(lock_rwsem_ptr,
+		       offsetof(struct rw_semaphore, rtmutex.wait_lock.magic),
+		       SPINLOCK_MAGIC))
+		return -EINVAL;
+#else
 	if (test_magic(lock_spinlock_ptr,
 		       offsetof(spinlock_t, rlock.magic),
 		       SPINLOCK_MAGIC) ||
@@ -494,6 +509,7 @@ static int __init test_lockup_init(void)
 		       SPINLOCK_MAGIC))
 		return -EINVAL;
 #endif
+#endif
 
 	if ((wait_state != TASK_RUNNING ||
 	     (call_cond_resched && !reacquire_locks) ||
_
