From: akpm@linux-foundation.org
Subject: + isdn-fix-stack-corruption-in-isdnloop_init.patch added to -mm tree
Date: Thu, 03 Sep 2009 17:15:38 -0700
Message-ID: <200909040015.n840Fdh6005672@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932548AbZIDARm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Sep 2009 20:17:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, arjan@infradead.org, davem@davemloft.net, isdn@linux-pingi.de, stable@kernel.org, tj@kernel.org


The patch titled
     isdn: fix stack corruption in isdnloop_init()
has been added to the -mm tree.  Its filename is
     isdn-fix-stack-corruption-in-isdnloop_init.patch

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
Subject: isdn: fix stack corruption in isdnloop_init()
From: Ingo Molnar <mingo@elte.hu>

-tip testing found this stack corruption and bootup crash
in the ISDN subsystem, reported by stackprotector:

[   25.656688] calling  isdn_init+0x0/0x2c2 @ 1
[   25.660388] ISDN subsystem Rev: 1.1.2.3/1.1.2.3/1.1.2.2/1.1.2.3/1.1.2.2/1.1.2.2
[   25.668179] initcall isdn_init+0x0/0x2c2 returned 0 after 6510 usecs
[   25.670005] calling  isdn_bsdcomp_init+0x0/0x45 @ 1
[   25.673336] PPP BSD Compression module registered
[   25.676674] initcall isdn_bsdcomp_init+0x0/0x45 returned 0 after 3255 usecs
[   25.680005] calling  isdnloop_init+0x0/0x88 @ 1
[   25.683337] isdnloop-ISDN-driver Rev 1.11.6.7
[   25.686705] isdnloop: (loop0) virtual card added
[   25.690004] Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: c1de2d8b
[   25.690006]
[   25.693338] Pid: 1, comm: swapper Not tainted 2.6.31-rc8-tip-01250-geed031c-dirty #9565
[   25.696672] Call Trace:
[   25.700008]  [<c190f517>] ? printk+0x1d/0x30
[   25.703339]  [<c190f45d>] panic+0x50/0xed
[   25.706677]  [<c1059194>] __stack_chk_fail+0x1e/0x42
[   25.710005]  [<c1de2d8b>] ? isdnloop_init+0x83/0x88
[   25.713338]  [<c1de2d8b>] isdnloop_init+0x83/0x88
[   25.716674]  [<c1001056>] _stext+0x56/0x15a
[   25.720007]  [<c1da8368>] kernel_init+0x8f/0xf1
[   25.723338]  [<c1da82d9>] ? kernel_init+0x0/0xf1
[   25.726675]  [<c1025c67>] kernel_thread_helper+0x7/0x58
[   25.730005] Rebooting in 1 seconds..Press any key to enter the menu

The bug is that the temporary array:

	char rev[10];

Is sized one byte too small to store strings based on the 'revision'
string.

This is a truly ancient bug: it has been introduced in the v2.4.2.1
kernel, ~8.5 years ago, which extended the length of 'revision' by 1 byte.

Instead of using a fixed size temporary array, size it based on the
'revision' string.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/isdnloop/isdnloop.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/isdn/isdnloop/isdnloop.c~isdn-fix-stack-corruption-in-isdnloop_init drivers/isdn/isdnloop/isdnloop.c
--- a/drivers/isdn/isdnloop/isdnloop.c~isdn-fix-stack-corruption-in-isdnloop_init
+++ a/drivers/isdn/isdnloop/isdnloop.c
@@ -15,7 +15,7 @@
 #include <linux/sched.h>
 #include "isdnloop.h"
 
-static char *revision = "$Revision: 1.11.6.7 $";
+static char revision[] = "$Revision: 1.11.6.7 $";
 static char *isdnloop_id = "loop0";
 
 MODULE_DESCRIPTION("ISDN4Linux: Pseudo Driver that simulates an ISDN card");
@@ -1494,7 +1494,7 @@ static int __init
 isdnloop_init(void)
 {
 	char *p;
-	char rev[10];
+	char rev[sizeof(revision)];
 
 	if ((p = strchr(revision, ':'))) {
 		strcpy(rev, p + 1);
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
isdn-fix-stack-corruption-in-isdnloop_init.patch
linux-next.patch
kernel-core-add-smp_call_function_any.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
genirq-switch-proc-irq-spurious-to-seq_file.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
spinlocks-check-spinlock_t-rwlock_t-argument-type-on-non-smp-builds.patch
spinlocks-check-spinlock_t-rwlock_t-argument-type-on-non-smp-builds-v3.patch
waitqueues-give-waitqueue-spinlocks-their-own-lockdep-classes-checkpatch-fixes.patch
kernel-profilec-switch-proc-irq-prof_cpu_mask-to-seq_file.patch
libfs-make-simple_read_from_buffer-conventional.patch
fs-fix-overflow-in-sys_mount-for-in-kernel-calls.patch
x86-_end-symbol-missing-from-symbolmap.patch
arches-drop-superfluous-casts-in-nr_free_pages-callers.patch
tracing-page-allocator-add-trace-events-for-page-allocation-and-page-freeing.patch
tracing-page-allocator-add-trace-events-for-anti-fragmentation-falling-back-to-other-migratetypes.patch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists.patch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists-fix.patch
tracing-page-allocator-add-a-postprocessing-script-for-page-allocator-related-ftrace-events.patch
tracing-documentation-add-a-document-describing-how-to-do-some-performance-analysis-with-tracepoints.patch
tracing-documentation-add-a-document-on-the-kmem-tracepoints.patch
mm-replace-various-uses-of-num_physpages-by-totalram_pages.patch
mm-dont-use-alloc_bootmem_low-where-not-strictly-needed.patch
mm-also-use-alloc_large_system_hash-for-the-pid-hash-table.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix-2.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch
generic-ipi-make-struct-call_function_data-lockless.patch
generic-ipi-make-struct-call_function_data-lockless-cleanup.patch
generic-ipi-cleanup-for-generic_smp_call_function_interrupt.patch
kernel-smpc-relocate-some-code.patch
generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd.patch
generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd-fix.patch
asm-sections-add-text-data-checking-functions-for-arches-to-override.patch
kallsyms-use-new-arch_is_kernel_text.patch
lockdep-use-new-arch_is_kernel_data.patch
blackfin-override-text-data-checking-functions.patch
procfs-provide-stack-information-for-threads-v08.patch
procfs-provide-stack-information-for-threads-v011.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
kprobes-use-do_irq-in-lkdtm.patch
time-add-function-to-convert-between-calendar-time-and-broken-down-time-for-universal-use.patch
fatfs-use-common-time_to_tm-in-fat_time_unix2fat.patch
cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time.patch
cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time-fix.patch
do_wait-wakeup-optimization-shift-security_task_wait-from-eligible_child-to-wait_consider_task.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup-selinux_bprm_committed_creds-use-__wake_up_parent.patch
do_wait-wakeup-optimization-child_wait_callback-check-__wnothread-case.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch
wait_consider_task-kill-parent-argument.patch
signals-introduce-do_send_sig_info-helper.patch
signals-send_sigio-use-do_send_sig_info-to-avoid-check_kill_permission.patch
cpu_hotplug-dont-affect-current-tasks-affinity.patch
sysctl-remove-struct-file-argument-of-proc_handler.patch
linux-futexh-place-kernel-types-behind-__kernel__.patch
edac-i3200-memory-controller-driver.patch
include-linux-unaligned-lbe_byteshifth-fix-usage-for-compressed-kernels.patch
lzo-add-support-for-lzo-compressed-kernels.patch
lzo-arm-add-support-for-lzo-compressed-kernels.patch
lzo-x86-add-support-for-lzo-compressed-kernels.patch
lzo-add-lzo-compression-support-for-initramfs-and-old-style-initrd.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch

