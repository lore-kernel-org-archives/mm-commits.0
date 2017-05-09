From: akpm@linux-foundation.org
Subject: [merged]
 fault-inject-use-correct-check-for-interrupts.patch removed from -mm tree
Date: Tue, 09 May 2017 11:02:09 -0700
Message-ID: <20170509180209.8n2xserW6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34588 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754425AbdEISCK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:02:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, dvyukov@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/fault-inject.c: use correct check for interrupts
has been removed from the -mm tree.  Its filename was
     fault-inject-use-correct-check-for-interrupts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

fault-inject-support-systematic-fault-injection.patch

