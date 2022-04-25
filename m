Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 601A9C43219
	for <mm-commits@archiver.kernel.org>; Mon, 25 Apr 2022 22:30:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbiDYWdH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Apr 2022 18:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233064AbiDYWce (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Apr 2022 18:32:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F20C3E88
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 15:27:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36C326147B
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 22:27:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A78C385A7;
        Mon, 25 Apr 2022 22:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650925621;
        bh=ovTVg3OcFsolRcPTj5a0TykxBshp5Ecn/LyWqFR+4ws=;
        h=Date:To:From:Subject:From;
        b=h9N5kpKYxSwC8A8zgRfJi22Lwwng4j6ao7FAkmK6T9HRIGheonYxZCHqi3P1i9bf4
         MwHM9pyUT9jcCuLRi1KJMbu0b8zOVrdiIjlDCrUPvv7eTX9kJ4ulzHiyQI77gtLPQr
         XIKivBWeCPUHgK4Wkk/itv17LD8onyzkfF9S4wI0=
Date:   Mon, 25 Apr 2022 15:27:00 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, hca@linux.ibm.com,
        bhe@redhat.com, willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + vmcore-convert-copy_oldmem_page-to-take-an-iov_iter.patch added to -mm tree
Message-Id: <20220425222701.76A78C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vmcore: convert copy_oldmem_page() to take an iov_iter
has been added to the -mm tree.  Its filename is
     vmcore-convert-copy_oldmem_page-to-take-an-iov_iter.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/vmcore-convert-copy_oldmem_page-to-take-an-iov_iter.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/vmcore-convert-copy_oldmem_page-to-take-an-iov_iter.patch

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
Subject: vmcore: convert copy_oldmem_page() to take an iov_iter

Patch series "Convert vmcore to use an iov_iter", v5.

For some reason several people have been sending bad patches to fix
compiler warnings in vmcore recently.  Here's how it should be done. 
Compile-tested only on x86.  As noted in the first patch, s390 should take
this conversion a bit further, but I'm not inclined to do that work
myself.


This patch (of 3):

Instead of passing in a 'buf' and 'userbuf' argument, pass in an iov_iter.
s390 needs more work to pass the iov_iter down further, or refactor, but
I'd be more comfortable if someone who can test on s390 did that work.

It's more convenient to convert the whole of read_from_oldmem() to take an
iov_iter at the same time, so rename it to read_from_oldmem_iter() and add
a temporary read_from_oldmem() wrapper that creates an iov_iter.

Link: https://lkml.kernel.org/r/20220408090636.560886-1-bhe@redhat.com
Link: https://lkml.kernel.org/r/20220408090636.560886-2-bhe@redhat.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/crash_dump.c     |   27 ++------------
 arch/arm64/kernel/crash_dump.c   |   29 ++-------------
 arch/ia64/kernel/crash_dump.c    |   32 ++---------------
 arch/mips/kernel/crash_dump.c    |   27 ++------------
 arch/powerpc/kernel/crash_dump.c |   35 ++----------------
 arch/riscv/kernel/crash_dump.c   |   26 ++-----------
 arch/s390/kernel/crash_dump.c    |   13 ++++--
 arch/sh/kernel/crash_dump.c      |   29 ++-------------
 arch/x86/kernel/crash_dump_32.c  |   29 ++-------------
 arch/x86/kernel/crash_dump_64.c  |   37 ++++---------------
 fs/proc/vmcore.c                 |   54 ++++++++++++++++++-----------
 include/linux/crash_dump.h       |    9 ++--
 12 files changed, 89 insertions(+), 258 deletions(-)

--- a/arch/arm64/kernel/crash_dump.c~vmcore-convert-copy_oldmem_page-to-take-an-iov_iter
+++ a/arch/arm64/kernel/crash_dump.c
@@ -9,25 +9,11 @@
 #include <linux/crash_dump.h>
 #include <linux/errno.h>
 #include <linux/io.h>
-#include <linux/memblock.h>
-#include <linux/uaccess.h>
+#include <linux/uio.h>
 #include <asm/memory.h>
 
-/**
- * copy_oldmem_page() - copy one page from old kernel memory
- * @pfn: page frame number to be copied
- * @buf: buffer where the copied page is placed
- * @csize: number of bytes to copy
- * @offset: offset in bytes into the page
- * @userbuf: if set, @buf is in a user address space
- *
- * This function copies one page from old kernel memory into buffer pointed by
- * @buf. If @buf is in userspace, set @userbuf to %1. Returns number of bytes
- * copied or negative error in case of failure.
- */
-ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
-			 size_t csize, unsigned long offset,
-			 int userbuf)
+ssize_t copy_oldmem_page(struct iov_iter *iter, unsigned long pfn,
+			 size_t csize, unsigned long offset)
 {
 	void *vaddr;
 
@@ -38,14 +24,7 @@ ssize_t copy_oldmem_page(unsigned long p
 	if (!vaddr)
 		return -ENOMEM;
 
-	if (userbuf) {
-		if (copy_to_user((char __user *)buf, vaddr + offset, csize)) {
-			memunmap(vaddr);
-			return -EFAULT;
-		}
-	} else {
-		memcpy(buf, vaddr + offset, csize);
-	}
+	csize = copy_to_iter(vaddr + offset, csize, iter);
 
 	memunmap(vaddr);
 
--- a/arch/arm/kernel/crash_dump.c~vmcore-convert-copy_oldmem_page-to-take-an-iov_iter
+++ a/arch/arm/kernel/crash_dump.c
@@ -14,22 +14,10 @@
 #include <linux/crash_dump.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
+#include <linux/uio.h>
 
-/**
- * copy_oldmem_page() - copy one page from old kernel memory
- * @pfn: page frame number to be copied
- * @buf: buffer where the copied page is placed
- * @csize: number of bytes to copy
- * @offset: offset in bytes into the page
- * @userbuf: if set, @buf is int he user address space
- *
- * This function copies one page from old kernel memory into buffer pointed by
- * @buf. If @buf is in userspace, set @userbuf to %1. Returns number of bytes
- * copied or negative error in case of failure.
- */
-ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
-			 size_t csize, unsigned long offset,
-			 int userbuf)
+ssize_t copy_oldmem_page(struct iov_iter *iter, unsigned long pfn,
+			 size_t csize, unsigned long offset)
 {
 	void *vaddr;
 
@@ -40,14 +28,7 @@ ssize_t copy_oldmem_page(unsigned long p
 	if (!vaddr)
 		return -ENOMEM;
 
-	if (userbuf) {
-		if (copy_to_user(buf, vaddr + offset, csize)) {
-			iounmap(vaddr);
-			return -EFAULT;
-		}
-	} else {
-		memcpy(buf, vaddr + offset, csize);
-	}
+	csize = copy_to_iter(vaddr + offset, csize, iter);
 
 	iounmap(vaddr);
 	return csize;
--- a/arch/ia64/kernel/crash_dump.c~vmcore-convert-copy_oldmem_page-to-take-an-iov_iter
+++ a/arch/ia64/kernel/crash_dump.c
@@ -10,42 +10,18 @@
 #include <linux/errno.h>
 #include <linux/types.h>
 #include <linux/crash_dump.h>
-
+#include <linux/uio.h>
 #include <asm/page.h>
-#include <linux/uaccess.h>
 
-/**
- * copy_oldmem_page - copy one page from "oldmem"
- * @pfn: page frame number to be copied
- * @buf: target memory address for the copy; this can be in kernel address
- *	space or user address space (see @userbuf)
- * @csize: number of bytes to copy
- * @offset: offset in bytes into the page (based on pfn) to begin the copy
- * @userbuf: if set, @buf is in user address space, use copy_to_user(),
- *	otherwise @buf is in kernel address space, use memcpy().
- *
- * Copy a page from "oldmem". For this page, there is no pte mapped
- * in the current kernel. We stitch up a pte, similar to kmap_atomic.
- *
- * Calling copy_to_user() in atomic context is not desirable. Hence first
- * copying the data to a pre-allocated kernel page and then copying to user
- * space in non-atomic context.
- */
-ssize_t
-copy_oldmem_page(unsigned long pfn, char *buf,
-		size_t csize, unsigned long offset, int userbuf)
+ssize_t copy_oldmem_page(struct iov_iter *iter, unsigned long pfn,
+		size_t csize, unsigned long offset)
 {
 	void  *vaddr;
 
 	if (!csize)
 		return 0;
 	vaddr = __va(pfn<<PAGE_SHIFT);
-	if (userbuf) {
-		if (copy_to_user(buf, (vaddr + offset), csize)) {
-			return -EFAULT;
-		}
-	} else
-		memcpy(buf, (vaddr + offset), csize);
+	csize = copy_to_iter(vaddr + offset, csize, iter);
 	return csize;
 }
 
--- a/arch/mips/kernel/crash_dump.c~vmcore-convert-copy_oldmem_page-to-take-an-iov_iter
+++ a/arch/mips/kernel/crash_dump.c
@@ -1,22 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/highmem.h>
 #include <linux/crash_dump.h>
+#include <linux/uio.h>
 
-/**
- * copy_oldmem_page - copy one page from "oldmem"
- * @pfn: page frame number to be copied
- * @buf: target memory address for the copy; this can be in kernel address
- *	space or user address space (see @userbuf)
- * @csize: number of bytes to copy
- * @offset: offset in bytes into the page (based on pfn) to begin the copy
- * @userbuf: if set, @buf is in user address space, use copy_to_user(),
- *	otherwise @buf is in kernel address space, use memcpy().
- *
- * Copy a page from "oldmem". For this page, there is no pte mapped
- * in the current kernel.
- */
-ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
-			 size_t csize, unsigned long offset, int userbuf)
+ssize_t copy_oldmem_page(struct iov_iter *iter, unsigned long pfn,
+			 size_t csize, unsigned long offset)
 {
 	void  *vaddr;
 
@@ -24,14 +12,7 @@ ssize_t copy_oldmem_page(unsigned long p
 		return 0;
 
 	vaddr = kmap_local_pfn(pfn);
-
-	if (!userbuf) {
-		memcpy(buf, vaddr + offset, csize);
-	} else {
-		if (copy_to_user(buf, vaddr + offset, csize))
-			csize = -EFAULT;
-	}
-
+	csize = copy_to_iter(vaddr + offset, csize, iter);
 	kunmap_local(vaddr);
 
 	return csize;
--- a/arch/powerpc/kernel/crash_dump.c~vmcore-convert-copy_oldmem_page-to-take-an-iov_iter
+++ a/arch/powerpc/kernel/crash_dump.c
@@ -16,7 +16,7 @@
 #include <asm/kdump.h>
 #include <asm/prom.h>
 #include <asm/firmware.h>
-#include <linux/uaccess.h>
+#include <linux/uio.h>
 #include <asm/rtas.h>
 #include <asm/inst.h>
 
@@ -68,33 +68,8 @@ void __init setup_kdump_trampoline(void)
 }
 #endif /* CONFIG_NONSTATIC_KERNEL */
 
-static size_t copy_oldmem_vaddr(void *vaddr, char *buf, size_t csize,
-                               unsigned long offset, int userbuf)
-{
-	if (userbuf) {
-		if (copy_to_user((char __user *)buf, (vaddr + offset), csize))
-			return -EFAULT;
-	} else
-		memcpy(buf, (vaddr + offset), csize);
-
-	return csize;
-}
-
-/**
- * copy_oldmem_page - copy one page from "oldmem"
- * @pfn: page frame number to be copied
- * @buf: target memory address for the copy; this can be in kernel address
- *      space or user address space (see @userbuf)
- * @csize: number of bytes to copy
- * @offset: offset in bytes into the page (based on pfn) to begin the copy
- * @userbuf: if set, @buf is in user address space, use copy_to_user(),
- *      otherwise @buf is in kernel address space, use memcpy().
- *
- * Copy a page from "oldmem". For this page, there is no pte mapped
- * in the current kernel. We stitch up a pte, similar to kmap_atomic.
- */
-ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
-			size_t csize, unsigned long offset, int userbuf)
+ssize_t copy_oldmem_page(struct iov_iter *iter, unsigned long pfn,
+			size_t csize, unsigned long offset)
 {
 	void  *vaddr;
 	phys_addr_t paddr;
@@ -107,10 +82,10 @@ ssize_t copy_oldmem_page(unsigned long p
 
 	if (memblock_is_region_memory(paddr, csize)) {
 		vaddr = __va(paddr);
-		csize = copy_oldmem_vaddr(vaddr, buf, csize, offset, userbuf);
+		csize = copy_to_iter(vaddr + offset, csize, iter);
 	} else {
 		vaddr = ioremap_cache(paddr, PAGE_SIZE);
-		csize = copy_oldmem_vaddr(vaddr, buf, csize, offset, userbuf);
+		csize = copy_to_iter(vaddr + offset, csize, iter);
 		iounmap(vaddr);
 	}
 
--- a/arch/riscv/kernel/crash_dump.c~vmcore-convert-copy_oldmem_page-to-take-an-iov_iter
+++ a/arch/riscv/kernel/crash_dump.c
@@ -7,22 +7,10 @@
 
 #include <linux/crash_dump.h>
 #include <linux/io.h>
+#include <linux/uio.h>
 
-/**
- * copy_oldmem_page() - copy one page from old kernel memory
- * @pfn: page frame number to be copied
- * @buf: buffer where the copied page is placed
- * @csize: number of bytes to copy
- * @offset: offset in bytes into the page
- * @userbuf: if set, @buf is in a user address space
- *
- * This function copies one page from old kernel memory into buffer pointed by
- * @buf. If @buf is in userspace, set @userbuf to %1. Returns number of bytes
- * copied or negative error in case of failure.
- */
-ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
-			 size_t csize, unsigned long offset,
-			 int userbuf)
+ssize_t copy_oldmem_page(struct iov_iter *iter, unsigned long pfn,
+			 size_t csize, unsigned long offset)
 {
 	void *vaddr;
 
@@ -33,13 +21,7 @@ ssize_t copy_oldmem_page(unsigned long p
 	if (!vaddr)
 		return -ENOMEM;
 
-	if (userbuf) {
-		if (copy_to_user((char __user *)buf, vaddr + offset, csize)) {
-			memunmap(vaddr);
-			return -EFAULT;
-		}
-	} else
-		memcpy(buf, vaddr + offset, csize);
+	csize = copy_to_iter(vaddr + offset, csize, iter);
 
 	memunmap(vaddr);
 	return csize;
--- a/arch/s390/kernel/crash_dump.c~vmcore-convert-copy_oldmem_page-to-take-an-iov_iter
+++ a/arch/s390/kernel/crash_dump.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/memblock.h>
 #include <linux/elf.h>
+#include <linux/uio.h>
 #include <asm/asm-offsets.h>
 #include <asm/os_info.h>
 #include <asm/elf.h>
@@ -212,8 +213,8 @@ static int copy_oldmem_user(void __user
 /*
  * Copy one page from "oldmem"
  */
-ssize_t copy_oldmem_page(unsigned long pfn, char *buf, size_t csize,
-			 unsigned long offset, int userbuf)
+ssize_t copy_oldmem_page(struct iov_iter *iter, unsigned long pfn, size_t csize,
+			 unsigned long offset)
 {
 	unsigned long src;
 	int rc;
@@ -221,10 +222,12 @@ ssize_t copy_oldmem_page(unsigned long p
 	if (!csize)
 		return 0;
 	src = pfn_to_phys(pfn) + offset;
-	if (userbuf)
-		rc = copy_oldmem_user((void __force __user *) buf, src, csize);
+
+	/* XXX: pass the iov_iter down to a common function */
+	if (iter_is_iovec(iter))
+		rc = copy_oldmem_user(iter->iov->iov_base, src, csize);
 	else
-		rc = copy_oldmem_kernel((void *) buf, src, csize);
+		rc = copy_oldmem_kernel(iter->kvec->iov_base, src, csize);
 	return rc;
 }
 
--- a/arch/sh/kernel/crash_dump.c~vmcore-convert-copy_oldmem_page-to-take-an-iov_iter
+++ a/arch/sh/kernel/crash_dump.c
@@ -8,23 +8,11 @@
 #include <linux/errno.h>
 #include <linux/crash_dump.h>
 #include <linux/io.h>
+#include <linux/uio.h>
 #include <linux/uaccess.h>
 
-/**
- * copy_oldmem_page - copy one page from "oldmem"
- * @pfn: page frame number to be copied
- * @buf: target memory address for the copy; this can be in kernel address
- *	space or user address space (see @userbuf)
- * @csize: number of bytes to copy
- * @offset: offset in bytes into the page (based on pfn) to begin the copy
- * @userbuf: if set, @buf is in user address space, use copy_to_user(),
- *	otherwise @buf is in kernel address space, use memcpy().
- *
- * Copy a page from "oldmem". For this page, there is no pte mapped
- * in the current kernel. We stitch up a pte, similar to kmap_atomic.
- */
-ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
-                               size_t csize, unsigned long offset, int userbuf)
+ssize_t copy_oldmem_page(struct iov_iter *iter, unsigned long pfn,
+			 size_t csize, unsigned long offset)
 {
 	void  __iomem *vaddr;
 
@@ -32,15 +20,8 @@ ssize_t copy_oldmem_page(unsigned long p
 		return 0;
 
 	vaddr = ioremap(pfn << PAGE_SHIFT, PAGE_SIZE);
-
-	if (userbuf) {
-		if (copy_to_user((void __user *)buf, (vaddr + offset), csize)) {
-			iounmap(vaddr);
-			return -EFAULT;
-		}
-	} else
-	memcpy(buf, (vaddr + offset), csize);
-
+	csize = copy_to_iter(vaddr + offset, csize, iter);
 	iounmap(vaddr);
+
 	return csize;
 }
--- a/arch/x86/kernel/crash_dump_32.c~vmcore-convert-copy_oldmem_page-to-take-an-iov_iter
+++ a/arch/x86/kernel/crash_dump_32.c
@@ -10,8 +10,7 @@
 #include <linux/errno.h>
 #include <linux/highmem.h>
 #include <linux/crash_dump.h>
-
-#include <linux/uaccess.h>
+#include <linux/uio.h>
 
 static inline bool is_crashed_pfn_valid(unsigned long pfn)
 {
@@ -29,21 +28,8 @@ static inline bool is_crashed_pfn_valid(
 #endif
 }
 
-/**
- * copy_oldmem_page - copy one page from "oldmem"
- * @pfn: page frame number to be copied
- * @buf: target memory address for the copy; this can be in kernel address
- *	space or user address space (see @userbuf)
- * @csize: number of bytes to copy
- * @offset: offset in bytes into the page (based on pfn) to begin the copy
- * @userbuf: if set, @buf is in user address space, use copy_to_user(),
- *	otherwise @buf is in kernel address space, use memcpy().
- *
- * Copy a page from "oldmem". For this page, there might be no pte mapped
- * in the current kernel.
- */
-ssize_t copy_oldmem_page(unsigned long pfn, char *buf, size_t csize,
-			 unsigned long offset, int userbuf)
+ssize_t copy_oldmem_page(struct iov_iter *iter, unsigned long pfn, size_t csize,
+			 unsigned long offset)
 {
 	void  *vaddr;
 
@@ -54,14 +40,7 @@ ssize_t copy_oldmem_page(unsigned long p
 		return -EFAULT;
 
 	vaddr = kmap_local_pfn(pfn);
-
-	if (!userbuf) {
-		memcpy(buf, vaddr + offset, csize);
-	} else {
-		if (copy_to_user(buf, vaddr + offset, csize))
-			csize = -EFAULT;
-	}
-
+	csize = copy_to_iter(vaddr + offset, csize, iter);
 	kunmap_local(vaddr);
 
 	return csize;
--- a/arch/x86/kernel/crash_dump_64.c~vmcore-convert-copy_oldmem_page-to-take-an-iov_iter
+++ a/arch/x86/kernel/crash_dump_64.c
@@ -8,12 +8,12 @@
 
 #include <linux/errno.h>
 #include <linux/crash_dump.h>
-#include <linux/uaccess.h>
+#include <linux/uio.h>
 #include <linux/io.h>
 #include <linux/cc_platform.h>
 
-static ssize_t __copy_oldmem_page(unsigned long pfn, char *buf, size_t csize,
-				  unsigned long offset, int userbuf,
+static ssize_t __copy_oldmem_page(struct iov_iter *iter, unsigned long pfn,
+				  size_t csize, unsigned long offset,
 				  bool encrypted)
 {
 	void  *vaddr;
@@ -29,44 +29,25 @@ static ssize_t __copy_oldmem_page(unsign
 	if (!vaddr)
 		return -ENOMEM;
 
-	if (userbuf) {
-		if (copy_to_user((void __user *)buf, vaddr + offset, csize)) {
-			iounmap((void __iomem *)vaddr);
-			return -EFAULT;
-		}
-	} else
-		memcpy(buf, vaddr + offset, csize);
+	csize = copy_to_iter(vaddr + offset, csize, iter);
 
 	iounmap((void __iomem *)vaddr);
 	return csize;
 }
 
-/**
- * copy_oldmem_page - copy one page of memory
- * @pfn: page frame number to be copied
- * @buf: target memory address for the copy; this can be in kernel address
- *	space or user address space (see @userbuf)
- * @csize: number of bytes to copy
- * @offset: offset in bytes into the page (based on pfn) to begin the copy
- * @userbuf: if set, @buf is in user address space, use copy_to_user(),
- *	otherwise @buf is in kernel address space, use memcpy().
- *
- * Copy a page from the old kernel's memory. For this page, there is no pte
- * mapped in the current kernel. We stitch up a pte, similar to kmap_atomic.
- */
-ssize_t copy_oldmem_page(unsigned long pfn, char *buf, size_t csize,
-			 unsigned long offset, int userbuf)
+ssize_t copy_oldmem_page(struct iov_iter *iter, unsigned long pfn, size_t csize,
+			 unsigned long offset)
 {
 	return __copy_oldmem_page(pfn, buf, csize, offset, userbuf, false);
 }
 
-/**
+/*
  * copy_oldmem_page_encrypted - same as copy_oldmem_page() above but ioremap the
  * memory with the encryption mask set to accommodate kdump on SME-enabled
  * machines.
  */
-ssize_t copy_oldmem_page_encrypted(unsigned long pfn, char *buf, size_t csize,
-				   unsigned long offset, int userbuf)
+ssize_t copy_oldmem_page_encrypted(struct iov_iter *iter, unsigned long pfn,
+				   size_t csize, unsigned long offset)
 {
 	return __copy_oldmem_page(pfn, buf, csize, offset, userbuf, true);
 }
--- a/fs/proc/vmcore.c~vmcore-convert-copy_oldmem_page-to-take-an-iov_iter
+++ a/fs/proc/vmcore.c
@@ -26,6 +26,7 @@
 #include <linux/vmalloc.h>
 #include <linux/pagemap.h>
 #include <linux/uaccess.h>
+#include <linux/uio.h>
 #include <linux/cc_platform.h>
 #include <asm/io.h>
 #include "internal.h"
@@ -128,9 +129,8 @@ static int open_vmcore(struct inode *ino
 }
 
 /* Reads a page from the oldmem device from given offset. */
-ssize_t read_from_oldmem(char *buf, size_t count,
-			 u64 *ppos, int userbuf,
-			 bool encrypted)
+static ssize_t read_from_oldmem_iter(struct iov_iter *iter, size_t count,
+			 u64 *ppos, bool encrypted)
 {
 	unsigned long pfn, offset;
 	size_t nr_bytes;
@@ -152,29 +152,23 @@ ssize_t read_from_oldmem(char *buf, size
 
 		/* If pfn is not ram, return zeros for sparse dump files */
 		if (!pfn_is_ram(pfn)) {
-			tmp = 0;
-			if (!userbuf)
-				memset(buf, 0, nr_bytes);
-			else if (clear_user(buf, nr_bytes))
-				tmp = -EFAULT;
+			tmp = iov_iter_zero(nr_bytes, iter);
 		} else {
 			if (encrypted)
-				tmp = copy_oldmem_page_encrypted(pfn, buf,
+				tmp = copy_oldmem_page_encrypted(iter, pfn,
 								 nr_bytes,
-								 offset,
-								 userbuf);
+								 offset);
 			else
-				tmp = copy_oldmem_page(pfn, buf, nr_bytes,
-						       offset, userbuf);
+				tmp = copy_oldmem_page(iter, pfn, nr_bytes,
+						       offset);
 		}
-		if (tmp < 0) {
+		if (tmp < nr_bytes) {
 			srcu_read_unlock(&vmcore_cb_srcu, idx);
-			return tmp;
+			return -EFAULT;
 		}
 
 		*ppos += nr_bytes;
 		count -= nr_bytes;
-		buf += nr_bytes;
 		read += nr_bytes;
 		++pfn;
 		offset = 0;
@@ -184,6 +178,27 @@ ssize_t read_from_oldmem(char *buf, size
 	return read;
 }
 
+ssize_t read_from_oldmem(char *buf, size_t count,
+			 u64 *ppos, int userbuf,
+			 bool encrypted)
+{
+	struct iov_iter iter;
+	struct iovec iov;
+	struct kvec kvec;
+
+	if (userbuf) {
+		iov.iov_base = (__force void __user *)buf;
+		iov.iov_len = count;
+		iov_iter_init(&iter, READ, &iov, 1, count);
+	} else {
+		kvec.iov_base = buf;
+		kvec.iov_len = count;
+		iov_iter_kvec(&iter, READ, &kvec, 1, count);
+	}
+
+	return read_from_oldmem_iter(&iter, count, ppos, encrypted);
+}
+
 /*
  * Architectures may override this function to allocate ELF header in 2nd kernel
  */
@@ -228,11 +243,10 @@ int __weak remap_oldmem_pfn_range(struct
 /*
  * Architectures which support memory encryption override this.
  */
-ssize_t __weak
-copy_oldmem_page_encrypted(unsigned long pfn, char *buf, size_t csize,
-			   unsigned long offset, int userbuf)
+ssize_t __weak copy_oldmem_page_encrypted(struct iov_iter *iter,
+		unsigned long pfn, size_t csize, unsigned long offset)
 {
-	return copy_oldmem_page(pfn, buf, csize, offset, userbuf);
+	return copy_oldmem_page(iter, pfn, csize, offset);
 }
 
 /*
--- a/include/linux/crash_dump.h~vmcore-convert-copy_oldmem_page-to-take-an-iov_iter
+++ a/include/linux/crash_dump.h
@@ -24,11 +24,10 @@ extern int remap_oldmem_pfn_range(struct
 				  unsigned long from, unsigned long pfn,
 				  unsigned long size, pgprot_t prot);
 
-extern ssize_t copy_oldmem_page(unsigned long, char *, size_t,
-						unsigned long, int);
-extern ssize_t copy_oldmem_page_encrypted(unsigned long pfn, char *buf,
-					  size_t csize, unsigned long offset,
-					  int userbuf);
+ssize_t copy_oldmem_page(struct iov_iter *i, unsigned long pfn, size_t csize,
+		unsigned long offset);
+ssize_t copy_oldmem_page_encrypted(struct iov_iter *iter, unsigned long pfn,
+				   size_t csize, unsigned long offset);
 
 void vmcore_cleanup(void);
 
_

Patches currently in -mm which might be from willy@infradead.org are

vmcore-convert-copy_oldmem_page-to-take-an-iov_iter.patch
vmcore-convert-__read_vmcore-to-use-an-iov_iter.patch
vmcore-convert-read_from_oldmem-to-take-an-iov_iter.patch

