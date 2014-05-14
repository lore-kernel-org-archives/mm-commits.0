From: akpm@linux-foundation.org
Subject: + fs-dlm-configc-convert-simple_str-to-kstr.patch added to -mm
 tree
Date: Wed, 14 May 2014 12:35:18 -0700
Message-ID: <5373c576.njQIuQ9FV+aiseDZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45905 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaENTfT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 May 2014 15:35:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ccaulfie@redhat.com, fabf@skynet.be

Subject: + fs-dlm-configc-convert-simple_str-to-kstr.patch added to -mm tree
To: fabf@skynet.be,ccaulfie@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 14 May 2014 12:35:18 -0700


The patch titled
     Subject: fs/dlm/config.c: convert simple_str to kstr
has been added to the -mm tree.  Its filename is
     fs-dlm-configc-convert-simple_str-to-kstr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-dlm-configc-convert-simple_str-to-kstr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-dlm-configc-convert-simple_str-to-kstr.patch

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
Subject: fs/dlm/config.c: convert simple_str to kstr

Replace obsolete functions

simple_strtoul/kstrtouint
simple_strtol/kstrtoint
(kstr __must_check requires the right function to be applied)

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Christine Caulfield <ccaulfie@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dlm/config.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff -puN fs/dlm/config.c~fs-dlm-configc-convert-simple_str-to-kstr fs/dlm/config.c
--- a/fs/dlm/config.c~fs-dlm-configc-convert-simple_str-to-kstr
+++ a/fs/dlm/config.c
@@ -157,11 +157,13 @@ static ssize_t cluster_set(struct dlm_cl
 			   const char *buf, size_t len)
 {
 	unsigned int x;
+	int rc;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-
-	x = simple_strtoul(buf, NULL, 0);
+	rc = kstrtouint(buf, 0, &x);
+	if (rc)
+		return rc;
 
 	if (check_zero && !x)
 		return -EINVAL;
@@ -730,7 +732,10 @@ static ssize_t comm_nodeid_read(struct d
 static ssize_t comm_nodeid_write(struct dlm_comm *cm, const char *buf,
 				 size_t len)
 {
-	cm->nodeid = simple_strtol(buf, NULL, 0);
+	int rc = kstrtoint(buf, 0, &cm->nodeid);
+
+	if (rc)
+		return rc;
 	return len;
 }
 
@@ -742,7 +747,10 @@ static ssize_t comm_local_read(struct dl
 static ssize_t comm_local_write(struct dlm_comm *cm, const char *buf,
 				size_t len)
 {
-	cm->local= simple_strtol(buf, NULL, 0);
+	int rc = kstrtoint(buf, 0, &cm->local);
+
+	if (rc)
+		return rc;
 	if (cm->local && !local_comm)
 		local_comm = cm;
 	return len;
@@ -846,7 +854,10 @@ static ssize_t node_nodeid_write(struct
 				 size_t len)
 {
 	uint32_t seq = 0;
-	nd->nodeid = simple_strtol(buf, NULL, 0);
+	int rc = kstrtoint(buf, 0, &nd->nodeid);
+
+	if (rc)
+		return rc;
 	dlm_comm_seq(nd->nodeid, &seq);
 	nd->comm_seq = seq;
 	return len;
@@ -860,7 +871,10 @@ static ssize_t node_weight_read(struct d
 static ssize_t node_weight_write(struct dlm_node *nd, const char *buf,
 				 size_t len)
 {
-	nd->weight = simple_strtol(buf, NULL, 0);
+	int rc = kstrtoint(buf, 0, &nd->weight);
+
+	if (rc)
+		return rc;
 	return len;
 }
 
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-ceph-debugfsc-replace-seq_printf-by-seq_puts.patch
fs-cifs-remove-obsolete-__constant.patch
fs-jfs-jfs_logmgrc-remove-null-assignment-on-static.patch
fs-jfs-superc-remove-0-assignement-to-static-code-clean-up.patch
fs-fscache-convert-printk-to-pr_foo.patch
fs-fscache-replace-seq_printf-by-seq_puts.patch
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
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-reiserfs-streec-remove-obsolete-__constant.patch
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
kernel-rcu-treec-make-rcu-node-arrays-static-const-char-const.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
ufs-sb-mutex-merge-mutex_destroy.patch
fs-gfs2-bmapc-kernel-doc-warning-fixes.patch
fs-dlm-configc-convert-simple_str-to-kstr.patch
fs-dlm-lockspacec-convert-simple_str-to-kstr.patch
fs-dlm-debug_fsc-replace-seq_printf-by-seq_puts.patch
fs-efivarfs-superc-use-static-const-for-dentry_operations.patch
fs-exportfs-expfsc-kernel-doc-warning-fixes.patch

