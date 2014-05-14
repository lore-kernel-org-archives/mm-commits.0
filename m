From: akpm@linux-foundation.org
Subject: + fs-dlm-debug_fsc-replace-seq_printf-by-seq_puts.patch added to
 -mm tree
Date: Wed, 14 May 2014 16:59:29 -0700
Message-ID: <53740361.zob9aqH5UmhLBJvC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49383 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaENX7a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 May 2014 19:59:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ccaulfie@redhat.com, fabf@skynet.be

Subject: + fs-dlm-debug_fsc-replace-seq_printf-by-seq_puts.patch added to -mm tree
To: fabf@skynet.be,ccaulfie@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 14 May 2014 16:59:29 -0700


The patch titled
     Subject: fs/dlm/debug_fs.c: replace seq_printf by seq_puts
has been added to the -mm tree.  Its filename is
     fs-dlm-debug_fsc-replace-seq_printf-by-seq_puts.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-dlm-debug_fsc-replace-seq_printf-by-seq_puts.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-dlm-debug_fsc-replace-seq_printf-by-seq_puts.patch

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
Subject: fs/dlm/debug_fs.c: replace seq_printf by seq_puts

Replace seq_printf where possible.  This patch also fixes the following
checkpatch warning "unnecessary whitespace before a quoted newline"

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Christine Caulfield <ccaulfie@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dlm/debug_fs.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff -puN fs/dlm/debug_fs.c~fs-dlm-debug_fsc-replace-seq_printf-by-seq_puts fs/dlm/debug_fs.c
--- a/fs/dlm/debug_fs.c~fs-dlm-debug_fsc-replace-seq_printf-by-seq_puts
+++ a/fs/dlm/debug_fs.c
@@ -68,7 +68,7 @@ static int print_format1_lock(struct seq
 	if (lkb->lkb_wait_type)
 		seq_printf(s, " wait_type: %d", lkb->lkb_wait_type);
 
-	return seq_printf(s, "\n");
+	return seq_puts(s, "\n");
 }
 
 static int print_format1(struct dlm_rsb *res, struct seq_file *s)
@@ -92,31 +92,31 @@ static int print_format1(struct dlm_rsb
 	}
 
 	if (res->res_nodeid > 0)
-		rv = seq_printf(s, "\"  \nLocal Copy, Master is node %d\n",
+		rv = seq_printf(s, "\"\nLocal Copy, Master is node %d\n",
 				res->res_nodeid);
 	else if (res->res_nodeid == 0)
-		rv = seq_printf(s, "\"  \nMaster Copy\n");
+		rv = seq_puts(s, "\"\nMaster Copy\n");
 	else if (res->res_nodeid == -1)
-		rv = seq_printf(s, "\"  \nLooking up master (lkid %x)\n",
+		rv = seq_printf(s, "\"\nLooking up master (lkid %x)\n",
 			   	res->res_first_lkid);
 	else
-		rv = seq_printf(s, "\"  \nInvalid master %d\n",
+		rv = seq_printf(s, "\"\nInvalid master %d\n",
 				res->res_nodeid);
 	if (rv)
 		goto out;
 
 	/* Print the LVB: */
 	if (res->res_lvbptr) {
-		seq_printf(s, "LVB: ");
+		seq_puts(s, "LVB: ");
 		for (i = 0; i < lvblen; i++) {
 			if (i == lvblen / 2)
-				seq_printf(s, "\n     ");
+				seq_puts(s, "\n     ");
 			seq_printf(s, "%02x ",
 				   (unsigned char) res->res_lvbptr[i]);
 		}
 		if (rsb_flag(res, RSB_VALNOTVALID))
-			seq_printf(s, " (INVALID)");
-		rv = seq_printf(s, "\n");
+			seq_puts(s, " (INVALID)");
+		rv = seq_puts(s, "\n");
 		if (rv)
 			goto out;
 	}
@@ -133,21 +133,21 @@ static int print_format1(struct dlm_rsb
 	}
 
 	/* Print the locks attached to this resource */
-	seq_printf(s, "Granted Queue\n");
+	seq_puts(s, "Granted Queue\n");
 	list_for_each_entry(lkb, &res->res_grantqueue, lkb_statequeue) {
 		rv = print_format1_lock(s, lkb, res);
 		if (rv)
 			goto out;
 	}
 
-	seq_printf(s, "Conversion Queue\n");
+	seq_puts(s, "Conversion Queue\n");
 	list_for_each_entry(lkb, &res->res_convertqueue, lkb_statequeue) {
 		rv = print_format1_lock(s, lkb, res);
 		if (rv)
 			goto out;
 	}
 
-	seq_printf(s, "Waiting Queue\n");
+	seq_puts(s, "Waiting Queue\n");
 	list_for_each_entry(lkb, &res->res_waitqueue, lkb_statequeue) {
 		rv = print_format1_lock(s, lkb, res);
 		if (rv)
@@ -157,13 +157,13 @@ static int print_format1(struct dlm_rsb
 	if (list_empty(&res->res_lookup))
 		goto out;
 
-	seq_printf(s, "Lookup Queue\n");
+	seq_puts(s, "Lookup Queue\n");
 	list_for_each_entry(lkb, &res->res_lookup, lkb_rsb_lookup) {
 		rv = seq_printf(s, "%08x %s", lkb->lkb_id,
 				print_lockmode(lkb->lkb_rqmode));
 		if (lkb->lkb_wait_type)
 			seq_printf(s, " wait_type: %d", lkb->lkb_wait_type);
-		rv = seq_printf(s, "\n");
+		rv = seq_puts(s, "\n");
 	}
  out:
 	unlock_rsb(res);
@@ -300,7 +300,7 @@ static int print_format3(struct dlm_rsb
 		else
 			seq_printf(s, " %02x", (unsigned char)r->res_name[i]);
 	}
-	rv = seq_printf(s, "\n");
+	rv = seq_puts(s, "\n");
 	if (rv)
 		goto out;
 
@@ -311,7 +311,7 @@ static int print_format3(struct dlm_rsb
 
 	for (i = 0; i < lvblen; i++)
 		seq_printf(s, " %02x", (unsigned char)r->res_lvbptr[i]);
-	rv = seq_printf(s, "\n");
+	rv = seq_puts(s, "\n");
 	if (rv)
 		goto out;
 
@@ -377,7 +377,7 @@ static int print_format4(struct dlm_rsb
 		else
 			seq_printf(s, " %02x", (unsigned char)r->res_name[i]);
 	}
-	rv = seq_printf(s, "\n");
+	rv = seq_puts(s, "\n");
  out:
 	unlock_rsb(r);
 	return rv;
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
kernel-rcu-treec-make-rcu-node-arrays-static-const-char-const.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-reiserfs-streec-remove-obsolete-__constant.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
ufs-sb-mutex-merge-mutex_destroy.patch

