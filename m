From: akpm@linux-foundation.org
Subject: + pid-use-for_each_thread-in-do_each_pid_thread.patch added to
 -mm tree
Date: Thu, 02 Feb 2017 14:57:55 -0800
Message-ID: <5893b973.lABlkcrLviSVKNeV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54224 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751496AbdBBW54 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Feb 2017 17:57:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/pid.h: use for_each_thread() in do_each_pid_thread()
has been added to the -mm tree.  Its filename is
     pid-use-for_each_thread-in-do_each_pid_thread.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pid-use-for_each_thread-in-do_each_pid_thread.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pid-use-for_each_thread-in-do_each_pid_thread.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: include/linux/pid.h: use for_each_thread() in do_each_pid_thread()

while_each_pid_thread() is using while_each_thread(), which is unsafe
under RCU lock according to commit 0c740d0afc3bff0a ("introduce
for_each_thread() to replace the buggy while_each_thread()").  Use
for_each_thread() in do_each_pid_thread() which is safe under RCU lock.

Link: http://lkml.kernel.org/r/201702011947.DBD56740.OMVHOLOtSJFFFQ@I-love.SAKURA.ne.jp
Link: http://lkml.kernel.org/r/1486041779-4401-2-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/pid.h~pid-use-for_each_thread-in-do_each_pid_thread include/linux/pid.h
--- a/include/linux/pid.h~pid-use-for_each_thread-in-do_each_pid_thread
+++ a/include/linux/pid.h
@@ -191,10 +191,10 @@ pid_t pid_vnr(struct pid *pid);
 #define do_each_pid_thread(pid, type, task)				\
 	do_each_pid_task(pid, type, task) {				\
 		struct task_struct *tg___ = task;			\
-		do {
+		for_each_thread(tg___, task) {
 
 #define while_each_pid_thread(pid, type, task)				\
-		} while_each_thread(tg___, task);			\
+		}							\
 		task = tg___;						\
 	} while_each_pid_task(pid, type, task)
 #endif /* _LINUX_PID_H */
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

block-use-for_each_thread-in-sys_ioprio_set-sys_ioprio_get.patch
pid-use-for_each_thread-in-do_each_pid_thread.patch

