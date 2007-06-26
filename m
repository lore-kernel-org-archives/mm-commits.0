From: akpm@linux-foundation.org
Subject: + kcdrwd-remove-unneeded-flush_signals-call.patch added to -mm tree
Date: Tue, 26 Jun 2007 13:42:45 -0700
Message-ID: <200706262042.l5QKgj6s001743@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55835 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757372AbXFZUnV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 16:43:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, petero2@telia.com


The patch titled
     kcdrwd: remove unneeded flush_signals() call
has been added to the -mm tree.  Its filename is
     kcdrwd-remove-unneeded-flush_signals-call.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kcdrwd: remove unneeded flush_signals() call
From: Oleg Nesterov <oleg@tv-sign.ru>

kcdrwd() is a kernel thread, all signals are ignored.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Peter Osterlund <petero2@telia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/pktcdvd.c |    3 ---
 1 files changed, 3 deletions(-)

diff -puN drivers/block/pktcdvd.c~kcdrwd-remove-unneeded-flush_signals-call drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c~kcdrwd-remove-unneeded-flush_signals-call
+++ a/drivers/block/pktcdvd.c
@@ -1652,9 +1652,6 @@ static int kcdrwd(void *foobar)
 				}
 			}
 
-			if (signal_pending(current)) {
-				flush_signals(current);
-			}
 			if (kthread_should_stop())
 				break;
 		}
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

avoid-spurious-pollin-returns-in-signalfd.patch
w1_therm_read_bin-suspicious-usage-of-flush_signals.patch
libata-core-convert-to-use-cancel_rearming_delayed_work.patch
freezer-make-kernel-threads-nonfreezable-by-default.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix-2.patch
freezer-run-show_state-when-freezing-times-out.patch
hibernation-prepare-to-enter-the-low-power-state.patch
freezer-avoid-freezing-kernel-threads-prematurely.patch
freezer-use-__set_current_state-in-refrigerator.patch
freezer-return-int-from-freeze_processes.patch
freezer-remove-redundant-check-in-try_to_freeze_tasks.patch
pm-prevent-frozen-user-mode-helpers-from-failing-the-freezing-of-tasks-rev-2.patch
add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage.patch
add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage-fix.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
use-write_trylock_irqsave-in-ptrace_attach.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
mm-fix-create_new_namespaces-return-value.patch
adb_probe_task-remove-unneeded-flush_signals-call.patch
kcdrwd-remove-unneeded-flush_signals-call.patch
