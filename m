Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C689C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:32:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE3E461058
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:32:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235373AbhKICez (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:34:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:50064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229999AbhKICey (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:34:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 323E660F9B;
        Tue,  9 Nov 2021 02:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425129;
        bh=ycvwM4ULCwPUEZ9w1slKLmFErCsDn+JtUJ/7vegrAQo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=YfODAppmLYEEcQj6Usi/1Zj4hXiwyyM0K6ysSxQ0gqimgD9wjxAoMybzvSIONhFLm
         3A0QqozRG/18J+kF+xnnq759zG1eaxlIcZsCyps8sBYoJotUYLkCgWnYp80cnBLLym
         YN7FOgY0szFxeKyfJAamdrJTG1UeCGkGdw8OLiis=
Date:   Mon, 08 Nov 2021 18:32:08 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        boqun.feng@gmail.com, brendanhiggins@google.com, jic23@kernel.org,
        laurent.pinchart@ideasonboard.com, linux-mm@kvack.org,
        linux@rasmusvillemoes.dk, longman@redhat.com, mchehab@kernel.org,
        miguel.ojeda.sandonis@gmail.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        regressions@leemhuis.info, sakari.ailus@linux.intel.com,
        sfr@canb.auug.org.au, tglx@linutronix.de,
        torvalds@linux-foundation.org, will@kernel.org
Subject:  [patch 14/87] kernel.h: drop unneeded <linux/kernel.h>
 inclusion from other headers
Message-ID: <20211109023208.x8lm1BCoS%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: kernel.h: drop unneeded <linux/kernel.h> inclusion from other headers

Patch series "kernel.h further split", v5.

kernel.h is a set of something which is not related to each other and
often used in non-crossed compilation units, especially when drivers need
only one or two macro definitions from it.


This patch (of 7):

There is no evidence we need kernel.h inclusion in certain headers.  Drop
unneeded <linux/kernel.h> inclusion from other headers.

[sfr@canb.auug.org.au: bottom_half.h needs kernel]
  Link: https://lkml.kernel.org/r/20211015202908.1c417ae2@canb.auug.org.au
Link: https://lkml.kernel.org/r/20211013170417.87909-1-andriy.shevchenko@linux.intel.com
Link: https://lkml.kernel.org/r/20211013170417.87909-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bottom_half.h |    1 +
 include/linux/rwsem.h       |    1 -
 include/linux/smp.h         |    1 -
 include/linux/spinlock.h    |    1 -
 4 files changed, 1 insertion(+), 3 deletions(-)

--- a/include/linux/bottom_half.h~kernelh-drop-unneeded-linux-kernelh-inclusion-from-other-headers
+++ a/include/linux/bottom_half.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_BH_H
 #define _LINUX_BH_H
 
+#include <linux/kernel.h>
 #include <linux/preempt.h>
 
 #if defined(CONFIG_PREEMPT_RT) || defined(CONFIG_TRACE_IRQFLAGS)
--- a/include/linux/rwsem.h~kernelh-drop-unneeded-linux-kernelh-inclusion-from-other-headers
+++ a/include/linux/rwsem.h
@@ -11,7 +11,6 @@
 #include <linux/linkage.h>
 
 #include <linux/types.h>
-#include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/atomic.h>
--- a/include/linux/smp.h~kernelh-drop-unneeded-linux-kernelh-inclusion-from-other-headers
+++ a/include/linux/smp.h
@@ -108,7 +108,6 @@ static inline void on_each_cpu_cond(smp_
 #ifdef CONFIG_SMP
 
 #include <linux/preempt.h>
-#include <linux/kernel.h>
 #include <linux/compiler.h>
 #include <linux/thread_info.h>
 #include <asm/smp.h>
--- a/include/linux/spinlock.h~kernelh-drop-unneeded-linux-kernelh-inclusion-from-other-headers
+++ a/include/linux/spinlock.h
@@ -57,7 +57,6 @@
 #include <linux/compiler.h>
 #include <linux/irqflags.h>
 #include <linux/thread_info.h>
-#include <linux/kernel.h>
 #include <linux/stringify.h>
 #include <linux/bottom_half.h>
 #include <linux/lockdep.h>
_
