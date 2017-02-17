From: akpm@linux-foundation.org
Subject: + printk-use-rcuidle-console-tracepoint.patch added to -mm tree
Date: Thu, 16 Feb 2017 18:25:03 -0800
Message-ID: <58a65eff.eVMV4aALe/bDawjj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48682 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754309AbdBQCZF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Feb 2017 21:25:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky.work@gmail.com, paulmck@linux.vnet.ibm.com, peterz@infradead.org, pmladek@suse.com, rmk@armlinux.org.uk, rostedt@goodmis.org, sergey.senozhatsky@gmail.com, stable@vger.kernel.org, tglx@linutronix.de, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: use rcuidle console tracepoint
has been added to the -mm tree.  Its filename is
     printk-use-rcuidle-console-tracepoint.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-use-rcuidle-console-tracepoint.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-use-rcuidle-console-tracepoint.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: printk: use rcuidle console tracepoint

Use rcuidle console tracepoint because, apparently, it may be issued from
an idle CPU:

[    2.581939] hw-breakpoint: Failed to enable monitor mode on CPU 0.
[    2.591613] hw-breakpoint: CPU 0 failed to disable vector catch
[    2.597686]
[    2.597717] ===============================
[    2.597717] [ ERR: suspicious RCU usage.  ]
[    2.597717] 4.10.0-rc8-next-20170215+ #119 Not tainted
[    2.597717] -------------------------------
[    2.597717] ./include/trace/events/printk.h:32 suspicious rcu_dereference_check() usage!
[    2.597717]
[    2.597717] other info that might help us debug this:
[    2.597717]
[    2.597717]
[    2.597717] RCU used illegally from idle CPU!
[    2.597717] rcu_scheduler_active = 2, debug_locks = 0
[    2.597747] RCU used illegally from extended quiescent state!
[    2.597747] 2 locks held by swapper/0/0:
[    2.597747]  #0:  (cpu_pm_notifier_lock){......}, at: [<c0237e2c>] cpu_pm_exit+0x10/0x54
[    2.597747]  #1:  (console_lock){+.+.+.}, at: [<c01ab350>] vprintk_emit+0x264/0x474
[    2.597747]
[    2.597747] stack backtrace:
[    2.597778] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.10.0-rc8-next-20170215+ #119
[    2.597778] Hardware name: Generic OMAP4 (Flattened Device Tree)
[    2.597778] [<c0110228>] (unwind_backtrace) from [<c010c224>] (show_stack+0x10/0x14)
[    2.597778] [<c010c224>] (show_stack) from [<c04ca8a0>] (dump_stack+0xac/0xe0)
[    2.597778] [<c04ca8a0>] (dump_stack) from [<c01ab084>] (console_unlock+0x5e8/0x650)
[    2.597778] [<c01ab084>] (console_unlock) from [<c01ab35c>] (vprintk_emit+0x270/0x474)
[    2.597778] [<c01ab35c>] (vprintk_emit) from [<c01ab6f0>] (vprintk_default+0x20/0x28)
[    2.597808] [<c01ab6f0>] (vprintk_default) from [<c0250c94>] (printk+0x20/0x30)
[    2.597808] [<c0250c94>] (printk) from [<c0111004>] (reset_ctrl_regs+0x108/0x288)
[    2.597808] [<c0111004>] (reset_ctrl_regs) from [<c0111220>] (dbg_cpu_pm_notify+0x28/0x30)
[    2.597808] [<c0111220>] (dbg_cpu_pm_notify) from [<c015f3ac>] (notifier_call_chain+0x44/0x80)
[    2.597808] [<c015f3ac>] (notifier_call_chain) from [<c0237e48>] (cpu_pm_exit+0x2c/0x54)
[    2.597808] [<c0237e48>] (cpu_pm_exit) from [<c0126ca0>] (omap_enter_idle_coupled+0x80/0x208)
[    2.597808] [<c0126ca0>] (omap_enter_idle_coupled) from [<c0680d80>] (cpuidle_enter_state+0x118/0x4ac)
[    2.597808] [<c0680d80>] (cpuidle_enter_state) from [<c0682e54>] (cpuidle_enter_state_coupled+0x3a8/0x40c)
[    2.597839] [<c0682e54>] (cpuidle_enter_state_coupled) from [<c0190c04>] (do_idle+0x1a4/0x218)
[    2.597839] [<c0190c04>] (do_idle) from [<c0190ffc>] (cpu_startup_entry+0x18/0x1c)
[    2.597839] [<c0190ffc>] (cpu_startup_entry) from [<c0c00c40>] (start_kernel+0x35c/0x3d4)
[    2.597839] [<c0c00c40>] (start_kernel) from [<8000807c>] (0x8000807c)

This RCU warning, however, is suppressed by lockdep_off() in printk(). 
lockdep_off() increments the ->lockdep_recursion counter and thus disables
RCU_LOCKDEP_WARN() and debug_lockdep_rcu_enabled(), which want lockdep to
be enabled "current->lockdep_recursion == 0".

Link: http://lkml.kernel.org/r/20170217015932.11898-1-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reported-by: Tony Lindgren <tony@atomide.com>
Tested-by: Tony Lindgren <tony@atomide.com>
Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Russell King <rmk@armlinux.org.uk>
Cc: <stable@vger.kernel.org> [3.4+]

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/printk/printk.c~printk-use-rcuidle-console-tracepoint kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-use-rcuidle-console-tracepoint
+++ a/kernel/printk/printk.c
@@ -1516,7 +1516,7 @@ static void call_console_drivers(int lev
 {
 	struct console *con;
 
-	trace_console(text, len);
+	trace_console_rcuidle(text, len);
 
 	if (!console_drivers)
 		return;
_

Patches currently in -mm which might be from sergey.senozhatsky.work@gmail.com are

printk-use-rcuidle-console-tracepoint.patch
zram-remove-obsolete-sysfs-attrs.patch

