Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 572C8C6FD1D
	for <mm-commits@archiver.kernel.org>; Tue, 21 Mar 2023 21:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbjCUVPM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Mar 2023 17:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbjCUVPJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Mar 2023 17:15:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC5B3B3E2
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 14:15:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01BE4B8197F
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 21:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2579C433D2;
        Tue, 21 Mar 2023 21:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679433304;
        bh=Fh5Q2OLHCmK8evZYePbYb8uuARyNqbzDznCON1x/n3Y=;
        h=Date:To:From:Subject:From;
        b=j8T0hTSFazY/upfi0nsJz6/LuZzLjrjRM/qOqVBpgy89QB5FpsWAPwwjAfBc7ZrGQ
         Kz529GOy1wiCXov2s5q+/7blt8/RDcl+TVVtFDVOsAfRY3APq0/TGb4EraG2X1oPIk
         fpsbRW8doigKISDlPxq5e+NcrmjbpJHz0dAPTgDE=
Date:   Tue, 21 Mar 2023 14:15:04 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, urezki@gmail.com, liushixin2@huawei.com,
        jolsa@kernel.org, david@redhat.com, bhe@redhat.com,
        axboe@kernel.dk, lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-kcore-convert-read_kcore-to-read_kcore_iter.patch added to mm-unstable branch
Message-Id: <20230321211504.B2579C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/kcore: convert read_kcore() to read_kcore_iter()
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-kcore-convert-read_kcore-to-read_kcore_iter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-kcore-convert-read_kcore-to-read_kcore_iter.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: fs/proc/kcore: convert read_kcore() to read_kcore_iter()
Date: Tue, 21 Mar 2023 20:54:31 +0000

Now we have eliminated spinlocks from the vread() case, convert
read_kcore() to read_kcore_iter().

For the time being we still use a bounce buffer for vread(), however in
the next patch we will convert this to interact directly with the iterator
and eliminate the bounce buffer altogether.

Link: https://lkml.kernel.org/r/a84da6cc458b44d949058b5f475ed3225008cfd9.1679431886.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Baoquan He <bhe@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |   58 +++++++++++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

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
+	loff_t *ppos = &iocb->ki_pos;
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
 
@@ -333,7 +337,7 @@ read_kcore(struct file *file, char __use
 	notes_offset = phdrs_offset + phdrs_len;
 
 	/* ELF file header. */
-	if (buflen && *fpos < sizeof(struct elfhdr)) {
+	if (buflen && *ppos < sizeof(struct elfhdr)) {
 		struct elfhdr ehdr = {
 			.e_ident = {
 				[EI_MAG0] = ELFMAG0,
@@ -355,19 +359,18 @@ read_kcore(struct file *file, char __use
 			.e_phnum = nphdr,
 		};
 
-		tsz = min_t(size_t, buflen, sizeof(struct elfhdr) - *fpos);
-		if (copy_to_user(buffer, (char *)&ehdr + *fpos, tsz)) {
+		tsz = min_t(size_t, buflen, sizeof(struct elfhdr) - *ppos);
+		if (copy_to_iter((char *)&ehdr + *ppos, tsz, iter) != tsz) {
 			ret = -EFAULT;
 			goto out;
 		}
 
-		buffer += tsz;
 		buflen -= tsz;
-		*fpos += tsz;
+		*ppos += tsz;
 	}
 
 	/* ELF program headers. */
-	if (buflen && *fpos < phdrs_offset + phdrs_len) {
+	if (buflen && *ppos < phdrs_offset + phdrs_len) {
 		struct elf_phdr *phdrs, *phdr;
 
 		phdrs = kzalloc(phdrs_len, GFP_KERNEL);
@@ -397,22 +400,21 @@ read_kcore(struct file *file, char __use
 			phdr++;
 		}
 
-		tsz = min_t(size_t, buflen, phdrs_offset + phdrs_len - *fpos);
-		if (copy_to_user(buffer, (char *)phdrs + *fpos - phdrs_offset,
-				 tsz)) {
+		tsz = min_t(size_t, buflen, phdrs_offset + phdrs_len - *ppos);
+		if (copy_to_iter((char *)phdrs + *ppos - phdrs_offset, tsz,
+				 iter) != tsz) {
 			kfree(phdrs);
 			ret = -EFAULT;
 			goto out;
 		}
 		kfree(phdrs);
 
-		buffer += tsz;
 		buflen -= tsz;
-		*fpos += tsz;
+		*ppos += tsz;
 	}
 
 	/* ELF note segment. */
-	if (buflen && *fpos < notes_offset + notes_len) {
+	if (buflen && *ppos < notes_offset + notes_len) {
 		struct elf_prstatus prstatus = {};
 		struct elf_prpsinfo prpsinfo = {
 			.pr_sname = 'R',
@@ -447,24 +449,23 @@ read_kcore(struct file *file, char __use
 				  vmcoreinfo_data,
 				  min(vmcoreinfo_size, notes_len - i));
 
-		tsz = min_t(size_t, buflen, notes_offset + notes_len - *fpos);
-		if (copy_to_user(buffer, notes + *fpos - notes_offset, tsz)) {
+		tsz = min_t(size_t, buflen, notes_offset + notes_len - *ppos);
+		if (copy_to_iter(notes + *ppos - notes_offset, tsz, iter) != tsz) {
 			kfree(notes);
 			ret = -EFAULT;
 			goto out;
 		}
 		kfree(notes);
 
-		buffer += tsz;
 		buflen -= tsz;
-		*fpos += tsz;
+		*ppos += tsz;
 	}
 
 	/*
 	 * Check to see if our file offset matches with any of
 	 * the addresses in the elf_phdr on our list.
 	 */
-	start = kc_offset_to_vaddr(*fpos - data_offset);
+	start = kc_offset_to_vaddr(*ppos - data_offset);
 	if ((tsz = (PAGE_SIZE - (start & ~PAGE_MASK))) > buflen)
 		tsz = buflen;
 
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
@@ -541,25 +542,24 @@ read_kcore(struct file *file, char __use
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
 		}
 skip:
 		buflen -= tsz;
-		*fpos += tsz;
-		buffer += tsz;
+		*ppos += tsz;
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

mm-prefer-xxx_page-alloc-free-functions-for-order-0-pages.patch
mm-refactor-do_fault_around.patch
mm-pefer-fault_around_pages-to-fault_around_bytes.patch
maintainers-add-myself-as-vmalloc-reviewer.patch
mm-remove-unused-vmf_insert_mixed_prot.patch
mm-remove-vmf_insert_pfn_xxx_prot-for-huge-page-table-entries.patch
drm-ttm-remove-comment-referencing-now-removed-vmf_insert_mixed_prot.patch
mm-mmap-vma_merge-further-improve-prev-next-vma-naming.patch
mm-mmap-vma_merge-set-next-to-null-if-not-applicable.patch
mm-mmap-vma_merge-extend-invariants-avoid-invalid-res-vma.patch
mm-mmap-vma_merge-init-cleanup-be-explicit-about-the-non-mergeable-case.patch
fs-proc-kcore-avoid-bounce-buffer-for-ktext-data.patch
fs-proc-kcore-convert-read_kcore-to-read_kcore_iter.patch
iov_iter-add-copy_page_to_iter_atomic.patch
mm-vmalloc-convert-vread-to-vread_iter.patch

