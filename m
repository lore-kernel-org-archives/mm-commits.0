From: akpm@osdl.org
Subject: - clocksource-small-cleanup-2-fix.patch removed from -mm tree
Date: Sun, 10 Dec 2006 00:32:11 -0800
Message-ID: <200612100832.kBA8WBVj018981@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33691 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760491AbWLJIct (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 03:32:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, dwalker@mvista.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     clocksource-small-cleanup-2-fix
has been removed from the -mm tree.  Its filename was
     clocksource-small-cleanup-2-fix.patch

This patch was dropped because it was folded into clocksource-small-cleanup-2.patch

------------------------------------------------------
Subject: clocksource-small-cleanup-2-fix
From: Andrew Morton <akpm@osdl.org>

kernel/timer.c: In function `update_wall_time':
kernel/timer.c:1207: error: syntax error before "do"
kernel/timer.c: At top level:
kernel/timer.c:1210: warning: type defaults to `int' in declaration of `hrtimer_clock_notify'
kernel/timer.c:1210: warning: function declaration isn't a prototype
kernel/timer.c:1210: error: conflicting types for 'hrtimer_clock_notify'
include/linux/hrtimer.h:261: error: previous definition of 'hrtimer_clock_notify' was here
kernel/timer.c:1210: warning: data definition has no type or storage class
kernel/timer.c:1211: warning: type defaults to `int' in declaration of `clocksource_calculate_interval'
kernel/timer.c:1211: warning: parameter names (without types) in function declaration
kernel/timer.c:1211: error: conflicting types for 'clocksource_calculate_interval'
include/linux/clocksource.h:163: error: previous definition of 'clocksource_calculate_interval' was here
kernel/timer.c:1211: warning: data definition has no type or storage class
kernel/timer.c:1212: error: syntax error before '}' token

Cc: Daniel Walker <dwalker@mvista.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/timer.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN kernel/timer.c~clocksource-small-cleanup-2-fix kernel/timer.c
--- a/kernel/timer.c~clocksource-small-cleanup-2-fix
+++ a/kernel/timer.c
@@ -923,7 +923,10 @@ static int change_clocksource(void)
 	return 0;
 }
 #else
-#define change_clocksource()	do { 0; } while(0)
+static inline int change_clocksource(void)
+{
+	return 0;
+}
 #endif
 
 /**
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
submit-checklist-update.patch
io-accounting-core-statistics.patch
clean-up-__set_page_dirty_nobuffers.patch
io-accounting-write-accounting.patch
io-accounting-write-cancel-accounting.patch
io-accounting-read-accounting-2.patch
io-accounting-read-accounting-nfs-fix.patch
io-accounting-read-accounting-cifs-fix.patch
io-accounting-direct-io.patch
io-accounting-report-in-procfs.patch
cleanup-taskstatsh.patch
io-accounting-via-taskstats.patch
getdelays-various-fixes.patch
io-accounting-add-to-getdelays.patch
sched-add-option-to-serialize-load-balancing.patch
kernel-schedc-whitespace-cleanups.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure.patch
round_jiffies-infrastructure.patch
clocksource-small-cleanup-2.patch
clocksource-small-cleanup-2-fix.patch
kvm-userspace-interface.patch
slim-main-include-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
kmap_atomic-debugging.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch

