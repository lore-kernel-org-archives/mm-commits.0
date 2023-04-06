Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7C26C7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:48:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234832AbjDFCsa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234868AbjDFCrj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:47:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D079EFB
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:45:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA404642A9
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:45:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4E9C433EF;
        Thu,  6 Apr 2023 02:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749133;
        bh=2DN60NEER0pvxq3zrq/49knv2FpdN+OQPY3getMWGPg=;
        h=Date:To:From:Subject:From;
        b=b6YXx774u4m+qKVanZXbxuuOF8EyGBx6qXrbJx1SD9XTINplA8aqgbpbOnXHiZAVQ
         EnGYs+TNKjTVdImjSereiI1V7ImjN9A2aeFr+wsw/VdRZIn6lFSGKLvel89rwlBxAU
         rqxhfnqHGsCDLQrFMYh3dlpz8zz5rMZK5JCYTXCc=
Date:   Wed, 05 Apr 2023 19:45:32 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, urezki@gmail.com, liushixin2@huawei.com,
        jolsa@kernel.org, david@redhat.com, bhe@redhat.com,
        axboe@kernel.dk, lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-proc-kcore-convert-read_kcore-to-read_kcore_iter.patch removed from -mm tree
Message-Id: <20230406024533.4A4E9C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs/proc/kcore: convert read_kcore() to read_kcore_iter()
has been removed from the -mm tree.  Its filename was
     fs-proc-kcore-convert-read_kcore-to-read_kcore_iter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: fs/proc/kcore: convert read_kcore() to read_kcore_iter()
Date: Wed, 22 Mar 2023 18:57:02 +0000

For the time being we still use a bounce buffer for vread(), however in
the next patch we will convert this to interact directly with the iterator
and eliminate the bounce buffer altogether.

Link: https://lkml.kernel.org/r/ebe12c8d70eebd71f487d80095605f3ad0d1489c.1679511146.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

--- a/fs/proc/kcore.c~fs-proc-kcore-convert-read_kcore-to-read_kcore_iter
+++ a/fs/proc/kcore.c
@@ -24,7 +24,7 @@
 #include <linux/memblock.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/uaccess.h>
+#include <linux/uio.h>
 #include <asm/io.h>
 #include <linux/list.h>
 #include <linux/ioport.h>
@@ -308,9 +308,12 @@ static void append_kcore_note(char *note
 }
 
 static ssize_t
