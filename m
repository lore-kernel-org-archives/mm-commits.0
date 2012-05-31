From: akpm@linux-foundation.org
Subject: [folded] c-r-prctl-simplify-pr_set_mm-on-mm-code-data-assignment-fix.patch removed from -mm tree
Date: Thu, 31 May 2012 14:01:05 -0700
Message-ID: <20120531210105.6B52FA03CD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:48453 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab2EaVBH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 17:01:07 -0400
Received: by wibhn6 with SMTP id hn6so80719wib.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 14:01:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gorcunov@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, keescook@chromium.org, serge.hallyn@canonical.com, tj@kernel.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: c-r-prctl-simplify-pr_set_mm-on-mm-code-data-assignment-fix
has been removed from the -mm tree.  Its filename was
     c-r-prctl-simplify-pr_set_mm-on-mm-code-data-assignment-fix.patch

This patch was dropped because it was folded into c-r-prctl-simplify-pr_set_mm-on-mm-code-data-assignment.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: c-r-prctl-simplify-pr_set_mm-on-mm-code-data-assignment-fix

restore lost initialization of `error'

Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/sys.c~c-r-prctl-simplify-pr_set_mm-on-mm-code-data-assignment-fix kernel/sys.c
--- a/kernel/sys.c~c-r-prctl-simplify-pr_set_mm-on-mm-code-data-assignment-fix
+++ a/kernel/sys.c
@@ -1727,6 +1727,8 @@ static int prctl_set_mm(int opt, unsigne
 	if (addr >= TASK_SIZE)
 		return -EINVAL;
 
+	error = -EINVAL;
+
 	down_read(&mm->mmap_sem);
 	vma = find_vma(mm, addr);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
isdn-add-missing-kern_cont-fix.patch
kernel-irq-managec-use-the-pr_foo-infrastructure-to-prefix-printks.patch
vsprintf-correctly-handle-width-when-flag-used-in-%p-format-checkpatch-fixes.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
proc-clean-up-proc-pid-environ-handling-checkpatch-fixes.patch
kernel-cpuc-document-clear_tasks_mm_cpumask.patch
kernel-cpuc-document-clear_tasks_mm_cpumask-fix.patch
ipc-mqueue-improve-performance-of-send-recv-fix.patch
ipc-mqueue-correct-mq_attr_ok-test-fix.patch
ipc-mqueue-strengthen-checks-on-mqueue-creation-fix.patch
tools-selftests-add-mq_perf_tests-checkpatch-fixes.patch
ipc-mqueue-add-rbtree-node-caching-support-checkpatch-fixes.patch
pidns-make-killed-children-autoreap-checkpatch-fixes.patch
fs-nls-add-apple-nls-fix.patch
eventfd-change-int-to-__u64-in-eventfd_signal-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch
c-r-prctl-simplify-pr_set_mm-on-mm-code-data-assignment.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch

