From: akpm@linux-foundation.org
Subject: + wait-explain-the-shadowing-and-type-inconsistencies.patch added to -mm tree
Date: Wed, 09 Apr 2014 12:04:44 -0700
Message-ID: <534599cc.UCxfr/kFuJdeo7dk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37371 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933480AbaDITEp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Apr 2014 15:04:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org, peterz@infradead.org

Subject: + wait-explain-the-shadowing-and-type-inconsistencies.patch added to -mm tree
To: peterz@infradead.org,akpm@linux-foundation.org
From: akpm@linux-foundation.org
Date: Wed, 09 Apr 2014 12:04:44 -0700


The patch titled
     Subject: wait: explain the shadowing and type inconsistencies
has been added to the -mm tree.  Its filename is
     wait-explain-the-shadowing-and-type-inconsistencies.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/wait-explain-the-shadowing-and-type-inconsistencies.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/wait-explain-the-shadowing-and-type-inconsistencies.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Zijlstra <peterz@infradead.org>
Subject: wait: explain the shadowing and type inconsistencies

Stick in a comment before someone else tries to fix the sparse warning
this generates.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-o2ro6f3vkxklni0bc8f7m68s@git.kernel.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/wait.h |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff -puN include/linux/wait.h~wait-explain-the-shadowing-and-type-inconsistencies include/linux/wait.h
--- a/include/linux/wait.h~wait-explain-the-shadowing-and-type-inconsistencies
+++ a/include/linux/wait.h
@@ -191,11 +191,23 @@ wait_queue_head_t *bit_waitqueue(void *,
 	(!__builtin_constant_p(state) ||				\
 		state == TASK_INTERRUPTIBLE || state == TASK_KILLABLE)	\
 
+/*
+ * The below macro ___wait_event() has an explicit shadow of the __ret
+ * variable when used from the wait_event_*() macros.
+ *
+ * This is so that both can use the ___wait_cond_timeout() construct
+ * to wrap the condition.
+ *
+ * The type inconsistency of the wait_event_*() __ret variable is also
+ * on purpose; we use long where we can return timeout values and int
+ * otherwise.
+ */
+
 #define ___wait_event(wq, condition, state, exclusive, ret, cmd)	\
 ({									\
 	__label__ __out;						\
 	wait_queue_t __wait;						\
-	long __ret = ret;						\
+	long __ret = ret;	/* explicit shadow */			\
 									\
 	INIT_LIST_HEAD(&__wait.task_list);				\
 	if (exclusive)							\
_

Patches currently in -mm which might be from peterz@infradead.org are

origin.patch
wait-explain-the-shadowing-and-type-inconsistencies.patch

