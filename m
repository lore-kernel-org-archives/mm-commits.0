From: akpm@linux-foundation.org
Subject: [alternative-merged] ioprio-rcu_read_lock-unlock-protect-find_task_by_vpid-call-v2.patch removed from -mm tree
Date: Thu, 25 Nov 2010 08:16:41 -0800
Message-ID: <201011251621.oAPGL6JZ023919@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41214 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752478Ab0KYQVP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Nov 2010 11:21:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, axboe@kernel.dk, paulmck@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ioprio: rcu_read_lock/unlock protect find_task_by_vpid call (V2)
has been removed from the -mm tree.  Its filename was
     ioprio-rcu_read_lock-unlock-protect-find_task_by_vpid-call-v2.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ioprio: rcu_read_lock/unlock protect find_task_by_vpid call (V2)
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Commit 4221a9918e38b7494cee341dda7b7b4bb8c04bde ("Add RCU check for
find_task_by_vpid()") introduced rcu_lockdep_assert to
find_task_by_pid_ns.  Assertion failed in sys_ioprio_get.  The patch is
fixing assertion failure in ioprio_set as well.

 kernel/pid.c:419 invoked rcu_dereference_check() without protection!

 stack backtrace:
 Pid: 4254, comm: iotop Not tainted
 Call Trace:
 [<ffffffff810656f2>] lockdep_rcu_dereference+0xaa/0xb2
 [<ffffffff81053c67>] find_task_by_pid_ns+0x4f/0x68
 [<ffffffff81053c9d>] find_task_by_vpid+0x1d/0x1f
 [<ffffffff811104e2>] sys_ioprio_get+0x50/0x2da
 [<ffffffff81002182>] system_call_fastpath+0x16/0x1b

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ioprio.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/ioprio.c~ioprio-rcu_read_lock-unlock-protect-find_task_by_vpid-call-v2 fs/ioprio.c
--- a/fs/ioprio.c~ioprio-rcu_read_lock-unlock-protect-find_task_by_vpid-call-v2
+++ a/fs/ioprio.c
@@ -106,12 +106,14 @@ SYSCALL_DEFINE3(ioprio_set, int, which, 
 	rcu_read_lock();
 	switch (which) {
 		case IOPRIO_WHO_PROCESS:
+			rcu_read_lock();
 			if (!who)
 				p = current;
 			else
 				p = find_task_by_vpid(who);
 			if (p)
 				ret = set_task_ioprio(p, ioprio);
+			rcu_read_unlock();
 			break;
 		case IOPRIO_WHO_PGRP:
 			if (!who)
@@ -195,12 +197,14 @@ SYSCALL_DEFINE2(ioprio_get, int, which, 
 	rcu_read_lock();
 	switch (which) {
 		case IOPRIO_WHO_PROCESS:
+			rcu_read_lock();
 			if (!who)
 				p = current;
 			else
 				p = find_task_by_vpid(who);
 			if (p)
 				ret = get_task_ioprio(p);
+			rcu_read_unlock();
 			break;
 		case IOPRIO_WHO_PGRP:
 			if (!who)
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

linux-next.patch

