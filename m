Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DCB8C43332
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:23:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECC8164E21
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:23:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234790AbhBYTXH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:23:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:60070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234642AbhBYTUH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:20:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FE8E64F56;
        Thu, 25 Feb 2021 19:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280403;
        bh=BvDnERwiHHF5VNVrCIdpAxXa0YfOWgOuVC4pV7L7lN4=;
        h=Date:From:To:Subject:From;
        b=ie9N8KwedNWRs6ZPrNage22Vcz7nd7GJL1dSuB7774RqzNgOONnQbzjpvgI8lboSa
         N9xKqeZq13B4tD7VJfJ26Qh1Vvu2S9F7H2TTE87gMSakCM04qhr/whnNPU/1WXjccK
         P9FvnmL6e35KxOKy3neZe642Y4vHN1kUorqvoidU=
Date:   Thu, 25 Feb 2021 11:13:23 -0800
From:   akpm@linux-foundation.org
To:     hch@lst.de, kent.overstreet@gmail.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [merged]
 mm-filemap-rename-generic_file_buffered_read-to-filemap_read.patch removed
 from -mm tree
Message-ID: <20210225191323.dm3FcXavq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: rename generic_file_buffered_read to filemap_read
has been removed from the -mm tree.  Its filename was
     mm-filemap-rename-generic_file_buffered_read-to-filemap_read.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm/filemap: rename generic_file_buffered_read to filemap_read

Rename generic_file_buffered_read to match the naming of filemap_fault,
also update the written parameter to a more descriptive name and improve
the kerneldoc comment.

Link: https://lkml.kernel.org/r/20210122160140.223228-18-willy@infradead.org
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/file.c    |    2 +-
 include/linux/fs.h |    4 ++--
 mm/filemap.c       |   39 ++++++++++++++++++---------------------
 3 files changed, 21 insertions(+), 24 deletions(-)

--- a/fs/btrfs/file.c~mm-filemap-rename-generic_file_buffered_read-to-filemap_read
+++ a/fs/btrfs/file.c
@@ -3634,7 +3634,7 @@ static ssize_t btrfs_file_read_iter(stru
 			return ret;
 	}
 
-	return generic_file_buffered_read(iocb, to, ret);
+	return filemap_read(iocb, to, ret);
 }
 
 const struct file_operations btrfs_file_operations = {
--- a/include/linux/fs.h~mm-filemap-rename-generic_file_buffered_read-to-filemap_read
+++ a/include/linux/fs.h
@@ -3080,8 +3080,8 @@ extern ssize_t generic_write_checks(stru
 extern int generic_write_check_limits(struct file *file, loff_t pos,
 		loff_t *count);
 extern int generic_file_rw_checks(struct file *file_in, struct file *file_out);
-extern ssize_t generic_file_buffered_read(struct kiocb *iocb,
-		struct iov_iter *to, ssize_t already_read);
+ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *to,
+		ssize_t already_read);
 extern ssize_t generic_file_read_iter(struct kiocb *, struct iov_iter *);
 extern ssize_t __generic_file_write_iter(struct kiocb *, struct iov_iter *);
 extern ssize_t generic_file_write_iter(struct kiocb *, struct iov_iter *);
--- a/mm/filemap.c~mm-filemap-rename-generic_file_buffered_read-to-filemap_read
+++ a/mm/filemap.c
@@ -2394,23 +2394,20 @@ err:
 }
 
 /**
- * generic_file_buffered_read - generic file read routine
- * @iocb:	the iocb to read
- * @iter:	data destination
- * @written:	already copied
- *
- * This is a generic file read routine, and uses the
- * mapping->a_ops->readpage() function for the actual low-level stuff.
- *
- * This is really ugly. But the goto's actually try to clarify some
- * of the logic when it comes to error handling etc.
- *
- * Return:
- * * total number of bytes copied, including those the were already @written
- * * negative error code if nothing was copied
+ * filemap_read - Read data from the page cache.
+ * @iocb: The iocb to read.
+ * @iter: Destination for the data.
+ * @already_read: Number of bytes already read by the caller.
+ *
+ * Copies data from the page cache.  If the data is not currently present,
+ * uses the readahead and readpage address_space operations to fetch it.
+ *
+ * Return: Total number of bytes copied, including those already read by
+ * the caller.  If an error happens before any bytes are copied, returns
+ * a negative error number.
  */
-ssize_t generic_file_buffered_read(struct kiocb *iocb,
-		struct iov_iter *iter, ssize_t written)
+ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
+		ssize_t already_read)
 {
 	struct file *filp = iocb->ki_filp;
 	struct file_ra_state *ra = &filp->f_ra;
@@ -2437,7 +2434,7 @@ ssize_t generic_file_buffered_read(struc
 		 * can no longer safely return -EIOCBQUEUED. Hence mark
 		 * an async read NOWAIT at that point.
 		 */
-		if ((iocb->ki_flags & IOCB_WAITQ) && written)
+		if ((iocb->ki_flags & IOCB_WAITQ) && already_read)
 			iocb->ki_flags |= IOCB_NOWAIT;
 
 		error = filemap_get_pages(iocb, iter, &pvec);
@@ -2497,7 +2494,7 @@ ssize_t generic_file_buffered_read(struc
 
 			copied = copy_page_to_iter(page, offset, bytes, iter);
 
-			written += copied;
+			already_read += copied;
 			iocb->ki_pos += copied;
 			ra->prev_pos = iocb->ki_pos;
 
@@ -2514,9 +2511,9 @@ put_pages:
 
 	file_accessed(filp);
 
-	return written ? written : error;
+	return already_read ? already_read : error;
 }
-EXPORT_SYMBOL_GPL(generic_file_buffered_read);
+EXPORT_SYMBOL_GPL(filemap_read);
 
 /**
  * generic_file_read_iter - generic filesystem read routine
@@ -2591,7 +2588,7 @@ generic_file_read_iter(struct kiocb *ioc
 			goto out;
 	}
 
-	retval = generic_file_buffered_read(iocb, iter, retval);
+	retval = filemap_read(iocb, iter, retval);
 out:
 	return retval;
 }
_

Patches currently in -mm which might be from hch@lst.de are


