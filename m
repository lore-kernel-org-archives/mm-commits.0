From: akpm@linux-foundation.org
Subject: [patch 045/114] kcov: simplify interrupt check
Date: Mon, 08 May 2017 15:56:48 -0700
Message-ID: <20170508225648.22NLMDJZT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46254 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751183AbdEHW4t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:56:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.popov@linux.com, andreyknvl@google.com, dvyukov@google.com, hillf.zj@alibaba-inc.com, james.morse@arm.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, wangkefeng.wang@huawei.com

From: Dmitry Vyukov <dvyukov@google.com>
Subject: kcov: simplify interrupt check

in_interrupt() semantics are confusing and wrong for most users as it also
returns true when bh is disabled.  Thus we open coded a proper check for
interrupts in __sanitizer_cov_trace_pc() with a lengthy explanatory
comment.

Use the new in_task() predicate instead.

Link: http://lkml.kernel.org/r/20170321091026.139655-1-dvyukov@google.com
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: James Morse <james.morse@arm.com>
Cc: Alexander Popov <alex.popov@linux.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcov.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff -puN kernel/kcov.c~kcov-simplify-interrupt-check kernel/kcov.c
--- a/kernel/kcov.c~kcov-simplify-interrupt-check
+++ a/kernel/kcov.c
@@ -60,15 +60,8 @@ void notrace __sanitizer_cov_trace_pc(vo
 	/*
 	 * We are interested in code coverage as a function of a syscall inputs,
 	 * so we ignore code executed in interrupts.
-	 * The checks for whether we are in an interrupt are open-coded, because
-	 * 1. We can't use in_interrupt() here, since it also returns true
-	 *    when we are inside local_bh_disable() section.
-	 * 2. We don't want to use (in_irq() | in_serving_softirq() | in_nmi()),
-	 *    since that leads to slower generated code (three separate tests,
-	 *    one for each of the flags).
 	 */
-	if (!t || (preempt_count() & (HARDIRQ_MASK | SOFTIRQ_OFFSET
-							| NMI_MASK)))
+	if (!t || !in_task())
 		return;
 	mode = READ_ONCE(t->kcov_mode);
 	if (mode == KCOV_MODE_TRACE) {
_
