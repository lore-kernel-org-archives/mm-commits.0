From: akpm@osdl.org
Subject: - round_jiffies-infrastructure-fix.patch removed from -mm tree
Date: Sun, 10 Dec 2006 00:30:31 -0800
Message-ID: <200612100830.kBA8UV2o018945@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33537 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760390AbWLJIan (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 03:30:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, arjan@linux.intel.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     round_jiffies-infrastructure-fix
has been removed from the -mm tree.  Its filename was
     round_jiffies-infrastructure-fix.patch

This patch was dropped because it was folded into round_jiffies-infrastructure.patch

------------------------------------------------------
Subject: round_jiffies-infrastructure-fix
From: Andrew Morton <akpm@osdl.org>

That would have caused much unpleasantness...

Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/timer.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/timer.c~round_jiffies-infrastructure-fix kernel/timer.c
--- a/kernel/timer.c~round_jiffies-infrastructure-fix
+++ a/kernel/timer.c
@@ -104,7 +104,7 @@ static DEFINE_PER_CPU(tvec_base_t *, tve
 unsigned long __round_jiffies(unsigned long j, int cpu)
 {
 	int rem;
-	int original  = j;
+	unsigned long original = j;
 
 	/*
 	 * We don't want all cpus firing their timers at once hitting the
@@ -213,7 +213,6 @@ unsigned long round_jiffies_relative(uns
 EXPORT_SYMBOL_GPL(round_jiffies_relative);
 
 
-
 static inline void set_running_timer(tvec_base_t *base,
 					struct timer_list *timer)
 {
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
round_jiffies-infrastructure-fix.patch
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

