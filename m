From: akpm@linux-foundation.org
Subject: + kernel-backtracetestc-replace-no-level-printk-by-pr_info.patch
 added to -mm tree
Date: Mon, 05 May 2014 13:14:01 -0700
Message-ID: <5367f109.v4yauxaCuWOZ62fn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50711 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbaEEUOC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2014 16:14:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be

Subject: + kernel-backtracetestc-replace-no-level-printk-by-pr_info.patch added to -mm tree
To: fabf@skynet.be
From: akpm@linux-foundation.org
Date: Mon, 05 May 2014 13:14:01 -0700


The patch titled
     Subject: kernel/backtracetest.c: replace no level printk by pr_info()
has been added to the -mm tree.  Its filename is
     kernel-backtracetestc-replace-no-level-printk-by-pr_info.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-backtracetestc-replace-no-level-printk-by-pr_info.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-backtracetestc-replace-no-level-printk-by-pr_info.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: kernel/backtracetest.c: replace no level printk by pr_info()

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/backtracetest.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN kernel/backtracetest.c~kernel-backtracetestc-replace-no-level-printk-by-pr_info kernel/backtracetest.c
--- a/kernel/backtracetest.c~kernel-backtracetestc-replace-no-level-printk-by-pr_info
+++ a/kernel/backtracetest.c
@@ -19,8 +19,8 @@
 
 static void backtrace_test_normal(void)
 {
-	printk("Testing a backtrace from process context.\n");
-	printk("The following trace is a kernel self test and not a bug!\n");
+	pr_info("Testing a backtrace from process context.\n");
+	pr_info("The following trace is a kernel self test and not a bug!\n");
 
 	dump_stack();
 }
@@ -37,8 +37,8 @@ static DECLARE_TASKLET(backtrace_tasklet
 
 static void backtrace_test_irq(void)
 {
-	printk("Testing a backtrace from irq context.\n");
-	printk("The following trace is a kernel self test and not a bug!\n");
+	pr_info("Testing a backtrace from irq context.\n");
+	pr_info("The following trace is a kernel self test and not a bug!\n");
 
 	init_completion(&backtrace_work);
 	tasklet_schedule(&backtrace_tasklet);
@@ -51,8 +51,8 @@ static void backtrace_test_saved(void)
 	struct stack_trace trace;
 	unsigned long entries[8];
 
-	printk("Testing a saved backtrace.\n");
-	printk("The following trace is a kernel self test and not a bug!\n");
+	pr_info("Testing a saved backtrace.\n");
+	pr_info("The following trace is a kernel self test and not a bug!\n");
 
 	trace.nr_entries = 0;
 	trace.max_entries = ARRAY_SIZE(entries);
@@ -65,19 +65,19 @@ static void backtrace_test_saved(void)
 #else
 static void backtrace_test_saved(void)
 {
-	printk("Saved backtrace test skipped.\n");
+	pr_info("Saved backtrace test skipped.\n");
 }
 #endif
 
 static int backtrace_regression_test(void)
 {
-	printk("====[ backtrace testing ]===========\n");
+	pr_info("====[ backtrace testing ]===========\n");
 
 	backtrace_test_normal();
 	backtrace_test_irq();
 	backtrace_test_saved();
 
-	printk("====[ end of backtrace testing ]====\n");
+	pr_info("====[ end of backtrace testing ]====\n");
 	return 0;
 }
 
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-jfs-jfs_logmgrc-remove-null-assignment-on-static.patch
fs-jfs-superc-remove-0-assignement-to-static-code-clean-up.patch
ntfs-remove-null-value-assignments.patch
fs-squashfs-squashfsh-replace-pr_warning-by-pr_warn.patch
fs-configs-itemc-kernel-doc-fixes-clean-up.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
fs-9p-v9fsc-add-__init-to-v9fs_sysfs_init.patch
fs-9p-kerneldoc-fixes.patch
mm-slubc-convert-printk-to-pr_foo.patch
mm-slubc-convert-vnsprintf-static-to-va_format.patch
mm-memory_hotplugc-use-pfn_down.patch
mm-memblockc-use-pfn_down.patch
mm-memcontrolc-remove-null-assignment-on-static.patch
mm-vmallocc-replace-seq_printf-by-seq_puts.patch
mm-zbudc-make-size-unsigned-like-unique-callsite.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
lib-libcrc32cc-use-ptr_err_or_zero.patch
lib-vsprintfc-fix-comparison-to-bool.patch
fs-binfmt_elfc-fix-bool-assignements.patch
fs-autofs4-dev-ioctlc-add-__init-to-autofs_dev_ioctl_init.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
linux-next.patch
init-mainc-code-clean-up.patch
ufs-sb-mutex-merge-mutex_destroy.patch
kernel-cpuc-convert-printk-to-pr_foo.patch
kernel-backtracetestc-replace-no-level-printk-by-pr_info.patch
kernel-capabilityc-code-clean-up.patch
kernel-compatc-use-sizeof-instead-of-sizeof.patch
kernel-exec_domainc-code-clean-up.patch
kernel-kexecc-convert-printk-to-pr_foo.patch
kernel-cpusetc-kernel-doc-fixes.patch
kernel-cpusetc-convert-printk-to-pr_foo.patch

