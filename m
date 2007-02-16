From: akpm@linux-foundation.org
Subject: - posix-timers-rcu-optimization-for-clock_gettime-fix.patch removed from -mm tree
Date: Fri, 16 Feb 2007 00:23:19 -0800
Message-ID: <200702160823.l1G8NKum024434@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59830 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966207AbXBPIXu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 03:23:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulmck@linux.vnet.ibm.com, johnstul@us.ibm.com, mingo@elte.hu, oleg@tv-sign.ru, tglx@linutronix.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     POSIX timers RCU optimization fix for clock_gettime
has been removed from the -mm tree.  Its filename was
     posix-timers-rcu-optimization-for-clock_gettime-fix.patch

This patch was dropped because it was folded into posix-timers-rcu-optimization-for-clock_gettime.patch

------------------------------------------------------
Subject: POSIX timers RCU optimization fix for clock_gettime
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Fixes an exit()/posix_cpu_clock_get() race spotted by Oleg Nesterov. 
Solution is to move the p->signal check under the tasklist_lock.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-cpu-timers.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff -puN kernel/posix-cpu-timers.c~posix-timers-rcu-optimization-for-clock_gettime-fix kernel/posix-cpu-timers.c
--- a/kernel/posix-cpu-timers.c~posix-timers-rcu-optimization-for-clock_gettime-fix
+++ a/kernel/posix-cpu-timers.c
@@ -312,10 +312,13 @@ int posix_cpu_clock_get(const clockid_t 
 					error = cpu_clock_sample(which_clock,
 								 p, &rtn);
 				}
-			} else if (p->tgid == pid && p->signal) {
+			} else {
 				read_lock(&tasklist_lock);
-				error = cpu_clock_sample_group(which_clock,
-							       p, &rtn);
+				if (p->tgid == pid && p->signal) {
+					error =
+					    cpu_clock_sample_group(which_clock,
+							           p, &rtn);
+				}
 				read_unlock(&tasklist_lock);
 			}
 		}
_

Patches currently in -mm which might be from paulmck@linux.vnet.ibm.com are

origin.patch
posix-timers-rcu-optimization-for-clock_gettime.patch
posix-timers-rcu-optimization-for-clock_gettime-fix.patch
