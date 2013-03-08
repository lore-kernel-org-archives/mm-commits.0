From: akpm@linux-foundation.org
Subject: [to-be-updated] coredump-factor-out-the-setting-of-pf_dumpcore.patch removed from -mm tree
Date: Fri, 08 Mar 2013 13:07:48 -0800
Message-ID: <20130308210749.001515A4123@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:63892 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932987Ab3CHVHu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Mar 2013 16:07:50 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so201831yen.3
        for <mm-commits@vger.kernel.org>; Fri, 08 Mar 2013 13:07:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, msb@chromium.org, nhorman@redhat.com, rjw@sisk.pl, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: factor out the setting of PF_DUMPCORE
has been removed from the -mm tree.  Its filename was
     coredump-factor-out-the-setting-of-pf_dumpcore.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: coredump: factor out the setting of PF_DUMPCORE

Cleanup and preparation. Every linux_binfmt->core_dump() sets
PF_DUMPCORE, move this into zap_threads() called by do_coredump().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Mandeep Singh Baines <msb@chromium.org>
Cc: Neil Horman <nhorman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
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
@@ -290,6 +290,7 @@ static int zap_threads(struct task_struc
 	if (!signal_group_exit(tsk->signal)) {
 		mm->core_state = core_state;
 		nr = zap_process(tsk, exit_code);
+		tsk->flags = PF_DUMPCORE;
 		tsk->signal->group_exit_task = tsk;
 		/* ignore all signals except SIGKILL, see prepare_signal() */
 		tsk->signal->flags = SIGNAL_GROUP_COREDUMP;
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
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch

