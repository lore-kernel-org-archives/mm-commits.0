From: akpm@linux-foundation.org
Subject: [merged] oom-make-oom_reaper-freezable.patch removed from -mm
 tree
Date: Sat, 26 Mar 2016 20:30:05 -0700
Message-ID: <56f753bd.G8Gds720RT1MZHXD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33097 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648AbcC0DaG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 26 Mar 2016 23:30:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hughd@google.com, mgorman@techsingularity.net, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom: make oom_reaper freezable
has been removed from the -mm tree.  Its filename was
     oom-make-oom_reaper-freezable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: oom: make oom_reaper freezable

After "oom: clear TIF_MEMDIE after oom_reaper managed to unmap the address
space" oom_reaper will call exit_oom_victim on the target task after it is
done.  This might however race with the PM freezer:

CPU0				CPU1				CPU2
freeze_processes
  try_to_freeze_tasks
  				# Allocation request
				out_of_memory
  oom_killer_disable
				  wake_oom_reaper(P1)
				  				__oom_reap_task
								  exit_oom_victim(P1)
    wait_event(oom_victims==0)
[...]
    				do_exit(P1)
				  perform IO/interfere with the freezer

which breaks the oom_killer_disable semantic.  We no longer have a
guarantee that the oom victim won't interfere with the freezer because it
might be anywhere on the way to do_exit while the freezer thinks the task
has already terminated.  It might trigger IO or touch devices which are
frozen already.

In order to close this race, make the oom_reaper thread freezable. This
will work because
	a) already running oom_reaper will block freezer to enter the
	   quiescent state
	b) wake_oom_reaper will not wake up the reaper after it has been
	   frozen
	c) the only way to call exit_oom_victim after try_to_freeze_tasks
	   is from the oom victim's context when we know the further
	   interference shouldn't be possible

Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/oom_kill.c~oom-make-oom_reaper-freezable mm/oom_kill.c
--- a/mm/oom_kill.c~oom-make-oom_reaper-freezable
+++ a/mm/oom_kill.c
@@ -525,6 +525,8 @@ static void oom_reap_task(struct task_st
 
 static int oom_reaper(void *unused)
 {
+	set_freezable();
+
 	while (true) {
 		struct task_struct *tsk = NULL;
 
_

Patches currently in -mm which might be from mhocko@suse.com are

oom-oom_reaper-disable-oom_reaper-for-oom_kill_allocating_task.patch
mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations.patch

