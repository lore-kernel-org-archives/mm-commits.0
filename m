From: akpm@linux-foundation.org
Subject: [merged] coredump-introduce-cn_vprintf.patch removed from -mm
 tree
Date: Mon, 08 Jul 2013 12:35:47 -0700
Message-ID: <51db1493.43gqesf8ragJana0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51497 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab3GHTfs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:35:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walters@verbum.org, vda.linux@googlemail.com, nhorman@tuxdriver.com, mzxreary@0pointer.de, lucas.de.marchi@gmail.com, jslaby@suse.cz, andi@firstfloor.org, oleg@redhat.com

Subject: [merged] coredump-introduce-cn_vprintf.patch removed from -mm tree
To: oleg@redhat.com,andi@firstfloor.org,jslaby@suse.cz,lucas.de.marchi@gmail.com,mzxreary@0pointer.de,nhorman@tuxdriver.com,vda.linux@googlemail.com,walters@verbum.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:35:47 -0700


The patch titled
     Subject: coredump: introduce cn_vprintf()
has been removed from the -mm tree.  Its filename was
     coredump-introduce-cn_vprintf.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: coredump: introduce cn_vprintf()

Turn cn_printf(...) into cn_vprintf(va_list args), reintroduce
cn_printf() as a trivial wrapper.

This simplifies the next change and cn_vprintf() will have more
callers.

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

 fs/coredump.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff -puN fs/coredump.c~coredump-introduce-cn_vprintf fs/coredump.c
--- a/fs/coredump.c~coredump-introduce-cn_vprintf
+++ a/fs/coredump.c
@@ -69,17 +69,13 @@ static int expand_corename(struct core_n
 	return 0;
 }
 
-static int cn_printf(struct core_name *cn, const char *fmt, ...)
+static int cn_vprintf(struct core_name *cn, const char *fmt, va_list arg)
 {
 	char *cur;
 	int need;
 	int ret;
-	va_list arg;
 
-	va_start(arg, fmt);
 	need = vsnprintf(NULL, 0, fmt, arg);
-	va_end(arg);
-
 	if (likely(need < cn->size - cn->used - 1))
 		goto out_printf;
 
@@ -89,9 +85,7 @@ static int cn_printf(struct core_name *c
 
 out_printf:
 	cur = cn->corename + cn->used;
-	va_start(arg, fmt);
 	vsnprintf(cur, need + 1, fmt, arg);
-	va_end(arg);
 	cn->used += need;
 	return 0;
 
@@ -99,6 +93,18 @@ expand_fail:
 	return ret;
 }
 
+static int cn_printf(struct core_name *cn, const char *fmt, ...)
+{
+	va_list arg;
+	int ret;
+
+	va_start(arg, fmt);
+	ret = cn_vprintf(cn, fmt, arg);
+	va_end(arg);
+
+	return ret;
+}
+
 static void cn_escape(char *str)
 {
 	for (; *str; str++)
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_work-fix.patch
fput-turn-list_head-delayed_fput_list-into-llist_head.patch
llist-fix-simplify-llist_add-and-llist_add_batch.patch
llist-llist_add-can-use-llist_add_batch.patch
vfree-dont-schedule-free_work-if-llist_add-returns-false.patch
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
signals-eventpoll-set-saved_sigmask-at-the-start.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch

