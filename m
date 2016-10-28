From: akpm@linux-foundation.org
Subject: [merged] kcov-properly-check-if-we-are-in-an-interrupt.patch
 removed from -mm tree
Date: Fri, 28 Oct 2016 11:30:13 -0700
Message-ID: <58139935.y4qwoLpJCLyyrtao%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45636 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965013AbcJ1SaO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2016 14:30:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com, james.morse@arm.com, keescook@chromium.org, nicstange@gmail.com, quentin.casasnovas@oracle.com, vegard.nossum@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kcov: properly check if we are in an interrupt
has been removed from the -mm tree.  Its filename was
     kcov-properly-check-if-we-are-in-an-interrupt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kcov: properly check if we are in an interrupt

in_interrupt() returns a nonzero value when we are either in an
interrupt or have bh disabled via local_bh_disable().  Since we are
interested in only ignoring coverage from actual interrupts, do a
proper check instead of just calling in_interrupt().

As a result of this change, kcov will start to collect coverage from
within local_bh_disable()/local_bh_enable() sections.

Link: http://lkml.kernel.org/r/1476115803-20712-1-git-send-email-andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Nicolai Stange <nicstange@gmail.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: James Morse <james.morse@arm.com>
Cc: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcov.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN kernel/kcov.c~kcov-properly-check-if-we-are-in-an-interrupt kernel/kcov.c
--- a/kernel/kcov.c~kcov-properly-check-if-we-are-in-an-interrupt
+++ a/kernel/kcov.c
@@ -53,8 +53,15 @@ void notrace __sanitizer_cov_trace_pc(vo
 	/*
 	 * We are interested in code coverage as a function of a syscall inputs,
 	 * so we ignore code executed in interrupts.
+	 * The checks for whether we are in an interrupt are open-coded, because
+	 * 1. We can't use in_interrupt() here, since it also returns true
+	 *    when we are inside local_bh_disable() section.
+	 * 2. We don't want to use (in_irq() | in_serving_softirq() | in_nmi()),
+	 *    since that leads to slower generated code (three separate tests,
+	 *    one for each of the flags).
 	 */
-	if (!t || in_interrupt())
+	if (!t || (preempt_count() & (HARDIRQ_MASK | SOFTIRQ_OFFSET
+							| NMI_MASK)))
 		return;
 	mode = READ_ONCE(t->kcov_mode);
 	if (mode == KCOV_MODE_TRACE) {
_

Patches currently in -mm which might be from andreyknvl@google.com are


