From: akpm@linux-foundation.org
Subject: + kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch added to -mm tree
Date: Tue, 24 Jan 2012 16:20:29 -0800
Message-ID: <20120125002029.A58F0A009D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:43526 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957Ab2AYAUc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2012 19:20:32 -0500
Received: by eekb15 with SMTP id b15so188684eek.1
        for <mm-commits@vger.kernel.org>; Tue, 24 Jan 2012 16:20:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, oleg@redhat.com, vda.linux@googlemail.com


The patch titled
     Subject: kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix
has been added to the -mm tree.  Its filename is
     kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix

add 0x to hex number output

Cc: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/exit.c~kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix kernel/exit.c
--- a/kernel/exit.c~kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix
+++ a/kernel/exit.c
@@ -711,7 +711,7 @@ static struct task_struct *find_new_reap
 	if (unlikely(pid_ns->child_reaper == father)) {
 		write_unlock_irq(&tasklist_lock);
 		if (unlikely(pid_ns == &init_pid_ns)) {
-			panic("Attempted to kill init! exitcode=%08x\n",
+			panic("Attempted to kill init! exitcode=0x%08x\n",
 				father->signal->group_exit_code ?:
 					father->exit_code);
 		}
_
Subject: Subject: kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
fs-btrfs-inode-mapc-fix-warnings.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
thermal-thermal_sys-fix-build-warning-fix.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
drivers-usb-misc-emi26c-emi62c-fix-warnings.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
brlocks-lglocks-cleanups-checkpatch-fixes.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

