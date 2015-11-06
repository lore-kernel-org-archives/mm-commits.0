From: akpm@linux-foundation.org
Subject: [merged]
 mmoom-suppress-unnecessary-sharing-same-memory-message.patch removed from
 -mm tree
Date: Fri, 06 Nov 2015 12:08:32 -0800
Message-ID: <563d08c0.3xrSyR0pD7YUeCs5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48751 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757627AbbKFUIc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:08:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@i-love.sakura.ne.jp, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/oom_kill.c: suppress unnecessary "sharing same memory" message
has been removed from the -mm tree.  Its filename was
     mmoom-suppress-unnecessary-sharing-same-memory-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: mm/oom_kill.c: suppress unnecessary "sharing same memory" message

oom_kill_process() sends SIGKILL to other thread groups sharing victim's
mm.  But printing

  "Kill process %d (%s) sharing same memory\n"

lines makes no sense if they already have pending SIGKILL.  This patch
reduces the "Kill process" lines by printing that line with info level
only if SIGKILL is not pending.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/oom_kill.c~mmoom-suppress-unnecessary-sharing-same-memory-message mm/oom_kill.c
--- a/mm/oom_kill.c~mmoom-suppress-unnecessary-sharing-same-memory-message
+++ a/mm/oom_kill.c
@@ -583,9 +583,11 @@ void oom_kill_process(struct oom_control
 		    !(p->flags & PF_KTHREAD)) {
 			if (p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
 				continue;
+			if (fatal_signal_pending(p))
+				continue;
 
 			task_lock(p);	/* Protect ->comm from prctl() */
-			pr_err("Kill process %d (%s) sharing same memory\n",
+			pr_info("Kill process %d (%s) sharing same memory\n",
 				task_pid_nr(p), p->comm);
 			task_unlock(p);
 			do_send_sig_info(SIGKILL, SEND_SIG_FORCED, p, true);
_

Patches currently in -mm which might be from penguin-kernel@i-love.sakura.ne.jp are


