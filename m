From: akpm@linux-foundation.org
Subject: + ecryptfs-fix-lookup-error-for-special-files.patch added to -mm tree
Date: Wed, 01 Aug 2007 15:57:33 -0700
Message-ID: <200708012257.l71MvXJK021697@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39785 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751353AbXHAW5t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2007 18:57:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: konishi.ryusuke@lab.ntt.co.jp, mhalcrow@us.ibm.com


The patch titled
     eCryptfs: fix lookup error for special files
has been added to the -mm tree.  Its filename is
     ecryptfs-fix-lookup-error-for-special-files.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eCryptfs: fix lookup error for special files
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

When ecryptfs_lookup() is called against special files, eCryptfs generates
the following errors because it tries to treat them like regular eCryptfs
files.

Error opening lower file for lower_dentry [0xffff810233a6f150], lower_mnt [0xffff810235bb4c80], and flags
[0x8000]
Error opening lower_file to read header region
Error attempting to read the [user.ecryptfs] xattr from the lower file; return value = [-95]
Valid metadata not found in header region or xattr region; treating file as unencrypted

For instance, the problem can be reproduced by the steps below.

  # mkdir /root/crypt /mnt/crypt
  # mount -t ecryptfs /root/crypt /mnt/crypt
  # mknod /mnt/crypt/c0 c 0 0
  # umount /mnt/crypt
  # mount -t ecryptfs /root/crypt /mnt/crypt
  # ls -l /mnt/crypt

This patch fixes it by adding a check similar to directories and
symlinks.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Acked-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/inode.c |    4 ++++
 1 files changed, 4 insertions(+)

diff -puN fs/ecryptfs/inode.c~ecryptfs-fix-lookup-error-for-special-files fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~ecryptfs-fix-lookup-error-for-special-files
+++ a/fs/ecryptfs/inode.c
@@ -359,6 +359,10 @@ static struct dentry *ecryptfs_lookup(st
 		ecryptfs_printk(KERN_DEBUG, "Is a symlink; returning\n");
 		goto out;
 	}
+	if (special_file(lower_inode->i_mode)) {
+		ecryptfs_printk(KERN_DEBUG, "Is a special file; returning\n");
+		goto out;
+	}
 	if (!nd) {
 		ecryptfs_printk(KERN_DEBUG, "We have a NULL nd, just leave"
 				"as we *think* we are about to unlink\n");
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

origin.patch
ecryptfs-fix-lookup-error-for-special-files.patch
