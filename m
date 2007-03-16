From: akpm@linux-foundation.org
Subject: + revoke-support-for-ext2-and-ext3.patch added to -mm tree
Date: Fri, 16 Mar 2007 03:29:41 -0800
Message-ID: <200703161129.l2GBTf0b009987@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41821 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932696AbXCPL3x (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Mar 2007 07:29:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penberg@cs.helsinki.fi, hch@lst.de


The patch titled
     revoke: support for ext2 and ext3 and ext4
has been added to the -mm tree.  Its filename is
     revoke-support-for-ext2-and-ext3.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: revoke: support for ext2 and ext3 and ext4
From: Pekka Enberg <penberg@cs.helsinki.fi>

Add revoke support to ext2, ext3 and ext4 by wiring f_ops->revoke with
generic_file_revoke.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/file.c |    1 +
 fs/ext3/file.c |    1 +
 fs/ext4/file.c |    1 +
 3 files changed, 3 insertions(+)

diff -puN fs/ext2/file.c~revoke-support-for-ext2-and-ext3 fs/ext2/file.c
--- a/fs/ext2/file.c~revoke-support-for-ext2-and-ext3
+++ a/fs/ext2/file.c
@@ -59,6 +59,7 @@ const struct file_operations ext2_file_o
 	.sendfile	= generic_file_sendfile,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= generic_file_splice_write,
+	.revoke		= generic_file_revoke,
 };
 
 #ifdef CONFIG_EXT2_FS_XIP
diff -puN fs/ext3/file.c~revoke-support-for-ext2-and-ext3 fs/ext3/file.c
--- a/fs/ext3/file.c~revoke-support-for-ext2-and-ext3
+++ a/fs/ext3/file.c
@@ -123,6 +123,7 @@ const struct file_operations ext3_file_o
 	.sendfile	= generic_file_sendfile,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= generic_file_splice_write,
+	.revoke         = generic_file_revoke,
 };
 
 const struct inode_operations ext3_file_inode_operations = {
diff -puN fs/ext4/file.c~revoke-support-for-ext2-and-ext3 fs/ext4/file.c
--- a/fs/ext4/file.c~revoke-support-for-ext2-and-ext3
+++ a/fs/ext4/file.c
@@ -123,6 +123,7 @@ const struct file_operations ext4_file_o
 	.sendfile	= generic_file_sendfile,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= generic_file_splice_write,
+	.revoke         = generic_file_revoke,
 };
 
 const struct inode_operations ext4_file_inode_operations = {
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
unionfs-fix-slab-abuses-with-krealloc.patch
slab-ensure-cache_alloc_refill-terminates.patch
module-use-krealloc.patch
slab-use-cpu_lock_.patch
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-core-code-misc-fixes.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-core-code-move-magic.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
slab-leaks3-default-y.patch
