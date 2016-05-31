From: akpm@linux-foundation.org
Subject: + mm-oom_reaper-do-not-use-siglock-in-try_oom_reaper.patch added
 to -mm tree
Date: Tue, 31 May 2016 12:38:42 -0700
Message-ID: <574de842.TwRDdAUQ8nNR08rK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48997 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400AbcEaTin (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2016 15:38:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, oleg@redhat.com, penguin-kernel@i-love.sakura.ne.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom_reaper: do not use siglock in try_oom_reaper()
has been added to the -mm tree.  Its filename is
     mm-oom_reaper-do-not-use-siglock-in-try_oom_reaper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom_reaper-do-not-use-siglock-in-try_oom_reaper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom_reaper-do-not-use-siglock-in-try_oom_reaper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, oom_reaper: do not use siglock in try_oom_reaper()

Oleg has noted that siglock usage in try_oom_reaper is both pointless and
dangerous.  signal_group_exit can be checked lockless.  The problem is
that sighand becomes NULL in __exit_signal so we can crash.

Fixes: 3ef22dfff239 ("oom, oom_reaper: try to reap tasks which skip regular OOM killer path")
Link: http://lkml.kernel.org/r/1464679423-30218-1-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN mm/oom_kill.c~mm-oom_reaper-do-not-use-siglock-in-try_oom_reaper mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_reaper-do-not-use-siglock-in-try_oom_reaper
+++ a/mm/oom_kill.c
@@ -625,8 +625,6 @@ void try_oom_reaper(struct task_struct *
 	if (atomic_read(&mm->mm_users) > 1) {
 		rcu_read_lock();
 		for_each_process(p) {
-			bool exiting;
