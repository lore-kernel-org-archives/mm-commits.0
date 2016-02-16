From: akpm@linux-foundation.org
Subject: + oom-make-oom_reaper-freezable.patch added to -mm tree
Date: Tue, 16 Feb 2016 12:38:49 -0800
Message-ID: <56c388d9.BByHQTV1iyNpJ3An%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38009 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079AbcBPUiv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Feb 2016 15:38:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hughd@google.com, mgorman@techsingularity.net, oleg@redhat.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom: make oom_reaper freezable
has been added to the -mm tree.  Its filename is
     oom-make-oom_reaper-freezable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/oom-make-oom_reaper-freezable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/oom-make-oom_reaper-freezable.patch

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
Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
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

mm-vmscan-make-zone_reclaimable_pages-more-precise.patch
mm-oom-introduce-oom-reaper.patch
oom-reaper-handle-mlocked-pages.patch
oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space.patch
mm-oom_reaper-report-success-failure.patch
mm-oom_reaper-report-success-failure-fix-2.patch
mm-oom_reaper-implement-oom-victims-queuing.patch
oom-make-oom_reaper-freezable.patch
mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations.patch

