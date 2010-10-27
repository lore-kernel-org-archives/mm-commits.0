From: akpm@linux-foundation.org
Subject: + ptrace-cleanup-arch_ptrace-on-x86-fix.patch added to -mm tree
Date: Wed, 27 Oct 2010 13:32:54 -0700
Message-ID: <201010272104.o9RL4kGQ018024@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757296Ab0J0VFH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Oct 2010 17:05:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hpa@zytor.com, mingo@redhat.com, namhyung@gmail.com, tglx@linutronix.de


The patch titled
     ptrace-cleanup-arch_ptrace-on-x86-fix
has been added to the -mm tree.  Its filename is
     ptrace-cleanup-arch_ptrace-on-x86-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace-cleanup-arch_ptrace-on-x86-fix
From: Andrew Morton <akpm@linux-foundation.org>

arch/x86/kernel/ptrace.c: In function 'arch_ptrace':
arch/x86/kernel/ptrace.c:809: warning: unused variable 'udescp'

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/ptrace.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN arch/x86/kernel/ptrace.c~ptrace-cleanup-arch_ptrace-on-x86-fix arch/x86/kernel/ptrace.c
--- a/arch/x86/kernel/ptrace.c~ptrace-cleanup-arch_ptrace-on-x86-fix
+++ a/arch/x86/kernel/ptrace.c
@@ -806,7 +806,6 @@ long arch_ptrace(struct task_struct *chi
 {
 	int ret;
 	unsigned long __user *datap = (unsigned long __user *)data;
-	struct user_desc __user *udescp = (struct user_desc __user *)data;
 
 	switch (request) {
 	/* read the word at location addr in the USER area. */
@@ -890,13 +889,15 @@ long arch_ptrace(struct task_struct *chi
 	case PTRACE_GET_THREAD_AREA:
 		if ((int) addr < 0)
 			return -EIO;
-		ret = do_get_thread_area(child, addr, udescp);
+		ret = do_get_thread_area(child, addr,
+					(struct user_desc __user *)data);
 		break;
 
 	case PTRACE_SET_THREAD_AREA:
 		if ((int) addr < 0)
 			return -EIO;
-		ret = do_set_thread_area(child, addr, udescp, 0);
+		ret = do_set_thread_area(child, addr,
+					(struct user_desc __user *)data, 0);
 		break;
 #endif
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
vcs-add-poll-fasync-support-fix-fix.patch
rtc-rtc-s3c-fix-access-unit-from-byte-to-word-on-rtccon-checkpatch-fixes.patch
drivers-rtc-rtc-jz4740c-add-alarm-function-checkpatch-fixes.patch
gpio-add-support-for-74x164-serial-in-parallel-out-8-bit-shift-register-fix.patch
gpio-add-topcliff-pch-gpio-driver-fix.patch
drivers-gpio-langwell_gpioc-remove-semicolons-after-function-definitions.patch
cgroup_freezer-update_freezer_state-does-incorrect-state-transitions-checkpatch-fixes.patch
memcg-cpu-hotplug-aware-quick-acount_move-detection-checkpatch-fixes.patch
ptrace-cleanup-arch_ptrace-on-x86-fix.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2-checkpatch-fixes.patch
proc-stat-fix-scalability-of-irq-sum-of-all-cpu-fix.patch
drivers-char-hvc_consolec-remove-unneeded-__set_current_statetask_running.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
fuse-use-release_pages.patch
kernel-resourcec-handle-reinsertion-of-an-already-inserted-resource.patch
ramoops-use-the-platform-data-structure-instead-of-module-params-fix.patch
select-rename-estimate_accuracy-to-select_estimate_accuracy.patch

