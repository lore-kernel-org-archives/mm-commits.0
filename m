From: akpm@linux-foundation.org
Subject: +
 block-use-for_each_thread-in-sys_ioprio_set-sys_ioprio_get.patch added to
 -mm tree
Date: Thu, 02 Feb 2017 14:57:01 -0800
Message-ID: <5893b93d.pV6uy74J/pE1p7tU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54214 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751585AbdBBW5C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Feb 2017 17:57:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, axboe@kernel.dk, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: block: use for_each_thread() in sys_ioprio_set()/sys_ioprio_get()
has been added to the -mm tree.  Its filename is
     block-use-for_each_thread-in-sys_ioprio_set-sys_ioprio_get.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/block-use-for_each_thread-in-sys_ioprio_set-sys_ioprio_get.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/block-use-for_each_thread-in-sys_ioprio_set-sys_ioprio_get.patch

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
Subject: block: use for_each_thread() in sys_ioprio_set()/sys_ioprio_get()

IOPRIO_WHO_USER case in sys_ioprio_set()/sys_ioprio_get() are using
while_each_thread(), which is unsafe under RCU lock according to commit
0c740d0afc3bff0a ("introduce for_each_thread() to replace the buggy
while_each_thread()").  Use for_each_thread() (via
for_each_process_thread()) which is safe under RCU lock.

Link: http://lkml.kernel.org/r/201702011947.DBD56740.OMVHOLOtSJFFFQ@I-love.SAKURA.ne.jp
Link: http://lkml.kernel.org/r/1486041779-4401-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/ioprio.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN block/ioprio.c~block-use-for_each_thread-in-sys_ioprio_set-sys_ioprio_get block/ioprio.c
--- a/block/ioprio.c~block-use-for_each_thread-in-sys_ioprio_set-sys_ioprio_get
+++ a/block/ioprio.c
@@ -122,14 +122,14 @@ SYSCALL_DEFINE3(ioprio_set, int, which,
 			if (!user)
 				break;
 
-			do_each_thread(g, p) {
+			for_each_process_thread(g, p) {
 				if (!uid_eq(task_uid(p), uid) ||
 				    !task_pid_vnr(p))
 					continue;
 				ret = set_task_ioprio(p, ioprio);
 				if (ret)
 					goto free_uid;
-			} while_each_thread(g, p);
+			}
 free_uid:
 			if (who)
 				free_uid(user);
@@ -222,7 +222,7 @@ SYSCALL_DEFINE2(ioprio_get, int, which,
 			if (!user)
 				break;
 
-			do_each_thread(g, p) {
+			for_each_process_thread(g, p) {
 				if (!uid_eq(task_uid(p), user->uid) ||
 				    !task_pid_vnr(p))
 					continue;
@@ -233,7 +233,7 @@ SYSCALL_DEFINE2(ioprio_get, int, which,
 					ret = tmpio;
 				else
 					ret = ioprio_best(ret, tmpio);
-			} while_each_thread(g, p);
+			}
 
 			if (who)
 				free_uid(user);
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

block-use-for_each_thread-in-sys_ioprio_set-sys_ioprio_get.patch

