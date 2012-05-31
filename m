From: akpm@linux-foundation.org
Subject: [folded] proc-clean-up-proc-pid-environ-handling-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 31 May 2012 16:15:05 -0700
Message-ID: <20120531231506.035BAA009B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:46011 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758577Ab2EaXPM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 19:15:12 -0400
Received: by yhgm50 with SMTP id m50so178204yhg.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 16:15:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc-clean-up-proc-pid-environ-handling-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     proc-clean-up-proc-pid-environ-handling-checkpatch-fixes.patch

This patch was dropped because it was folded into proc-clean-up-proc-pid-environ-handling.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: proc-clean-up-proc-pid-environ-handling-checkpatch-fixes

ERROR: "foo* bar" should be "foo *bar"
#26: FILE: fs/proc/base.c:680:
+static int __mem_open(struct inode* inode, struct file* file, unsigned int mode)

ERROR: "foo* bar" should be "foo *bar"
#26: FILE: fs/proc/base.c:680:
+static int __mem_open(struct inode* inode, struct file* file, unsigned int mode)

ERROR: "foo* bar" should be "foo *bar"
#43: FILE: fs/proc/base.c:708:
+static int mem_open(struct inode* inode, struct file* file)

ERROR: "foo* bar" should be "foo *bar"
#43: FILE: fs/proc/base.c:708:
+static int mem_open(struct inode* inode, struct file* file)

ERROR: "foo* bar" should be "foo *bar"
#55: FILE: fs/proc/base.c:809:
+static int environ_open(struct inode* inode, struct file* file)

ERROR: "foo* bar" should be "foo *bar"
#55: FILE: fs/proc/base.c:809:
+static int environ_open(struct inode* inode, struct file* file)

total: 6 errors, 0 warnings, 100 lines checked

./patches/proc-clean-up-proc-pid-environ-handling.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/proc/base.c~proc-clean-up-proc-pid-environ-handling-checkpatch-fixes fs/proc/base.c
--- a/fs/proc/base.c~proc-clean-up-proc-pid-environ-handling-checkpatch-fixes
+++ a/fs/proc/base.c
@@ -677,7 +677,7 @@ static const struct file_operations proc
 	.release	= single_release,
 };
 
-static int __mem_open(struct inode* inode, struct file* file, unsigned int mode)
+static int __mem_open(struct inode *inode, struct file *file, unsigned int mode)
 {
 	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
 	struct mm_struct *mm;
@@ -705,7 +705,7 @@ static int __mem_open(struct inode* inod
 	return 0;
 }
 
-static int mem_open(struct inode* inode, struct file* file)
+static int mem_open(struct inode *inode, struct file *file)
 {
 	return __mem_open(inode, file, PTRACE_MODE_ATTACH);
 }
@@ -806,7 +806,7 @@ static const struct file_operations proc
 	.release	= mem_release,
 };
 
-static int environ_open(struct inode* inode, struct file* file)
+static int environ_open(struct inode *inode, struct file *file)
 {
 	return __mem_open(inode, file, PTRACE_MODE_READ);
 }
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

