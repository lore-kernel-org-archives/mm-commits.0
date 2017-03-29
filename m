From: akpm@linux-foundation.org
Subject: + fault-inject-use-correct-check-for-interrupts.patch added to
 -mm tree
Date: Wed, 29 Mar 2017 16:08:46 -0700
Message-ID: <58dc3e7e.lQkxf80EcBGKDD1U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40410 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753290AbdC2XIs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Mar 2017 19:08:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/fault-inject.c: use correct check for interrupts
has been added to the -mm tree.  Its filename is
     fault-inject-use-correct-check-for-interrupts.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fault-inject-use-correct-check-for-interrupts.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fault-inject-use-correct-check-for-interrupts.patch

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
Subject: lib/fault-inject.c: use correct check for interrupts

in_interrupt() also returns true when bh is disabled in task context. 
That's not what fail_task() wants to check.  Use the new in_task()
predicate that does the right thing.

Link: http://lkml.kernel.org/r/20170321091805.140676-1-dvyukov@google.com
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/fault-inject.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/fault-inject.c~fault-inject-use-correct-check-for-interrupts lib/fault-inject.c
--- a/lib/fault-inject.c~fault-inject-use-correct-check-for-interrupts
+++ a/lib/fault-inject.c
@@ -56,7 +56,7 @@ static void fail_dump(struct fault_attr
 
 static bool fail_task(struct fault_attr *attr, struct task_struct *task)
 {
-	return !in_interrupt() && task->make_it_fail;
+	return in_task() && task->make_it_fail;
 }
 
 #define MAX_STACK_TRACE_DEPTH 32
_

Patches currently in -mm which might be from dvyukov@google.com are

fault-inject-use-correct-check-for-interrupts.patch
fault-inject-support-systematic-fault-injection.patch
kasan-allow-kasan_check_read-write-to-accept-pointers-to-volatiles.patch
asm-generic-x86-wrap-atomic-operations.patch
asm-generic-x86-wrap-atomic-operations-fix.patch
asm-generic-add-kasan-instrumentation-to-atomic-operations.patch
asm-generic-fix-compilation-failure-in-cmpxchg_double.patch
x86-remove-unused-atomic_inc_short.patch
x86-asm-generic-add-kasan-instrumentation-to-bitops.patch

