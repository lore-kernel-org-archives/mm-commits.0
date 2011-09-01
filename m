From: akpm@linux-foundation.org
Subject: + cgroups-more-safe-tasklist-locking-in-cgroup_attach_proc.patch added to -mm tree
Date: Thu, 01 Sep 2011 14:08:32 -0700
Message-ID: <201109012108.p81L8X0b029484@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59108 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757996Ab1IAVJM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Sep 2011 17:09:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bblum@andrew.cmu.edu, fweisbec@gmail.com, neilb@suse.de, oleg@redhat.com, paul@paulmenage.org, paulmck@linux.vnet.ibm.com


The patch titled
     cgroups: more safe tasklist locking in cgroup_attach_proc
has been added to the -mm tree.  Its filename is
     cgroups-more-safe-tasklist-locking-in-cgroup_attach_proc.patch

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
Subject: cgroups: more safe tasklist locking in cgroup_attach_proc
From: Ben Blum <bblum@andrew.cmu.edu>

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

cgroups-more-safe-tasklist-locking-in-cgroup_attach_proc.patch
cgroups-fix-ordering-of-calls-in-cgroup_attach_proc.patch

