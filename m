From: akpm@linux-foundation.org
Subject: - posix-timers-rcu-optimization-for-clock_gettime.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:15:44 -0800
Message-ID: <200702170715.l1H7FioE021659@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51315 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946579AbXBQHTp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:19:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulmck@linux.vnet.ibm.com, johnstul@us.ibm.com, mingo@elte.hu, oleg@tv-sign.ru, tglx@linutronix.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     posix timers: RCU optimization for clock_gettime()
has been removed from the -mm tree.  Its filename was
     posix-timers-rcu-optimization-for-clock_gettime.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: posix timers: RCU optimization for clock_gettime()
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Use RCU to avoid the need to acquire tasklist_lock in the single-threaded
case of clock_gettime().  It still acquires tasklist_lock when for a
(potentially multithreaded) process.  This change allows realtime
applications to frequently monitor CPU consumption of individual tasks, as
requested (and now deployed) by some off-list users.

This has been in Ingo Molnar's -rt patchset since late 2005 with no
problems reported, and tests successfully on 2.6.20-rc6, so I believe that
it is long-since ready for mainline adoption.

[paulmck@linux.vnet.ibm.com: fix exit()/posix_cpu_clock_get() race spotted by Oleg]
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-cpu-timers.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN kernel/posix-cpu-timers.c~posix-timers-rcu-optimization-for-clock_gettime kernel/posix-cpu-timers.c
--- a/kernel/posix-cpu-timers.c~posix-timers-rcu-optimization-for-clock_gettime
+++ a/kernel/posix-cpu-timers.c
@@ -304,7 +304,7 @@ int posix_cpu_clock_get(const clockid_t 
 		 * should be able to see it.
 		 */
 		struct task_struct *p;
-		read_lock(&tasklist_lock);
+		rcu_read_lock();
 		p = find_task_by_pid(pid);
 		if (p) {
 			if (CPUCLOCK_PERTHREAD(which_clock)) {
@@ -312,12 +312,17 @@ int posix_cpu_clock_get(const clockid_t 
 					error = cpu_clock_sample(which_clock,
 								 p, &rtn);
 				}
-			} else if (p->tgid == pid && p->signal) {
-				error = cpu_clock_sample_group(which_clock,
-							       p, &rtn);
+			} else {
+				read_lock(&tasklist_lock);
+				if (p->tgid == pid && p->signal) {
+					error =
+					    cpu_clock_sample_group(which_clock,
+							           p, &rtn);
+				}
+				read_unlock(&tasklist_lock);
 			}
 		}
-		read_unlock(&tasklist_lock);
+		rcu_read_unlock();
 	}
 
 	if (error)
_

Patches currently in -mm which might be from paulmck@linux.vnet.ibm.com are

origin.patch
git-block.patch
