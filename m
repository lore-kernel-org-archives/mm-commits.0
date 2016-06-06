From: akpm@linux-foundation.org
Subject: [merged] mm-oom_reaper-do-not-use-siglock-in-try_oom_reaper.patch removed from -mm tree
Date: Mon, 06 Jun 2016 12:06:54 -0700
Message-ID: <5755c9ce.AB/OIxrIwE2IsH5O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36381 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbcFFTGz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jun 2016 15:06:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, oleg@redhat.com, penguin-kernel@i-love.sakura.ne.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom_reaper: do not use siglock in try_oom_reaper()
has been removed from the -mm tree.  Its filename was
     mm-oom_reaper-do-not-use-siglock-in-try_oom_reaper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
-
 			if (!process_shares_mm(p, mm))
 				continue;
 			if (fatal_signal_pending(p))
@@ -636,10 +634,7 @@ void try_oom_reaper(struct task_struct *
 			 * If the task is exiting make sure the whole thread group
 			 * is exiting and cannot acces mm anymore.
 			 */
-			spin_lock_irq(&p->sighand->siglock);
-			exiting = signal_group_exit(p->signal);
-			spin_unlock_irq(&p->sighand->siglock);
-			if (exiting)
+			if (signal_group_exit(p->signal))
 				continue;
 
 			/* Give up */
_

Patches currently in -mm which might be from mhocko@suse.com are

tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i.patch
x86-get-rid-of-superfluous-__gfp_repeat.patch
x86-efi-get-rid-of-superfluous-__gfp_repeat.patch
arm-get-rid-of-superfluous-__gfp_repeat.patch
arm64-get-rid-of-superfluous-__gfp_repeat.patch
arc-get-rid-of-superfluous-__gfp_repeat.patch
mips-get-rid-of-superfluous-__gfp_repeat.patch
nios2-get-rid-of-superfluous-__gfp_repeat.patch
parisc-get-rid-of-superfluous-__gfp_repeat.patch
score-get-rid-of-superfluous-__gfp_repeat.patch
powerpc-get-rid-of-superfluous-__gfp_repeat.patch
sparc-get-rid-of-superfluous-__gfp_repeat.patch
s390-get-rid-of-superfluous-__gfp_repeat.patch
sh-get-rid-of-superfluous-__gfp_repeat.patch
tile-get-rid-of-superfluous-__gfp_repeat.patch
unicore32-get-rid-of-superfluous-__gfp_repeat.patch
jbd2-get-rid-of-superfluous-__gfp_repeat.patch

