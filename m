From: akpm@linux-foundation.org
Subject: + iget-use-iget_failed-in-afs.patch added to -mm tree
Date: Sat, 27 Oct 2007 00:43:21 -0700
Message-ID: <200710270743.l9R7hLIu003248@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43797 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751429AbXJ0Hnf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Oct 2007 03:43:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     iget: use iget_failed() in AFS
has been added to the -mm tree.  Its filename is
     iget-use-iget_failed-in-afs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: iget: use iget_failed() in AFS
From: David Howells <dhowells@redhat.com>

Use iget_failed() in AFS to kill a failed inode.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/inode.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN fs/afs/inode.c~iget-use-iget_failed-in-afs fs/afs/inode.c
--- a/fs/afs/inode.c~iget-use-iget_failed-in-afs
+++ a/fs/afs/inode.c
@@ -196,10 +196,7 @@ struct inode *afs_iget(struct super_bloc
 
 	/* failure */
 bad_inode:
-	make_bad_inode(inode);
-	unlock_new_inode(inode);
-	iput(inode);
-
+	iget_failed(inode);
 	_leave(" = %d [bad]", ret);
 	return ERR_PTR(ret);
 }
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
64-bit-i_version-afs-fixes.patch
add-an-err_cast-function-to-complement-err_ptr-and-co.patch
convert-err_ptrptr_errp-instances-to-err_castp.patch
iget-introduce-a-function-to-register-iget-failure.patch
iget-use-iget_failed-in-afs.patch
iget-use-iget_failed-in-gfs2.patch
iget-stop-affs-from-using-iget-and-read_inode-try.patch
iget-stop-autofs-from-using-iget-and-read_inode.patch
iget-stop-befs-from-using-iget-and-read_inode-try.patch
iget-stop-bfs-from-using-iget-and-read_inode-try.patch
iget-stop-cifs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try.patch
iget-stop-ext2-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
iget-stop-fat-from-using-iget-and-read_inode-try.patch
iget-stop-freevxfs-from-using-iget-and-read_inode.patch
iget-stop-fuse-from-using-iget-and-read_inode-try.patch
iget-stop-hfsplus-from-using-iget-and-read_inode.patch
iget-stop-isofs-from-using-read_inode.patch
iget-stop-jffs2-from-using-iget-and-read_inode.patch
iget-stop-jfs-from-using-iget-and-read_inode-try.patch
iget-stop-the-minix-filesystem-from-using-iget-and.patch
iget-stop-procfs-from-using-iget-and-read_inode.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try.patch
iget-stop-romfs-from-using-iget-and-read_inode.patch
iget-stop-the-sysv-filesystem-from-using-iget-and.patch
iget-stop-ufs-from-using-iget-and-read_inode-try.patch
iget-stop-openpromfs-from-using-iget-and.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hppfs-from-using-iget-and-read_inode.patch
iget-remove-iget-and-the-read_inode-super-op-as.patch
mutex-subsystem-synchro-test-module.patch
