From: akpm@linux-foundation.org
Subject: + mmoom-fix-potentially-killing-unrelated-process.patch added to
 -mm tree
Date: Mon, 21 Sep 2015 15:02:47 -0700
Message-ID: <56007e87.T4NBbdrzZjdZUHo8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56630 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932428AbbIUWCs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Sep 2015 18:02:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@i-love.sakura.ne.jp, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/oom_kill.c: fix potentially killing unrelated process
has been added to the -mm tree.  Its filename is
     mmoom-fix-potentially-killing-unrelated-process.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmoom-fix-potentially-killing-unrelated-process.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmoom-fix-potentially-killing-unrelated-process.patch

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
Subject: mm/oom_kill.c: fix potentially killing unrelated process

At the for_each_process() loop in oom_kill_process(), we are comparing
address of OOM victim's mm without holding a reference to that mm.  If
there are a lot of processes to compare or a lot of "Kill process %d (%s)
sharing same memory" messages to print, for_each_process() loop could take
very long time.

It is possible that meanwhile the OOM victim exits and releases its mm,
and then mm is allocated with the same address and assigned to some
unrelated process.  When we hit such race, the unrelated process will be
killed by error.  To make sure that the OOM victim's mm does not go away
until for_each_process() loop finishes, get a reference on the OOM
victim's mm before calling task_unlock(victim).

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/oom_kill.c~mmoom-fix-potentially-killing-unrelated-process mm/oom_kill.c
--- a/mm/oom_kill.c~mmoom-fix-potentially-killing-unrelated-process
+++ a/mm/oom_kill.c
@@ -561,8 +561,9 @@ void oom_kill_process(struct oom_control
 		victim = p;
 	}
 
-	/* mm cannot safely be dereferenced after task_unlock(victim) */
+	/* Get a reference to safely compare mm after task_unlock(victim) */
 	mm = victim->mm;
+	atomic_inc(&mm->mm_users);
 	/* Send SIGKILL before setting TIF_MEMDIE. */
 	do_send_sig_info(SIGKILL, SEND_SIG_FORCED, victim, true);
 	mark_oom_victim(victim);
@@ -596,6 +597,7 @@ void oom_kill_process(struct oom_control
 		}
 	rcu_read_unlock();
 
+	mmput(mm);
 	put_task_struct(victim);
 }
 #undef K
_

Patches currently in -mm which might be from penguin-kernel@i-love.sakura.ne.jp are

mmoom-reverse-the-order-of-setting-tif_memdie-and-sending-sigkill.patch
mmoom-fix-potentially-killing-unrelated-process.patch
mmoom-suppress-unnecessary-sharing-same-memory-message.patch
lib-vsprintf-add-%pt-format-specifier.patch

