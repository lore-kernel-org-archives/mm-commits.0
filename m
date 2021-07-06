Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FF02C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:23:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45B9361CA8
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:23:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhGFT0T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:26:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:59446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229793AbhGFT0T (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:26:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AD2661CA3;
        Tue,  6 Jul 2021 19:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599420;
        bh=RJMl5OL/4UfRMsWXueHyqHUWXH/0qODYivFirZz9x2g=;
        h=Date:From:To:Subject:From;
        b=cz6sNo9C6odLQc+H7BKi35pQAuXva2NXxFuZKbTOYxHW+U0HO33PdkrjB8IKeWKeA
         uzC6A+QO0eWhQsyyWxz+ocjmtkb1NTbiW6mHMOipLZwh7Ir19btTh54+yP8jrVvA5K
         GuLI7icIjcO4/1tzfOiwOIjbP4rd23w2KYGzGv9M=
Date:   Tue, 06 Jul 2021 12:23:40 -0700
From:   akpm@linux-foundation.org
To:     1vier1@web.de, dbueso@suse.de, manfred@colorfullife.com,
        mm-commits@vger.kernel.org, paulmck@kernel.org
Subject:  [merged]
 ipc-semc-use-read_once-write_once-for-use_global_lock.patch removed from
 -mm tree
Message-ID: <20210706192340.5XGzSddNk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem.c: use READ_ONCE()/WRITE_ONCE() for use_global_lock
has been removed from the -mm tree.  Its filename was
     ipc-semc-use-read_once-write_once-for-use_global_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc/sem.c: use READ_ONCE()/WRITE_ONCE() for use_global_lock

The patch solves three weaknesses in ipc/sem.c:

1) The initial read of use_global_lock in sem_lock() is an intentional
   race.  KCSAN detects these accesses and prints a warning.

2) The code assumes that plain C read/writes are not mangled by the CPU
   or the compiler.

3) The comment it sysvipc_sem_proc_show() was hard to understand: The
   rest of the comments in ipc/sem.c speaks about sem_perm.lock, and
   suddenly this function speaks about ipc_lock_object().

To solve 1) and 2), use READ_ONCE()/WRITE_ONCE().  Plain C reads are used
in code that owns sma->sem_perm.lock.

The comment is updated to solve 3)

[manfred@colorfullife.com: use READ_ONCE()/WRITE_ONCE() for use_global_lock]
  Link: https://lkml.kernel.org/r/20210627161919.3196-3-manfred@colorfullife.com
Link: https://lkml.kernel.org/r/20210514175319.12195-1-manfred@colorfullife.com
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: Davidlohr Bueso <dbueso@suse.de>
Cc: <1vier1@web.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/ipc/sem.c~ipc-semc-use-read_once-write_once-for-use_global_lock
+++ a/ipc/sem.c
@@ -217,6 +217,8 @@ static int sysvipc_sem_proc_show(struct
  * this smp_load_acquire(), this is guaranteed because the smp_load_acquire()
  * is inside a spin_lock() and after a write from 0 to non-zero a
  * spin_lock()+spin_unlock() is done.
+ * To prevent the compiler/cpu temporarily writing 0 to use_global_lock,
+ * READ_ONCE()/WRITE_ONCE() is used.
  *
  * 2) queue.status: (SEM_BARRIER_2)
  * Initialization is done while holding sem_lock(), so no further barrier is
@@ -342,10 +344,10 @@ static void complexmode_enter(struct sem
 		 * Nothing to do, just reset the
 		 * counter until we return to simple mode.
 		 */
-		sma->use_global_lock = USE_GLOBAL_LOCK_HYSTERESIS;
+		WRITE_ONCE(sma->use_global_lock, USE_GLOBAL_LOCK_HYSTERESIS);
 		return;
 	}
-	sma->use_global_lock = USE_GLOBAL_LOCK_HYSTERESIS;
+	WRITE_ONCE(sma->use_global_lock, USE_GLOBAL_LOCK_HYSTERESIS);
 
 	for (i = 0; i < sma->sem_nsems; i++) {
 		sem = &sma->sems[i];
@@ -371,7 +373,8 @@ static void complexmode_tryleave(struct
 		/* See SEM_BARRIER_1 for purpose/pairing */
 		smp_store_release(&sma->use_global_lock, 0);
 	} else {
-		sma->use_global_lock--;
+		WRITE_ONCE(sma->use_global_lock,
+				sma->use_global_lock-1);
 	}
 }
 
@@ -412,7 +415,7 @@ static inline int sem_lock(struct sem_ar
 	 * Initial check for use_global_lock. Just an optimization,
 	 * no locking, no memory barrier.
 	 */
-	if (!sma->use_global_lock) {
+	if (!READ_ONCE(sma->use_global_lock)) {
 		/*
 		 * It appears that no complex operation is around.
 		 * Acquire the per-semaphore lock.
@@ -2436,7 +2439,8 @@ static int sysvipc_sem_proc_show(struct
 
 	/*
 	 * The proc interface isn't aware of sem_lock(), it calls
-	 * ipc_lock_object() directly (in sysvipc_find_ipc).
+	 * ipc_lock_object(), i.e. spin_lock(&sma->sem_perm.lock).
+	 * (in sysvipc_find_ipc)
 	 * In order to stay compatible with sem_lock(), we must
 	 * enter / leave complex_mode.
 	 */
_

Patches currently in -mm which might be from manfred@colorfullife.com are


