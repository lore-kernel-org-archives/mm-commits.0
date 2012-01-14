From: akpm@linux-foundation.org
Subject: + prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch added to -mm tree
Date: Fri, 13 Jan 2012 16:39:54 -0800
Message-ID: <20120114003955.8AA295C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:62089 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988Ab2ANAj5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 19:39:57 -0500
Received: by mail-ey0-f202.google.com with SMTP id d12so30424eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 16:39:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, Valdis.Kletnieks@vt.edu, kay.sievers@vrfy.org, lennart@poettering.net, oleg@redhat.com


The patch titled
     Subject: prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix
has been added to the -mm tree.  Its filename is
     prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch

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
Subject: prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix

add lengthy code comment from Oleg

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN kernel/exit.c~prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix kernel/exit.c
--- a/kernel/exit.c~prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix
+++ a/kernel/exit.c
@@ -724,7 +724,13 @@ static struct task_struct *find_new_reap
 	} else if (father->signal->has_child_subreaper) {
 		struct task_struct *reaper;
 
-		/* find the first ancestor marked as child_subreaper */
+		/*
+		 * Find the first ancestor marked as child_subreaper.
+		 * Note that the code below checks same_thread_group(reaper,
+		 * pid_ns->child_reaper).  This is what we need to DTRT in a
+		 * PID namespace. However we still need the check above, see
+		 * http://marc.info/?l=linux-kernel&m=131385460420380
+		 */
 		for (reaper = father->real_parent;
 		     reaper != &init_task;
 		     reaper = reaper->real_parent) {
_
Subject: Subject: prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-fix-warnings-regarding-enum-migrate_mode.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
drivers-scsi-megaraidc-fix-sparse-warnings-checkpatch-fixes.patch
drivers-usb-misc-emi26c-emi62c-fix-warnings.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
audit-treat-s_id-as-an-untrusted-string.patch
hpet-factor-timer-allocate-from-open.patch
drivers-idle-intel_idlec-remove-redundant-local_irq_disable-call.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
brlocks-lglocks-cleanups-checkpatch-fixes.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

