From: akpm@linux-foundation.org
Subject: + proc-clean-up-proc-pid-environ-handling-checkpatch-fixes.patch added to -mm tree
Date: Wed, 11 Apr 2012 17:49:22 -0700
Message-ID: <20120412004923.16456A03A5@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:47132 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654Ab2DLAtZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Apr 2012 20:49:25 -0400
Received: by qcsp5 with SMTP id p5so195952qcs.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Apr 2012 17:49:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, xiyou.wangcong@gmail.com


The patch titled
     Subject: proc-clean-up-proc-pid-environ-handling-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     proc-clean-up-proc-pid-environ-handling-checkpatch-fixes.patch

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
Subject: Subject: proc-clean-up-proc-pid-environ-handling-checkpatch-fixes

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
percpu-remove-percpu_xxx-functions-fix.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
brlocks-lglocks-cleanups.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
leds-led-module-for-da9052-53-pmic-v2-fix.patch
leds-add-led-driver-for-lm3556-chip-checkpatch-fixes.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
proc-clean-up-proc-pid-environ-handling-checkpatch-fixes.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

