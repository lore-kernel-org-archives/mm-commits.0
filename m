From: akpm@linux-foundation.org
Subject: - uml-virtualized-time-fix.patch removed from -mm tree
Date: Mon, 07 May 2007 17:07:44 -0700
Message-ID: <200705080007.l4807il5009314@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967421AbXEHAIG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:08:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: virtualized time fix
has been removed from the -mm tree.  Its filename was
     uml-virtualized-time-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: virtualized time fix
From: Jeff Dike <jdike@addtoit.com>

With the current timekeeping, !CONFIG_UML_REAL_TIME_CLOCK has
inconsistent behavior.  Previously, gettimeofday could be (and was)
isolated from the clock ticking.  Now, it's not, so when
CONFIG_UML_REAL_TIME_CLOCK is disabled, gettimeofday must progress in
lockstep with the clock, making it fully virtual.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/time.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN arch/um/kernel/time.c~uml-virtualized-time-fix arch/um/kernel/time.c
--- a/arch/um/kernel/time.c~uml-virtualized-time-fix
+++ a/arch/um/kernel/time.c
@@ -34,8 +34,8 @@ unsigned long long sched_clock(void)
 	return (unsigned long long)jiffies_64 * (1000000000 / HZ);
 }
 
-static unsigned long long prev_nsecs[NR_CPUS];
 #ifdef CONFIG_UML_REAL_TIME_CLOCK
+static unsigned long long prev_nsecs[NR_CPUS];
 static long long delta[NR_CPUS];		/* Deviation per interval */
 #endif
 
@@ -94,7 +94,12 @@ irqreturn_t um_timer(int irq, void *dev)
 
 	do_timer(1);
 
+#ifdef CONFIG_UML_REAL_TIME_CLOCK
 	nsecs = get_time();
+#else
+	nsecs = (unsigned long long) xtime.tv_sec * BILLION + xtime.tv_nsec +
+		BILLION / HZ;
+#endif
 	xtime.tv_sec = nsecs / NSEC_PER_SEC;
 	xtime.tv_nsec = nsecs - xtime.tv_sec * NSEC_PER_SEC;
 
@@ -127,13 +132,18 @@ void time_init(void)
 	nsecs = os_nsecs();
 	set_normalized_timespec(&wall_to_monotonic, -nsecs / BILLION,
 				-nsecs % BILLION);
+	set_normalized_timespec(&xtime, nsecs / BILLION, nsecs % BILLION);
 	late_time_init = register_timer;
 }
 
 void do_gettimeofday(struct timeval *tv)
 {
+#ifdef CONFIG_UML_REAL_TIME_CLOCK
 	unsigned long long nsecs = get_time();
-
+#else
+	unsigned long long nsecs = (unsigned long long) xtime.tv_sec * BILLION +
+		xtime.tv_nsec;
+#endif
 	tv->tv_sec = nsecs / NSEC_PER_SEC;
 	/* Careful about calculations here - this was originally done as
 	 * (nsecs - tv->tv_sec * NSEC_PER_SEC) / NSEC_PER_USEC
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-hostfs-style-fixes.patch
uml-an-idle-system-should-have-zero-load-average.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch
