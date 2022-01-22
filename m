Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D473C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 01:21:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbiAVBVE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Jan 2022 20:21:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbiAVBVD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Jan 2022 20:21:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E4EC06173B
        for <mm-commits@vger.kernel.org>; Fri, 21 Jan 2022 17:21:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2342161AA5
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 01:21:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0156CC340E1;
        Sat, 22 Jan 2022 01:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642814462;
        bh=2jgIP2h7lprJXfsxIbEbSNg/aNEUUyHQM44GB7y+V6I=;
        h=Date:From:To:Subject:From;
        b=KjQRjrwU9lCV6tR6BeTYHHRN2YdT32vz5ukmSvqSSglioPekt4uCB794fw2+P5SvZ
         8eTzvGUdOfKc61DiGvrZw7DA8AxsjIiS5WA87EeH0Ro1lVGma6blqv6xawG9mOI00a
         z1iAj+BPnFCtB0RymRYNOHne0FphyrxxQQcsj4cg=
Date:   Fri, 21 Jan 2022 17:21:01 -0800
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, bigeasy@linutronix.de, boqun.feng@gmail.com,
        dalias@libc.org, geert@linux-m68k.org, longman@redhat.com,
        minchan@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        naresh.kamboju@linaro.org, peterz@infradead.org,
        senozhatsky@chromium.org, sfr@canb.auug.org.au,
        umgwanakikbuti@gmail.com, will@kernel.org, ysato@users.osdn.me
Subject:  [folded-merged]
 locking-rwlocks-introduce-write_lock_nested-fix-2.patch removed from -mm
 tree
Message-ID: <20220122012101.hMmbc_1f1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: locking: fixup write_lock_nested() implementation
has been removed from the -mm tree.  Its filename was
     locking-rwlocks-introduce-write_lock_nested-fix-2.patch

This patch was dropped because it was folded into locking-rwlocks-introduce-write_lock_nested.patch

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: locking: fixup write_lock_nested() implementation

    kernel/locking/spinlock.c:306:9: error: implicit declaration of
    function '__raw_write_lock_nested'; did you mean


Link: https://lkml.kernel.org/r/20211123170134.y6xb7pmpgdn4m3bn@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
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

locking-rwlocks-introduce-write_lock_nested.patch

