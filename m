From: akpm@linux-foundation.org
Subject: [merged]
 sched-replace-init_completion-with-reinit_completion.patch removed from -mm tree
Date: Fri, 15 Nov 2013 12:09:05 -0800
Message-ID: <52867f61.LpCRuSsNFD1UGhBi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35776 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab3KOUJF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:09:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mingo@kernel.org, linus.walleij@linaro.org, wsa@the-dreams.de

Subject: [merged] sched-replace-init_completion-with-reinit_completion.patch removed from -mm tree
To: wsa@the-dreams.de,linus.walleij@linaro.org,mingo@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:09:05 -0800


The patch titled
     Subject: sched: replace INIT_COMPLETION with reinit_completion
has been removed from the -mm tree.  Its filename was
     sched-replace-init_completion-with-reinit_completion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wolfram Sang <wsa@the-dreams.de>
Subject: sched: replace INIT_COMPLETION with reinit_completion

For the casual device driver writer, it is hard to remember when to use
init_completion (to init a completion structure) or INIT_COMPLETION (to
*reinit* a completion structure).  Furthermore, while all other completion
functions exepct a pointer as a parameter, INIT_COMPLETION does not.  To
make it easier to remember which function to use and to make code more
readable, introduce a new inline function with the proper name and
consistent argument type.  Update the kernel-doc for init_completion while
we are here.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Acked-by: Linus Walleij <linus.walleij@linaro.org> (personally at LCE13)
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/completion.h |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff -puN include/linux/completion.h~sched-replace-init_completion-with-reinit_completion include/linux/completion.h
--- a/include/linux/completion.h~sched-replace-init_completion-with-reinit_completion
+++ a/include/linux/completion.h
@@ -19,8 +19,8 @@
  *
  * See also:  complete(), wait_for_completion() (and friends _timeout,
  * _interruptible, _interruptible_timeout, and _killable), init_completion(),
- * and macros DECLARE_COMPLETION(), DECLARE_COMPLETION_ONSTACK(), and
- * INIT_COMPLETION().
+ * reinit_completion(), and macros DECLARE_COMPLETION(),
+ * DECLARE_COMPLETION_ONSTACK().
  */
 struct completion {
 	unsigned int done;
@@ -65,7 +65,7 @@ struct completion {
 
 /**
  * init_completion - Initialize a dynamically allocated completion
- * @x:  completion structure that is to be initialized
+ * @x:  pointer to completion structure that is to be initialized
  *
  * This inline function will initialize a dynamically created completion
  * structure.
@@ -76,6 +76,18 @@ static inline void init_completion(struc
 	init_waitqueue_head(&x->wait);
 }
 
+/**
+ * reinit_completion - reinitialize a completion structure
+ * @x:  pointer to completion structure that is to be reinitialized
+ *
+ * This inline function should be used to reinitialize a completion structure so it can
+ * be reused. This is especially important after complete_all() is used.
+ */
+static inline void reinit_completion(struct completion *x)
+{
+	x->done = 0;
+}
+
 extern void wait_for_completion(struct completion *);
 extern void wait_for_completion_io(struct completion *);
 extern int wait_for_completion_interruptible(struct completion *x);
_

Patches currently in -mm which might be from wsa@the-dreams.de are

origin.patch
linux-next.patch

