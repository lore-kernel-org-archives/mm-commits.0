Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725FD1537A7
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752977351; cv=none; b=XBzyo1V3wG/TiaPP1xRIFt0/6z4VfWVdZR3gZKNEZZMVAx6orwgQVcQQgKki/a/PeO9xQWNzkrbjy+dYb8gkh/11Z/3Af4E8XXJvl9RdVmPbiuGjWke4WyQMKgNosJDSKsxvDmgWQwh44CfeT8Dt1kxc/o06ysV68bO2lo1BGo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752977351; c=relaxed/simple;
	bh=TRb1y0GKLGVrWa2uR4POQmAFSsqX88uxYL/rqn5SsAU=;
	h=Date:To:From:Subject:Message-Id; b=oeIVxJ7GuAhWuWifNdPj1ge26eT6a6QzPJyQ0lID5fyaZSa/Q64TGq64n5mGZOxFNZ/XU7mb6/4RZWM8UZU5Z3OE2VXDyhKEZn1rWVcLIqUSYCkDV4I7R6s9ZH1mfFZzG5lZ6Y0acOexTuX8RJoP0ycpkiKgn+xAmC98leSHGBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MS7Qmgze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MS7Qmgze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9BE5C4CEE3;
	Sun, 20 Jul 2025 02:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752977350;
	bh=TRb1y0GKLGVrWa2uR4POQmAFSsqX88uxYL/rqn5SsAU=;
	h=Date:To:From:Subject:From;
	b=MS7Qmgze/kidh12coY9dGBjolaEgQpBCUBLWSPsdl6uyh2p3gWdq8Z3vHhQYf112z
	 sQOAZlmdguTxorcy2LQPiBR5sd46Xttk/uhiPcSsvnng3KLha5Dv+jPgoyyJtTe/8H
	 dW8PNexbzL7cGCWA38c+I1qOzzM8Y7Zl/vsVUe0o=
Date: Sat, 19 Jul 2025 19:09:10 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,pmladek@suse.com,paulmck@kernel.org,nathan@kernel.org,lance.yang@linux.dev,john.ogness@linutronix.de,corbet@lwn.net,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] panic-clean-up-code-for-console-replay.patch removed from -mm tree
Message-Id: <20250720020910.D9BE5C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic: clean up code for console replay
has been removed from the -mm tree.  Its filename was
     panic-clean-up-code-for-console-replay.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Feng Tang <feng.tang@linux.alibaba.com>
Subject: panic: clean up code for console replay
Date: Thu, 3 Jul 2025 10:10:00 +0800

Patch series "generalize panic_print's dump function to be used by other
kernel parts", v3.

When working on kernel stability issues, panic, task-hung and
software/hardware lockup are frequently met.  And to debug them, user may
need lots of system information at that time, like task call stacks, lock
info, memory info etc.  

panic case already has panic_print_sys_info() for this purpose, and has a
'panic_print' bitmask to control what kinds of information is needed,
which is also helpful to debug other task-hung and lockup cases.

So this patchset extracts the function out to a new file 'lib/sys_info.c',
and makes it available for other cases which also need to dump system info
for debugging.  

Also as suggested by Petr Mladek, add 'panic_sys_info=' interface to take
human readable string like "tasks,mem,locks,timers,ftrace,....", and
eventually obsolete the current 'panic_print' bitmap interface.

In RFC and V1 version, hung_task and SW/HW watchdog modules are enabled
with the new sys_info dump interface.  In v2, they are kept out for better
review of current change, and will be posted later.  

Locally these have been used in our bug chasing for stability issues and
was proven helpful.

Many thanks to Petr Mladek for great suggestions on both the code and
architectures!


This patch (of 5):

Currently the panic_print_sys_info() was called twice with different
parameters to handle console replay case, which is kind of confusing.

