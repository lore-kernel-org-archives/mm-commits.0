Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D782AC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 25 Apr 2022 22:30:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiDYWdF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Apr 2022 18:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234471AbiDYWcj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Apr 2022 18:32:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F4310C88F
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 15:27:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6A23B81B33
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 22:27:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4E4C385A4;
        Mon, 25 Apr 2022 22:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650925626;
        bh=v+Z1amJsQksnG5CKHQ+Qyq0tWt0Kuf5WAXHT15TXbgg=;
        h=Date:To:From:Subject:From;
        b=mLPrJSvmyEuKduqNJo9I5bWwNM3Fc/04yr6nOJWjjdg85PQ792o/uYcNv2+AtS8g8
         Wuf31BJ2FOfHySnBSUUH1s7XEl8t0jPd2MNOm6BQYTmXb3zP0q51qFr4+YM2l5qQvh
         M5AdazEOq7388TJW4+ArNZRvdpDCeNYf0GjqxQA0=
Date:   Mon, 25 Apr 2022 15:27:05 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, bhe@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + vmcore-convert-__read_vmcore-to-use-an-iov_iter.patch added to -mm tree
Message-Id: <20220425222706.7C4E4C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vmcore: convert __read_vmcore to use an iov_iter
has been added to the -mm tree.  Its filename is
     vmcore-convert-__read_vmcore-to-use-an-iov_iter.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/vmcore-convert-__read_vmcore-to-use-an-iov_iter.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/vmcore-convert-__read_vmcore-to-use-an-iov_iter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: vmcore: convert __read_vmcore to use an iov_iter

This gets rid of copy_to() and let us use proc_read_iter() instead of
proc_read().

Link: https://lkml.kernel.org/r/20220408090636.560886-3-bhe@redhat.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |   82 ++++++++++++++++-----------------------------
 1 file changed, 30 insertions(+), 52 deletions(-)

--- a/fs/proc/vmcore.c~vmcore-convert-__read_vmcore-to-use-an-iov_iter
+++ a/fs/proc/vmcore.c
@@ -249,22 +249,8 @@ ssize_t __weak copy_oldmem_page_encrypte
 	return copy_oldmem_page(iter, pfn, csize, offset);
 }
 
-/*
- * Copy to either kernel or user space
- */
-static int copy_to(void *target, void *src, size_t size, int userbuf)
-{
-	if (userbuf) {
-		if (copy_to_user((char __user *) target, src, size))
-			return -EFAULT;
-	} else {
-		memcpy(target, src, size);
-	}
-	return 0;
-}
-
 #ifdef CONFIG_PROC_VMCORE_DEVICE_DUMP
