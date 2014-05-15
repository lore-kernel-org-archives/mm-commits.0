From: akpm@linux-foundation.org
Subject: [merged]
 kernel-rcu-treec-make-rcu-node-arrays-static-const-char-const.patch removed from -mm tree
Date: Thu, 15 May 2014 12:22:01 -0700
Message-ID: <537513d9.lCq5/YfWLPLUQZMg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36283 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbaEOTWD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 May 2014 15:22:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paulmck@us.ibm.com, dipankar@in.ibm.com, fabf@skynet.be

Subject: [merged] kernel-rcu-treec-make-rcu-node-arrays-static-const-char-const.patch removed from -mm tree
To: fabf@skynet.be,dipankar@in.ibm.com,paulmck@us.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 15 May 2014 12:22:01 -0700


The patch titled
     Subject: kernel/rcu/tree.c: make rcu node arrays static const char * const
has been removed from the -mm tree.  Its filename was
     kernel-rcu-treec-make-rcu-node-arrays-static-const-char-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: kernel/rcu/tree.c: make rcu node arrays static const char * const

Those 2 arrays are being passed to lockdep_init_map with const char *
and stored in lockdep_map the same way

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcu/tree.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff -puN kernel/rcu/tree.c~kernel-rcu-treec-make-rcu-node-arrays-static-const-char-const kernel/rcu/tree.c
--- a/kernel/rcu/tree.c~kernel-rcu-treec-make-rcu-node-arrays-static-const-char-const
+++ a/kernel/rcu/tree.c
@@ -3468,14 +3468,16 @@ static void __init rcu_init_levelspread(
 static void __init rcu_init_one(struct rcu_state *rsp,
 		struct rcu_data __percpu *rda)
 {
-	static char *buf[] = { "rcu_node_0",
-			       "rcu_node_1",
-			       "rcu_node_2",
-			       "rcu_node_3" };  /* Match MAX_RCU_LVLS */
-	static char *fqs[] = { "rcu_node_fqs_0",
-			       "rcu_node_fqs_1",
-			       "rcu_node_fqs_2",
-			       "rcu_node_fqs_3" };  /* Match MAX_RCU_LVLS */
+	static const char * const buf[] = {
+		"rcu_node_0",
+		"rcu_node_1",
+		"rcu_node_2",
+		"rcu_node_3" };  /* Match MAX_RCU_LVLS */
+	static const char * const fqs[] = {
+		"rcu_node_fqs_0",
+		"rcu_node_fqs_1",
+		"rcu_node_fqs_2",
+		"rcu_node_fqs_3" };  /* Match MAX_RCU_LVLS */
 	int cpustride = 1;
 	int i;
 	int j;
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-ceph-debugfsc-replace-seq_printf-by-seq_puts.patch
fs-cifs-remove-obsolete-__constant.patch
fs-jfs-jfs_logmgrc-remove-null-assignment-on-static.patch
fs-jfs-superc-remove-0-assignement-to-static-code-clean-up.patch
fs-fscache-convert-printk-to-pr_foo.patch
fs-fscache-replace-seq_printf-by-seq_puts.patch
fs-gfs2-bmapc-kernel-doc-warning-fixes.patch
fs-dlm-configc-convert-simple_str-to-kstr.patch
fs-dlm-lockspacec-convert-simple_str-to-kstr.patch
fs-dlm-debug_fsc-replace-seq_printf-by-seq_puts.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kernel-time-ntpc-convert-simple_strtol-to-kstrtol.patch
ntfs-remove-null-value-assignments.patch
fs-squashfs-squashfsh-replace-pr_warning-by-pr_warn.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1-fix.patch
arch-unicore32-mm-ioremapc-return-null-on-invalid-pfn.patch
fs-configs-itemc-kernel-doc-fixes-clean-up.patch
fs-configfs-convert-printk-to-pr_foo.patch
fs-configfs-use-pr_fmt.patch
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
fs-efivarfs-superc-use-static-const-for-dentry_operations.patch
fs-exportfs-expfsc-kernel-doc-warning-fixes.patch
kernel-cpuc-convert-printk-to-pr_foo.patch
kernel-backtracetestc-replace-no-level-printk-by-pr_info.patch
kernel-capabilityc-code-clean-up.patch
kernel-exec_domainc-code-clean-up.patch
kernel-latencytopc-convert-seq_printf-to-seq_puts.patch
kernel-stop_machinec-kernel-doc-warning-fix.patch
kernel-tracepointc-kernel-doc-fixes.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull-fix.patch
kernel-rebootc-convert-simple_strtoul-to-kstrtoint.patch
kernel-utsname_sysctlc-replace-obsolete-__initcall-by-device_initcall.patch
kernel-hung_taskc-convert-simple_strtoul-to-kstrtouint.patch
documentation-expand-clarify-debug-documentation.patch
lib-libcrc32cc-use-ptr_err_or_zero.patch
lib-vsprintfc-fix-comparison-to-bool.patch
kernel-compatc-use-sizeof-instead-of-sizeof.patch
fs-efs-convert-printk-to-pr_foo.patch
fs-efs-add-pr_fmt-use-__func__.patch
fs-efs-convert-printkkern_debug-to-pr_debug.patch
fs-binfmt_elfc-fix-bool-assignements.patch
fs-autofs4-dev-ioctlc-add-__init-to-autofs_dev_ioctl_init.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-coda-replace-printk-by-pr_foo.patch
fs-coda-logging-prefix-uniformization.patch
fs-coda-use-__func__.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
kernel-kexecc-convert-printk-to-pr_foo.patch
kernel-user_namespacec-kernel-doc-checkpatch-fixes.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
kernel-profilec-convert-printk-to-pr_foo.patch
kernel-profilec-use-static-const-char-instead-of-static-char.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
fs-cachefiles-convert-printk-to-pr_foo.patch
fs-cachefiles-replace-kerror-by-pr_err.patch
fs-devpts-inodec-convert-printk-to-pr_foo.patch
kernel-seccompc-kernel-doc-warning-fix.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-reiserfs-streec-remove-obsolete-__constant.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
ufs-sb-mutex-merge-mutex_destroy.patch

