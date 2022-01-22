Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A06CC433F5
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 01:21:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbiAVBVB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Jan 2022 20:21:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbiAVBVB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Jan 2022 20:21:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C5CC06173B
        for <mm-commits@vger.kernel.org>; Fri, 21 Jan 2022 17:21:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FE7361AB9
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 01:21:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CBA8C340E1;
        Sat, 22 Jan 2022 01:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642814459;
        bh=KR4/5U2lYvpGqnuZ2KTkuz/srpt7BxZzU91zPMpFm6E=;
        h=Date:From:To:Subject:From;
        b=JkoT8Am31ans6JgmU8AGw5P/LMTrGmvKcYbxeifTL+FCbW6ehmY17vWilYIVPvR6O
         /RBd+pwv6s3Ol5V+JCpvcrZQhscvfM2whT0i/lPiFbAPstdD0w4gjxyrAfVyDdq9lA
         ttiLb/48nI/FcIhImJ7qkaHgWg0a7SQnIW78CWy4=
Date:   Fri, 21 Jan 2022 17:20:59 -0800
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, minchan@kernel.org,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au
Subject:  [folded-merged]
 locking-rwlocks-introduce-write_lock_nested-fix.patch removed from -mm tree
Message-ID: <20220122012059.PekXr80UF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: locking/rwlocks: fix write_lock_nested for RT
has been removed from the -mm tree.  Its filename was
     locking-rwlocks-introduce-write_lock_nested-fix.patch

This patch was dropped because it was folded into locking-rwlocks-introduce-write_lock_nested.patch

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: locking/rwlocks: fix write_lock_nested for RT

Fix build break of write_lock_nested for RT.

Link: https://lkml.kernel.org/r/YZfrMTAXV56HFWJY@google.com
Signed-off-by: Minchan Kim <minchan@kernel.org>
Suggested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
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
zsmalloc-replace-per-zpage-lock-with-pool-migrate_lock.patch

