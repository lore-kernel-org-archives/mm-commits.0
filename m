From: akpm@linux-foundation.org
Subject: [merged] cgroups-more-safe-tasklist-locking-in-cgroup_attach_proc.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:26:33 -0800
Message-ID: <201111072026.pA7KQXDa022554@wpaz21.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:5300 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab1KGU1A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:27:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bblum@andrew.cmu.edu, fweisbec@gmail.com, neilb@suse.de, oleg@redhat.com, paul@paulmenage.org, paulmck@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cgroups: more safe tasklist locking in cgroup_attach_proc
has been removed from the -mm tree.  Its filename was
     cgroups-more-safe-tasklist-locking-in-cgroup_attach_proc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Ben Blum <bblum@andrew.cmu.edu>
Subject: cgroups: more safe tasklist locking in cgroup_attach_proc

Fix unstable tasklist locking in cgroup_attach_proc.

According to this thread - https://lkml.org/lkml/2011/7/27/243 - RCU is
not sufficient to guarantee the tasklist is stable w.r.t.  de_thread and
exit.  Taking tasklist_lock for reading, instead of rcu_read_lock, ensures
proper exclusion.

Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>
Acked-by: Paul Menage <paul@paulmenage.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/cgroup.c~cgroups-more-safe-tasklist-locking-in-cgroup_attach_proc kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-more-safe-tasklist-locking-in-cgroup_attach_proc
+++ a/kernel/cgroup.c
@@ -2027,7 +2027,7 @@ int cgroup_attach_proc(struct cgroup *cg
 		goto out_free_group_list;
 
 	/* prevent changes to the threadgroup list while we take a snapshot. */
-	rcu_read_lock();
+	read_lock(&tasklist_lock);
 	if (!thread_group_leader(leader)) {
 		/*
 		 * a race with de_thread from another thread's exec() may strip
@@ -2036,7 +2036,7 @@ int cgroup_attach_proc(struct cgroup *cg
 		 * throw this task away and try again (from cgroup_procs_write);
 		 * this is "double-double-toil-and-trouble-check locking".
 		 */
-		rcu_read_unlock();
+		read_unlock(&tasklist_lock);
 		retval = -EAGAIN;
 		goto out_free_group_list;
 	}
@@ -2057,7 +2057,7 @@ int cgroup_attach_proc(struct cgroup *cg
 	} while_each_thread(leader, tsk);
 	/* remember the number of threads in the array for later. */
 	group_size = i;
-	rcu_read_unlock();
+	read_unlock(&tasklist_lock);
 
 	/*
 	 * step 1: check that we can legitimately attach to the cgroup.
_

Patches currently in -mm which might be from bblum@andrew.cmu.edu are

origin.patch

