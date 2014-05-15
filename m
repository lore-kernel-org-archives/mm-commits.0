From: akpm@linux-foundation.org
Subject: + fs-hpfs-use-__func__-for-logging.patch added to -mm tree
Date: Thu, 15 May 2014 12:56:12 -0700
Message-ID: <53751bdc.5TLXVw6qXgEmVVqT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36983 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbaEOT4N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 May 2014 15:56:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mikulas@artax.karlin.mff.cuni.cz, fabf@skynet.be

Subject: + fs-hpfs-use-__func__-for-logging.patch added to -mm tree
To: fabf@skynet.be,mikulas@artax.karlin.mff.cuni.cz
From: akpm@linux-foundation.org
Date: Thu, 15 May 2014 12:56:12 -0700


The patch titled
     Subject: fs/hpfs: use __func__ for logging
has been added to the -mm tree.  Its filename is
     fs-hpfs-use-__func__-for-logging.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-hpfs-use-__func__-for-logging.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-hpfs-use-__func__-for-logging.patch

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
Subject: fs/hpfs: use __func__ for logging

Normalize function display fx() using __func__

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hpfs/buffer.c |   12 ++++++------
 fs/hpfs/dnode.c  |   12 ++++++------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff -puN fs/hpfs/buffer.c~fs-hpfs-use-__func__-for-logging fs/hpfs/buffer.c
--- a/fs/hpfs/buffer.c~fs-hpfs-use-__func__-for-logging
+++ a/fs/hpfs/buffer.c
@@ -55,7 +55,7 @@ void *hpfs_map_sector(struct super_block
 	if (bh != NULL)
 		return bh->b_data;
 	else {
-		pr_warn("hpfs_map_sector: read error\n");
+		pr_warn("%s(): read error\n", __func__);
 		return NULL;
 	}
 }
@@ -76,7 +76,7 @@ void *hpfs_get_sector(struct super_block
 		set_buffer_uptodate(bh);
 		return bh->b_data;
 	} else {
-		pr_warn("hpfs_get_sector: getblk failed\n");
+		pr_warn("%s(): getblk failed\n", __func__);
 		return NULL;
 	}
 }
@@ -93,7 +93,7 @@ void *hpfs_map_4sectors(struct super_blo
 	cond_resched();
 
 	if (secno & 3) {
-		pr_warn("hpfs_map_4sectors: unaligned read\n");
+		pr_warn("%s(): unaligned read\n", __func__);
 		return NULL;
 	}
 
@@ -112,7 +112,7 @@ void *hpfs_map_4sectors(struct super_blo
 
 	qbh->data = data = kmalloc(2048, GFP_NOFS);
 	if (!data) {
-		pr_warn("hpfs_map_4sectors: out of memory\n");
+		pr_warn("%s(): out of memory\n", __func__);
 		goto bail4;
 	}
 
@@ -145,7 +145,7 @@ void *hpfs_get_4sectors(struct super_blo
 	hpfs_lock_assert(s);
 
 	if (secno & 3) {
-		pr_warn("hpfs_get_4sectors: unaligned read\n");
+		pr_warn("%s(): unaligned read\n", __func__);
 		return NULL;
 	}
 
@@ -161,7 +161,7 @@ void *hpfs_get_4sectors(struct super_blo
 	}
 
 	if (!(qbh->data = kmalloc(2048, GFP_NOFS))) {
-		pr_warn("hpfs_get_4sectors: out of memory\n");
+		pr_warn("%s(): out of memory\n", __func__);
 		goto bail4;
 	}
 	return qbh->data;
diff -puN fs/hpfs/dnode.c~fs-hpfs-use-__func__-for-logging fs/hpfs/dnode.c
--- a/fs/hpfs/dnode.c~fs-hpfs-use-__func__-for-logging
+++ a/fs/hpfs/dnode.c
@@ -17,7 +17,7 @@ static loff_t get_pos(struct dnode *d, s
 		if (de == fde) return ((loff_t) le32_to_cpu(d->self) << 4) | (loff_t)i;
 		i++;
 	}
-	pr_info("get_pos: not_found\n");
+	pr_info("%s(): not_found\n", __func__);
 	return ((loff_t)le32_to_cpu(d->self) << 4) | (loff_t)1;
 }
 
@@ -94,8 +94,8 @@ static void hpfs_pos_ins(loff_t *p, loff
 	if ((*p & ~0x3f) == (d & ~0x3f) && (*p & 0x3f) >= (d & 0x3f)) {
 		int n = (*p & 0x3f) + c;
 		if (n > 0x3f)
-			pr_warn("hpfs_pos_ins: %08x + %d\n",
-				(int)*p, (int)c >> 8);
+			pr_warn("%s(): %08x + %d\n",
+				__func__, (int)*p, (int)c >> 8);
 		else
 			*p = (*p & ~0x3f) | n;
 	}
@@ -106,8 +106,8 @@ static void hpfs_pos_del(loff_t *p, loff
 	if ((*p & ~0x3f) == (d & ~0x3f) && (*p & 0x3f) >= (d & 0x3f)) {
 		int n = (*p & 0x3f) - c;
 		if (n < 1)
-			pr_warn("hpfs_pos_ins: %08x - %d\n",
-				(int)*p, (int)c >> 8);
+			pr_warn("%s(): %08x - %d\n",
+				__func__, (int)*p, (int)c >> 8);
 		else
 			*p = (*p & ~0x3f) | n;
 	}
@@ -251,7 +251,7 @@ static int hpfs_add_to_dnode(struct inod
 	}
 	go_up:
 	if (namelen >= 256) {
-		hpfs_error(i->i_sb, "hpfs_add_to_dnode: namelen == %d", namelen);
+		hpfs_error(i->i_sb, "%s(): namelen == %d", __func__, namelen);
 		kfree(nd);
 		kfree(nname);
 		return 1;
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
fs-add-generic-data-flush-to-fsync.patch
fs-add-generic-data-flush-to-fsync-fix.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
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
fs-hpfs-convert-printk-to-pr_foo.patch
fs-hpfs-use-pr_fmt-for-logging.patch
fs-hpfs-use-__func__-for-logging.patch
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

