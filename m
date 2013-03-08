From: akpm@linux-foundation.org
Subject: + coredump-factor-out-the-setting-of-pf_dumpcore.patch added to -mm tree
Date: Fri, 08 Mar 2013 13:21:00 -0800
Message-ID: <20130308212100.E2BAE31C2B9@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:60706 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413Ab3CHVVC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Mar 2013 16:21:02 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so203175yhz.1
        for <mm-commits@vger.kernel.org>; Fri, 08 Mar 2013 13:21:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, msb@chromium.org, nhorman@redhat.com, rjw@sisk.pl, tj@kernel.org


The patch titled
     Subject: coredump: factor out the setting of PF_DUMPCORE
has been added to the -mm tree.  Its filename is
     coredump-factor-out-the-setting-of-pf_dumpcore.patch

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
Subject: coredump: factor out the setting of PF_DUMPCORE

Cleanup.  Every linux_binfmt->core_dump() sets PF_DUMPCORE, move this into
zap_threads() called by do_coredump().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Neil Horman <nhorman@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/ia32/ia32_aout.c |    1 -
 fs/binfmt_aout.c          |    1 -
 fs/binfmt_elf.c           |    3 +--
 fs/binfmt_elf_fdpic.c     |    2 --
 fs/coredump.c             |    1 +
 5 files changed, 2 insertions(+), 6 deletions(-)

diff -puN arch/x86/ia32/ia32_aout.c~coredump-factor-out-the-setting-of-pf_dumpcore arch/x86/ia32/ia32_aout.c
--- a/arch/x86/ia32/ia32_aout.c~coredump-factor-out-the-setting-of-pf_dumpcore
+++ a/arch/x86/ia32/ia32_aout.c
@@ -162,7 +162,6 @@ static int aout_core_dump(long signr, st
 	fs = get_fs();
 	set_fs(KERNEL_DS);
 	has_dumped = 1;
-	current->flags |= PF_DUMPCORE;
 	strncpy(dump.u_comm, current->comm, sizeof(current->comm));
 	dump.u_ar0 = offsetof(struct user32, regs);
 	dump.signal = signr;
diff -puN fs/binfmt_aout.c~coredump-factor-out-the-setting-of-pf_dumpcore fs/binfmt_aout.c
--- a/fs/binfmt_aout.c~coredump-factor-out-the-setting-of-pf_dumpcore
+++ a/fs/binfmt_aout.c
@@ -62,7 +62,6 @@ static int aout_core_dump(struct coredum
 	fs = get_fs();
 	set_fs(KERNEL_DS);
 	has_dumped = 1;
-	current->flags |= PF_DUMPCORE;
        	strncpy(dump.u_comm, current->comm, sizeof(dump.u_comm));
 	dump.u_ar0 = offsetof(struct user, regs);
 	dump.signal = cprm->siginfo->si_signo;
diff -puN fs/binfmt_elf.c~coredump-factor-out-the-setting-of-pf_dumpcore fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~coredump-factor-out-the-setting-of-pf_dumpcore
+++ a/fs/binfmt_elf.c
@@ -2107,8 +2107,7 @@ static int elf_core_dump(struct coredump
 		goto cleanup;
 
 	has_dumped = 1;
-	current->flags |= PF_DUMPCORE;
-  
+
 	fs = get_fs();
 	set_fs(KERNEL_DS);
 
diff -puN fs/binfmt_elf_fdpic.c~coredump-factor-out-the-setting-of-pf_dumpcore fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~coredump-factor-out-the-setting-of-pf_dumpcore
+++ a/fs/binfmt_elf_fdpic.c
@@ -1687,8 +1687,6 @@ static int elf_fdpic_core_dump(struct co
 	fill_elf_fdpic_header(elf, e_phnum);
 
 	has_dumped = 1;
-	current->flags |= PF_DUMPCORE;
-
 	/*
 	 * Set up the notes in similar form to SVR4 core dumps made
 	 * with info from their /proc.
diff -puN fs/coredump.c~coredump-factor-out-the-setting-of-pf_dumpcore fs/coredump.c
--- a/fs/coredump.c~coredump-factor-out-the-setting-of-pf_dumpcore
+++ a/fs/coredump.c
@@ -299,6 +299,7 @@ static int zap_threads(struct task_struc
 	if (unlikely(nr < 0))
 		return nr;
 
+	tsk->flags = PF_DUMPCORE;
 	if (atomic_read(&mm->mm_users) == nr + 1)
 		goto done;
 	/*
_

Patches currently in -mm which might be from oleg@redhat.com are

thinkpad-acpi-kill-hotkey_thread_mutex.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
ptrace-add-ability-to-retrieve-signals-without-removing-from-a-queue-v4.patch
selftest-add-a-test-case-for-ptrace_peeksiginfo.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-introduce-dump_interrupted.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
coredump-change-wait_for_dump_helpers-to-use-wait_event_interruptible.patch

