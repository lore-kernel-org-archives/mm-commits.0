From: akpm@linux-foundation.org
Subject: + sched-replace-init_completion-with-reinit_completion.patch
 added to -mm tree
Date: Tue, 15 Oct 2013 15:25:37 -0700
Message-ID: <525dc0e1.oKywJQFtofNI3K/q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54945 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932802Ab3JOWZi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Oct 2013 18:25:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mingo@kernel.org, linus.walleij@linaro.org, wsa@the-dreams.de

Subject: + sched-replace-init_completion-with-reinit_completion.patch added to -mm tree
To: wsa@the-dreams.de,linus.walleij@linaro.org,mingo@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 15 Oct 2013 15:25:37 -0700


The patch titled
     Subject: sched: replace INIT_COMPLETION with reinit_completion
has been added to the -mm tree.  Its filename is
     sched-replace-init_completion-with-reinit_completion.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sched-replace-init_completion-with-reinit_completion.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sched-replace-init_completion-with-reinit_completion.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

sched-replace-init_completion-with-reinit_completion.patch
tree-wide-use-reinit_completion-instead-of-init_completion.patch
sched-remove-init_completion.patch

