From: akpm@linux-foundation.org
Subject: [merged] kernel-cpusetc-convert-printk-to-pr_foo.patch removed
 from -mm tree
Date: Wed, 07 May 2014 12:05:25 -0700
Message-ID: <536a83f5.t23PWj4uZSdJA0zt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56169 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaEGTF0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2014 15:05:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, lizefan@huawei.com, fabf@skynet.be

Subject: [merged] kernel-cpusetc-convert-printk-to-pr_foo.patch removed from -mm tree
To: fabf@skynet.be,lizefan@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 07 May 2014 12:05:25 -0700


The patch titled
     Subject: kernel/cpuset.c: convert printk to pr_foo()
has been removed from the -mm tree.  Its filename was
     kernel-cpusetc-convert-printk-to-pr_foo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: kernel/cpuset.c: convert printk to pr_foo()

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN kernel/cpuset.c~kernel-cpusetc-convert-printk-to-pr_foo kernel/cpuset.c
--- a/kernel/cpuset.c~kernel-cpusetc-convert-printk-to-pr_foo
+++ a/kernel/cpuset.c
@@ -696,11 +696,8 @@ restart:
 		if (nslot == ndoms) {
 			static int warnings = 10;
 			if (warnings) {
-				printk(KERN_WARNING
-				 "rebuild_sched_domains confused:"
-				  " nslot %d, ndoms %d, csn %d, i %d,"
-				  " apn %d\n",
-				  nslot, ndoms, csn, i, apn);
+				pr_warn("rebuild_sched_domains confused: nslot %d, ndoms %d, csn %d, i %d, apn %d\n",
+					nslot, ndoms, csn, i, apn);
 				warnings--;
 			}
 			continue;
@@ -2018,7 +2015,7 @@ static void remove_tasks_in_empty_cpuset
 		parent = parent_cs(parent);
 
 	if (cgroup_transfer_tasks(parent->css.cgroup, cs->css.cgroup)) {
-		printk(KERN_ERR "cpuset: failed to transfer tasks out of empty cpuset ");
+		pr_err("cpuset: failed to transfer tasks out of empty cpuset ");
 		pr_cont_cgroup_name(cs->css.cgroup);
 		pr_cont("\n");
 	}
@@ -2555,7 +2552,7 @@ void cpuset_print_task_mems_allowed(stru
 	cgrp = task_cs(tsk)->css.cgroup;
 	nodelist_scnprintf(cpuset_nodelist, CPUSET_NODELIST_LEN,
 			   tsk->mems_allowed);
-	printk(KERN_INFO "%s cpuset=", tsk->comm);
+	pr_info("%s cpuset=", tsk->comm);
 	pr_cont_cgroup_name(cgrp);
 	pr_cont(" mems_allowed=%s\n", cpuset_nodelist);
 
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
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
linux-next.patch
init-mainc-code-clean-up.patch
kernel-rcu-treec-make-rcu-node-arrays-static-const-char-const.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
ufs-sb-mutex-merge-mutex_destroy.patch