-static int vmcoredd_copy_dumps(void *dst, u64 start, size_t size, int userbuf)
+static int vmcoredd_copy_dumps(struct iov_iter *iter, u64 start, size_t size)
 {
 	struct vmcoredd_node *dump;
 	u64 offset = 0;
@@ -277,14 +263,13 @@ static int vmcoredd_copy_dumps(void *dst
 		if (start < offset + dump->size) {
 			tsz = min(offset + (u64)dump->size - start, (u64)size);
 			buf = dump->buf + start - offset;
-			if (copy_to(dst, buf, tsz, userbuf)) {
+			if (copy_to_iter(buf, tsz, iter) < tsz) {
 				ret = -EFAULT;
 				goto out_unlock;
 			}
 
 			size -= tsz;
 			start += tsz;
-			dst += tsz;
 
 			/* Leave now if buffer filled already */
 			if (!size)
@@ -340,33 +325,28 @@ out_unlock:
 /* Read from the ELF header and then the crash dump. On error, negative value is
  * returned otherwise number of bytes read are returned.
  */
-static ssize_t __read_vmcore(char *buffer, size_t buflen, loff_t *fpos,
-			     int userbuf)
+static ssize_t __read_vmcore(struct iov_iter *iter, loff_t *fpos)
 {
 	ssize_t acc = 0, tmp;
 	size_t tsz;
 	u64 start;
 	struct vmcore *m = NULL;
 
-	if (buflen == 0 || *fpos >= vmcore_size)
+	if (!iov_iter_count(iter) || *fpos >= vmcore_size)
 		return 0;
 
-	/* trim buflen to not go beyond EOF */
-	if (buflen > vmcore_size - *fpos)
-		buflen = vmcore_size - *fpos;
+	iov_iter_truncate(iter, vmcore_size - *fpos);
 
 	/* Read ELF core header */
 	if (*fpos < elfcorebuf_sz) {
-		tsz = min(elfcorebuf_sz - (size_t)*fpos, buflen);
-		if (copy_to(buffer, elfcorebuf + *fpos, tsz, userbuf))
+		tsz = min(elfcorebuf_sz - (size_t)*fpos, iov_iter_count(iter));
+		if (copy_to_iter(elfcorebuf + *fpos, tsz, iter) < tsz)
 			return -EFAULT;
-		buflen -= tsz;
 		*fpos += tsz;
-		buffer += tsz;
 		acc += tsz;
 
 		/* leave now if filled buffer already */
-		if (buflen == 0)
+		if (!iov_iter_count(iter))
 			return acc;
 	}
 
@@ -387,35 +367,32 @@ static ssize_t __read_vmcore(char *buffe
 		/* Read device dumps */
 		if (*fpos < elfcorebuf_sz + vmcoredd_orig_sz) {
 			tsz = min(elfcorebuf_sz + vmcoredd_orig_sz -
-				  (size_t)*fpos, buflen);
+				  (size_t)*fpos, iov_iter_count(iter));
 			start = *fpos - elfcorebuf_sz;
-			if (vmcoredd_copy_dumps(buffer, start, tsz, userbuf))
+			if (vmcoredd_copy_dumps(iter, start, tsz))
 				return -EFAULT;
 
-			buflen -= tsz;
 			*fpos += tsz;
-			buffer += tsz;
 			acc += tsz;
 
 			/* leave now if filled buffer already */
-			if (!buflen)
+			if (!iov_iter_count(iter))
 				return acc;
 		}
 #endif /* CONFIG_PROC_VMCORE_DEVICE_DUMP */
 
 		/* Read remaining elf notes */
-		tsz = min(elfcorebuf_sz + elfnotes_sz - (size_t)*fpos, buflen);
+		tsz = min(elfcorebuf_sz + elfnotes_sz - (size_t)*fpos,
+			  iov_iter_count(iter));
 		kaddr = elfnotes_buf + *fpos - elfcorebuf_sz - vmcoredd_orig_sz;
-		if (copy_to(buffer, kaddr, tsz, userbuf))
+		if (copy_to_iter(kaddr, tsz, iter) < tsz)
 			return -EFAULT;
 
-		buflen -= tsz;
 		*fpos += tsz;
-		buffer += tsz;
 		acc += tsz;
 
 		/* leave now if filled buffer already */
-		if (buflen == 0)
+		if (!iov_iter_count(iter))
 			return acc;
 	}
 
@@ -423,19 +400,17 @@ static ssize_t __read_vmcore(char *buffe
 		if (*fpos < m->offset + m->size) {
 			tsz = (size_t)min_t(unsigned long long,
 					    m->offset + m->size - *fpos,
-					    buflen);
+					    iov_iter_count(iter));
 			start = m->paddr + *fpos - m->offset;
-			tmp = read_from_oldmem(buffer, tsz, &start,
-					       userbuf, cc_platform_has(CC_ATTR_MEM_ENCRYPT));
+			tmp = read_from_oldmem_iter(iter, tsz, &start,
+					cc_platform_has(CC_ATTR_MEM_ENCRYPT));
 			if (tmp < 0)
 				return tmp;
-			buflen -= tsz;
 			*fpos += tsz;
-			buffer += tsz;
 			acc += tsz;
 
 			/* leave now if filled buffer already */
-			if (buflen == 0)
+			if (!iov_iter_count(iter))
 				return acc;
 		}
 	}
@@ -443,15 +418,14 @@ static ssize_t __read_vmcore(char *buffe
 	return acc;
 }
 
-static ssize_t read_vmcore(struct file *file, char __user *buffer,
-			   size_t buflen, loff_t *fpos)
+static ssize_t read_vmcore(struct kiocb *iocb, struct iov_iter *iter)
 {
-	return __read_vmcore((__force char *) buffer, buflen, fpos, 1);
+	return __read_vmcore(iter, &iocb->ki_pos);
 }
 
 /*
  * The vmcore fault handler uses the page cache and fills data using the
- * standard __vmcore_read() function.
+ * standard __read_vmcore() function.
  *
  * On s390 the fault handler is used for memory regions that can't be mapped
  * directly with remap_pfn_range().
@@ -461,9 +435,10 @@ static vm_fault_t mmap_vmcore_fault(stru
 #ifdef CONFIG_S390
 	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
 	pgoff_t index = vmf->pgoff;
+	struct iov_iter iter;
+	struct kvec kvec;
 	struct page *page;
 	loff_t offset;
-	char *buf;
 	int rc;
 
 	page = find_or_create_page(mapping, index, GFP_KERNEL);
@@ -471,8 +446,11 @@ static vm_fault_t mmap_vmcore_fault(stru
 		return VM_FAULT_OOM;
 	if (!PageUptodate(page)) {
 		offset = (loff_t) index << PAGE_SHIFT;
-		buf = __va((page_to_pfn(page) << PAGE_SHIFT));
-		rc = __read_vmcore(buf, PAGE_SIZE, &offset, 0);
+		kvec.iov_base = page_address(page);
+		kvec.iov_len = PAGE_SIZE;
+		iov_iter_kvec(&iter, READ, &kvec, 1, PAGE_SIZE);
+
+		rc = __read_vmcore(&iter, &offset);
 		if (rc < 0) {
 			unlock_page(page);
 			put_page(page);
@@ -722,7 +700,7 @@ static int mmap_vmcore(struct file *file
 
 static const struct proc_ops vmcore_proc_ops = {
 	.proc_open	= open_vmcore,
-	.proc_read	= read_vmcore,
+	.proc_read_iter	= read_vmcore,
 	.proc_lseek	= default_llseek,
 	.proc_mmap	= mmap_vmcore,
 };
_

Patches currently in -mm which might be from willy@infradead.org are

vmcore-convert-copy_oldmem_page-to-take-an-iov_iter.patch
vmcore-convert-__read_vmcore-to-use-an-iov_iter.patch
vmcore-convert-read_from_oldmem-to-take-an-iov_iter.patch

