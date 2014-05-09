From: akpm@linux-foundation.org
Subject: + kernel-user_namespacec-kernel-doc-checkpatch-fixes.patch added
 to -mm tree
Date: Fri, 09 May 2014 12:06:48 -0700
Message-ID: <536d2748.ql2LX2NqKHxG1/9T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55465 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756938AbaEITGt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2014 15:06:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, oleg@redhat.com, fabf@skynet.be

Subject: + kernel-user_namespacec-kernel-doc-checkpatch-fixes.patch added to -mm tree
To: fabf@skynet.be,oleg@redhat.com
From: akpm@linux-foundation.org
Date: Fri, 09 May 2014 12:06:48 -0700


The patch titled
     Subject: kernel/user_namespace.c: kernel-doc/checkpatch fixes
has been added to the -mm tree.  Its filename is
     kernel-user_namespacec-kernel-doc-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-user_namespacec-kernel-doc-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-user_namespacec-kernel-doc-checkpatch-fixes.patch

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
Subject: kernel/user_namespace.c: kernel-doc/checkpatch fixes

-uid->gid
-split some function declarations
-if/then/else warning

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/user_namespace.c |   33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff -puN kernel/user_namespace.c~kernel-user_namespacec-kernel-doc-checkpatch-fixes kernel/user_namespace.c
--- a/kernel/user_namespace.c~kernel-user_namespacec-kernel-doc-checkpatch-fixes
+++ a/kernel/user_namespace.c
@@ -286,7 +286,7 @@ EXPORT_SYMBOL(from_kuid_munged);
 /**
  *	make_kgid - Map a user-namespace gid pair into a kgid.
  *	@ns:  User namespace that the gid is in
- *	@uid: group identifier
+ *	@gid: group identifier
  *
  *	Maps a user-namespace gid pair into a kernel internal kgid,
  *	and returns that kgid.
@@ -482,7 +482,8 @@ static int projid_m_show(struct seq_file
 	return 0;
 }
 
-static void *m_start(struct seq_file *seq, loff_t *ppos, struct uid_gid_map *map)
+static void *m_start(struct seq_file *seq, loff_t *ppos,
+		     struct uid_gid_map *map)
 {
 	struct uid_gid_extent *extent = NULL;
 	loff_t pos = *ppos;
@@ -546,7 +547,8 @@ struct seq_operations proc_projid_seq_op
 	.show = projid_m_show,
 };
 
-static bool mappings_overlap(struct uid_gid_map *new_map, struct uid_gid_extent *extent)
+static bool mappings_overlap(struct uid_gid_map *new_map,
+			     struct uid_gid_extent *extent)
 {
 	u32 upper_first, lower_first, upper_last, lower_last;
 	unsigned idx;
@@ -653,7 +655,7 @@ static ssize_t map_write(struct file *fi
 	ret = -EINVAL;
 	pos = kbuf;
 	new_map.nr_extents = 0;
-	for (;pos; pos = next_line) {
+	for (; pos; pos = next_line) {
 		extent = &new_map.extent[new_map.nr_extents];
 
 		/* Find the end of line and ensure I don't look past it */
@@ -687,13 +689,16 @@ static ssize_t map_write(struct file *fi
 
 		/* Verify we have been given valid starting values */
 		if ((extent->first == (u32) -1) ||
-		    (extent->lower_first == (u32) -1 ))
+		    (extent->lower_first == (u32) -1))
 			goto out;
 
-		/* Verify count is not zero and does not cause the extent to wrap */
+		/* Verify count is not zero and does not cause the
+		 * extent to wrap
+		 */
 		if ((extent->first + extent->count) <= extent->first)
 			goto out;
-		if ((extent->lower_first + extent->count) <= extent->lower_first)
+		if ((extent->lower_first + extent->count) <=
+		     extent->lower_first)
 			goto out;
 
 		/* Do the ranges in extent overlap any previous extents? */
@@ -751,7 +756,8 @@ out:
 	return ret;
 }
 
-ssize_t proc_uid_map_write(struct file *file, const char __user *buf, size_t size, loff_t *ppos)
+ssize_t proc_uid_map_write(struct file *file, const char __user *buf,
+			   size_t size, loff_t *ppos)
 {
 	struct seq_file *seq = file->private_data;
 	struct user_namespace *ns = seq->private;
@@ -767,7 +773,8 @@ ssize_t proc_uid_map_write(struct file *
 			 &ns->uid_map, &ns->parent->uid_map);
 }
 
-ssize_t proc_gid_map_write(struct file *file, const char __user *buf, size_t size, loff_t *ppos)
+ssize_t proc_gid_map_write(struct file *file, const char __user *buf,
+			   size_t size, loff_t *ppos)
 {
 	struct seq_file *seq = file->private_data;
 	struct user_namespace *ns = seq->private;
@@ -783,7 +790,8 @@ ssize_t proc_gid_map_write(struct file *
 			 &ns->gid_map, &ns->parent->gid_map);
 }
 
-ssize_t proc_projid_map_write(struct file *file, const char __user *buf, size_t size, loff_t *ppos)
+ssize_t proc_projid_map_write(struct file *file, const char __user *buf,
+			      size_t size, loff_t *ppos)
 {
 	struct seq_file *seq = file->private_data;
 	struct user_namespace *ns = seq->private;
@@ -800,7 +808,7 @@ ssize_t proc_projid_map_write(struct fil
 			 &ns->projid_map, &ns->parent->projid_map);
 }
 
-static bool new_idmap_permitted(const struct file *file, 
+static bool new_idmap_permitted(const struct file *file,
 				struct user_namespace *ns, int cap_setid,
 				struct uid_gid_map *new_map)
 {
@@ -811,8 +819,7 @@ static bool new_idmap_permitted(const st
 			kuid_t uid = make_kuid(ns->parent, id);
 			if (uid_eq(uid, file->f_cred->fsuid))
 				return true;
-		}
-		else if (cap_setid == CAP_SETGID) {
+		} else if (cap_setid == CAP_SETGID) {
 			kgid_t gid = make_kgid(ns->parent, id);
 			if (gid_eq(gid, file->f_cred->fsgid))
 				return true;
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

