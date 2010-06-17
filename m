From: akpm@linux-foundation.org
Subject: + cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix.patch added to -mm tree
Date: Wed, 16 Jun 2010 23:59:25 -0700
Message-ID: <201006170659.o5H6xJJk019459@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38195 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754801Ab0FQG7c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jun 2010 02:59:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, arjan@infradead.org, jslaby@suse.cz, len.brown@intel.com, maximlevitsky@gmail.com, pavel@ucw.cz, rjw@sisk.pl, sergey.senozhatsky@gmail.com


The patch titled
     cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix
has been added to the -mm tree.  Its filename is
     cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix.patch

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
Subject: cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix
From: Andrew Morton <akpm@linux-foundation.org>

optimise tick_cpu_sched.cpu initialisation

Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Len Brown <len.brown@intel.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tick.h      |    1 +
 kernel/time/tick-common.c |    1 +
 kernel/time/tick-sched.c  |   11 ++++++++---
 3 files changed, 10 insertions(+), 3 deletions(-)

diff -puN include/linux/tick.h~cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix include/linux/tick.h
--- a/include/linux/tick.h~cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix
+++ a/include/linux/tick.h
@@ -71,6 +71,7 @@ struct tick_sched {
 };
 
 extern void __init tick_init(void);
+extern void __init tick_sched_init(void);
 extern int tick_is_oneshot_available(void);
 extern struct tick_device *tick_get_device(int cpu);
 
diff -puN kernel/time/tick-common.c~cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix kernel/time/tick-common.c
--- a/kernel/time/tick-common.c~cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix
+++ a/kernel/time/tick-common.c
@@ -413,4 +413,5 @@ static struct notifier_block tick_notifi
 void __init tick_init(void)
 {
 	clockevents_register_notifier(&tick_notifier);
+	tick_sched_init();
 }
diff -puN kernel/time/tick-sched.c~cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix
+++ a/kernel/time/tick-sched.c
@@ -38,9 +38,6 @@ static ktime_t last_jiffies_update;
 
 struct tick_sched *tick_get_tick_sched(int cpu)
 {
-	/*FIXME: Arjan van de Ven:
-	 can we do this bit once, when the ts structure gets initialized?*/
-	per_cpu(tick_cpu_sched, cpu).cpu = cpu;
 	return &per_cpu(tick_cpu_sched, cpu);
 }
 
@@ -880,3 +877,11 @@ int tick_check_oneshot_change(int allow_
 	tick_nohz_switch_to_nohz();
 	return 0;
 }
+
+void __init tick_sched_init(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		per_cpu(tick_cpu_sched, cpu).cpu = cpu;
+}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
x86-cpufreq-make-trace_power_frequency-cpufreq-driver-independent-fix.patch
x86-olpc-add-support-for-calling-into-openfirmware-fix-fix.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
dib3000mc-reduce-large-stack-usage-fix.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
3x59x-fix-pci-resource-management.patch
altera_uart-simplify-altera_uart_console_putc-checkpatch-fixes.patch
serial-mcf-dont-take-spinlocks-in-already-protected-functions-fix.patch
scsi-remove-private-bit-macros.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
mm.patch
tmpfs-quick-token-library-to-allow-scalable-retrieval-of-tokens-from-token-jar.patch
mm-vmap-area-cache-fix.patch
mm-track-the-root-oldest-anon_vma-fix.patch
oom-improve-commentary-in-dump_tasks.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-protect-dereferencing-of-tasks-comm.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
include-linux-compiler-gcch-use-__same_type-in-__must_be_array.patch
mmc-recognize-csd-structure-fix.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-fix.patch
fix-vc-vc_origin-on-take_over_console-checkpatch-fixes.patch
rtc-fixes-and-new-functionality-for-fm3130-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch

