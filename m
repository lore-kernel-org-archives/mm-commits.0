Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E64CC433ED
	for <mm-commits@archiver.kernel.org>; Fri, 14 May 2021 21:10:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 211BF613DE
	for <mm-commits@archiver.kernel.org>; Fri, 14 May 2021 21:10:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhENVLW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 May 2021 17:11:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:48600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229681AbhENVLV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 May 2021 17:11:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D989D61352;
        Fri, 14 May 2021 21:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621026610;
        bh=kL5e7hupOlqwOwwFjmNa1WLb2GF/Nchp/wr/158Qx1I=;
        h=Date:From:To:Subject:From;
        b=JBu+B56MJdkAbAb11sbLQkcj2cmrZdqsX+9phDcBOAN7WNfiZTfV6EVhMiGIOrtnk
         m23ulRkNQHl+/cihvYfctyYzkQWKx5ODpW9/3pUzaMxJqqLF29WXlbIhdiYSyqND1/
         N6dC/FTMxtLPczHMtposGg6bSA0vAPV1Rah8W4qg=
Date:   Fri, 14 May 2021 14:10:09 -0700
From:   akpm@linux-foundation.org
To:     1vier1@web.de, dave@stgolabs.net, manfred@colorfullife.com,
        mm-commits@vger.kernel.org, paulmck@kernel.org
Subject:  +
 ipc-semc-use-read_once-write_once-for-use_global_lock.patch added to -mm
 tree
Message-ID: <20210514211009.9o33Ortuq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem.c: use READ_ONCE()/WRITE_ONCE() for use_global_lock
has been added to the -mm tree.  Its filename is
     ipc-semc-use-read_once-write_once-for-use_global_lock.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ipc-semc-use-read_once-write_once-for-use_global_lock.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ipc-semc-use-read_once-write_once-for-use_global_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc/sem.c: use READ_ONCE()/WRITE_ONCE() for use_global_lock

The patch solves two weaknesses in ipc/sem.c:

1) The initial read of use_global_lock in sem_lock() is an intentional
race.  KCSAN detects these accesses and prints a warning.

2) The code assumes that plain C read/writes are not mangled by the CPU or
the compiler.

To solve both issues, use READ_ONCE()/WRITE_ONCE().  Plain C reads are
used in code that owns sma->sem_perm.lock.

Link: https://lkml.kernel.org/r/20210514175319.12195-1-manfred@colorfullife.com
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: <1vier1@web.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

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
_

Patches currently in -mm which might be from manfred@colorfullife.com are

ipc-semc-use-read_once-write_once-for-use_global_lock.patch

