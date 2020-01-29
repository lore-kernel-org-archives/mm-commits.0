From: akpm@linux-foundation.org
Subject: +
 mips-kdb-remove-old-workaround-for-backtracing-on-other-cpus.patch added to
 -mm tree
Date: Tue, 28 Jan 2020 17:43:16 -0800
Message-ID: <20200129014316.0wnCw6-mR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbgA2BnU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 28 Jan 2020 20:43:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bigeasy@linutronix.de, daniel.thompson@linaro.org, dianders@chromium.org, ebiederm@xmission.com, f4bug@amsat.org, fancer.lancer@gmail.com, jason.wessel@windriver.com, jhogan@kernel.org, mm-commits@vger.kernel.org, paul.burton@mips.com, qiaochong@loongson.cn, ralf@linux-mips.org, rppt@linux.ibm.com


The patch titled
     Subject: MIPS: kdb: remove old workaround for backtracing on other CPUs
has been added to the -mm tree.  Its filename is
     mips-kdb-remove-old-workaround-for-backtracing-on-other-cpus.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mips-kdb-remove-old-workaround-for-backtracing-on-other-cpus.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mips-kdb-remove-old-workaround-for-backtracing-on-other-cpus.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Douglas Anderson <dianders@chromium.org>
Subject: MIPS: kdb: remove old workaround for backtracing on other CPUs

Patch series "kdb: Don't implicitly change tasks; plus misc fixups".


This patch (of 5):

As of commit 2277b492582d ("kdb: Fix stack crawling on 'running' CPUs that
aren't the master") we no longer need any special case for doing stack
dumps on CPUs that are not the kdb master.  Let's remove.

Link: http://lkml.kernel.org/r/20191109111623.1.I30a0cac4d9880040c8d41495bd9a567fe3e24989@changeid
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

 arch/mips/kernel/traps.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/arch/mips/kernel/traps.c~mips-kdb-remove-old-workaround-for-backtracing-on-other-cpus
+++ a/arch/mips/kernel/traps.c
@@ -210,11 +210,6 @@ void show_stack(struct task_struct *task
 			regs.regs[29] = task->thread.reg29;
 			regs.regs[31] = 0;
 			regs.cp0_epc = task->thread.reg31;
-#ifdef CONFIG_KGDB_KDB
-		} else if (atomic_read(&kgdb_active) != -1 &&
-			   kdb_current_regs) {
-			memcpy(&regs, kdb_current_regs, sizeof(regs));
-#endif /* CONFIG_KGDB_KDB */
 		} else {
 			prepare_frametrace(&regs);
 		}
_

Patches currently in -mm which might be from dianders@chromium.org are

mips-kdb-remove-old-workaround-for-backtracing-on-other-cpus.patch
kdb-kdb_current_regs-should-be-private.patch
kdb-kdb_current_task-shouldnt-be-exported.patch
kdb-gid-rid-of-implicit-setting-of-the-current-task-regs.patch
kdb-get-rid-of-confusing-diag-msg-from-rd-if-current-task-has-no-regs.patch
