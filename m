From: akpm@linux-foundation.org
Subject: [folded] pidns-make-killed-children-autoreap-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 31 May 2012 16:19:07 -0700
Message-ID: <20120531231907.B11E4A009B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:56604 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758599Ab2EaXTI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 19:19:08 -0400
Received: by qabg24 with SMTP id g24so10059qab.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 16:19:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pidns-make-killed-children-autoreap-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     pidns-make-killed-children-autoreap-checkpatch-fixes.patch

This patch was dropped because it was folded into pidns-make-killed-children-autoreap.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: pidns-make-killed-children-autoreap-checkpatch-fixes

ERROR: need consistent spacing around '-' (ctx:WxV)
#36: FILE: kernel/pid_namespace.c:156:
+	me->sighand->action[SIGCHLD -1].sa.sa_handler = SIG_IGN;
 	                            ^

total: 1 errors, 0 warnings, 13 lines checked

./patches/pidns-make-killed-children-autoreap.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid_namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/pid_namespace.c~pidns-make-killed-children-autoreap-checkpatch-fixes kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~pidns-make-killed-children-autoreap-checkpatch-fixes
+++ a/kernel/pid_namespace.c
@@ -153,7 +153,7 @@ void zap_pid_ns_processes(struct pid_nam
 
 	/* Ignore SIGCHLD causing any terminated children to autoreap */
 	spin_lock_irq(&me->sighand->siglock);
-	me->sighand->action[SIGCHLD -1].sa.sa_handler = SIG_IGN;
+	me->sighand->action[SIGCHLD - 1].sa.sa_handler = SIG_IGN;
 	spin_unlock_irq(&me->sighand->siglock);
 
 	/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
isdn-add-missing-kern_cont.patch
kernel-irq-managec-use-the-pr_foo-infrastructure-to-prefix-printks.patch
vsprintf-correctly-handle-width-when-flag-used-in-%p-format.patch
vsprintf-further-optimize-decimal-conversion.patch
proc-clean-up-proc-pid-environ-handling.patch
kernel-cpuc-document-clear_tasks_mm_cpumask.patch
ipc-mqueue-improve-performance-of-send-recv.patch
ipc-mqueue-correct-mq_attr_ok-test.patch
ipc-mqueue-strengthen-checks-on-mqueue-creation.patch
tools-selftests-add-mq_perf_tests.patch
ipc-mqueue-add-rbtree-node-caching-support.patch
pidns-make-killed-children-autoreap.patch
fs-nls-add-apple-nls-fix.patch
eventfd-change-int-to-__u64-in-eventfd_signal-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch

