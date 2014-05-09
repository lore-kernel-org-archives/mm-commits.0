From: akpm@linux-foundation.org
Subject: + kernel-hung_taskc-convert-simple_strtoul-to-kstrtouint.patch
 added to -mm tree
Date: Fri, 09 May 2014 12:06:50 -0700
Message-ID: <536d274a./LJw9Kgv+DNlrlTW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55471 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756986AbaEITGv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2014 15:06:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mingo@kernel.org, fabf@skynet.be

Subject: + kernel-hung_taskc-convert-simple_strtoul-to-kstrtouint.patch added to -mm tree
To: fabf@skynet.be,mingo@kernel.org
From: akpm@linux-foundation.org
Date: Fri, 09 May 2014 12:06:50 -0700


The patch titled
     Subject: kernel/hung_task.c: convert simple_strtoul to kstrtouint
has been added to the -mm tree.  Its filename is
     kernel-hung_taskc-convert-simple_strtoul-to-kstrtouint.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-hung_taskc-convert-simple_strtoul-to-kstrtouint.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-hung_taskc-convert-simple_strtoul-to-kstrtouint.patch

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
Subject: kernel/hung_task.c: convert simple_strtoul to kstrtouint

sysctl_hung_task_panic has been changed to unsigned int.  use kstrtouint
instead of obsolete simple_strtoul

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hung_task.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/hung_task.c~kernel-hung_taskc-convert-simple_strtoul-to-kstrtouint kernel/hung_task.c
--- a/kernel/hung_task.c~kernel-hung_taskc-convert-simple_strtoul-to-kstrtouint
+++ a/kernel/hung_task.c
@@ -52,8 +52,10 @@ unsigned int __read_mostly sysctl_hung_t
 
 static int __init hung_task_panic_setup(char *str)
 {
-	sysctl_hung_task_panic = simple_strtoul(str, NULL, 0);
+	int rc = kstrtouint(str, 0, &sysctl_hung_task_panic);
 
+	if (rc)
+		return rc;
 	return 1;
 }
 __setup("hung_task_panic=", hung_task_panic_setup);
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-ceph-debugfsc-replace-seq_printf-by-seq_puts.patch
fs-cifs-remove-obsolete-__constant.patch
fs-jfs-jfs_logmgrc-remove-null-assignment-on-static.patch
fs-jfs-superc-remove-0-assignement-to-static-code-clean-up.patch
fs-fscache-convert-printk-to-pr_foo.patch
fs-fscache-replace-seq_printf-by-seq_puts.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
ntfs-remove-null-value-assignments.patch
fs-squashfs-squashfsh-replace-pr_warning-by-pr_warn.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1-fix.patch
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
mm-mempolicyc-parameter-doc-uniformization.patch
mm-zbudc-make-size-unsigned-like-unique-callsite.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
kernel-cpuc-convert-printk-to-pr_foo.patch
kernel-backtracetestc-replace-no-level-printk-by-pr_info.patch
kernel-capabilityc-code-clean-up.patch
kernel-exec_domainc-code-clean-up.patch
kernel-latencytopc-convert-seq_printf-to-seq_puts.patch
kernel-stop_machinec-kernel-doc-warning-fix.patch
kernel-tracepointc-kernel-doc-fixes.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull-fix.patch
documentation-expand-clarify-debug-documentation.patch
lib-libcrc32cc-use-ptr_err_or_zero.patch
lib-vsprintfc-fix-comparison-to-bool.patch
kernel-compatc-use-sizeof-instead-of-sizeof.patch
fs-binfmt_elfc-fix-bool-assignements.patch
fs-autofs4-dev-ioctlc-add-__init-to-autofs_dev_ioctl_init.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-reiserfs-streec-remove-obsolete-__constant.patch
kernel-kexecc-convert-printk-to-pr_foo.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
kernel-profilec-convert-printk-to-pr_foo.patch
kernel-profilec-use-static-const-char-instead-of-static-char.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
kernel-seccompc-kernel-doc-warning-fix.patch
linux-next.patch
init-mainc-code-clean-up.patch
kernel-rcu-treec-make-rcu-node-arrays-static-const-char-const.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
ufs-sb-mutex-merge-mutex_destroy.patch
kernel-rebootc-convert-simple_strtoul-to-kstrtoint.patch
kernel-time-ntpc-convert-simple_strtol-to-kstrtol.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
kernel-utsname_sysctlc-replace-obsolete-__initcall-by-device_initcall.patch
kernel-user_namespacec-kernel-doc-checkpatch-fixes.patch
kernel-power-hibernatec-convert-simple_strtoul-to-kstrtoul.patch
kernel-hung_taskc-convert-simple_strtoul-to-kstrtouint.patch

