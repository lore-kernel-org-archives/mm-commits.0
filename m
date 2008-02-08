From: akpm@linux-foundation.org
Subject: - iget-stop-fuse-from-using-iget-and-read_inode-try.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:07:44 -0800
Message-ID: <200802080807.m1887PIu014532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52036 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932960AbYBHIVC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:21:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, hch@lst.de, miklos@szeredi.hu, mm-commits@vger.kernel.org


The patch titled
     iget: stop FUSE from using iget() and read_inode()
has been removed from the -mm tree.  Its filename was
     iget-stop-fuse-from-using-iget-and-read_inode-try.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iget: stop FUSE from using iget() and read_inode()
From: David Howells <dhowells@redhat.com>

Stop the FUSE filesystem from using read_inode(), which it doesn't use anyway.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/inode.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN fs/fuse/inode.c~iget-stop-fuse-from-using-iget-and-read_inode-try fs/fuse/inode.c
--- a/fs/fuse/inode.c~iget-stop-fuse-from-using-iget-and-read_inode-try
+++ a/fs/fuse/inode.c
@@ -76,11 +76,6 @@ static void fuse_destroy_inode(struct in
 	kmem_cache_free(fuse_inode_cachep, inode);
 }
 
-static void fuse_read_inode(struct inode *inode)
-{
-	/* No op */
-}
-
 void fuse_send_forget(struct fuse_conn *fc, struct fuse_req *req,
 		      unsigned long nodeid, u64 nlookup)
 {
@@ -515,7 +510,6 @@ static struct inode *get_root_inode(stru
 static const struct super_operations fuse_super_operations = {
 	.alloc_inode    = fuse_alloc_inode,
 	.destroy_inode  = fuse_destroy_inode,
-	.read_inode	= fuse_read_inode,
 	.clear_inode	= fuse_clear_inode,
 	.drop_inode	= generic_delete_inode,
 	.remount_fs	= fuse_remount_fs,
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
