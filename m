Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3C7DC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235548AbiCVVkE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235523AbiCVVkD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:40:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7533FC62
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:38:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05E1961723
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:38:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 628B6C340EC;
        Tue, 22 Mar 2022 21:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985114;
        bh=bvIqLgXiERK4GBDLZRKDdHuPcuE01ue3q5jEwZMes2U=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=ekHBUYmWeXzUtNgxrL/QZlb1Nxi2FHl9jlSZ+uxulfKz1uuQkOXB4hypdRihqc2la
         lpCWHV6oJu62Zla1DsGDuqJCkpeIyeD3zwEaoeAZ9Wr7ts9SJS/JQlLr/kX1qBs8Cv
         NVYMo9ygjppq8YzqRh3G8GIv9hAUvj2+daK7jjZw=
Date:   Tue, 22 Mar 2022 14:38:33 -0700
To:     tj@kernel.org, pmladek@suse.com, laoar.shao@gmail.com,
        ebiederm@xmission.com, david@redhat.com, caihuoqing@baidu.com,
        linux@rasmusvillemoes.dk, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 001/227] linux/kthread.h: remove unused macros
Message-Id: <20220322213834.628B6C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
