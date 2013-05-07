From: akpm@linux-foundation.org
Subject: [merged] coredump-factor-out-the-setting-of-pf_dumpcore.patch removed from -mm tree
Date: Tue, 07 May 2013 10:49:36 -0700
Message-ID: <20130507174936.80C6A5A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:33508 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758406Ab3EGRti (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:49:38 -0400
Received: by mail-ve0-f201.google.com with SMTP id m1so85405ves.0
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:49:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, msb@chromium.org, nhorman@redhat.com, rjw@sisk.pl, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: factor out the setting of PF_DUMPCORE
has been removed from the -mm tree.  Its filename was
     coredump-factor-out-the-setting-of-pf_dumpcore.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2092,8 +2092,7 @@ static int elf_core_dump(struct coredump
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

origin.patch
posix_cpu_timer-consolidate-expiry-time-type.patch
posix_cpu_timers-consolidate-timer-list-cleanups.patch
posix_cpu_timers-consolidate-expired-timers-check.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
posix_timers-fix-racy-timer-delta-caching-on-task-exit.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch

