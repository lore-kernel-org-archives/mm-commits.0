From: akpm@linux-foundation.org
Subject: [merged] char-add-aio_readwrite-to-dev-nullzero.patch removed from -mm tree
Date: Wed, 08 May 2013 11:35:00 -0700
Message-ID: <20130508183500.E606631C088@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:45670 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758202Ab3EHSfC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 14:35:02 -0400
Received: by mail-qe0-f73.google.com with SMTP id a11so207994qen.0
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 11:35:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zab@redhat.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, koverstreet@google.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: char: add aio_{read,write} to /dev/{null,zero}
has been removed from the -mm tree.  Its filename was
     char-add-aio_readwrite-to-dev-nullzero.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zach Brown <zab@redhat.com>
Subject: char: add aio_{read,write} to /dev/{null,zero}

These are handy for measuring the cost of the aio infrastructure with
operations that do very little and complete immediately.

Signed-off-by: Zach Brown <zab@redhat.com>
Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Selvan Mani <smani@micron.com>
Cc: Sam Bradshaw <sbradshaw@micron.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff -puN drivers/char/mem.c~char-add-aio_readwrite-to-dev-nullzero drivers/char/mem.c
--- a/drivers/char/mem.c~char-add-aio_readwrite-to-dev-nullzero
+++ a/drivers/char/mem.c
@@ -627,6 +627,18 @@ static ssize_t write_null(struct file *f
 	return count;
 }
 
+static ssize_t aio_read_null(struct kiocb *iocb, const struct iovec *iov,
+			     unsigned long nr_segs, loff_t pos)
+{
+	return 0;
+}
+
+static ssize_t aio_write_null(struct kiocb *iocb, const struct iovec *iov,
+			      unsigned long nr_segs, loff_t pos)
+{
+	return iov_length(iov, nr_segs);
+}
+
 static int pipe_to_null(struct pipe_inode_info *info, struct pipe_buffer *buf,
 			struct splice_desc *sd)
 {
@@ -670,6 +682,24 @@ static ssize_t read_zero(struct file *fi
 	return written ? written : -EFAULT;
 }
 
+static ssize_t aio_read_zero(struct kiocb *iocb, const struct iovec *iov,
+			     unsigned long nr_segs, loff_t pos)
+{
+	size_t written = 0;
+	unsigned long i;
+	ssize_t ret;
+
+	for (i = 0; i < nr_segs; i++) {
+		ret = read_zero(iocb->ki_filp, iov[i].iov_base, iov[i].iov_len,
+				&pos);
+		if (ret < 0)
+			break;
+		written += ret;
+	}
+
+	return written ? written : -EFAULT;
+}
+
 static int mmap_zero(struct file *file, struct vm_area_struct *vma)
 {
 #ifndef CONFIG_MMU
@@ -738,6 +768,7 @@ static int open_port(struct inode *inode
 #define full_lseek      null_lseek
 #define write_zero	write_null
 #define read_full       read_zero
+#define aio_write_zero	aio_write_null
 #define open_mem	open_port
 #define open_kmem	open_mem
 #define open_oldmem	open_mem
@@ -766,6 +797,8 @@ static const struct file_operations null
 	.llseek		= null_lseek,
 	.read		= read_null,
 	.write		= write_null,
+	.aio_read	= aio_read_null,
+	.aio_write	= aio_write_null,
 	.splice_write	= splice_write_null,
 };
 
@@ -782,6 +815,8 @@ static const struct file_operations zero
 	.llseek		= zero_lseek,
 	.read		= read_zero,
 	.write		= write_zero,
+	.aio_read	= aio_read_zero,
+	.aio_write	= aio_write_zero,
 	.mmap		= mmap_zero,
 };
 
_

Patches currently in -mm which might be from zab@redhat.com are

origin.patch
aio-reqs_active-reqs_available.patch
aio-percpu-reqs_available.patch
generic-dynamic-per-cpu-refcounting.patch
aio-percpu-ioctx-refcount.patch
aio-use-xchg-instead-of-completion_lock.patch
block-prep-work-for-batch-completion.patch
block-aio-batch-completion-for-bios-kiocbs.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch
aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch

