From: akpm@linux-foundation.org
Subject: [merged] arc-print-fatal-signals-reduce-duplicated-information.patch removed from -mm tree
Date: Tue, 07 May 2013 10:47:20 -0700
Message-ID: <20130507174720.A1ABC5A41B9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:60918 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759209Ab3EGRrW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:47:22 -0400
Received: by mail-qe0-f73.google.com with SMTP id a11so85164qen.0
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:47:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgupta@synopsys.com, bhelgaas@google.com, davem@davemloft.net, fengguang.wu@intel.com, heiko.carstens@de.ibm.com, jesper.nilsson@axis.com, sam@ravnborg.org, schwidefsky@de.ibm.com, tj@kernel.org, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     Subject: arc, print-fatal-signals: reduce duplicated information
has been removed from the -mm tree.  Its filename was
     arc-print-fatal-signals-reduce-duplicated-information.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -71,7 +71,7 @@ void print_task_path_n_nm(struct task_st
 	}
 
 done:
-	pr_info("%s, TGID %u\n", path_nm, tsk->tgid);
+	pr_info("Path: %s\n", path_nm);
 }
 EXPORT_SYMBOL(print_task_path_n_nm);
 
diff -puN kernel/signal.c~arc-print-fatal-signals-reduce-duplicated-information kernel/signal.c
--- a/kernel/signal.c~arc-print-fatal-signals-reduce-duplicated-information
+++ a/kernel/signal.c
@@ -1160,8 +1160,7 @@ static int send_signal(int sig, struct s
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

