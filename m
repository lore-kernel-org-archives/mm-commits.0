Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1DDCC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 19 Nov 2021 22:51:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234413AbhKSWy3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Nov 2021 17:54:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:45440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231231AbhKSWy3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Nov 2021 17:54:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AAE2961AF0;
        Fri, 19 Nov 2021 22:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637362286;
        bh=ajV3iuJtGM61fWrsVOr4wmxk/G+ynWtnonXBNWwRpHI=;
        h=Date:From:To:Subject:From;
        b=F1o8vdV+BKgUxW3BqGj+xqkftXjgoKvwMVrdf+XfT+OY4t79gXna0yk/ROWi8sm9f
         ToosV/LT4IQYoxVoPXLQS1fLItlkz2USsCDGIKyLXqVHZxgSKrmg/sWpt9wI8p48cz
         H4FQ2Pef35Yx/KSzAk3N2puiMIQ6zNaEljx2W8Ns=
Date:   Fri, 19 Nov 2021 14:51:26 -0800
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, minchan@kernel.org,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au
Subject:  + locking-rwlocks-introduce-write_lock_nested-fix.patch
 added to -mm tree
Message-ID: <20211119225126.3ilU1Uv6x%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: locking/rwlocks: fix write_lock_nested for RT
has been added to the -mm tree.  Its filename is
     locking-rwlocks-introduce-write_lock_nested-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/locking-rwlocks-introduce-write_lock_nested-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/locking-rwlocks-introduce-write_lock_nested-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: locking/rwlocks: fix write_lock_nested for RT

Fix build break of write_lock_nested for RT.

Link: https://lkml.kernel.org/r/YZfrMTAXV56HFWJY@google.com
Signed-off-by: Minchan Kim <minchan@kernel.org>
Suggested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rwlock_rt.h    |    4 ++++
 kernel/locking/spinlock_rt.c |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/include/linux/rwlock_rt.h~locking-rwlocks-introduce-write_lock_nested-fix
+++ a/include/linux/rwlock_rt.h
@@ -84,10 +84,14 @@ static __always_inline void write_lock(r
 	rt_write_lock(rwlock);
 }
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
 static __always_inline void write_lock_nested(rwlock_t *rwlock, int subclass)
 {
 	rt_write_lock_nested(rwlock, subclass);
 }
+#else
+#define write_lock_nested(lock, subclass)	rt_write_lock(((void)(subclass), (lock)))
+#endif
 
 static __always_inline void write_lock_bh(rwlock_t *rwlock)
 {
--- a/kernel/locking/spinlock_rt.c~locking-rwlocks-introduce-write_lock_nested-fix
+++ a/kernel/locking/spinlock_rt.c
@@ -242,7 +242,7 @@ EXPORT_SYMBOL(rt_write_lock);
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 void __sched rt_write_lock_nested(rwlock_t *rwlock, int subclass)
 {
-	___might_sleep(__FILE__, __LINE__, 0);
+	rtlock_might_resched();
 	rwlock_acquire(&rwlock->dep_map, subclass, 0, _RET_IP_);
 	rwbase_write_lock(&rwlock->rwbase, TASK_RTLOCK_WAIT);
 	rcu_read_lock();
_

Patches currently in -mm which might be from minchan@kernel.org are

zsmalloc-introduce-some-helper-functions.patch
zsmalloc-rename-zs_stat_type-to-class_stat_type.patch
zsmalloc-decouple-class-actions-from-zspage-works.patch
zsmalloc-introduce-obj_allocated.patch
zsmalloc-move-huge-compressed-obj-from-page-to-zspage.patch
zsmalloc-remove-zspage-isolation-for-migration.patch
locking-rwlocks-introduce-write_lock_nested.patch
locking-rwlocks-introduce-write_lock_nested-fix.patch
zsmalloc-replace-per-zpage-lock-with-pool-migrate_lock.patch

