From: akpm@linux-foundation.org
Subject: +
 fault-inject-fix-wrong-should_fail-decision-in-task-context.patch added to
 -mm tree
Date: Wed, 02 Aug 2017 16:20:38 -0700
Message-ID: <59825e46.onxDRe4jrs+8jwOq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59290 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751804AbdHBXUi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2017 19:20:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, dvyukov@google.com, lufq.fnst@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fault-inject: fix wrong should_fail() decision in task context
has been added to the -mm tree.  Its filename is
     fault-inject-fix-wrong-should_fail-decision-in-task-context.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fault-inject-fix-wrong-should_fail-decision-in-task-context.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fault-inject-fix-wrong-should_fail-decision-in-task-context.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from akinobu.mita@gmail.com are

fault-inject-fix-wrong-should_fail-decision-in-task-context.patch

