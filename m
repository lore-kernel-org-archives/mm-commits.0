From: akpm@linux-foundation.org
Subject: + coredump-kill-cn_escape-introduce-cn_esc_printf.patch added to
 -mm tree
Date: Fri, 24 May 2013 12:53:46 -0700
Message-ID: <519fc54a.1jl44QE/C3bgzGJo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57973 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757394Ab3EXTxr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 May 2013 15:53:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walters@verbum.org, vda.linux@googlemail.com, nhorman@tuxdriver.com, mzxreary@0pointer.de, lucas.de.marchi@gmail.com, jslaby@suse.cz, andi@firstfloor.org, oleg@redhat.com

Subject: + coredump-kill-cn_escape-introduce-cn_esc_printf.patch added to -mm tree
To: oleg@redhat.com,andi@firstfloor.org,jslaby@suse.cz,lucas.de.marchi@gmail.com,mzxreary@0pointer.de,nhorman@tuxdriver.com,vda.linux@googlemail.com,walters@verbum.org
From: akpm@linux-foundation.org
Date: Fri, 24 May 2013 12:53:46 -0700


The patch titled
     Subject: coredump: kill cn_escape(), introduce cn_esc_printf()
has been added to the -mm tree.  Its filename is
     coredump-kill-cn_escape-introduce-cn_esc_printf.patch

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
Subject: coredump: kill cn_escape(), introduce cn_esc_printf()

The usage of cn_escape() looks really annoying, imho this sequence needs a
wrapper.  And it is buggy.  If cn_printf() does expand_corename()
cn_escape() writes to the freed memory.

Introduce cn_esc_printf() which hopefully does this all right.  It records
the index before cn_vprintf(), not "char *" which is no longer valid (in
general) after krealloc().

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

 fs/coredump.c |   44 +++++++++++++++++++++-----------------------
 1 file changed, 21 insertions(+), 23 deletions(-)

diff -puN fs/coredump.c~coredump-kill-cn_escape-introduce-cn_esc_printf fs/coredump.c
--- a/fs/coredump.c~coredump-kill-cn_escape-introduce-cn_esc_printf
+++ a/fs/coredump.c
@@ -99,11 +99,21 @@ static int cn_printf(struct core_name *c
 	return ret;
 }
 
-static void cn_escape(char *str)
+static int cn_esc_printf(struct core_name *cn, const char *fmt, ...)
 {
-	for (; *str; str++)
-		if (*str == '/')
-			*str = '!';
+	int cur = cn->used;
+	va_list arg;
+	int ret;
+
+	va_start(arg, fmt);
+	ret = cn_vprintf(cn, fmt, arg);
+	va_end(arg);
+
+	for (; cur < cn->used; ++cur) {
+		if (cn->corename[cur] == '/')
+			cn->corename[cur] = '!';
+	}
+	return ret;
 }
 
 static int cn_print_exe_file(struct core_name *cn)
@@ -113,12 +123,8 @@ static int cn_print_exe_file(struct core
 	int ret;
 
 	exe_file = get_mm_exe_file(current->mm);
-	if (!exe_file) {
-		char *commstart = cn->corename + cn->used;
-		ret = cn_printf(cn, "%s (path unknown)", current->comm);
-		cn_escape(commstart);
-		return ret;
-	}
+	if (!exe_file)
+		return cn_esc_printf(cn, "%s (path unknown)", current->comm);
 
 	pathbuf = kmalloc(PATH_MAX, GFP_TEMPORARY);
 	if (!pathbuf) {
@@ -132,9 +138,7 @@ static int cn_print_exe_file(struct core
 		goto free_buf;
 	}
 
-	cn_escape(path);
-
-	ret = cn_printf(cn, "%s", path);
+	ret = cn_esc_printf(cn, "%s", path);
 
 free_buf:
 	kfree(pathbuf);
@@ -207,22 +211,16 @@ static int format_corename(struct core_n
 				break;
 			}
 			/* hostname */
-			case 'h': {
-				char *namestart = cn->corename + cn->used;
+			case 'h':
 				down_read(&uts_sem);
-				err = cn_printf(cn, "%s",
+				err = cn_esc_printf(cn, "%s",
 					      utsname()->nodename);
 				up_read(&uts_sem);
-				cn_escape(namestart);
 				break;
-			}
 			/* executable */
-			case 'e': {
-				char *commstart = cn->corename + cn->used;
-				err = cn_printf(cn, "%s", current->comm);
-				cn_escape(commstart);
+			case 'e':
+				err = cn_esc_printf(cn, "%s", current->comm);
 				break;
-			}
 			case 'E':
 				err = cn_print_exe_file(cn);
 				break;
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

