From: akpm@linux-foundation.org
Subject: + cgroup_freezer-fix-can_attach-to-prohibit-moving-from-to-freezing-frozen-cgroups.patch added to -mm tree
Date: Thu, 12 Aug 2010 12:32:32 -0700
Message-ID: <201008121932.o7CJWW90008583@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49628 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753158Ab0HLTco (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Aug 2010 15:32:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tomasz.buchert@inria.fr, lizf@cn.fujitsu.com, matthltc@us.ibm.com, menage@google.com


The patch titled
     cgroup_freezer: fix can_attach() to prohibit moving from/to freezing/frozen cgroups
has been added to the -mm tree.  Its filename is
     cgroup_freezer-fix-can_attach-to-prohibit-moving-from-to-freezing-frozen-cgroups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup_freezer: fix can_attach() to prohibit moving from/to freezing/frozen cgroups
From: Tomasz Buchert <tomasz.buchert@inria.fr>

It is possible to move a task from its cgroup even if this group is
'FREEZING'.  This results in a nasty bug - the moved task will become
frozen OUTSIDE its original cgroup and will remain in a permanent 'D'
state.

This patch allows to migrate the task only between THAWED cgroups.

This behavior was observed and easily reproduced on a single core laptop. 
Notice that reproducibility depends highly on the machine used.  Program
and instructions how to reproduce the bug can be fetched from:
http://pentium.hopto.org/~thinred/repos/linux-misc/freezer_bug.c

Signed-off-by: Tomasz Buchert <tomasz.buchert@inria.fr>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup_freezer.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN kernel/cgroup_freezer.c~cgroup_freezer-fix-can_attach-to-prohibit-moving-from-to-freezing-frozen-cgroups kernel/cgroup_freezer.c
--- a/kernel/cgroup_freezer.c~cgroup_freezer-fix-can_attach-to-prohibit-moving-from-to-freezing-frozen-cgroups
+++ a/kernel/cgroup_freezer.c
@@ -173,24 +173,25 @@ static int freezer_can_attach(struct cgr
 
 	/*
 	 * Anything frozen can't move or be moved to/from.
-	 *
-	 * Since orig_freezer->state == FROZEN means that @task has been
-	 * frozen, so it's sufficient to check the latter condition.
 	 */
 
-	if (is_task_frozen_enough(task))
+	freezer = cgroup_freezer(new_cgroup);
+	if (freezer->state != CGROUP_THAWED)
 		return -EBUSY;
 
-	freezer = cgroup_freezer(new_cgroup);
-	if (freezer->state == CGROUP_FROZEN)
+	rcu_read_lock();
+	if (__cgroup_freezing_or_frozen(task)) {
+		rcu_read_unlock();
 		return -EBUSY;
+	}
+	rcu_read_unlock();
 
 	if (threadgroup) {
 		struct task_struct *c;
 
 		rcu_read_lock();
 		list_for_each_entry_rcu(c, &task->thread_group, thread_group) {
-			if (is_task_frozen_enough(c)) {
+			if (__cgroup_freezing_or_frozen(c)) {
 				rcu_read_unlock();
 				return -EBUSY;
 			}
_

Patches currently in -mm which might be from tomasz.buchert@inria.fr are

cgroup_freezer-unnecessary-test-in-cgroup_freezing_or_frozen.patch
cgroup_freezer-fix-can_attach-to-prohibit-moving-from-to-freezing-frozen-cgroups.patch
cgroup_freezer-update_freezer_state-does-incorrect-state-transitions.patch

