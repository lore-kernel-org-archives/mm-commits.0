From: akpm@linux-foundation.org
Subject: + char-add-aio_readwrite-to-dev-nullzero.patch added to -mm tree
Date: Thu, 03 Jan 2013 15:39:23 -0800
Message-ID: <20130103233924.CB29A20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f73.google.com ([209.85.215.73]:62293 "EHLO
	mail-la0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544Ab3ACXj3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jan 2013 18:39:29 -0500
Received: by mail-la0-f73.google.com with SMTP id fq13so394535lab.4
        for <mm-commits@vger.kernel.org>; Thu, 03 Jan 2013 15:39:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zab@redhat.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, koverstreet@google.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: char: add aio_{read,write} to /dev/{null,zero}
has been added to the -mm tree.  Its filename is
     char-add-aio_readwrite-to-dev-nullzero.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin LaHaise <bcrl@kvack.org> 
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
@@ -738,6 +768,7 @@ static int open_port(struct inode * inod
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

mm-remove-old-aio-use_mm-comment.patch
aio-remove-dead-code-from-aioh.patch
gadget-remove-only-user-of-aio-retry.patch
aio-remove-retry-based-aio.patch
char-add-aio_readwrite-to-dev-nullzero.patch
aio-kill-return-value-of-aio_complete.patch
aio-kiocb_cancel.patch
aio-move-private-stuff-out-of-aioh.patch
aio-dprintk-pr_debug.patch
aio-do-fget-after-aio_get_req.patch
aio-make-aio_put_req-lockless.patch
aio-refcounting-cleanup.patch
wait-add-wait_event_hrtimeout.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers.patch
aio-use-flush_dcache_page.patch
aio-use-cancellation-list-lazily.patch
aio-change-reqs_active-to-include-unreaped-completions.patch
aio-kill-batch-allocation.patch
aio-kill-struct-aio_ring_info.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
aio-reqs_active-reqs_available.patch
aio-percpu-reqs_available.patch
generic-dynamic-per-cpu-refcounting.patch
aio-percpu-ioctx-refcount.patch
aio-use-xchg-instead-of-completion_lock.patch
aio-dont-include-aioh-in-schedh.patch
aio-kill-ki_key.patch
aio-kill-ki_retry.patch
block-aio-batch-completion-for-bios-kiocbs.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch
aio-smoosh-struct-kiocb.patch

