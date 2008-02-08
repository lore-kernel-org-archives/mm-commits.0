From: akpm@linux-foundation.org
Subject: - iget-stop-fat-from-using-iget-and-read_inode-try.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:07:39 -0800
Message-ID: <200802080807.m1887KxB014526@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45819 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932717AbYBHIUp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:20:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, hch@lst.de, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     iget: stop FAT from using iget() and read_inode()
has been removed from the -mm tree.  Its filename was
     iget-stop-fat-from-using-iget-and-read_inode-try.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iget: stop FAT from using iget() and read_inode()
From: David Howells <dhowells@redhat.com>

Stop the FAT filesystem from using iget() and read_inode().  Replace the call
to iget() with a call to ilookup().

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/fat/inode.c~iget-stop-fat-from-using-iget-and-read_inode-try fs/fat/inode.c
--- a/fs/fat/inode.c~iget-stop-fat-from-using-iget-and-read_inode-try
+++ a/fs/fat/inode.c
@@ -634,8 +634,6 @@ static const struct super_operations fat
 	.clear_inode	= fat_clear_inode,
 	.remount_fs	= fat_remount,
 
-	.read_inode	= make_bad_inode,
-
 	.show_options	= fat_show_options,
 };
 
@@ -663,8 +661,8 @@ static struct dentry *fat_fh_to_dentry(s
 	if (fh_len < 5 || fh_type != 3)
 		return NULL;
 
-	inode = iget(sb, fh[0]);
-	if (!inode || is_bad_inode(inode) || inode->i_generation != fh[1]) {
+	inode = ilookup(sb, fh[0]);
+	if (!inode || inode->i_generation != fh[1]) {
 		if (inode)
 			iput(inode);
 		inode = NULL;
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
iget-stop-unionfs-from-using-iget-and-read_inode-fix-2.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
tty-let-architectures-override-the-user-kernel-macros.patch
aout-move-stack_top-to-asm-processorh.patch
aout-mark-arches-that-support-aout-format.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix.patch
usb-net2280-cant-have-a-function-called-show_registers.patch
mn10300-allocate-serial-port-uart-ids-for-on-chip-serial-ports.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
mn10300-add-platform-mtd-support-for-the-asb2303-board.patch
fs-afs-securityc-fix-uninitialized-var-warning.patch
procfs-constify-function-pointer-tables.patch
avoid-overflows-in-kernel-timec.patch
mount-options-fix-afs.patch
remove-aout-interpreter-support-in-elf-loader.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
mutex-subsystem-synchro-test-module.patch
