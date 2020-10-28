Return-Path: <SRS0=6wtZ=ED=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71369C55179
	for <mm-commits@archiver.kernel.org>; Wed, 28 Oct 2020 22:07:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21B5E2474F
	for <mm-commits@archiver.kernel.org>; Wed, 28 Oct 2020 22:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603922877;
	bh=e+8xcg0aps+qY5JRBt4Wup2MQmM7uCi/UfzruedmLPk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=raLAENvVH+uhoGBVyy+FOigepK08WKNYBqcYhoYI0FbFPCAHhGoZEGrkJ8+UgP7rt
	 IAm91f006goDvkA1f0mPT6Zs1LwqNI7j+vGww5SFkCjcw3iz5O/q5qre7eTIG33/B0
	 EJRXriP+E8N/F4tCwgc1lGEsC7TjNe9JTS1ab3Zs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730088AbgJ1WH0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Oct 2020 18:07:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:52334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730090AbgJ1WHY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 28 Oct 2020 18:07:24 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D62512480F;
        Wed, 28 Oct 2020 20:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603918062;
        bh=e+8xcg0aps+qY5JRBt4Wup2MQmM7uCi/UfzruedmLPk=;
        h=Date:From:To:Subject:From;
        b=1m0I/8jtDCzlB3QcyradKDwfK5yKfKKLEdwyKDp35qjzMOPkKltSvmHny1/i2b+Vv
         QxNaIY86vLOTvKHyDErbHbyAYIhI0tvex/OphZ/VMXdt9523cJL68EbDsUTV6rg2il
         nCB//vV0HMAm2oBHnXGP2GUUOKJe9riiJ/GF9r0Y=
Date:   Wed, 28 Oct 2020 13:47:40 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, khlebnikov@yandex-team.ru,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        tglx@linutronix.de
Subject:  +
 lib-test_lockup-minimum-fix-to-get-it-compiled-on-preempt_rt.patch added to
 -mm tree
Message-ID: <20201028204740.eJfl0Qdit%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_lockup.c: minimum fix to get it compiled on PREEMPT_RT
has been added to the -mm tree.  Its filename is
     lib-test_lockup-minimum-fix-to-get-it-compiled-on-preempt_rt.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-test_lockup-minimum-fix-to-get-it-compiled-on-preempt_rt.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-test_lockup-minimum-fix-to-get-it-compiled-on-preempt_rt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from bigeasy@linutronix.de are

lib-test_lockup-minimum-fix-to-get-it-compiled-on-preempt_rt.patch

