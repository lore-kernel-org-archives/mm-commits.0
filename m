From: akpm@linux-foundation.org
Subject: + cgroup-check-task_lock-in-task_subsys_state.patch added to -mm tree
Date: Mon, 26 Apr 2010 12:15:30 -0700
Message-ID: <201004261915.o3QJFUBP014170@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752589Ab0DZTQK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Apr 2010 15:16:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, matthltc@us.ibm.com, menage@google.com, paulmck@linux.vnet.ibm.com


The patch titled
     cgroup: check task_lock in task_subsys_state()
has been added to the -mm tree.  Its filename is
     cgroup-check-task_lock-in-task_subsys_state.patch

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
cgroup-check-task_lock-in-task_subsys_state.patch
memcg-rcu-lock-fix-v3.patch

