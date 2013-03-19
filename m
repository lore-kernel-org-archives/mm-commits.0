From: akpm@linux-foundation.org
Subject: + argv_split-teach-it-to-handle-mutable-strings-fix-2.patch added to -mm tree
Date: Tue, 19 Mar 2013 13:12:08 -0700
Message-ID: <20130319201208.663FE5A41B9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:64382 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757371Ab3CSUMJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Mar 2013 16:12:09 -0400
Received: by mail-vc0-f201.google.com with SMTP id hf12so86030vcb.4
        for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2013 13:12:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, andi@firstfloor.org


The patch titled
     Subject: argv_split-teach-it-to-handle-mutable-strings-fix-2
has been added to the -mm tree.  Its filename is
     argv_split-teach-it-to-handle-mutable-strings-fix-2.patch

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
Subject: argv_split-teach-it-to-handle-mutable-strings-fix-2

Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/argv_split.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/argv_split.c~argv_split-teach-it-to-handle-mutable-strings-fix-2 lib/argv_split.c
--- a/lib/argv_split.c~argv_split-teach-it-to-handle-mutable-strings-fix-2
+++ a/lib/argv_split.c
@@ -63,7 +63,7 @@ char **argv_split(gfp_t gfp, const char
 	char **argv, **argv_ret;
 	int argc;
 
-	argv_str = kstrndup(str, KMALLOC_MAX_SIZE, gfp);
+	argv_str = kstrndup(str, KMALLOC_MAX_SIZE - 1, gfp);
 	if (!argv_str)
 		return NULL;
 
_

Patches currently in -mm which might be from oleg@redhat.com are

poweroff-change-orderly_poweroff-to-use-schedule_work.patch
thinkpad-acpi-kill-hotkey_thread_mutex.patch
kthread-introduce-to_live_kthread.patch
kthread-kill-task_get_live_kthread.patch
posix_cpu_timer-consolidate-expiry-time-type.patch
posix_cpu_timers-consolidate-timer-list-cleanups.patch
posix_cpu_timers-consolidate-expired-timers-check.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
argv_split-teach-it-to-handle-mutable-strings.patch
argv_split-teach-it-to-handle-mutable-strings-fix.patch
argv_split-teach-it-to-handle-mutable-strings-fix-2.patch
epoll-use-rcu-to-protect-wakeup_source-in-epitem.patch
ptrace-add-ability-to-retrieve-signals-without-removing-from-a-queue-v4.patch
selftest-add-a-test-case-for-ptrace_peeksiginfo.patch
usermodehelper-export-_exec-and-_setup-functions.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kmod-split-call-to-call_usermodehelper_fns.patch
keys-split-call-to-call_usermodehelper_fns.patch
coredump-remove-trailling-whitespaces.patch
split-remaining-calls-to-call_usermodehelper_fns.patch
kmod-remove-call_usermodehelper_fns.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-introduce-dump_interrupted.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
coredump-change-wait_for_dump_helpers-to-use-wait_event_interruptible.patch
set_task_comm-kill-the-pointless-memset-wmb.patch

