From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kdb-kdb_current_regs-should-be-private.patch
 removed from -mm tree
Date: Mon, 03 Feb 2020 17:48:36 -0800
Message-ID: <20200204014836.dyymYzXd9%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726872AbgBDBsj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Feb 2020 20:48:39 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bigeasy@linutronix.de, daniel.thompson@linaro.org, dianders@chromium.org, ebiederm@xmission.com, f4bug@amsat.org, fancer.lancer@gmail.com, jason.wessel@windriver.com, jhogan@kernel.org, mm-commits@vger.kernel.org, paul.burton@mips.com, qiaochong@loongson.cn, ralf@linux-mips.org, rppt@linux.ibm.com


The patch titled
     Subject: kdb: kdb_current_regs should be private
has been removed from the -mm tree.  Its filename was
     kdb-kdb_current_regs-should-be-private.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Douglas Anderson <dianders@chromium.org>
Subject: kdb: kdb_current_regs should be private

As of the patch ("MIPS: kdb: Remove old workaround for backtracing on
other CPUs") there is no reason for kdb_current_regs to be in the public
"kdb.h".  Let's move it next to kdb_current_task.

Link: http://lkml.kernel.org/r/20191109111623.2.Iadbfb484e90b557cc4b5ac9890bfca732cd99d77@changeid
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

 include/linux/kdb.h            |    2 --
 kernel/debug/kdb/kdb_private.h |    1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/kdb.h~kdb-kdb_current_regs-should-be-private
+++ a/include/linux/kdb.h
@@ -183,8 +183,6 @@ int kdb_process_cpu(const struct task_st
 	return cpu;
 }
 
-/* kdb access to register set for stack dumping */
-extern struct pt_regs *kdb_current_regs;
 #ifdef CONFIG_KALLSYMS
 extern const char *kdb_walk_kallsyms(loff_t *pos);
 #else /* ! CONFIG_KALLSYMS */
--- a/kernel/debug/kdb/kdb_private.h~kdb-kdb_current_regs-should-be-private
+++ a/kernel/debug/kdb/kdb_private.h
@@ -242,6 +242,7 @@ extern void debug_kusage(void);
 
 extern void kdb_set_current_task(struct task_struct *);
 extern struct task_struct *kdb_current_task;
+extern struct pt_regs *kdb_current_regs;
 
 #ifdef CONFIG_KDB_KEYBOARD
 extern void kdb_kbd_cleanup_state(void);
_

Patches currently in -mm which might be from dianders@chromium.org are

kdb-kdb_current_task-shouldnt-be-exported.patch
kdb-gid-rid-of-implicit-setting-of-the-current-task-regs.patch
kdb-get-rid-of-confusing-diag-msg-from-rd-if-current-task-has-no-regs.patch
