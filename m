From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged]
 kdb-gid-rid-of-implicit-setting-of-the-current-task-regs.patch removed from
 -mm tree
Date: Mon, 03 Feb 2020 17:48:42 -0800
Message-ID: <20200204014842.YEaIUqr4D%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726872AbgBDBso (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Feb 2020 20:48:44 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bigeasy@linutronix.de, daniel.thompson@linaro.org, dianders@chromium.org, ebiederm@xmission.com, f4bug@amsat.org, fancer.lancer@gmail.com, jason.wessel@windriver.com, jhogan@kernel.org, mm-commits@vger.kernel.org, paul.burton@mips.com, qiaochong@loongson.cn, ralf@linux-mips.org, rppt@linux.ibm.com


The patch titled
     Subject: kdb: get rid of implicit setting of the current task/regs
has been removed from the -mm tree.  Its filename was
     kdb-gid-rid-of-implicit-setting-of-the-current-task-regs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Douglas Anderson <dianders@chromium.org>
Subject: kdb: get rid of implicit setting of the current task/regs

Some (but not all?) of the kdb backtrace paths would cause the
kdb_current_task and kdb_current_regs to remain changed.  As discussed in
a review of a previous patch [1], this doesn't seem intuitive, so let's
fix that.

...but, it turns out that there's actually no longer any reason to set the
current task / current regs while backtracing anymore anyway.  As of
commit 2277b492582d ("kdb: Fix stack crawling on 'running' CPUs that
aren't the master") if we're backtracing on a task running on a CPU we ask
that CPU to do the backtrace itself.  Linux can do that without anything
fancy.  If we're doing backtrace on a sleeping task we can also do that
fine without updating globals.  So this patch mostly just turns into
deleting a bunch of code.

[1] https://lore.kernel.org/r/20191010150735.dhrj3pbjgmjrdpwr@holly.lan

Link: http://lkml.kernel.org/r/20191109111624.4.Ibc3d982bbeb9e46872d43973ba808cd4c79537c7@changeid
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Cc: Chong Qiao <qiaochong@loongson.cn>
Cc: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: James Hogan <jhogan@kernel.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Paul Burton <paul.burton@mips.com>
Cc: Philippe Mathieu-Daud <f4bug@amsat.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Serge Semin <fancer.lancer@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/debug/kdb/kdb_bt.c      |    8 +-------
 kernel/debug/kdb/kdb_main.c    |    2 +-
 kernel/debug/kdb/kdb_private.h |    1 -
 3 files changed, 2 insertions(+), 9 deletions(-)

--- a/kernel/debug/kdb/kdb_bt.c~kdb-gid-rid-of-implicit-setting-of-the-current-task-regs
+++ a/kernel/debug/kdb/kdb_bt.c
@@ -119,7 +119,6 @@ kdb_bt_cpu(unsigned long cpu)
 		return;
 	}
 
-	kdb_set_current_task(kdb_tsk);
 	kdb_bt1(kdb_tsk, ~0UL, false);
 }
 
@@ -166,10 +165,8 @@ kdb_bt(int argc, const char **argv)
 		if (diag)
 			return diag;
 		p = find_task_by_pid_ns(pid, &init_pid_ns);
-		if (p) {
-			kdb_set_current_task(p);
+		if (p)
 			return kdb_bt1(p, ~0UL, false);
-		}
 		kdb_printf("No process with pid == %ld found\n", pid);
 		return 0;
 	} else if (strcmp(argv[0], "btt") == 0) {
@@ -178,11 +175,9 @@ kdb_bt(int argc, const char **argv)
 		diag = kdbgetularg((char *)argv[1], &addr);
 		if (diag)
 			return diag;
-		kdb_set_current_task((struct task_struct *)addr);
 		return kdb_bt1((struct task_struct *)addr, ~0UL, false);
 	} else if (strcmp(argv[0], "btc") == 0) {
 		unsigned long cpu = ~0;
-		struct task_struct *save_current_task = kdb_current_task;
 		if (argc > 1)
 			return KDB_ARGCOUNT;
 		if (argc == 1) {
@@ -204,7 +199,6 @@ kdb_bt(int argc, const char **argv)
 				kdb_bt_cpu(cpu);
 				touch_nmi_watchdog();
 			}
-			kdb_set_current_task(save_current_task);
 		}
 		return 0;
 	} else {
--- a/kernel/debug/kdb/kdb_main.c~kdb-gid-rid-of-implicit-setting-of-the-current-task-regs
+++ a/kernel/debug/kdb/kdb_main.c
@@ -1138,7 +1138,7 @@ static void kdb_dumpregs(struct pt_regs
 	console_loglevel = old_lvl;
 }
 
-void kdb_set_current_task(struct task_struct *p)
+static void kdb_set_current_task(struct task_struct *p)
 {
 	kdb_current_task = p;
 
--- a/kernel/debug/kdb/kdb_private.h~kdb-gid-rid-of-implicit-setting-of-the-current-task-regs
+++ a/kernel/debug/kdb/kdb_private.h
@@ -240,7 +240,6 @@ extern void *debug_kmalloc(size_t size,
 extern void debug_kfree(void *);
 extern void debug_kusage(void);
 
-extern void kdb_set_current_task(struct task_struct *);
 extern struct task_struct *kdb_current_task;
 extern struct pt_regs *kdb_current_regs;
 
_

Patches currently in -mm which might be from dianders@chromium.org are

kdb-get-rid-of-confusing-diag-msg-from-rd-if-current-task-has-no-regs.patch
