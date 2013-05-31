From: akpm@linux-foundation.org
Subject: [nacked]
 kernel-sysc-remove-unnecessary-parameter-of-set_one_prio.patch removed from -mm tree
Date: Fri, 31 May 2013 16:08:30 -0700
Message-ID: <51a92d6e.0NBBjoKgl0sK9bFA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41159 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756836Ab3EaXIb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 May 2013 19:08:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, lig.fnst@cn.fujitsu.com

Subject: [nacked] kernel-sysc-remove-unnecessary-parameter-of-set_one_prio.patch removed from -mm tree
To: lig.fnst@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 31 May 2013 16:08:30 -0700


The patch titled
     Subject: kernel/sys.c: remove unnecessary parameter of set_one_prio()
has been removed from the -mm tree.  Its filename was
     kernel-sysc-remove-unnecessary-parameter-of-set_one_prio.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: liguang <lig.fnst@cn.fujitsu.com>
Subject: kernel/sys.c: remove unnecessary parameter of set_one_prio()

[akpm@linux-foundation.org: clean up definitions, remove unneeded assignment]
Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN kernel/sys.c~kernel-sysc-remove-unnecessary-parameter-of-set_one_prio kernel/sys.c
--- a/kernel/sys.c~kernel-sysc-remove-unnecessary-parameter-of-set_one_prio
+++ a/kernel/sys.c
@@ -151,9 +151,10 @@ static bool set_one_prio_perm(struct tas
  * set the priority of a task
  * - the caller must hold the RCU read lock
  */
-static int set_one_prio(struct task_struct *p, int niceval, int error)
+static int set_one_prio(struct task_struct *p, int niceval)
 {
 	int no_nice;
+	int error = 0;
 
 	if (!set_one_prio_perm(p)) {
 		error = -EPERM;
@@ -168,8 +169,6 @@ static int set_one_prio(struct task_stru
 		error = no_nice;
 		goto out;
 	}
-	if (error == -ESRCH)
-		error = 0;
 	set_user_nice(p, niceval);
 out:
 	return error;
@@ -188,7 +187,6 @@ SYSCALL_DEFINE3(setpriority, int, which,
 		goto out;
 
 	/* normalize: avoid signed division (rounding problems) */
-	error = -ESRCH;
 	if (niceval < -20)
 		niceval = -20;
 	if (niceval > 19)
@@ -203,7 +201,7 @@ SYSCALL_DEFINE3(setpriority, int, which,
 			else
 				p = current;
 			if (p)
-				error = set_one_prio(p, niceval, error);
+				error = set_one_prio(p, niceval);
 			break;
 		case PRIO_PGRP:
 			if (who)
@@ -211,7 +209,7 @@ SYSCALL_DEFINE3(setpriority, int, which,
 			else
 				pgrp = task_pgrp(current);
 			do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
-				error = set_one_prio(p, niceval, error);
+				error = set_one_prio(p, niceval);
 			} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
 			break;
 		case PRIO_USER:
@@ -225,7 +223,7 @@ SYSCALL_DEFINE3(setpriority, int, which,
 
 			do_each_thread(g, p) {
 				if (uid_eq(task_uid(p), uid))
-					error = set_one_prio(p, niceval, error);
+					error = set_one_prio(p, niceval);
 			} while_each_thread(g, p);
 			if (!uid_eq(uid, cred->uid))
 				free_uid(user);		/* For find_user() */
_

Patches currently in -mm which might be from lig.fnst@cn.fujitsu.com are

kernel-sysc-sys_reboot-fix-malformed-panic-message.patch

