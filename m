Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B0A8C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 00:27:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238874AbhKXAa2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 23 Nov 2021 19:30:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:54554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233846AbhKXAa2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 23 Nov 2021 19:30:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB71F60240;
        Wed, 24 Nov 2021 00:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637713639;
        bh=epJm76xCgOuRo8dkukwyR1zosrhax+Cnnny4r9UKmKU=;
        h=Date:From:To:Subject:From;
        b=TAqctVzrXkezQWjZnyHRCHd9qx6+Ixnu8XWTMpxKhu3DgarIfgDlDlSiKTeGnAXYy
         P37poLJk0TdLdX1hPYKQqY1W/inXjxSbsKZhoRrGHkhpb1RFo23wG/BGvRwWFk0ZUZ
         hSFufbbBrc0web01/ucXRgM9DqxqZ5iV1T+D0qsU=
Date:   Tue, 23 Nov 2021 16:27:18 -0800
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, bigeasy@linutronix.de, boqun.feng@gmail.com,
        dalias@libc.org, geert@linux-m68k.org, longman@redhat.com,
        minchan@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        naresh.kamboju@linaro.org, peterz@infradead.org,
        senozhatsky@chromium.org, sfr@canb.auug.org.au,
        umgwanakikbuti@gmail.com, will@kernel.org, ysato@users.osdn.me
Subject:  + locking-rwlocks-introduce-write_lock_nested-fix-2.patch
 added to -mm tree
Message-ID: <20211124002718.D_TbiDsqh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: locking: fixup write_lock_nested() implementation
has been added to the -mm tree.  Its filename is
     locking-rwlocks-introduce-write_lock_nested-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/locking-rwlocks-introduce-write_lock_nested-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/locking-rwlocks-introduce-write_lock_nested-fix-2.patch

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
Subject: locking: fixup write_lock_nested() implementation

    kernel/locking/spinlock.c:306:9: error: implicit declaration of
    function '__raw_write_lock_nested'; did you mean


Link: https://lkml.kernel.org/r/20211123170134.y6xb7pmpgdn4m3bn@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Yoshinori Sato <ysato@users.osdn.me>
Cc: Rich Felker <dalias@libc.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rwlock_api_smp.h |    1 -
 kernel/locking/spinlock.c      |    4 ++++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/rwlock_api_smp.h~locking-rwlocks-introduce-write_lock_nested-fix-2
+++ a/include/linux/rwlock_api_smp.h
@@ -47,7 +47,6 @@ _raw_write_unlock_irqrestore(rwlock_t *l
 
 #ifdef CONFIG_INLINE_WRITE_LOCK
 #define _raw_write_lock(lock) __raw_write_lock(lock)
-#define _raw_write_lock_nested(lock, subclass) __raw_write_lock_nested(lock, subclass)
 #endif
 
 #ifdef CONFIG_INLINE_READ_LOCK_BH
--- a/kernel/locking/spinlock.c~locking-rwlocks-introduce-write_lock_nested-fix-2
+++ a/kernel/locking/spinlock.c
@@ -301,6 +301,10 @@ void __lockfunc _raw_write_lock(rwlock_t
 }
 EXPORT_SYMBOL(_raw_write_lock);
 
+#ifndef CONFIG_DEBUG_LOCK_ALLOC
+#define __raw_write_lock_nested(lock, subclass)	__raw_write_lock(((void)(subclass), (lock)))
+#endif
+
 void __lockfunc _raw_write_lock_nested(rwlock_t *lock, int subclass)
 {
 	__raw_write_lock_nested(lock, subclass);
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

locking-rwlocks-introduce-write_lock_nested-fix-2.patch

