Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F76F2BF3E2
	for <mm-commits@vger.kernel.org>; Thu,  3 Jul 2025 22:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751582498; cv=none; b=sNLPPcW54CEsi9iEz7k3ElMhAYbny4OCXiPfwV3FBHeit7XTL2Guqy16mMRA7zmFhKFATr6n/Ya7f6EsFnSmFH+n9qfyqlN1Gsn/ZZdjq/4yr7tl+4zTA+DC2K4FPtClaqwS6HrSM/Buox/ptv4ZAfLc51cteaMbQt+GIa+wtfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751582498; c=relaxed/simple;
	bh=/5CdmM/jWL26fxt17dlmUj6Bk4RCpiNL9ju8PEbKABs=;
	h=Date:To:From:Subject:Message-Id; b=UJAgWuTZgj8RI9mxILcupTt/MVZTUjbc/hnDfvyUAH8blnQic9XaJXe66J7DS3FqxbnaQprWCNYL31dIODZVDrMFub+2RAwQRH5Hw0k4tfMfqdXBREj0gCxQRxa5LaJTkzhKKwO8kEZYk4mHim1OHG0L6nGr2f0cLqmIE690MS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GVGhOZ4h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GVGhOZ4h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B507C4CEF0;
	Thu,  3 Jul 2025 22:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751582495;
	bh=/5CdmM/jWL26fxt17dlmUj6Bk4RCpiNL9ju8PEbKABs=;
	h=Date:To:From:Subject:From;
	b=GVGhOZ4hSV7YhO90N81G2Pl2gDomsjJZVNRpoWAWC70Svbu1W374euuJY8U7tmZkD
	 lD0muEh+igQqn/pkwdCOq/xaic5WboxlmRxVSJ5Z8KyrKluewYUNn8yW/E+Ftgwf4j
	 1zczVeJdGjR75SQdO9PwuQkDF89O8HEKtAiDmPL4=
Date: Thu, 03 Jul 2025 15:41:34 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,pmladek@suse.com,paulmck@kernel.org,lance.yang@linux.dev,john.ogness@linutronix.de,corbet@lwn.net,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-clean-up-code-for-console-replay.patch added to mm-nonmm-unstable branch
Message-Id: <20250703224135.3B507C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: clean up code for console replay
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-clean-up-code-for-console-replay.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-clean-up-code-for-console-replay.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

So this patchset extract the function out to a new file 'lib/sys_info.c',
and make it available for other cases which also need to dump system info
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

panic-clean-up-code-for-console-replay.patch
panic-generalize-panic_prints-function-to-show-sys-info.patch
panic-add-panic_sys_info-sysctl-to-take-human-readable-string-parameter.patch
panic-add-panic_sys_info=-setup-option-for-kernel-cmdline.patch
panic-add-note-that-panic_print-sysctl-interface-is-deprecated.patch

