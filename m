From: akpm@linux-foundation.org
Subject: + iget-stop-isofs-from-using-read_inode-fix-2-update.patch added to -mm tree
Date: Wed, 19 Dec 2007 15:40:09 -0800
Message-ID: <200712192340.lBJNeEtf025246@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45028 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753172AbXLSXkz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Dec 2007 18:40:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, hidave.darkstar@gmail.com


The patch titled
     IGET: Handle errors in ISOFS correctly [try #2]
has been added to the -mm tree.  Its filename is
     iget-stop-isofs-from-using-read_inode-fix-2-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: IGET: Handle errors in ISOFS correctly [try #2]
From: David Howells <dhowells@redhat.com>

Dave Young <hidave.darkstar@gmail.com> wrote:

> +     if (IS_ERR(inode))
> +            goto out_no_root;

How about this then?

David

---
IGET: Handle errors in ISOFS correctly


Handle errors in ISOFS correctly.

Updated to correctly handle the iput() and re-isofs_iget() done when we change
to the secondary root.

Updated to return -ENOMEM from isofs_fill_super() rather than -EINVAL when the
former is the actual error condition.  Also to return -EIO when that occurs
within isofs_iget().

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: "Dave Young" <hidave.darkstar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/isofs/inode.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN fs/isofs/inode.c~iget-stop-isofs-from-using-read_inode-fix-2-update fs/isofs/inode.c
--- a/fs/isofs/inode.c~iget-stop-isofs-from-using-read_inode-fix-2-update
+++ a/fs/isofs/inode.c
@@ -551,7 +551,7 @@ static int isofs_fill_super(struct super
 	int joliet_level = 0;
 	int iso_blknum, block;
 	int orig_zonesize;
-	int table;
+	int table, error = -EINVAL;
 	unsigned int vol_desc_start;
 
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
@@ -809,6 +809,8 @@ root_found:
 	 * we then decide whether to use the Joliet descriptor.
 	 */
 	inode = isofs_iget(s, sbi->s_firstdatazone, 0);
+	if (IS_ERR(inode))
+		goto out_no_root;
 
 	/*
 	 * If this disk has both Rock Ridge and Joliet on it, then we
@@ -828,6 +830,8 @@ root_found:
 				"ISOFS: changing to secondary root\n");
 			iput(inode);
 			inode = isofs_iget(s, sbi->s_firstdatazone, 0);
+			if (IS_ERR(inode))
+				goto out_no_root;
 		}
 	}
 
@@ -841,8 +845,6 @@ root_found:
 	sbi->s_joliet_level = joliet_level;
 
 	/* check the root inode */
-	if (IS_ERR(inode))
-		goto out_no_root;
 	if (!inode->i_op)
 		goto out_bad_root;
 
@@ -879,7 +881,9 @@ out_iput:
 	iput(inode);
 	goto out_no_inode;
 out_no_root:
-	printk(KERN_WARNING "%s: get root inode failed\n", __func__);
+	error = PTR_ERR(inode);
+	if (error != -ENOMEM)
+		printk(KERN_WARNING "%s: get root inode failed\n", __func__);
 out_no_inode:
 #ifdef CONFIG_JOLIET
 	if (sbi->s_nls_iocharset)
@@ -908,7 +912,7 @@ out_freesbi:
 	kfree(opt.iocharset);
 	kfree(sbi);
 	s->s_fs_info = NULL;
-	return -EINVAL;
+	return error;
 }
 
 static int isofs_statfs (struct dentry *dentry, struct kstatfs *buf)
_

Patches currently in -mm which might be from dhowells@redhat.com are

git-mtd.patch
frv-permit-the-memory-to-be-located-elsewhere-in-nommu-mode.patch
frv-move-dma-macros-to-scatterlisth-for-consistency.patch
frv-remove-dead-config-symbol-from-frv-code.patch
nommu-add-new-vmalloc_user-and-remap_vmalloc_range-interfaces.patch
create-arch-kconfig.patch
add-have_oprofile.patch
add-have_kprobes.patch
move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig.patch
64-bit-i_version-afs-fixes.patch
add-an-err_cast-function-to-complement-err_ptr-and-co.patch
convert-err_ptrptr_errp-instances-to-err_castp.patch
iget-introduce-a-function-to-register-iget-failure.patch
iget-use-iget_failed-in-afs.patch
iget-use-iget_failed-in-gfs2.patch
iget-stop-affs-from-using-iget-and-read_inode-try.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-autofs-from-using-iget-and-read_inode.patch
iget-stop-befs-from-using-iget-and-read_inode-try.patch
iget-stop-bfs-from-using-iget-and-read_inode-try.patch
iget-stop-cifs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
iget-stop-fat-from-using-iget-and-read_inode-try.patch
iget-stop-freevxfs-from-using-iget-and-read_inode.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-fix.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-fuse-from-using-iget-and-read_inode-try.patch
iget-stop-hfsplus-from-using-iget-and-read_inode.patch
iget-stop-isofs-from-using-read_inode.patch
iget-stop-isofs-from-using-read_inode-fix-2.patch
iget-stop-isofs-from-using-read_inode-fix-2-update.patch
iget-stop-jffs2-from-using-iget-and-read_inode.patch
iget-stop-jfs-from-using-iget-and-read_inode-try.patch
iget-stop-the-minix-filesystem-from-using-iget-and.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-openpromfs-from-using-iget-and.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-hppfs-from-using-iget-and-read_inode.patch
iget-remove-iget-and-the-read_inode-super-op-as.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
unexport-asm-pageh.patch
add-cmpxchg_local-to-frv.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
tty-let-architectures-override-the-user-kernel-macros.patch
aout-move-stack_top-to-asm-processorh.patch
aout-mark-arches-that-support-aout-format.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-sanitize-the-type-of-struct-useru_ar0.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix.patch
usb-net2280-cant-have-a-function-called-show_registers.patch
mn10300-allocate-serial-port-uart-ids-for-on-chip-serial-ports.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
mn10300-add-platform-mtd-support-for-the-asb2303-board.patch
mutex-subsystem-synchro-test-module.patch
