From: akpm@linux-foundation.org
Subject: [patch 046/114] lib/fault-inject.c: use correct check for
 interrupts
Date: Mon, 08 May 2017 15:56:51 -0700
Message-ID: <20170508225651.1KMWCuAov%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46266 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751183AbdEHW4w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:56:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, akpm@linux-foundation.org, dvyukov@google.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
