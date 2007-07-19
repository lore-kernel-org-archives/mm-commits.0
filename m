From: akpm@linux-foundation.org
Subject: + isofs-mounting-to-regular-file-may-succeed.patch added to -mm tree
Date: Wed, 18 Jul 2007 22:40:16 -0700
Message-ID: <200707190540.l6J5eGHt016043@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54771 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751633AbXGSFk3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 01:40:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kuvkir@epsmu.com


The patch titled
     isofs: mounting to regular file may succeed
has been added to the -mm tree.  Its filename is
     isofs-mounting-to-regular-file-may-succeed.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: isofs: mounting to regular file may succeed
From: Kirill Kuvaldin <kuvkir@epsmu.com>

It turned out that mounting a corrupted ISO image to a regular file may
succeed, e.g.  if an image was prepared as follows:

$ dd if=correct.iso of=bad.iso bs=4k count=8

We then can mount it to a regular file:

# mount -o loop -t iso9660 bad.iso /tmp/file

But mounting it to a directory fails with -ENOTDIR, simply because
the root directory inode doesn't have S_IFDIR set and the condition
in graft_tree() is met:

	if (S_ISDIR(nd->dentry->d_inode->i_mode) !=
	      S_ISDIR(mnt->mnt_root->d_inode->i_mode))
		return -ENOTDIR

This is because the root directory inode was read from an incorrect
block. It's supposed to be read from sbi->s_firstdatazone, which is
an absolute value and gets messed up in the case of an incorrect image.

In order to somehow circumvent this we have to check that the root
directory inode is actually a directory after all.

Signed-off-by: Kirill Kuvaldin <kuvkir@epsmu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/isofs/inode.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN fs/isofs/inode.c~isofs-mounting-to-regular-file-may-succeed fs/isofs/inode.c
--- a/fs/isofs/inode.c~isofs-mounting-to-regular-file-may-succeed
+++ a/fs/isofs/inode.c
@@ -846,6 +846,15 @@ root_found:
 		goto out_no_root;
 	if (!inode->i_op)
 		goto out_bad_root;
+
+	/* Make sure the root inode is a directory */
+	if (!S_ISDIR(inode->i_mode)) {
+		printk(KERN_WARNING
+			"isofs_fill_super: root inode is not a directory. "
+			"Corrupted media?\n");
+		goto out_iput;
+	}
+
 	/* get the root dentry */
 	s->s_root = d_alloc_root(inode);
 	if (!(s->s_root))
_

Patches currently in -mm which might be from kuvkir@epsmu.com are

isofs-mounting-to-regular-file-may-succeed.patch
