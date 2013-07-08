From: akpm@linux-foundation.org
Subject: [merged]
 coredump-%-at-the-end-shouldnt-bypass-core_uses_pid-logic.patch removed
 from -mm tree
Date: Mon, 08 Jul 2013 12:35:55 -0700
Message-ID: <51db149b.6CeYboDHyJPj/eP8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51543 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab3GHTf4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:35:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walters@verbum.org, vda.linux@googlemail.com, nhorman@tuxdriver.com, mzxreary@0pointer.de, lucas.de.marchi@gmail.com, jslaby@suse.cz, andi@firstfloor.org, oleg@redhat.com

Subject: [merged] coredump-%-at-the-end-shouldnt-bypass-core_uses_pid-logic.patch removed from -mm tree
To: oleg@redhat.com,andi@firstfloor.org,jslaby@suse.cz,lucas.de.marchi@gmail.com,mzxreary@0pointer.de,nhorman@tuxdriver.com,vda.linux@googlemail.com,walters@verbum.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:35:55 -0700


The patch titled
     Subject: coredump: '% at the end' shouldn't bypass core_uses_pid logic
has been removed from the -mm tree.  Its filename was
     coredump-%-at-the-end-shouldnt-bypass-core_uses_pid-logic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: coredump: '% at the end' shouldn't bypass core_uses_pid logic

"goto end" should not bypass the "Backward compatibility with
core_uses_pid" code, move this label up.

While at it,

	- It is ugly to copy '|' into cn->corename and then inc
	  the pointer for argv_split().

	  Change format_corename() to increment pat_ptr instead.

	- Remove the dead "if (*pat_ptr == 0)" in format_corename(),
	  we already checked it is not zero.

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

 fs/coredump.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN fs/coredump.c~coredump-%-at-the-end-shouldnt-bypass-core_uses_pid-logic fs/coredump.c
--- a/fs/coredump.c~coredump-%-at-the-end-shouldnt-bypass-core_uses_pid-logic
+++ a/fs/coredump.c
@@ -165,13 +165,15 @@ static int format_corename(struct core_n
 	cn->corename = NULL;
 	if (expand_corename(cn, core_name_size))
 		return -ENOMEM;
+	cn->corename[0] = '\0';
+
+	if (ispipe)
+		++pat_ptr;
 
 	/* Repeat as long as we have more pattern to process and more output
 	   space */
 	while (*pat_ptr) {
 		if (*pat_ptr != '%') {
-			if (*pat_ptr == 0)
-				goto out;
 			err = cn_printf(cn, "%c", *pat_ptr++);
 		} else {
 			switch (*++pat_ptr) {
@@ -240,6 +242,7 @@ static int format_corename(struct core_n
 			return err;
 	}
 
+out:
 	/* Backward compatibility with core_uses_pid:
 	 *
 	 * If core_pattern does not include a %p (as is the default)
@@ -250,7 +253,6 @@ static int format_corename(struct core_n
 		if (err)
 			return err;
 	}
-out:
 	return ispipe;
 }
 
@@ -580,7 +582,7 @@ void do_coredump(siginfo_t *siginfo)
 			goto fail_dropcount;
 		}
 
-		helper_argv = argv_split(GFP_KERNEL, cn.corename+1, NULL);
+		helper_argv = argv_split(GFP_KERNEL, cn.corename, NULL);
 		if (!helper_argv) {
 			printk(KERN_WARNING "%s failed to allocate memory\n",
 			       __func__);
@@ -597,7 +599,7 @@ void do_coredump(siginfo_t *siginfo)
 
 		argv_free(helper_argv);
 		if (retval) {
-			printk(KERN_INFO "Core dump to %s pipe failed\n",
+			printk(KERN_INFO "Core dump to |%s pipe failed\n",
 			       cn.corename);
 			goto close_fail;
 		}
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

