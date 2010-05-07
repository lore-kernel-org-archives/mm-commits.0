From: akpm@linux-foundation.org
Subject: [merged] cgroup-check-task_lock-in-task_subsys_state.patch removed from -mm tree
Date: Fri, 07 May 2010 12:11:51 -0400
Message-ID: <201005071913.o47JDLn8006609@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757707Ab0EGTNm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 May 2010 15:13:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, matthltc@us.ibm.com, menage@google.com, paulmck@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     cgroup: check task_lock in task_subsys_state()
has been removed from the -mm tree.  Its filename was
     cgroup-check-task_lock-in-task_subsys_state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup: check task_lock in task_subsys_state()
From: Li Zefan <lizf@cn.fujitsu.com>

task_subsys_state() is safe under task_lock().  See
Documentation/cgroups/cgroups.txt for locking rule.

This fixes an RCU warning when resume from suspend.  The warning comes
from freezer cgroup in cgroup_freezing_or_frozen().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Matt Helsley <matthltc@us.ibm.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/cgroup.h~cgroup-check-task_lock-in-task_subsys_state include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroup-check-task_lock-in-task_subsys_state
+++ a/include/linux/cgroup.h
@@ -530,6 +530,7 @@ static inline struct cgroup_subsys_state
 {
 	return rcu_dereference_check(task->cgroups->subsys[subsys_id],
 				     rcu_read_lock_held() ||
+				     lockdep_is_held(&task->alloc_lock) ||
 				     cgroup_lock_is_held());
 }
 
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch
memcg-make-oom-killer-a-no-op-when-no-killable-task-can-be-found.patch

