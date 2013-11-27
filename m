From: akpm@linux-foundation.org
Subject: + kernel-forkc-make-dup_mm-static.patch added to -mm tree
Date: Wed, 27 Nov 2013 15:29:53 -0800
Message-ID: <52968071.5JGWQLvLwo2V7XRr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52597 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab3K0X3x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Nov 2013 18:29:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, daeseok.youn@gmail.com, daeseok.youn@lge.com

Subject: + kernel-forkc-make-dup_mm-static.patch added to -mm tree
To: daeseok.youn@lge.com,daeseok.youn@gmail.com
From: akpm@linux-foundation.org
Date: Wed, 27 Nov 2013 15:29:53 -0800


The patch titled
     Subject: kernel/fork.c: make dup_mm() static
has been added to the -mm tree.  Its filename is
     kernel-forkc-make-dup_mm-static.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-forkc-make-dup_mm-static.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-forkc-make-dup_mm-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daeseok Youn <daeseok.youn@lge.com>
Subject: kernel/fork.c: make dup_mm() static

dup_mm() function is used only in kernel/fork.c

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 --
 kernel/fork.c         |    2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff -puN include/linux/sched.h~kernel-forkc-make-dup_mm-static include/linux/sched.h
--- a/include/linux/sched.h~kernel-forkc-make-dup_mm-static
+++ a/include/linux/sched.h
@@ -2177,8 +2177,6 @@ extern struct mm_struct *get_task_mm(str
 extern struct mm_struct *mm_access(struct task_struct *task, unsigned int mode);
 /* Remove the current tasks stale references to the old mm_struct */
 extern void mm_release(struct task_struct *, struct mm_struct *);
-/* Allocate a new mm structure and copy contents from tsk->mm */
-extern struct mm_struct *dup_mm(struct task_struct *tsk);
 
 extern int copy_thread(unsigned long, unsigned long, unsigned long,
 			struct task_struct *);
diff -puN kernel/fork.c~kernel-forkc-make-dup_mm-static kernel/fork.c
--- a/kernel/fork.c~kernel-forkc-make-dup_mm-static
+++ a/kernel/fork.c
@@ -799,7 +799,7 @@ void mm_release(struct task_struct *tsk,
  * Allocate a new mm structure and copy contents from the
  * mm structure of the passed in task structure.
  */
-struct mm_struct *dup_mm(struct task_struct *tsk)
+static struct mm_struct *dup_mm(struct task_struct *tsk)
 {
 	struct mm_struct *mm, *oldmm = current->mm;
 	int err;
_

Patches currently in -mm which might be from daeseok.youn@lge.com are

kernel-forkc-make-dup_mm-static.patch