Add panic_console_replay() explicitly and rename
'PANIC_PRINT_ALL_PRINTK_MSG' to 'PANIC_CONSOLE_REPLAY', to make the code
straightforward.  The related kernel document is also updated.

Link: https://lkml.kernel.org/r/20250703021004.42328-1-feng.tang@linux.alibaba.com
Link: https://lkml.kernel.org/r/20250703021004.42328-2-feng.tang@linux.alibaba.com
Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
Suggested-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    2 -
 Documentation/admin-guide/sysctl/kernel.rst     |    2 -
 kernel/panic.c                                  |   18 +++++++-------
 3 files changed, 11 insertions(+), 11 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~panic-clean-up-code-for-console-replay
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -4555,7 +4555,7 @@
 			bit 2: print timer info
 			bit 3: print locks info if CONFIG_LOCKDEP is on
 			bit 4: print ftrace buffer
-			bit 5: print all printk messages in buffer
+			bit 5: replay all messages on consoles at the end of panic
 			bit 6: print all CPUs backtrace (if available in the arch)
 			bit 7: print only tasks in uninterruptible (blocked) state
 			*Be aware* that this option may print a _lot_ of lines,
--- a/Documentation/admin-guide/sysctl/kernel.rst~panic-clean-up-code-for-console-replay
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -889,7 +889,7 @@ bit 1  print system memory info
 bit 2  print timer info
 bit 3  print locks info if ``CONFIG_LOCKDEP`` is on
 bit 4  print ftrace buffer
-bit 5  print all printk messages in buffer
+bit 5  replay all messages on consoles at the end of panic
 bit 6  print all CPUs backtrace (if available in the arch)
 bit 7  print only tasks in uninterruptible (blocked) state
 =====  ============================================
--- a/kernel/panic.c~panic-clean-up-code-for-console-replay
+++ a/kernel/panic.c
@@ -74,7 +74,7 @@ EXPORT_SYMBOL_GPL(panic_timeout);
 #define PANIC_PRINT_TIMER_INFO		0x00000004
 #define PANIC_PRINT_LOCK_INFO		0x00000008
 #define PANIC_PRINT_FTRACE_INFO		0x00000010
-#define PANIC_PRINT_ALL_PRINTK_MSG	0x00000020
+#define PANIC_CONSOLE_REPLAY		0x00000020
 #define PANIC_PRINT_ALL_CPU_BT		0x00000040
 #define PANIC_PRINT_BLOCKED_TASKS	0x00000080
 unsigned long panic_print;
@@ -238,14 +238,14 @@ void nmi_panic(struct pt_regs *regs, con
 }
 EXPORT_SYMBOL(nmi_panic);
 
-static void panic_print_sys_info(bool console_flush)
+static void panic_console_replay(void)
 {
-	if (console_flush) {
-		if (panic_print & PANIC_PRINT_ALL_PRINTK_MSG)
-			console_flush_on_panic(CONSOLE_REPLAY_ALL);
-		return;
-	}
+	if (panic_print & PANIC_CONSOLE_REPLAY)
+		console_flush_on_panic(CONSOLE_REPLAY_ALL);
+}
 
+static void panic_print_sys_info(void)
+{
 	if (panic_print & PANIC_PRINT_TASK_INFO)
 		show_state();
 
@@ -410,7 +410,7 @@ void panic(const char *fmt, ...)
 	 */
 	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
 
-	panic_print_sys_info(false);
+	panic_print_sys_info();
 
 	kmsg_dump_desc(KMSG_DUMP_PANIC, buf);
 
@@ -439,7 +439,7 @@ void panic(const char *fmt, ...)
 	debug_locks_off();
 	console_flush_on_panic(CONSOLE_FLUSH_PENDING);
 
-	panic_print_sys_info(true);
+	panic_console_replay();
 
 	if (!panic_blink)
 		panic_blink = no_blink;
_

Patches currently in -mm which might be from feng.tang@linux.alibaba.com are


