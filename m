Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A87CC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:29:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357316AbiCYBbM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243739AbiCYBbL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:31:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754842655A
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:29:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0165617C7
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:29:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390E3C340EC;
        Fri, 25 Mar 2022 01:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171777;
        bh=tz3/jD49iic1vqqfoxHYU6DSAXBojobUcPMW9XfUEXQ=;
        h=Date:To:From:Subject:From;
        b=Wgaw2BLeJ2X/WFjEXUnILtxQs8cf2//qZjPflN46kJe7x1tsO4prcnsiCyCTe4Uli
         TuEojIajW6jkPEVby2EXLVmmAHWoISKCrwg96lvBbTrv1rVD0GmS0G2t1bNdVmqRO1
         T6pGlVOQRGhs3vkVBKeJd5sYG7JXzpkyD/oStPu0=
Date:   Thu, 24 Mar 2022 18:29:36 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, pmladek@suse.com,
        laoar.shao@gmail.com, ebiederm@xmission.com, david@redhat.com,
        caihuoqing@baidu.com, linux@rasmusvillemoes.dk,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] linux-kthreadh-remove-unused-macros.patch removed from -mm tree
Message-Id: <20220325012937.390E3C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux/kthread.h: remove unused macros
has been removed from the -mm tree.  Its filename was
     linux-kthreadh-remove-unused-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: linux/kthread.h: remove unused macros

Ever since these macros were introduced in commit b56c0d8937e6 ("kthread:
implement kthread_worker"), there has been precisely one user (commit
4d115420707a, "NVMe: Async IO queue deletion"), and that user went away in
2016 with db3cbfff5bcc ("NVMe: IO queue deletion re-write").

Apart from being unused, these macros are also awkward to use (which may
contribute to them not being used): Having a way to statically (or
on-stack) allocating the storage for the struct kthread_worker itself
doesn't help much, since obviously one needs to have some code for
actually _spawning_ the worker thread, which must have error checking. 
And these days we have the kthread_create_worker() interface which both
allocates the struct kthread_worker and spawns the kthread.

Link: https://lkml.kernel.org/r/20220314145343.494694-1-linux@rasmusvillemoes.dk
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Cai Huoqing <caihuoqing@baidu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kthread.h |   22 ----------------------
 1 file changed, 22 deletions(-)

--- a/include/linux/kthread.h~linux-kthreadh-remove-unused-macros
+++ a/include/linux/kthread.h
@@ -141,12 +141,6 @@ struct kthread_delayed_work {
 	struct timer_list timer;
 };
 
-#define KTHREAD_WORKER_INIT(worker)	{				\
-	.lock = __RAW_SPIN_LOCK_UNLOCKED((worker).lock),		\
-	.work_list = LIST_HEAD_INIT((worker).work_list),		\
-	.delayed_work_list = LIST_HEAD_INIT((worker).delayed_work_list),\
-	}
-
 #define KTHREAD_WORK_INIT(work, fn)	{				\
 	.node = LIST_HEAD_INIT((work).node),				\
 	.func = (fn),							\
@@ -158,9 +152,6 @@ struct kthread_delayed_work {
 				     TIMER_IRQSAFE),			\
 	}
 
-#define DEFINE_KTHREAD_WORKER(worker)					\
-	struct kthread_worker worker = KTHREAD_WORKER_INIT(worker)
-
 #define DEFINE_KTHREAD_WORK(work, fn)					\
 	struct kthread_work work = KTHREAD_WORK_INIT(work, fn)
 
@@ -168,19 +159,6 @@ struct kthread_delayed_work {
 	struct kthread_delayed_work dwork =				\
 		KTHREAD_DELAYED_WORK_INIT(dwork, fn)
 
-/*
- * kthread_worker.lock needs its own lockdep class key when defined on
- * stack with lockdep enabled.  Use the following macros in such cases.
- */
-#ifdef CONFIG_LOCKDEP
-# define KTHREAD_WORKER_INIT_ONSTACK(worker)				\
-	({ kthread_init_worker(&worker); worker; })
-# define DEFINE_KTHREAD_WORKER_ONSTACK(worker)				\
-	struct kthread_worker worker = KTHREAD_WORKER_INIT_ONSTACK(worker)
-#else
-# define DEFINE_KTHREAD_WORKER_ONSTACK(worker) DEFINE_KTHREAD_WORKER(worker)
-#endif
-
 extern void __kthread_init_worker(struct kthread_worker *worker,
 			const char *name, struct lock_class_key *key);
 
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are


