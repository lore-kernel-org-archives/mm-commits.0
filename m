From: akpm@linux-foundation.org
Subject: [patch 19/78] include/linux/pid.h: use for_each_thread() in
 do_each_pid_thread()
Date: Mon, 27 Feb 2017 14:27:37 -0800
Message-ID: <58b4a7d9.Et+zfOgUVIv0voVc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45462 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751921AbdB0WgF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 17:36:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, penguin-kernel@I-love.SAKURA.ne.jp, oleg@redhat.com

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
