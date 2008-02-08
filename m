From: akpm@linux-foundation.org
Subject: - iget-use-iget_failed-in-gfs2.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:07:13 -0800
Message-ID: <200802080806.m1886sZx014490@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52820 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932791AbYBHIUp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:20:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, hch@lst.de, swhiteho@redhat.com, mm-commits@vger.kernel.org


The patch titled
     iget: use iget_failed() in GFS2
has been removed from the -mm tree.  Its filename was
     iget-use-iget_failed-in-gfs2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iget: use iget_failed() in GFS2
From: David Howells <dhowells@redhat.com>

Use iget_failed() in GFS2 to kill a failed inode.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/gfs2/inode.c~iget-use-iget_failed-in-gfs2 fs/gfs2/inode.c
--- a/fs/gfs2/inode.c~iget-use-iget_failed-in-gfs2
+++ a/fs/gfs2/inode.c
@@ -240,7 +240,7 @@ fail_put:
 	ip->i_gl->gl_object = NULL;
 	gfs2_glock_put(ip->i_gl);
 fail:
-	iput(inode);
+	iget_failed(inode);
 	return ERR_PTR(error);
 }
 
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
