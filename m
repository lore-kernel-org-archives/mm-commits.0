From: akpm@linux-foundation.org
Subject: + arc-print-fatal-signals-reduce-duplicated-information.patch added to -mm tree
Date: Thu, 11 Apr 2013 13:07:51 -0700
Message-ID: <20130411200752.0361C5A42F3@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:40979 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab3DKUHx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Apr 2013 16:07:53 -0400
Received: by mail-yh0-f73.google.com with SMTP id 47so179790yhr.4
        for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2013 13:07:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vgupta@synopsys.com, bhelgaas@google.com, davem@davemloft.net, fengguang.wu@intel.com, heiko.carstens@de.ibm.com, jesper.nilsson@axis.com, sam@ravnborg.org, schwidefsky@de.ibm.com, tj@kernel.org, vapier@gentoo.org


The patch titled
     Subject: arc, print-fatal-signals: reduce duplicated information
has been added to the -mm tree.  Its filename is
     arc-print-fatal-signals-reduce-duplicated-information.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vineet Gupta <vgupta@synopsys.com>
Subject: arc, print-fatal-signals: reduce duplicated information

After the recent generic debug info on dump_stack() and friends, arc
is printing duplicate information on debug dumps.

 [ARCLinux]$ ./crash
 crash/50: potentially unexpected fatal signal 11.	<-- [1]
 /sbin/crash, TGID 50					<-- [2]
 Pid: 50, comm: crash Not tainted 3.9.0-rc4+ #132 	<-- [3]
 ...

Remove them.

[tj@kernel.org: updated patch desc]
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/kernel/troubleshoot.c |    2 +-
 kernel/signal.c                |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/arc/kernel/troubleshoot.c~arc-print-fatal-signals-reduce-duplicated-information arch/arc/kernel/troubleshoot.c
--- a/arch/arc/kernel/troubleshoot.c~arc-print-fatal-signals-reduce-duplicated-information
+++ a/arch/arc/kernel/troubleshoot.c
@@ -75,7 +75,7 @@ void print_task_path_n_nm(struct task_st
 	}
 
 done:
-	pr_info("%s, TGID %u\n", path_nm, tsk->tgid);
+	pr_info("Path: %s\n", path_nm);
 }
 EXPORT_SYMBOL(print_task_path_n_nm);
 
diff -puN kernel/signal.c~arc-print-fatal-signals-reduce-duplicated-information kernel/signal.c
--- a/kernel/signal.c~arc-print-fatal-signals-reduce-duplicated-information
+++ a/kernel/signal.c
@@ -1161,8 +1161,7 @@ static int send_signal(int sig, struct s
 static void print_fatal_signal(int signr)
 {
 	struct pt_regs *regs = signal_pt_regs();
-	printk(KERN_INFO "%s/%d: potentially unexpected fatal signal %d.\n",
-		current->comm, task_pid_nr(current), signr);
+	printk(KERN_INFO "potentially unexpected fatal signal %d.\n", signr);
 
 #if defined(__i386__) && !defined(__arch_um__)
 	printk(KERN_INFO "code at %08lx: ", regs->ip);
_

Patches currently in -mm which might be from vgupta@synopsys.com are

origin.patch
linux-next.patch
memblock-add-assertion-for-zero-allocation-alignment.patch
mm-introduce-common-help-functions-to-deal-with-reserved-managed-pages.patch
mm-arc-use-common-help-functions-to-free-reserved-pages.patch
x86-dont-show-trace-beyond-show_stacknull-null.patch
sparc32-make-show_stack-acquire-%fp-if-_ksp-is-not-specified.patch
dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors.patch
dmi-morph-dmi_dump_ids-into-dmi_format_ids-which-formats-into-a-buffer.patch
dump_stack-implement-arch-specific-hardware-description-in-task-dumps.patch
dump_stack-unify-debug-information-printed-by-show_regs.patch
arc-print-fatal-signals-reduce-duplicated-information.patch

