From: akpm@linux-foundation.org
Subject: + coredump-cn_vprintf-has-no-reason-to-call-vsnprintf-twice.patch added to -mm tree
Date: Fri, 24 May 2013 12:53:45 -0700
Message-ID: <519fc549.Q1A2UhI4cAkxSpiw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57966 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757410Ab3EXTxq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 May 2013 15:53:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walters@verbum.org, vda.linux@googlemail.com, nhorman@tuxdriver.com, mzxreary@0pointer.de, lucas.de.marchi@gmail.com, jslaby@suse.cz, andi@firstfloor.org, oleg@redhat.com

Subject: + coredump-cn_vprintf-has-no-reason-to-call-vsnprintf-twice.patch added to -mm tree
To: oleg@redhat.com,andi@firstfloor.org,jslaby@suse.cz,lucas.de.marchi@gmail.com,mzxreary@0pointer.de,nhorman@tuxdriver.com,vda.linux@googlemail.com,walters@verbum.org
From: akpm@linux-foundation.org
Date: Fri, 24 May 2013 12:53:45 -0700


The patch titled
     Subject: coredump: cn_vprintf() has no reason to call vsnprintf() twice
has been added to the -mm tree.  Its filename is
     coredump-cn_vprintf-has-no-reason-to-call-vsnprintf-twice.patch

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
Subject: coredump: cn_vprintf() has no reason to call vsnprintf() twice

cn_vprintf() looks really overcomplicated and sub-optimal.  We do not need
vsnprintf(NULL) to calculate the size we need, we can simply try to print
into the current buffer and expand/retry only if necessary.

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

 fs/coredump.c |   28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff -puN fs/coredump.c~coredump-cn_vprintf-has-no-reason-to-call-vsnprintf-twice fs/coredump.c
--- a/fs/coredump.c~coredump-cn_vprintf-has-no-reason-to-call-vsnprintf-twice
+++ a/fs/coredump.c
@@ -71,26 +71,20 @@ static int expand_corename(struct core_n
 
 static int cn_vprintf(struct core_name *cn, const char *fmt, va_list arg)
 {
-	char *cur;
-	int need;
-	int ret;
+	int free, need;
 
-	need = vsnprintf(NULL, 0, fmt, arg);
-	if (likely(need < cn->size - cn->used - 1))
-		goto out_printf;
+again:
+	free = cn->size - cn->used;
+	need = vsnprintf(cn->corename + cn->used, free, fmt, arg);
+	if (need < free) {
+		cn->used += need;
+		return 0;
+	}
 
-	ret = expand_corename(cn);
-	if (ret)
-		goto expand_fail;
+	if (!expand_corename(cn))
+		goto again;
 
-out_printf:
-	cur = cn->corename + cn->used;
-	vsnprintf(cur, need + 1, fmt, arg);
-	cn->used += need;
-	return 0;
-
-expand_fail:
-	return ret;
+	return -ENOMEM;
 }
 
 static int cn_printf(struct core_name *cn, const char *fmt, ...)
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

