From: akpm@linux-foundation.org
Subject: - ftrace-disable-tracing-for-suspend-to-ram.patch removed from -mm tree
Date: Thu, 28 Aug 2008 14:48:48 -0700
Message-ID: <200808282148.m7SLmmf0016133@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755612AbYH1Vto (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Aug 2008 17:49:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, marcin.slusarz@gmail.com, mingo@elte.hu, rjw@sisk.pl, srostedt@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ftrace: disable tracing for suspend to ram
has been removed from the -mm tree.  Its filename was
     ftrace-disable-tracing-for-suspend-to-ram.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ftrace: disable tracing for suspend to ram
From: Steven Rostedt <rostedt@goodmis.org>

I've been painstakingly debugging the issue with suspend to ram and
ftraced.  The 2.6.28 code does not have this issue, but since the mcount
recording is not going to be in 27, this must be solved for the ftrace
daemon version.

The resume from suspend to ram would reboot because it was triple
faulting.  Debugging further, I found that calling the mcount function
itself was not an issue, but it would fault when it incremented
preempt_count.  preempt_count is on the tasks info structure that is on
the low memory address of the task's stack.  For some reason, it could not
write to it.  Resuming out of suspend to ram does quite a lot of funny
tricks to get to work, so it is not surprising at all that simply doing a
preempt_disable() would cause a fault.

Thanks to Rafael for suggesting to add a "while (1);" to find the place in
resuming that is causing the fault.  I would place the loop somewhere in
the code, compile and reboot and see if it would either reboot (hit the
fault) or simply hang (hit the loop).  Doing this over and over again, I
narrowed it down that it was happening in enable_nonboot_cpus.

At this point, I found that it is easier to simply disable tracing around
the suspend code, instead of searching for the particular function that
can not handle doing a preempt_disable.

This patch disables the tracer as it suspends and reenables it on resume.

I tested this patch on my Laptop, and it can resume fine with the patch.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Tested-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/main.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN kernel/power/main.c~ftrace-disable-tracing-for-suspend-to-ram kernel/power/main.c
--- a/kernel/power/main.c~ftrace-disable-tracing-for-suspend-to-ram
+++ a/kernel/power/main.c
@@ -21,6 +21,7 @@
 #include <linux/freezer.h>
 #include <linux/vmstat.h>
 #include <linux/syscalls.h>
+#include <linux/ftrace.h>
 
 #include "power.h"
 
@@ -310,7 +311,7 @@ static int suspend_enter(suspend_state_t
  */
 int suspend_devices_and_enter(suspend_state_t state)
 {
-	int error;
+	int error, ftrace_save;
 
 	if (!suspend_ops)
 		return -ENOSYS;
@@ -321,6 +322,7 @@ int suspend_devices_and_enter(suspend_st
 			goto Close;
 	}
 	suspend_console();
+	ftrace_save = __ftrace_enabled_save();
 	suspend_test_start();
 	error = device_suspend(PMSG_SUSPEND);
 	if (error) {
@@ -352,6 +354,7 @@ int suspend_devices_and_enter(suspend_st
 	suspend_test_start();
 	device_resume(PMSG_RESUME);
 	suspend_test_finish("resume devices");
+	__ftrace_enabled_restore(ftrace_save);
 	resume_console();
  Close:
 	if (suspend_ops->end)
_

Patches currently in -mm which might be from rostedt@goodmis.org are

origin.patch
linux-next.patch
kbuild-ftrace-dont-assume-that-scripts-recordmcountpl-is-executable.patch
ftrace-warn-on-failure-to-disable-mcount-callers.patch

