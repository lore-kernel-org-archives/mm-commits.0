From: akpm@linux-foundation.org
Subject: + fs-efs-convert-printkkern_debug-to-pr_debug.patch added to -mm
 tree
Date: Wed, 14 May 2014 12:30:17 -0700
Message-ID: <5373c449.h6Q6wpBaDJZM9c6a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45846 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaENTaS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 May 2014 15:30:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, fabf@skynet.be

Subject: + fs-efs-convert-printkkern_debug-to-pr_debug.patch added to -mm tree
To: fabf@skynet.be,joe@perches.com
From: akpm@linux-foundation.org
Date: Wed, 14 May 2014 12:30:17 -0700


The patch titled
     Subject: fs/efs: convert printk(KERN_DEBUG to pr_debug
has been added to the -mm tree.  Its filename is
     fs-efs-convert-printkkern_debug-to-pr_debug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-efs-convert-printkkern_debug-to-pr_debug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-efs-convert-printkkern_debug-to-pr_debug.patch

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
Subject: fs/efs: convert printk(KERN_DEBUG to pr_debug

All KERN_DEBUG callsites being under #ifdef DEBUG we can safely convert
everything to pr_debug without changing current behaviour.

Remove #ifdef DEBUG around pr_debugs only (suggested by Joe Perches)

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/efs/dir.c   |    7 +++----
 fs/efs/inode.c |   18 ++++++------------
 fs/efs/super.c |   18 ++++++++----------
 3 files changed, 17 insertions(+), 26 deletions(-)

diff -puN fs/efs/dir.c~fs-efs-convert-printkkern_debug-to-pr_debug fs/efs/dir.c
--- a/fs/efs/dir.c~fs-efs-convert-printkkern_debug-to-pr_debug
+++ a/fs/efs/dir.c
@@ -71,10 +71,9 @@ static int efs_readdir(struct file *file
 			inodenum = be32_to_cpu(dirslot->inode);
 			namelen  = dirslot->namelen;
 			nameptr  = dirslot->name;
-
-#ifdef DEBUG
-			printk(KERN_DEBUG "EFS: readdir(): block %d slot %d/%d: inode %u, name \"%s\", namelen %u\n", block, slot, dirblock->slots-1, inodenum, nameptr, namelen);
-#endif
+			pr_debug("%s(): block %d slot %d/%d: inode %u, name \"%s\", namelen %u\n",
+				 __func__, block, slot, dirblock->slots-1,
+				 inodenum, nameptr, namelen);
 			if (!namelen)
 				continue;
 			/* found the next entry */
diff -puN fs/efs/inode.c~fs-efs-convert-printkkern_debug-to-pr_debug fs/efs/inode.c
--- a/fs/efs/inode.c~fs-efs-convert-printkkern_debug-to-pr_debug
+++ a/fs/efs/inode.c
@@ -138,12 +138,8 @@ struct inode *efs_iget(struct super_bloc
 	}
 
 	brelse(bh);
-   
-#ifdef DEBUG
-	printk(KERN_DEBUG "EFS: efs_iget(): inode %lu, extents %d, mode %o\n",
-		inode->i_ino, in->numextents, inode->i_mode);
-#endif
-
+	pr_debug("efs_iget(): inode %lu, extents %d, mode %o\n",
+		 inode->i_ino, in->numextents, inode->i_mode);
 	switch (inode->i_mode & S_IFMT) {
 		case S_IFDIR: 
 			inode->i_op = &efs_dir_inode_operations; 
@@ -239,9 +235,8 @@ efs_block_t efs_map_block(struct inode *
 		return 0;
 	}
 
-#ifdef DEBUG
-	printk(KERN_DEBUG "EFS: map_block(): indirect search for logical block %u\n", block);
-#endif
+	pr_debug("%s(): indirect search for logical block %u\n",
+		 __func__, block);
 	direxts = in->extents[0].cooked.ex_offset;
 	indexts = in->numextents;
 
@@ -285,9 +280,8 @@ efs_block_t efs_map_block(struct inode *
 				       __func__, iblock);
 				return 0;
 			}
-#ifdef DEBUG
-			printk(KERN_DEBUG "EFS: map_block(): read indirect extent block %d\n", iblock);
-#endif
+			pr_debug("%s(): read indirect extent block %d\n",
+				 __func__, iblock);
 			first = 0;
 			lastblock = iblock;
 		}
diff -puN fs/efs/super.c~fs-efs-convert-printkkern_debug-to-pr_debug fs/efs/super.c
--- a/fs/efs/super.c~fs-efs-convert-printkkern_debug-to-pr_debug
+++ a/fs/efs/super.c
@@ -184,7 +184,7 @@ static efs_block_t efs_validate_vh(struc
 	}
 
 #ifdef DEBUG
-	printk(KERN_DEBUG "EFS: bf: \"%16s\"\n", vh->vh_bootfile);
+	pr_debug("bf: \"%16s\"\n", vh->vh_bootfile);
 
 	for(i = 0; i < NVDIR; i++) {
 		int	j;
@@ -196,9 +196,8 @@ static efs_block_t efs_validate_vh(struc
 		name[j] = (char) 0;
 
 		if (name[0]) {
-			printk(KERN_DEBUG "EFS: vh: %8s block: 0x%08x size: 0x%08x\n",
-				name,
-				(int) be32_to_cpu(vh->vh_vd[i].vd_lbn),
+			pr_debug("vh: %8s block: 0x%08x size: 0x%08x\n",
+				name, (int) be32_to_cpu(vh->vh_vd[i].vd_lbn),
 				(int) be32_to_cpu(vh->vh_vd[i].vd_nbytes));
 		}
 	}
@@ -211,12 +210,11 @@ static efs_block_t efs_validate_vh(struc
 		}
 #ifdef DEBUG
 		if (be32_to_cpu(vh->vh_pt[i].pt_nblks)) {
-			printk(KERN_DEBUG "EFS: pt %2d: start: %08d size: %08d type: 0x%02x (%s)\n",
-				i,
-				(int) be32_to_cpu(vh->vh_pt[i].pt_firstlbn),
-				(int) be32_to_cpu(vh->vh_pt[i].pt_nblks),
-				pt_type,
-				(pt_entry->pt_name) ? pt_entry->pt_name : "unknown");
+			pr_debug("pt %2d: start: %08d size: %08d type: 0x%02x (%s)\n",
+				 i, (int)be32_to_cpu(vh->vh_pt[i].pt_firstlbn),
+				 (int)be32_to_cpu(vh->vh_pt[i].pt_nblks),
+				 pt_type, (pt_entry->pt_name) ?
+				 pt_entry->pt_name : "unknown");
 		}
 #endif
 		if (IS_EFS(pt_type)) {
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

