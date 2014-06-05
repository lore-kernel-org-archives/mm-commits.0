From: akpm@linux-foundation.org
Subject: [merged] fs-efs-convert-printkkern_debug-to-pr_debug.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 13:07:29 -0700
Message-ID: <5390ce01.Z4hdJW806NJuEFCz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56890 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbaFEUHa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 16:07:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, fabf@skynet.be

Subject: [merged] fs-efs-convert-printkkern_debug-to-pr_debug.patch removed from -mm tree
To: fabf@skynet.be,joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 13:07:29 -0700


The patch titled
     Subject: fs/efs: convert printk(KERN_DEBUG to pr_debug
has been removed from the -mm tree.  Its filename was
     fs-efs-convert-printkkern_debug-to-pr_debug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-ceph-debugfsc-replace-seq_printf-by-seq_puts.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-coda-replace-printk-by-pr_foo.patch
fs-coda-logging-prefix-uniformization.patch
fs-coda-use-__func__.patch
fs-hfsplus-bnodec-replace-min-casting-by-min_t.patch
fs-hfsplus-optionsc-replace-seq_printf-by-seq_puts.patch
fs-hfsplus-wrapperc-replace-min-casting-by-min_t.patch
fs-hfsplus-wrapperc-replace-shift-loop-by-ilog2.patch
fs-hfsplus-fix-pr_foo-and-hfs_dbg-formats.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-hpfs-convert-printk-to-pr_foo.patch
fs-hpfs-use-pr_fmt-for-logging.patch
fs-hpfs-use-__func__-for-logging.patch
fs-hpfs-increase-pr_warn-level.patch
documentation-filesystems-seq_filetxt-create_proc_entry-deprecated.patch
fs-proc-task_mmuc-replace-seq_printf-by-seq_puts.patch
fs-proc-vmcorec-remove-null-assignment-on-static.patch
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
fs-devpts-inodec-convert-printk-to-pr_foo-fix.patch
kernel-seccompc-kernel-doc-warning-fix.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-reiserfs-streec-remove-obsolete-__constant.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
fs-dlm-configc-convert-simple_str-to-kstr.patch
fs-dlm-lockspacec-convert-simple_str-to-kstr.patch
fs-dlm-debug_fsc-replace-seq_printf-by-seq_puts.patch
mm-kmemleak-testc-use-pr_fmt-for-logging.patch
ufs-sb-mutex-merge-mutex_destroy.patch

