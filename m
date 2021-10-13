Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 511DEC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 13 Oct 2021 21:21:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23E9A61186
	for <mm-commits@archiver.kernel.org>; Wed, 13 Oct 2021 21:21:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbhJMVXm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Oct 2021 17:23:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:49204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229575AbhJMVXg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 13 Oct 2021 17:23:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 390D86117A;
        Wed, 13 Oct 2021 21:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634160092;
        bh=thCRvTO7CmdGs+9lSXs0de3KfhPsbCEW5/BFwG8B8aw=;
        h=Date:From:To:Subject:From;
        b=VtFQeMSRleIIi8ayT7BKDI7AxaVsGBfYFk1hKkJWcmD3dScN+xXqoeHEgPp1VPTzd
         demHqBRjbRvmDTrbHXyPSi47TOjg8QZBP1KqqXsqcDXMDOZJ1Xd74THq5zft1OPFMi
         OwAhtO8LglVxhQ/kll//9IfqGq5H15lHKHy82iNY=
Date:   Wed, 13 Oct 2021 14:21:31 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, boqun.feng@gmail.com,
        brendanhiggins@google.com, jic23@kernel.org,
        laurent.pinchart@ideasonboard.com, linux@rasmusvillemoes.dk,
        longman@redhat.com, mchehab@kernel.org,
        miguel.ojeda.sandonis@gmail.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        regressions@leemhuis.info, sakari.ailus@linux.intel.com,
        tglx@linutronix.de, will@kernel.org
Subject:  +
 kernelh-drop-unneeded-linux-kernelh-inclusion-from-other-headers.patch
 added to -mm tree
Message-ID: <20211013212131.DK4GTb2pH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel.h: drop unneeded <linux/kernel.h> inclusion from other headers
has been added to the -mm tree.  Its filename is
     kernelh-drop-unneeded-linux-kernelh-inclusion-from-other-headers.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernelh-drop-unneeded-linux-kernelh-inclusion-from-other-headers.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernelh-drop-unneeded-linux-kernelh-inclusion-from-other-headers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: kernel.h: drop unneeded <linux/kernel.h> inclusion from other headers

Patch series "kernel.h further split", v5.

kernel.h is a set of something which is not related to each other and
often used in non-crossed compilation units, especially when drivers need
only one or two macro definitions from it.


This patch (of 7):

There is no evidence we need kernel.h inclusion in certain headers.  Drop
unneeded <linux/kernel.h> inclusion from other headers.

Link: https://lkml.kernel.org/r/20211013170417.87909-1-andriy.shevchenko@linux.intel.com
Link: https://lkml.kernel.org/r/20211013170417.87909-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
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

 include/linux/rwsem.h    |    1 -
 include/linux/smp.h      |    1 -
 include/linux/spinlock.h |    1 -
 3 files changed, 3 deletions(-)

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

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

kernelh-drop-unneeded-linux-kernelh-inclusion-from-other-headers.patch
kernelh-split-out-container_of-and-typeof_member-macros.patch
kunit-replace-kernelh-with-the-necessary-inclusions.patch
list-replace-kernelh-with-the-necessary-inclusions.patch
llist-replace-kernelh-with-the-necessary-inclusions.patch
plist-replace-kernelh-with-the-necessary-inclusions.patch
media-entity-replace-kernelh-with-the-necessary-inclusions.patch
seq_file-move-seq_escape-to-a-header.patch

