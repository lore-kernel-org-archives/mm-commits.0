From: akpm@linux-foundation.org
Subject: [patch 08/21] fault-inject: fix wrong should_fail() decision in
 task context
Date: Thu, 10 Aug 2017 15:23:53 -0700
Message-ID: <598cdcf9.U6FYnci8T1KQzTcj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48310 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753272AbdHJWXy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Aug 2017 18:23:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, akinobu.mita@gmail.com, dvyukov@google.com, lufq.fnst@cn.fujitsu.com

From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: fault-inject: fix wrong should_fail() decision in task context

Commit 1203c8e6fb0a ("fault-inject: simplify access check for fail-nth")
unintentionally broke a conditional statement in should_fail().  Any
faults are not injected in the task context by the change when the
systematic fault injection is not used.

This change restores to the previous correct behaviour.

Link: http://lkml.kernel.org/r/1501633700-3488-1-git-send-email-akinobu.mita@gmail.com
Fixes: 1203c8e6fb0a ("fault-inject: simplify access check for fail-nth")
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reported-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Tested-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/fault-inject.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN lib/fault-inject.c~fault-inject-fix-wrong-should_fail-decision-in-task-context lib/fault-inject.c
--- a/lib/fault-inject.c~fault-inject-fix-wrong-should_fail-decision-in-task-context
+++ a/lib/fault-inject.c
@@ -110,10 +110,12 @@ bool should_fail(struct fault_attr *attr
 	if (in_task()) {
 		unsigned int fail_nth = READ_ONCE(current->fail_nth);
 
-		if (fail_nth && !WRITE_ONCE(current->fail_nth, fail_nth - 1))
-			goto fail;
+		if (fail_nth) {
+			if (!WRITE_ONCE(current->fail_nth, fail_nth - 1))
+				goto fail;
 
-		return false;
+			return false;
+		}
 	}
 
 	/* No need to check any other properties if the probability is 0 */
_