-read_kcore(struct file *file, char __user *buffer, size_t buflen, loff_t *fpos)
+read_kcore_iter(struct kiocb *iocb, struct iov_iter *iter)
 {
+	struct file *file = iocb->ki_filp;
 	char *buf = file->private_data;
+	loff_t *fpos = &iocb->ki_pos;
+
 	size_t phdrs_offset, notes_offset, data_offset;
 	size_t page_offline_frozen = 1;
 	size_t phdrs_len, notes_len;
@@ -318,6 +321,7 @@ read_kcore(struct file *file, char __use
 	size_t tsz;
 	int nphdr;
 	unsigned long start;
+	size_t buflen = iov_iter_count(iter);
 	size_t orig_buflen = buflen;
 	int ret = 0;
 
@@ -356,12 +360,11 @@ read_kcore(struct file *file, char __use
 		};
 
 		tsz = min_t(size_t, buflen, sizeof(struct elfhdr) - *fpos);
-		if (copy_to_user(buffer, (char *)&ehdr + *fpos, tsz)) {
+		if (copy_to_iter((char *)&ehdr + *fpos, tsz, iter) != tsz) {
 			ret = -EFAULT;
 			goto out;
 		}
 
-		buffer += tsz;
 		buflen -= tsz;
 		*fpos += tsz;
 	}
@@ -398,15 +401,14 @@ read_kcore(struct file *file, char __use
 		}
 
 		tsz = min_t(size_t, buflen, phdrs_offset + phdrs_len - *fpos);
-		if (copy_to_user(buffer, (char *)phdrs + *fpos - phdrs_offset,
-				 tsz)) {
+		if (copy_to_iter((char *)phdrs + *fpos - phdrs_offset, tsz,
+				 iter) != tsz) {
 			kfree(phdrs);
 			ret = -EFAULT;
 			goto out;
 		}
 		kfree(phdrs);
 
-		buffer += tsz;
 		buflen -= tsz;
 		*fpos += tsz;
 	}
@@ -448,14 +450,13 @@ read_kcore(struct file *file, char __use
 				  min(vmcoreinfo_size, notes_len - i));
 
 		tsz = min_t(size_t, buflen, notes_offset + notes_len - *fpos);
-		if (copy_to_user(buffer, notes + *fpos - notes_offset, tsz)) {
+		if (copy_to_iter(notes + *fpos - notes_offset, tsz, iter) != tsz) {
 			kfree(notes);
 			ret = -EFAULT;
 			goto out;
 		}
 		kfree(notes);
 
-		buffer += tsz;
 		buflen -= tsz;
 		*fpos += tsz;
 	}
@@ -497,7 +498,7 @@ read_kcore(struct file *file, char __use
 		}
 
 		if (!m) {
-			if (clear_user(buffer, tsz)) {
+			if (iov_iter_zero(tsz, iter) != tsz) {
 				ret = -EFAULT;
 				goto out;
 			}
@@ -508,14 +509,14 @@ read_kcore(struct file *file, char __use
 		case KCORE_VMALLOC:
 			vread(buf, (char *)start, tsz);
 			/* we have to zero-fill user buffer even if no read */
-			if (copy_to_user(buffer, buf, tsz)) {
+			if (copy_to_iter(buf, tsz, iter) != tsz) {
 				ret = -EFAULT;
 				goto out;
 			}
 			break;
 		case KCORE_USER:
 			/* User page is handled prior to normal kernel page: */
-			if (copy_to_user(buffer, (char *)start, tsz)) {
+			if (copy_to_iter((char *)start, tsz, iter) != tsz) {
 				ret = -EFAULT;
 				goto out;
 			}
@@ -531,7 +532,7 @@ read_kcore(struct file *file, char __use
 			 */
 			if (!page || PageOffline(page) ||
 			    is_page_hwpoison(page) || !pfn_is_ram(pfn)) {
-				if (clear_user(buffer, tsz)) {
+				if (iov_iter_zero(tsz, iter) != tsz) {
 					ret = -EFAULT;
 					goto out;
 				}
@@ -541,17 +542,17 @@ read_kcore(struct file *file, char __use
 		case KCORE_VMEMMAP:
 		case KCORE_TEXT:
 			/*
-			 * We use _copy_to_user() to bypass usermode hardening
+			 * We use _copy_to_iter() to bypass usermode hardening
 			 * which would otherwise prevent this operation.
 			 */
-			if (_copy_to_user(buffer, (char *)start, tsz)) {
+			if (_copy_to_iter((char *)start, tsz, iter) != tsz) {
 				ret = -EFAULT;
 				goto out;
 			}
 			break;
 		default:
 			pr_warn_once("Unhandled KCORE type: %d\n", m->type);
-			if (clear_user(buffer, tsz)) {
+			if (iov_iter_zero(tsz, iter) != tsz) {
 				ret = -EFAULT;
 				goto out;
 			}
@@ -559,7 +560,6 @@ read_kcore(struct file *file, char __use
 skip:
 		buflen -= tsz;
 		*fpos += tsz;
-		buffer += tsz;
 		start += tsz;
 		tsz = (buflen > PAGE_SIZE ? PAGE_SIZE : buflen);
 	}
@@ -603,7 +603,7 @@ static int release_kcore(struct inode *i
 }
 
 static const struct proc_ops kcore_proc_ops = {
-	.proc_read	= read_kcore,
+	.proc_read_iter	= read_kcore_iter,
 	.proc_open	= open_kcore,
 	.proc_release	= release_kcore,
 	.proc_lseek	= default_llseek,
_

Patches currently in -mm which might be from lstoakes@gmail.com are


