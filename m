From: akpm@linux-foundation.org
Subject: + coredump-kill-call_count-add-core_name_size.patch added to -mm
 tree
Date: Fri, 24 May 2013 12:53:47 -0700
Message-ID: <519fc54b.gYrU5IyMUT3OKhbO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57981 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757455Ab3EXTxs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 May 2013 15:53:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walters@verbum.org, vda.linux@googlemail.com, nhorman@tuxdriver.com, mzxreary@0pointer.de, lucas.de.marchi@gmail.com, jslaby@suse.cz, andi@firstfloor.org, oleg@redhat.com

Subject: + coredump-kill-call_count-add-core_name_size.patch added to -mm tree
To: oleg@redhat.com,andi@firstfloor.org,jslaby@suse.cz,lucas.de.marchi@gmail.com,mzxreary@0pointer.de,nhorman@tuxdriver.com,vda.linux@googlemail.com,walters@verbum.org
From: akpm@linux-foundation.org
Date: Fri, 24 May 2013 12:53:47 -0700


The patch titled
     Subject: coredump: kill call_count, add core_name_size
has been added to the -mm tree.  Its filename is
     coredump-kill-call_count-add-core_name_size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: coredump: kill call_count, add core_name_size

Imho, "atomic_t call_count" is ugly and should die.  It buys nothing and
in fact it can grow more than necessary, expand doesn't check if it was
already incremented by another task.

Kill it, and introduce "static int core_name_size" updated by
expand_corename().  This is obviously racy too but harmless, and
core_name_size never grows for no reason.

We do not bother to to calculate the "right" new size, we simply do
kmalloc(size_we_need) and use ksize() to rely on kmalloc_index's decision.

Finally change format_corename() to use expand_corename(), krealloc(NULL)
is fine.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Colin Walters <walters@verbum.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Lennart Poettering <mzxreary@0pointer.de>
Cc: Lucas De Marchi <lucas.de.marchi@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff -puN fs/coredump.c~coredump-kill-call_count-add-core_name_size fs/coredump.c
--- a/fs/coredump.c~coredump-kill-call_count-add-core_name_size
+++ a/fs/coredump.c
@@ -45,26 +45,28 @@
 #include <trace/events/sched.h>
 
 int core_uses_pid;
-char core_pattern[CORENAME_MAX_SIZE] = "core";
 unsigned int core_pipe_limit;
+char core_pattern[CORENAME_MAX_SIZE] = "core";
+static int core_name_size = CORENAME_MAX_SIZE;
 
 struct core_name {
 	char *corename;
 	int used, size;
 };
-static atomic_t call_count = ATOMIC_INIT(1);
 
 /* The maximal length of core_pattern is also specified in sysctl.c */
 
-static int expand_corename(struct core_name *cn)
+static int expand_corename(struct core_name *cn, int size)
 {
-	int size = CORENAME_MAX_SIZE * atomic_inc_return(&call_count);
 	char *corename = krealloc(cn->corename, size, GFP_KERNEL);
 
 	if (!corename)
 		return -ENOMEM;
 
-	cn->size = size;
+	if (size > core_name_size) /* racy but harmless */
+		core_name_size = size;
+
+	cn->size = ksize(corename);
 	cn->corename = corename;
 	return 0;
 }
@@ -81,7 +83,7 @@ again:
 		return 0;
 	}
 
-	if (!expand_corename(cn))
+	if (!expand_corename(cn, cn->size + need - free + 1))
 		goto again;
 
 	return -ENOMEM;
@@ -160,9 +162,8 @@ static int format_corename(struct core_n
 	int err = 0;
 
 	cn->used = 0;
-	cn->size = CORENAME_MAX_SIZE * atomic_read(&call_count);
-	cn->corename = kmalloc(cn->size, GFP_KERNEL);
-	if (!cn->corename)
+	cn->corename = NULL;
+	if (expand_corename(cn, core_name_size))
 		return -ENOMEM;
 
 	/* Repeat as long as we have more pattern to process and more output
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
posix_cpu_timer-consolidate-expiry-time-type.patch
posix_cpu_timers-consolidate-timer-list-cleanups.patch
posix_cpu_timers-consolidate-expired-timers-check.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
posix_timers-fix-racy-timer-delta-caching-on-task-exit.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
ptrace-x86-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-powerpc-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-arm-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-sh-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-revert-prepare-to-fix-racy-accesses-on-task-breakpoints.patch
ptrace-x86-simplify-the-disable-logic-in-ptrace_write_dr7.patch
ptrace-x86-dont-delay-disable-till-second-pass-in-ptrace_write_dr7.patch
ptrace-x86-introduce-ptrace_register_breakpoint.patch
ptrace-x86-ptrace_write_dr7-should-create-bp-if-disabled.patch
ptrace-x86-cleanup-ptrace_set_debugreg.patch
ptrace-ptrace_detach-should-do-flush_ptrace_hw_breakpointchild.patch
ptrace-x86-flush_ptrace_hw_breakpoint-shoule-clear-the-virtual-debug-registers.patch
x86-kill-tif_debug.patch
coredump-format_corename-can-leak-cn-corename.patch
coredump-introduce-cn_vprintf.patch
coredump-cn_vprintf-has-no-reason-to-call-vsnprintf-twice.patch
coredump-kill-cn_escape-introduce-cn_esc_printf.patch
coredump-kill-call_count-add-core_name_size.patch
coredump-%-at-the-end-shouldnt-bypass-core_uses_pid-logic.patch

