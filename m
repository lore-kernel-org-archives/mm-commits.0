From: akpm@linux-foundation.org
Subject: + cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems-fix2.patch added to -mm tree
Date: Wed, 12 May 2010 00:27:56 -0400
Message-ID: <201005120729.o4C7TOYe016173@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49524 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752580Ab0ELHaA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 May 2010 03:30:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: miaox@cn.fujitsu.com, andi@firstfloor.org, cl@linux-foundation.org, hugh.dickins@tiscali.co.uk, kiran@scalex86.org, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, menage@google.com, npiggin@suse.de, rientjes@google.com


The patch titled
     cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems-fix2
has been added to the -mm tree.  Its filename is
     cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems-fix2.patch

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
Subject: cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems-fix2
From: Miao Xie <miaox@cn.fujitsu.com>

- cleanup unnecessary header file
- fix the race between set_mempolicy() and cpuset_change_task_nodemask()

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Paul Menage <menage@google.com>
Cc: Ravikiran Thirumalai <kiran@scalex86.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    3 +--
 kernel/exit.c   |    1 -
 kernel/fork.c   |    1 -
 3 files changed, 1 insertion(+), 4 deletions(-)

diff -puN kernel/cpuset.c~cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems-fix2 kernel/cpuset.c
--- a/kernel/cpuset.c~cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems-fix2
+++ a/kernel/cpuset.c
@@ -963,7 +963,6 @@ repeat:
 	task_lock(tsk);
 	nodes_or(tsk->mems_allowed, tsk->mems_allowed, *newmems);
 	mpol_rebind_task(tsk, newmems, MPOL_REBIND_STEP1);
-	task_unlock(tsk);
 
 
 	/*
@@ -985,6 +984,7 @@ repeat:
 	 * for the read-side.
 	 */
 	while (ACCESS_ONCE(tsk->mems_allowed_change_disable)) {
+		task_unlock(tsk);
 		if (!task_curr(tsk))
 			yield();
 		goto repeat;
@@ -999,7 +999,6 @@ repeat:
 	 */
 	smp_mb();
 
-	task_lock(tsk);
 	mpol_rebind_task(tsk, newmems, MPOL_REBIND_STEP2);
 	tsk->mems_allowed = *newmems;
 	task_unlock(tsk);
diff -puN kernel/exit.c~cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems-fix2 kernel/exit.c
--- a/kernel/exit.c~cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems-fix2
+++ a/kernel/exit.c
@@ -16,7 +16,6 @@
 #include <linux/key.h>
 #include <linux/security.h>
 #include <linux/cpu.h>
-#include <linux/cpuset.h>
 #include <linux/acct.h>
 #include <linux/tsacct_kern.h>
 #include <linux/file.h>
diff -puN kernel/fork.c~cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems-fix2 kernel/fork.c
--- a/kernel/fork.c~cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems-fix2
+++ a/kernel/fork.c
@@ -31,7 +31,6 @@
 #include <linux/nsproxy.h>
 #include <linux/capability.h>
 #include <linux/cpu.h>
-#include <linux/cpuset.h>
 #include <linux/cgroup.h>
 #include <linux/security.h>
 #include <linux/hugetlb.h>
_

Patches currently in -mm which might be from miaox@cn.fujitsu.com are

mempolicy-restructure-rebinding-mempolicy-functions.patch
cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems.patch
cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems-fix.patch
cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems-fix2.patch
cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems-spelling.patch

