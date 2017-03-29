From: akpm@linux-foundation.org
Subject: + kcov-simplify-interrupt-check.patch added to -mm tree
Date: Wed, 29 Mar 2017 16:10:07 -0700
Message-ID: <58dc3ecf.WClYWop/zJs31p2O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40444 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754333AbdC2XKJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Mar 2017 19:10:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, alex.popov@linux.com, andreyknvl@google.com, hillf.zj@alibaba-inc.com, james.morse@arm.com, wangkefeng.wang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kcov: simplify interrupt check
has been added to the -mm tree.  Its filename is
     kcov-simplify-interrupt-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kcov-simplify-interrupt-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kcov-simplify-interrupt-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from dvyukov@google.com are

kcov-simplify-interrupt-check.patch
fault-inject-use-correct-check-for-interrupts.patch
fault-inject-support-systematic-fault-injection.patch
kasan-allow-kasan_check_read-write-to-accept-pointers-to-volatiles.patch
asm-generic-x86-wrap-atomic-operations.patch
asm-generic-x86-wrap-atomic-operations-fix.patch
asm-generic-add-kasan-instrumentation-to-atomic-operations.patch
asm-generic-fix-compilation-failure-in-cmpxchg_double.patch
x86-remove-unused-atomic_inc_short.patch
x86-asm-generic-add-kasan-instrumentation-to-bitops.patch

