From: akpm@linux-foundation.org
Subject: + add-kernel-doc-for-simple_read_from_buffer-and-memory_read_from_buffer.patch added to -mm tree
Date: Tue, 01 Jul 2008 01:15:03 -0700
Message-ID: <200807010815.m618F34J016873@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752080AbYGAIPQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 04:15:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, hch@lst.de, rdunlap@xenotime.net


The patch titled
     add kernel-doc for simple_read_from_buffer and memory_read_from_buffer
has been added to the -mm tree.  Its filename is
     add-kernel-doc-for-simple_read_from_buffer-and-memory_read_from_buffer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: add kernel-doc for simple_read_from_buffer and memory_read_from_buffer
From: Akinobu Mita <akinobu.mita@gmail.com>

Add kernel-doc comments describing simple_read_from_buffer and
memory_read_from_buffer.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/libfs.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff -puN fs/libfs.c~add-kernel-doc-for-simple_read_from_buffer-and-memory_read_from_buffer fs/libfs.c
--- a/fs/libfs.c~add-kernel-doc-for-simple_read_from_buffer-and-memory_read_from_buffer
+++ a/fs/libfs.c
@@ -512,6 +512,20 @@ void simple_release_fs(struct vfsmount *
 	mntput(mnt);
 }
 
+/**
+ * simple_read_from_buffer - copy data from the buffer to user space
+ * @to: the user space buffer to read to
+ * @count: the maximum number of bytes to read
+ * @ppos: the current position in the buffer
+ * @from: the buffer to read from
+ * @available: the size of the buffer
+ *
+ * The simple_read_from_buffer() function reads up to @count bytes from the
+ * buffer @from at offset @ppos into the user space address starting at @to.
+ *
+ * On success, the number of bytes read is returned and the offset @ppos is
+ * advanced by this number, or negative value is returned on error.
+ **/
 ssize_t simple_read_from_buffer(void __user *to, size_t count, loff_t *ppos,
 				const void *from, size_t available)
 {
@@ -528,6 +542,20 @@ ssize_t simple_read_from_buffer(void __u
 	return count;
 }
 
+/**
+ * memory_read_from_buffer - copy data from the buffer
+ * @to: the kernel space buffer to read to
+ * @count: the maximum number of bytes to read
+ * @ppos: the current position in the buffer
+ * @from: the buffer to read from
+ * @available: the size of the buffer
+ *
+ * The memory_read_from_buffer() function reads up to @count bytes from the
+ * buffer @from at offset @ppos into the kernel space address starting at @to.
+ *
+ * On success, the number of bytes read is returned and the offset @ppos is
+ * advanced by this number, or negative value is returned on error.
+ **/
 ssize_t memory_read_from_buffer(void *to, size_t count, loff_t *ppos,
 				const void *from, size_t available)
 {
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

add-kernel-doc-for-simple_read_from_buffer-and-memory_read_from_buffer.patch
ttusb-use-simple_read_from_buffer.patch
s390-vmcp-use-simple_read_from_buffer.patch
s390-use-simple_read_from_buffer.patch
s390-cio-use-memory_read_from_buffer.patch
s390-use-memory_read_from_buffer.patch
ipr-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer.patch
cris-use-simple_read_from_buffer.patch
binfmt_misc-use-simple_read_from_buffer.patch
aty-use-memory_read_from_buffer.patch
ipc-use-simple_read_from_buffer.patch
nwflash-use-simple_read_from_buffer.patch
firmware-use-memory_read_from_buffer.patch
dcdbas-use-memory_read_from_buffer.patch
dell_rbu-use-memory_read_from_buffer.patch

