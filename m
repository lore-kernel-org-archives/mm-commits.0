From: akpm@linux-foundation.org
Subject: - workqueues-do-cpu_up_canceled-if-cpu_up_prepare-fails.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:00:29 -0700
Message-ID: <200807252300.m6PN0TNU003590@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751706AbYGYXBC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:01:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     workqueues: do CPU_UP_CANCELED if CPU_UP_PREPARE fails
has been removed from the -mm tree.  Its filename was
     workqueues-do-cpu_up_canceled-if-cpu_up_prepare-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: workqueues: do CPU_UP_CANCELED if CPU_UP_PREPARE fails
From: Oleg Nesterov <oleg@tv-sign.ru>

The bug was pointed out by Akinobu Mita <akinobu.mita@gmail.com>, and this
patch is based on his original patch.

workqueue_cpu_callback(CPU_UP_PREPARE) expects that if it returns
NOTIFY_BAD, _cpu_up() will send CPU_UP_CANCELED then.

However, this is not true since

	"cpu hotplug: cpu: deliver CPU_UP_CANCELED only to NOTIFY_OKed callbacks with CPU_UP_PREPARE"
	commit: a0d8cdb652d35af9319a9e0fb7134de2a276c636

The callback which has returned NOTIFY_BAD will not receive
CPU_UP_CANCELED.  Change the code to fulfil the CPU_UP_CANCELED logic if
CPU_UP_PREPARE fails.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Reported-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN kernel/workqueue.c~workqueues-do-cpu_up_canceled-if-cpu_up_prepare-fails kernel/workqueue.c
--- a/kernel/workqueue.c~workqueues-do-cpu_up_canceled-if-cpu_up_prepare-fails
+++ a/kernel/workqueue.c
@@ -911,6 +911,7 @@ static int __devinit workqueue_cpu_callb
 	unsigned int cpu = (unsigned long)hcpu;
 	struct cpu_workqueue_struct *cwq;
 	struct workqueue_struct *wq;
+	int ret = NOTIFY_OK;
 
 	action &= ~CPU_TASKS_FROZEN;
 
@@ -918,7 +919,7 @@ static int __devinit workqueue_cpu_callb
 	case CPU_UP_PREPARE:
 		cpu_set(cpu, cpu_populated_map);
 	}
-
+undo:
 	list_for_each_entry(wq, &workqueues, list) {
 		cwq = per_cpu_ptr(wq->cpu_wq, cpu);
 
@@ -928,7 +929,9 @@ static int __devinit workqueue_cpu_callb
 				break;
 			printk(KERN_ERR "workqueue [%s] for %i failed\n",
 				wq->name, cpu);
-			return NOTIFY_BAD;
+			action = CPU_UP_CANCELED;
+			ret = NOTIFY_BAD;
+			goto undo;
 
 		case CPU_ONLINE:
 			start_workqueue_thread(cwq, cpu);
@@ -948,7 +951,7 @@ static int __devinit workqueue_cpu_callb
 		cpu_clear(cpu, cpu_populated_map);
 	}
 
-	return NOTIFY_OK;
+	return ret;
 }
 
 void __init init_workqueues(void)
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
linux-next.patch
migrate_timers-add-comment-use-spinlock_irq.patch
tracehook-add-linux-tracehookh.patch
tracehook-exec.patch
tracehook-unexport-ptrace_notify.patch
tracehook-exit.patch
tracehook-clone.patch
tracehook-vfork-done.patch
tracehook-release_task.patch
tracehook-tracehook_tracer_task.patch
tracehook-tracehook_expect_breakpoints.patch
tracehook-tracehook_signal_handler.patch
tracehook-tracehook_consider_ignored_signal.patch
tracehook-tracehook_consider_fatal_signal.patch
tracehook-syscall.patch
tracehook-get_signal_to_deliver.patch
tracehook-job-control.patch
tracehook-death.patch
tracehook-force-signal_pending.patch
tracehook-tif_notify_resume.patch
tracehook-asm-syscallh.patch
tracehook-config_have_arch_tracehook.patch
tracehook-wait_task_inactive.patch
task_current_syscall.patch
proc-pid-syscall.patch

