From: akpm@linux-foundation.org
Subject: + mmoom-suppress-unnecessary-sharing-same-memory-message.patch
 added to -mm tree
Date: Mon, 21 Sep 2015 15:02:49 -0700
Message-ID: <56007e89.2SXTG9mdbqLb0CiA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56638 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932428AbbIUWCu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Sep 2015 18:02:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@i-love.sakura.ne.jp, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/oom_kill.c: suppress unnecessary "sharing same memory" message
has been added to the -mm tree.  Its filename is
     mmoom-suppress-unnecessary-sharing-same-memory-message.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmoom-suppress-unnecessary-sharing-same-memory-message.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmoom-suppress-unnecessary-sharing-same-memory-message.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -588,9 +588,11 @@ void oom_kill_process(struct oom_control
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

mmoom-reverse-the-order-of-setting-tif_memdie-and-sending-sigkill.patch
mmoom-fix-potentially-killing-unrelated-process.patch
mmoom-suppress-unnecessary-sharing-same-memory-message.patch
lib-vsprintf-add-%pt-format-specifier.patch

