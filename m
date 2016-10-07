From: akpm@linux-foundation.org
Subject: [patch 047/127] oom, oom_reaper: allow to reap mm shared by the
 kthreads
Date: Fri, 07 Oct 2016 16:59:09 -0700
Message-ID: <57f836cd.B5QYsa4snTd9iWTK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39183 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754816AbcJHAAN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 20:00:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vdavydov@parallels.com

From: Michal Hocko <mhocko@suse.com>
Subject: oom, oom_reaper: allow to reap mm shared by the kthreads

oom reaper was skipped for an mm which is shared with the kernel thread
(aka use_mm()).  The primary concern was that such a kthread might want to
read from the userspace memory and see zero page as a result of the oom
reaper action.  This is no longer a problem after "mm: make sure that
kthreads will not refault oom reaped memory" because any attempt to fault
in when the MMF_UNSTABLE is set will result in SIGBUS and so the target
user should see an error.  This means that we can finally allow oom reaper
also to tasks which share their mm with kthreads.

Link: http://lkml.kernel.org/r/1472119394-11342-10-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN mm/oom_kill.c~oom-oom_reaper-allow-to-reap-mm-shared-by-the-kthreads mm/oom_kill.c
--- a/mm/oom_kill.c~oom-oom_reaper-allow-to-reap-mm-shared-by-the-kthreads
+++ a/mm/oom_kill.c
@@ -902,13 +902,7 @@ static void oom_kill_process(struct oom_
 			continue;
 		if (same_thread_group(p, victim))
 			continue;
-		if (unlikely(p->flags & PF_KTHREAD) || is_global_init(p)) {
-			/*
-			 * We cannot use oom_reaper for the mm shared by this
-			 * process because it wouldn't get killed and so the
-			 * memory might be still used. Hide the mm from the oom
-			 * killer to guarantee OOM forward progress.
-			 */
+		if (is_global_init(p)) {
 			can_oom_reap = false;
 			set_bit(MMF_OOM_SKIP, &mm->flags);
 			pr_info("oom killer %d (%s) has mm pinned by %d (%s)\n",
@@ -916,6 +910,12 @@ static void oom_kill_process(struct oom_
 					task_pid_nr(p), p->comm);
 			continue;
 		}
+		/*
+		 * No use_mm() user needs to read from the userspace so we are
+		 * ok to reap it.
+		 */
+		if (unlikely(p->flags & PF_KTHREAD))
+			continue;
 		do_send_sig_info(SIGKILL, SEND_SIG_FORCED, p, true);
 	}
 	rcu_read_unlock();
_
