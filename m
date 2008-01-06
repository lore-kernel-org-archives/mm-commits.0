From: akpm@linux-foundation.org
Subject: + iget-stop-isofs-from-using-read_inode-fix-2-update-fix.patch added to -mm tree
Date: Sat, 05 Jan 2008 17:39:49 -0800
Message-ID: <200801060139.m061dTpb020192@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41202 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754220AbYAFBkL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 5 Jan 2008 20:40:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     Stop the ISOFS filesystem from using read_inode(). Make isofs_read_inode()
has been added to the -mm tree.  Its filename is
     iget-stop-isofs-from-using-read_inode-fix-2-update-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Stop the ISOFS filesystem from using read_inode(). Make isofs_read_inode()
From: David Howells <dhowells@redhat.com>

Stop the ISOFS filesystem from using read_inode().  Make isofs_read_inode()
return an error code, and make isofs_iget() pass it on.  Furthermore
isofs_iget() no longer ever returns NULL for situations where it used to,
so all the places that call it must use IS_ERR() to check its return value.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/isofs/export.c |   14 +++++++-------
 fs/isofs/inode.c  |    7 +++++--
 fs/isofs/namei.c  |    4 ++--
 fs/isofs/rock.c   |    4 +++-
 4 files changed, 17 insertions(+), 12 deletions(-)

diff -puN fs/isofs/export.c~iget-stop-isofs-from-using-read_inode-fix-2-update-fix fs/isofs/export.c
--- a/fs/isofs/export.c~iget-stop-isofs-from-using-read_inode-fix-2-update-fix
+++ a/fs/isofs/export.c
@@ -26,11 +26,9 @@ isofs_export_iget(struct super_block *sb
 	if (block == 0)
 		return ERR_PTR(-ESTALE);
 	inode = isofs_iget(sb, block, offset);
-	if (inode == NULL)
-		return ERR_PTR(-ENOMEM);
-	if (is_bad_inode(inode)
-	    || (generation && inode->i_generation != generation))
-	{
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
+	if (generation && inode->i_generation != generation) {
 		iput(inode);
 		return ERR_PTR(-ESTALE);
 	}
@@ -110,8 +108,10 @@ static struct dentry *isofs_export_get_p
 	parent_inode = isofs_iget(child_inode->i_sb,
 				  parent_block,
 				  parent_offset);
-	if (parent_inode == NULL) {
-		rv = ERR_PTR(-EACCES);
+	if (IS_ERR(parent_inode)) {
+		rv = ERR_CAST(parent_inode);
+		if (rv != ERR_PTR(-ENOMEM))
+			rv = ERR_PTR(-EACCES);
 		goto out;
 	}
 
diff -puN fs/isofs/inode.c~iget-stop-isofs-from-using-read_inode-fix-2-update-fix fs/isofs/inode.c
--- a/fs/isofs/inode.c~iget-stop-isofs-from-using-read_inode-fix-2-update-fix
+++ a/fs/isofs/inode.c
@@ -1408,7 +1408,7 @@ struct inode *isofs_iget(struct super_bl
 	long ret;
 
 	if (offset >= 1ul << sb->s_blocksize_bits)
-		return NULL;
+		return ERR_PTR(-EINVAL);
 
 	data.block = block;
 	data.offset = offset;
@@ -1418,7 +1418,10 @@ struct inode *isofs_iget(struct super_bl
 	inode = iget5_locked(sb, hashval, &isofs_iget5_test,
 				&isofs_iget5_set, &data);
 
-	if (inode && (inode->i_state & I_NEW)) {
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+
+	if (inode->i_state & I_NEW) {
 		ret = isofs_read_inode(inode);
 		if (ret < 0) {
 			iget_failed(inode);
diff -puN fs/isofs/namei.c~iget-stop-isofs-from-using-read_inode-fix-2-update-fix fs/isofs/namei.c
--- a/fs/isofs/namei.c~iget-stop-isofs-from-using-read_inode-fix-2-update-fix
+++ a/fs/isofs/namei.c
@@ -179,9 +179,9 @@ struct dentry *isofs_lookup(struct inode
 	inode = NULL;
 	if (found) {
 		inode = isofs_iget(dir->i_sb, block, offset);
-		if (!inode) {
+		if (IS_ERR(inode)) {
 			unlock_kernel();
-			return ERR_PTR(-EACCES);
+			return ERR_CAST(inode);
 		}
 	}
 	unlock_kernel();
diff -puN fs/isofs/rock.c~iget-stop-isofs-from-using-read_inode-fix-2-update-fix fs/isofs/rock.c
--- a/fs/isofs/rock.c~iget-stop-isofs-from-using-read_inode-fix-2-update-fix
+++ a/fs/isofs/rock.c
@@ -474,8 +474,10 @@ repeat:
 			    isofs_iget(inode->i_sb,
 				       ISOFS_I(inode)->i_first_extent,
 				       0);
-			if (!reloc)
+			if (IS_ERR(reloc)) {
+				ret = PTR_ERR(reloc);
 				goto out;
+			}
 			inode->i_mode = reloc->i_mode;
 			inode->i_nlink = reloc->i_nlink;
 			inode->i_uid = reloc->i_uid;
_

Patches currently in -mm which might be from dhowells@redhat.com are

keys-fix-macro.patch
git-mtd.patch
frv-permit-the-memory-to-be-located-elsewhere-in-nommu-mode.patch
frv-move-dma-macros-to-scatterlisth-for-consistency.patch
frv-remove-dead-config-symbol-from-frv-code.patch
nommu-add-new-vmalloc_user-and-remap_vmalloc_range-interfaces.patch
avoid-overflows-in-kernel-timec.patch
create-arch-kconfig.patch
add-have_oprofile.patch
add-have_kprobes.patch
move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig.patch
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
iget-stop-isofs-from-using-read_inode-fix-2-update-fix.patch
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
aout-move-stack_top-to-asm-processorh-fix.patch
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
