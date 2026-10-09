Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF47411A1B
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525507; cv=none; b=a6+Q8sxkXIX0YPi328Bn1DFmhxlwjTTFhV11J3eOfNkZbuVnX08GxyMZkaIVtbxX8WfyzEY/++jJw4J2MstxQkjGrXFlPZbH7qMMMXNvlVYI682M/UD+maj4OYd8OIbVqEZwo/iABTnMkN941ZkbArUEtjtv4v8Qs+va/ekD27k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525507; c=relaxed/simple;
	bh=IGp/bw7gyngTPxZk75B0j1DrfsTR8lk6AchwjVsIfeg=;
	h=Date:To:From:Subject:Message-Id; b=iPaREtrA727MGoeN3YjJX+S2cV2LmejQLUh3IfYMt4VbSZVujMvthzIbBORN7xNm2Rmcbjt01Fv8rWo5qmrOJH6BsgMxRwB97kQ+N1GlgubDnITTxuPlldeFWoyyh7QXcXn2GJmGNv4KgEbrtanRoK3gstsTnPg6QRIj0OzMLBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MfVClnTq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MfVClnTq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97DB01F00893;
	Fri,  9 Oct 2026 05:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525504;
	bh=Ckla00RBpDD0sx6e0n2eFyOFHBavZPDjEwpbJVLmpLY=;
	h=Date:To:From:Subject;
	b=MfVClnTqmG33ePOuQkM6/LQgCGNNuXRCE9hwt9F/OPbwc9icOK/Fjyu1YuaHkCKm3
	 JVGbnyhEjMCPUp18PL4meIcBObmcwHZkD/gnl3qPxoFIJ1xAsmLC5M6V64RzfqIJC2
	 qbV4N3hEfFZ7/KcYVy08pBajhmeniJdZiMV4ms6o=
Date: Thu, 08 Oct 2026 22:58:24 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,liam@infradead.org,jannh@google.com,jack@suse.cz,hughd@google.com,gregkh@linuxfoundation.org,david@kernel.org,baolin.wang@linux.alibaba.com,arnd@arndb.de,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-drivers-char-memc-to-mm-char-memc.patch removed from -mm tree
Message-Id: <20261009055824.97DB01F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: move drivers/char/mem.c to mm/char-mem.c
has been removed from the -mm tree.  Its filename was
     mm-move-drivers-char-memc-to-mm-char-memc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm: move drivers/char/mem.c to mm/char-mem.c
Date: Sat, 26 Sep 2026 11:41:06 +0100

The memory character driver implements several mm-specific features and is
always compiled into the kernel, so move it to mm/ where it belongs.

Among other things the driver implements /dev/mem which provides raw access
to physical memory, and /dev/zero which either allows mapping of a shmem
region (if mapped with MAP_SHARED) or, uniquely, anonymous memory (if
mapped MAP_PRIVATE).

This change lays the foundations to allow MAP_PRIVATE-/dev/zero to be
mapped precisely the same as anonymous memory is mapped as currently it is
an edge case within mm.

Also update a couple of comments that reference 'drivers/char/mem.c' to
reference 'mm/char-mem.c'.

Link: https://lore.kernel.org/20260926-map-private-dev-zero-v3-1-d4781e84ccfc@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
---

 MAINTAINERS           |    4 
 drivers/char/Makefile |    2 
 drivers/char/mem.c    |  778 ----------------------------------------
 mm/Makefile           |    3 
 mm/char-mem.c         |  778 ++++++++++++++++++++++++++++++++++++++++
 mm/shmem.c            |    2 
 6 files changed, 784 insertions(+), 783 deletions(-)

--- a/drivers/char/Makefile~mm-move-drivers-char-memc-to-mm-char-memc
+++ a/drivers/char/Makefile
@@ -3,7 +3,7 @@
 # Makefile for the kernel character device drivers.
 #
 
-obj-y				+= mem.o random.o
+obj-y				+= random.o
 obj-$(CONFIG_TTY_PRINTK)	+= ttyprintk.o
 obj-y				+= misc.o
 obj-$(CONFIG_TEST_MISC_MINOR)	+= misc_minor_kunit.o
diff --git a/drivers/char/mem.c a/drivers/char/mem.c
deleted file mode 100644
--- a/drivers/char/mem.c
+++ /dev/null
@@ -1,778 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- *  linux/drivers/char/mem.c
- *
- *  Copyright (C) 1991, 1992  Linus Torvalds
- *
- *  Added devfs support.
- *    Jan-11-1998, C. Scott Ananian <cananian@alumni.princeton.edu>
- *  Shared /dev/zero mmapping support, Feb 2000, Kanoj Sarcar <kanoj@sgi.com>
- */
-
-#include <linux/mm.h>
-#include <linux/miscdevice.h>
-#include <linux/slab.h>
-#include <linux/vmalloc.h>
-#include <linux/mman.h>
-#include <linux/random.h>
-#include <linux/init.h>
-#include <linux/tty.h>
-#include <linux/capability.h>
-#include <linux/ptrace.h>
-#include <linux/device.h>
-#include <linux/highmem.h>
-#include <linux/backing-dev.h>
-#include <linux/shmem_fs.h>
-#include <linux/splice.h>
-#include <linux/pfn.h>
-#include <linux/export.h>
-#include <linux/io.h>
-#include <linux/uio.h>
-#include <linux/uaccess.h>
-#include <linux/security.h>
-
-#define DEVMEM_MINOR	1
-#define DEVPORT_MINOR	4
-
-static inline unsigned long size_inside_page(unsigned long start,
-					     unsigned long size)
-{
-	unsigned long sz;
-
-	sz = PAGE_SIZE - (start & (PAGE_SIZE - 1));
-
-	return min(sz, size);
-}
-
-#ifndef ARCH_HAS_VALID_PHYS_ADDR_RANGE
-static inline int valid_phys_addr_range(phys_addr_t addr, size_t count)
-{
-	return addr + count <= __pa(high_memory);
-}
-
-static inline int valid_mmap_phys_addr_range(unsigned long pfn, size_t size)
-{
-	return 1;
-}
-#endif
-
-#ifdef CONFIG_STRICT_DEVMEM
-static inline int page_is_allowed(unsigned long pfn)
-{
-	return devmem_is_allowed(pfn);
-}
-#else
-static inline int page_is_allowed(unsigned long pfn)
-{
-	return 1;
-}
-#endif
-
-static inline bool should_stop_iteration(void)
-{
-	if (need_resched())
-		cond_resched();
-	return signal_pending(current);
-}
-
-/*
- * This funcion reads the *physical* memory. The f_pos points directly to the
- * memory location.
- */
-static ssize_t read_mem(struct file *file, char __user *buf,
-			size_t count, loff_t *ppos)
-{
-	phys_addr_t p = *ppos;
-	ssize_t read, sz;
-	void *ptr;
-	char *bounce;
-	int err;
-
-	if (p != *ppos)
-		return 0;
-
-	if (!valid_phys_addr_range(p, count))
-		return -EFAULT;
-	read = 0;
-#ifdef __ARCH_HAS_NO_PAGE_ZERO_MAPPED
-	/* we don't have page 0 mapped on sparc and m68k.. */
-	if (p < PAGE_SIZE) {
-		sz = size_inside_page(p, count);
-		if (sz > 0) {
-			if (clear_user(buf, sz))
-				return -EFAULT;
-			buf += sz;
-			p += sz;
-			count -= sz;
-			read += sz;
-		}
-	}
-#endif
-
-	bounce = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!bounce)
-		return -ENOMEM;
-
-	while (count > 0) {
-		unsigned long remaining;
-		int allowed, probe;
-
-		sz = size_inside_page(p, count);
-
-		err = -EPERM;
-		allowed = page_is_allowed(p >> PAGE_SHIFT);
-		if (!allowed)
-			goto failed;
-
-		err = -EFAULT;
-		if (allowed == 2) {
-			/* Show zeros for restricted memory. */
-			remaining = clear_user(buf, sz);
-		} else {
-			/*
-			 * On ia64 if a page has been mapped somewhere as
-			 * uncached, then it must also be accessed uncached
-			 * by the kernel or data corruption may occur.
-			 */
-			ptr = xlate_dev_mem_ptr(p);
-			if (!ptr)
-				goto failed;
-
-			probe = copy_from_kernel_nofault(bounce, ptr, sz);
-			unxlate_dev_mem_ptr(p, ptr);
-			if (probe)
-				goto failed;
-
-			remaining = copy_to_user(buf, bounce, sz);
-		}
-
-		if (remaining)
-			goto failed;
-
-		buf += sz;
-		p += sz;
-		count -= sz;
-		read += sz;
-		if (should_stop_iteration())
-			break;
-	}
-	kfree(bounce);
-
-	*ppos += read;
-	return read;
-
-failed:
-	kfree(bounce);
-	return err;
-}
-
-static ssize_t write_mem(struct file *file, const char __user *buf,
-			 size_t count, loff_t *ppos)
-{
-	phys_addr_t p = *ppos;
-	ssize_t written, sz;
-	unsigned long copied;
-	void *ptr;
-
-	if (p != *ppos)
-		return -EFBIG;
-
-	if (!valid_phys_addr_range(p, count))
-		return -EFAULT;
-
-	written = 0;
-
-#ifdef __ARCH_HAS_NO_PAGE_ZERO_MAPPED
-	/* we don't have page 0 mapped on sparc and m68k.. */
-	if (p < PAGE_SIZE) {
-		sz = size_inside_page(p, count);
-		/* Hmm. Do something? */
-		buf += sz;
-		p += sz;
-		count -= sz;
-		written += sz;
-	}
-#endif
-
-	while (count > 0) {
-		int allowed;
-
-		sz = size_inside_page(p, count);
-
-		allowed = page_is_allowed(p >> PAGE_SHIFT);
-		if (!allowed)
-			return -EPERM;
-
-		/* Skip actual writing when a page is marked as restricted. */
-		if (allowed == 1) {
-			/*
-			 * On ia64 if a page has been mapped somewhere as
-			 * uncached, then it must also be accessed uncached
-			 * by the kernel or data corruption may occur.
-			 */
-			ptr = xlate_dev_mem_ptr(p);
-			if (!ptr) {
-				if (written)
-					break;
-				return -EFAULT;
-			}
-
-			copied = copy_from_user(ptr, buf, sz);
-			unxlate_dev_mem_ptr(p, ptr);
-			if (copied) {
-				written += sz - copied;
-				if (written)
-					break;
-				return -EFAULT;
-			}
-		}
-
-		buf += sz;
-		p += sz;
-		count -= sz;
-		written += sz;
-		if (should_stop_iteration())
-			break;
-	}
-
-	*ppos += written;
-	return written;
-}
-
-int __weak phys_mem_access_prot_allowed(struct file *file,
-	unsigned long pfn, unsigned long size, pgprot_t *vma_prot)
-{
-	return 1;
-}
-
-#ifndef __HAVE_PHYS_MEM_ACCESS_PROT
-
-/*
- * Architectures vary in how they handle caching for addresses
- * outside of main memory.
- *
- */
-#ifdef pgprot_noncached
-static int uncached_access(struct file *file, phys_addr_t addr)
-{
-	/*
-	 * Accessing memory above the top the kernel knows about or through a
-	 * file pointer
-	 * that was marked O_DSYNC will be done non-cached.
-	 */
-	if (file->f_flags & O_DSYNC)
-		return 1;
-	return addr >= __pa(high_memory);
-}
-#endif
-
-static pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
-				     unsigned long size, pgprot_t vma_prot)
-{
-#ifdef pgprot_noncached
-	phys_addr_t offset = pfn << PAGE_SHIFT;
-
-	if (uncached_access(file, offset))
-		return pgprot_noncached(vma_prot);
-#endif
-	return vma_prot;
-}
-#endif
-
-#ifndef CONFIG_MMU
-static unsigned long get_unmapped_area_mem(struct file *file,
-					   unsigned long addr,
-					   unsigned long len,
-					   unsigned long pgoff,
-					   unsigned long flags)
-{
-	if (!valid_mmap_phys_addr_range(pgoff, len))
-		return (unsigned long) -EINVAL;
-	return pgoff << PAGE_SHIFT;
-}
-
-/* permit direct mmap, for read, write or exec */
-static unsigned memory_mmap_capabilities(struct file *file)
-{
-	return NOMMU_MAP_DIRECT |
-		NOMMU_MAP_READ | NOMMU_MAP_WRITE | NOMMU_MAP_EXEC;
-}
-
-static unsigned zero_mmap_capabilities(struct file *file)
-{
-	return NOMMU_MAP_COPY;
-}
-
-/* can't do an in-place private mapping if there's no MMU */
-static inline int private_mapping_ok(struct vm_area_desc *desc)
-{
-	return is_nommu_shared_vma_flags(&desc->vma_flags);
-}
-#else
-
-static inline int private_mapping_ok(struct vm_area_desc *desc)
-{
-	return 1;
-}
-#endif
-
-static const struct vm_operations_struct mmap_mem_ops = {
-#ifdef CONFIG_HAVE_IOREMAP_PROT
-	.access = generic_access_phys
-#endif
-};
-
-static int mmap_mem_prepare(struct vm_area_desc *desc)
-{
-	struct file *file = desc->file;
-	const size_t size = vma_desc_size(desc);
-	const phys_addr_t offset = (phys_addr_t)desc->pgoff << PAGE_SHIFT;
-
-	/* Does it even fit in phys_addr_t? */
-	if (offset >> PAGE_SHIFT != desc->pgoff)
-		return -EINVAL;
-
-	/* It's illegal to wrap around the end of the physical address space. */
-	if (offset + (phys_addr_t)size - 1 < offset)
-		return -EINVAL;
-
-	if (!valid_mmap_phys_addr_range(desc->pgoff, size))
-		return -EINVAL;
-
-	if (!private_mapping_ok(desc))
-		return -ENOSYS;
-
-	if (!range_is_allowed(desc->pgoff, size))
-		return -EPERM;
-
-	if (!phys_mem_access_prot_allowed(file, desc->pgoff, size,
-					  &desc->page_prot))
-		return -EINVAL;
-
-	desc->page_prot = phys_mem_access_prot(file, desc->pgoff,
-					       size,
-					       desc->page_prot);
-
-	desc->vm_ops = &mmap_mem_ops;
-
-	/* Remap-pfn-range will mark the range with the I/O flag. */
-	mmap_action_remap_full(desc, desc->pgoff);
-	desc->action.error_override = -EAGAIN;
-
-	return 0;
-}
-
-#ifdef CONFIG_DEVPORT
-static ssize_t read_port(struct file *file, char __user *buf,
-			 size_t count, loff_t *ppos)
-{
-	unsigned long i = *ppos;
-	char __user *tmp = buf;
-
-	if (!access_ok(buf, count))
-		return -EFAULT;
-	while (count-- > 0 && i < 65536) {
-		if (__put_user(inb(i), tmp) < 0)
-			return -EFAULT;
-		i++;
-		tmp++;
-	}
-	*ppos = i;
-	return tmp-buf;
-}
-
-static ssize_t write_port(struct file *file, const char __user *buf,
-			  size_t count, loff_t *ppos)
-{
-	unsigned long i = *ppos;
-	const char __user *tmp = buf;
-
-	if (!access_ok(buf, count))
-		return -EFAULT;
-	while (count-- > 0 && i < 65536) {
-		char c;
-
-		if (__get_user(c, tmp)) {
-			if (tmp > buf)
-				break;
-			return -EFAULT;
-		}
-		outb(c, i);
-		i++;
-		tmp++;
-	}
-	*ppos = i;
-	return tmp-buf;
-}
-#endif
-
-static ssize_t read_null(struct file *file, char __user *buf,
-			 size_t count, loff_t *ppos)
-{
-	return 0;
-}
-
-static ssize_t write_null(struct file *file, const char __user *buf,
-			  size_t count, loff_t *ppos)
-{
-	return count;
-}
-
-static ssize_t read_iter_null(struct kiocb *iocb, struct iov_iter *to)
-{
-	return 0;
-}
-
-static ssize_t write_iter_null(struct kiocb *iocb, struct iov_iter *from)
-{
-	size_t count = iov_iter_count(from);
-	iov_iter_advance(from, count);
-	return count;
-}
-
-static int pipe_to_null(struct pipe_inode_info *info, struct pipe_buffer *buf,
-			struct splice_desc *sd)
-{
-	return sd->len;
-}
-
-static ssize_t splice_write_null(struct pipe_inode_info *pipe, struct file *out,
-				 loff_t *ppos, size_t len, unsigned int flags)
-{
-	return splice_from_pipe(pipe, out, ppos, len, flags, pipe_to_null);
-}
-
-static int uring_cmd_null(struct io_uring_cmd *ioucmd, unsigned int issue_flags)
-{
-	return 0;
-}
-
-static ssize_t read_iter_zero(struct kiocb *iocb, struct iov_iter *iter)
-{
-	size_t written = 0;
-
-	while (iov_iter_count(iter)) {
-		size_t chunk = iov_iter_count(iter), n;
-
-		if (chunk > PAGE_SIZE)
-			chunk = PAGE_SIZE;	/* Just for latency reasons */
-		n = iov_iter_zero(chunk, iter);
-		if (!n && iov_iter_count(iter))
-			return written ? written : -EFAULT;
-		written += n;
-		if (signal_pending(current))
-			return written ? written : -ERESTARTSYS;
-		if (!need_resched())
-			continue;
-		if (iocb->ki_flags & IOCB_NOWAIT)
-			return written ? written : -EAGAIN;
-		cond_resched();
-	}
-	return written;
-}
-
-static ssize_t read_zero(struct file *file, char __user *buf,
-			 size_t count, loff_t *ppos)
-{
-	size_t cleared = 0;
-
-	while (count) {
-		size_t chunk = min_t(size_t, count, PAGE_SIZE);
-		size_t left;
-
-		left = clear_user(buf + cleared, chunk);
-		if (unlikely(left)) {
-			cleared += (chunk - left);
-			if (!cleared)
-				return -EFAULT;
-			break;
-		}
-		cleared += chunk;
-		count -= chunk;
-
-		if (signal_pending(current))
-			break;
-		cond_resched();
-	}
-
-	return cleared;
-}
-
-static int mmap_zero_prepare(struct vm_area_desc *desc)
-{
-#ifndef CONFIG_MMU
-	return -ENOSYS;
-#endif
-	if (vma_desc_test(desc, VMA_MAYSHARE_BIT))
-		return shmem_zero_setup_desc(desc);
-
-	/*
-	 * This is a highly unique situation where we mark a MAP_PRIVATE mapping
-	 * of /dev/zero anonymous, despite it not being.
-	 */
-	vma_desc_set_anonymous(desc);
-	return 0;
-}
-
-#ifndef CONFIG_MMU
-static unsigned long get_unmapped_area_zero(struct file *file,
-				unsigned long addr, unsigned long len,
-				unsigned long pgoff, unsigned long flags)
-{
-	return -ENOSYS;
-}
-#else
-static unsigned long get_unmapped_area_zero(struct file *file,
-				unsigned long addr, unsigned long len,
-				unsigned long pgoff, unsigned long flags)
-{
-	if (flags & MAP_SHARED) {
-		/*
-		 * mmap_zero_prepare() will call shmem_zero_setup() to create a
-		 * file, so use shmem's get_unmapped_area in case it can be
-		 * huge; and pass NULL for file as in mmap.c's
-		 * get_unmapped_area(), so as not to confuse shmem with our
-		 * handle on "/dev/zero".
-		 */
-		return shmem_get_unmapped_area(NULL, addr, len, pgoff, flags);
-	}
-
-	/*
-	 * Otherwise flags & MAP_PRIVATE: with no shmem object beneath it,
-	 * attempt to map aligned to huge page size if possible, otherwise we
-	 * fall back to system page size mappings.
-	 */
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	return thp_get_unmapped_area(file, addr, len, pgoff, flags);
-#else
-	return mm_get_unmapped_area(file, addr, len, pgoff, flags);
-#endif
-}
-#endif /* CONFIG_MMU */
-
-static ssize_t write_full(struct file *file, const char __user *buf,
-			  size_t count, loff_t *ppos)
-{
-	return -ENOSPC;
-}
-
-/*
- * Special lseek() function for /dev/null and /dev/zero.  Most notably, you
- * can fopen() both devices with "a" now.  This was previously impossible.
- * -- SRB.
- */
-static loff_t null_lseek(struct file *file, loff_t offset, int orig)
-{
-	return file->f_pos = 0;
-}
-
-/*
- * The memory devices use the full 32/64 bits of the offset, and so we cannot
- * check against negative addresses: they are ok. The return value is weird,
- * though, in that case (0).
- *
- * also note that seeking relative to the "end of file" isn't supported:
- * it has no meaning, so it returns -EINVAL.
- */
-static loff_t memory_lseek(struct file *file, loff_t offset, int orig)
-{
-	loff_t ret;
-
-	inode_lock(file_inode(file));
-	switch (orig) {
-	case SEEK_CUR:
-		offset += file->f_pos;
-		fallthrough;
-	case SEEK_SET:
-		/* to avoid userland mistaking f_pos=-9 as -EBADF=-9 */
-		if ((unsigned long long)offset >= -MAX_ERRNO) {
-			ret = -EOVERFLOW;
-			break;
-		}
-		file->f_pos = offset;
-		ret = file->f_pos;
-		force_successful_syscall_return();
-		break;
-	default:
-		ret = -EINVAL;
-	}
-	inode_unlock(file_inode(file));
-	return ret;
-}
-
-static int open_port(struct inode *inode, struct file *filp)
-{
-	int rc;
-
-	if (!capable(CAP_SYS_RAWIO))
-		return -EPERM;
-
-	rc = security_locked_down(LOCKDOWN_DEV_MEM);
-	if (rc)
-		return rc;
-
-	if (iminor(inode) != DEVMEM_MINOR)
-		return 0;
-
-	/*
-	 * Use a unified address space to have a single point to manage
-	 * revocations when drivers want to take over a /dev/mem mapped
-	 * range.
-	 */
-	filp->f_mapping = iomem_get_mapping();
-
-	return 0;
-}
-
-#define zero_lseek	null_lseek
-#define full_lseek      null_lseek
-#define write_zero	write_null
-#define write_iter_zero	write_iter_null
-#define splice_write_zero	splice_write_null
-#define open_mem	open_port
-
-static const struct file_operations __maybe_unused mem_fops = {
-	.llseek		= memory_lseek,
-	.read		= read_mem,
-	.write		= write_mem,
-	.mmap_prepare	= mmap_mem_prepare,
-	.open		= open_mem,
-#ifndef CONFIG_MMU
-	.get_unmapped_area = get_unmapped_area_mem,
-	.mmap_capabilities = memory_mmap_capabilities,
-#endif
-	.fop_flags	= FOP_UNSIGNED_OFFSET,
-};
-
-static const struct file_operations null_fops = {
-	.llseek		= null_lseek,
-	.read		= read_null,
-	.write		= write_null,
-	.read_iter	= read_iter_null,
-	.write_iter	= write_iter_null,
-	.splice_write	= splice_write_null,
-	.uring_cmd	= uring_cmd_null,
-};
-
-#ifdef CONFIG_DEVPORT
-static const struct file_operations port_fops = {
-	.llseek		= memory_lseek,
-	.read		= read_port,
-	.write		= write_port,
-	.open		= open_port,
-};
-#endif
-
-static const struct file_operations zero_fops = {
-	.llseek		= zero_lseek,
-	.write		= write_zero,
-	.read_iter	= read_iter_zero,
-	.read		= read_zero,
-	.write_iter	= write_iter_zero,
-	.splice_read	= copy_splice_read,
-	.splice_write	= splice_write_zero,
-	.mmap_prepare	= mmap_zero_prepare,
-	.get_unmapped_area = get_unmapped_area_zero,
-#ifndef CONFIG_MMU
-	.mmap_capabilities = zero_mmap_capabilities,
-#endif
-};
-
-static const struct file_operations full_fops = {
-	.llseek		= full_lseek,
-	.read_iter	= read_iter_zero,
-	.write		= write_full,
-	.splice_read	= copy_splice_read,
-};
-
-static const struct memdev {
-	const char *name;
-	const struct file_operations *fops;
-	fmode_t fmode;
-	umode_t mode;
-} devlist[] = {
-#ifdef CONFIG_DEVMEM
-	[DEVMEM_MINOR] = { "mem", &mem_fops, 0, 0 },
-#endif
-	[3] = { "null", &null_fops, FMODE_NOWAIT, 0666 },
-#ifdef CONFIG_DEVPORT
-	[4] = { "port", &port_fops, 0, 0 },
-#endif
-	[5] = { "zero", &zero_fops, FMODE_NOWAIT, 0666 },
-	[7] = { "full", &full_fops, 0, 0666 },
-	[8] = { "random", &random_fops, FMODE_NOWAIT, 0666 },
-	[9] = { "urandom", &urandom_fops, FMODE_NOWAIT, 0666 },
-#ifdef CONFIG_PRINTK
-	[11] = { "kmsg", &kmsg_fops, 0, 0644 },
-#endif
-};
-
-static int memory_open(struct inode *inode, struct file *filp)
-{
-	int minor;
-	const struct memdev *dev;
-
-	minor = iminor(inode);
-	if (minor >= ARRAY_SIZE(devlist))
-		return -ENXIO;
-
-	dev = &devlist[minor];
-	if (!dev->fops)
-		return -ENXIO;
-
-	filp->f_op = dev->fops;
-	filp->f_mode |= dev->fmode;
-
-	if (dev->fops->open)
-		return dev->fops->open(inode, filp);
-
-	return 0;
-}
-
-static const struct file_operations memory_fops = {
-	.open = memory_open,
-	.llseek = noop_llseek,
-};
-
-static char *mem_devnode(const struct device *dev, umode_t *mode)
-{
-	if (mode && devlist[MINOR(dev->devt)].mode)
-		*mode = devlist[MINOR(dev->devt)].mode;
-	return NULL;
-}
-
-static const struct class mem_class = {
-	.name		= "mem",
-	.devnode	= mem_devnode,
-};
-
-static int __init chr_dev_init(void)
-{
-	int retval;
-	int minor;
-
-	if (register_chrdev(MEM_MAJOR, "mem", &memory_fops))
-		printk("unable to get major %d for memory devs\n", MEM_MAJOR);
-
-	retval = class_register(&mem_class);
-	if (retval)
-		return retval;
-
-	for (minor = 1; minor < ARRAY_SIZE(devlist); minor++) {
-		if (!devlist[minor].name)
-			continue;
-
-		/*
-		 * Create /dev/port?
-		 */
-		if ((minor == DEVPORT_MINOR) && !arch_has_dev_port())
-			continue;
-
-		device_create(&mem_class, NULL, MKDEV(MEM_MAJOR, minor),
-			      NULL, devlist[minor].name);
-	}
-
-	return tty_init();
-}
-
-fs_initcall(chr_dev_init);
--- a/MAINTAINERS~mm-move-drivers-char-memc-to-mm-char-memc
+++ a/MAINTAINERS
@@ -17269,7 +17269,7 @@ F:	Documentation/ABI/testing/sysfs-kerne
 F:	Documentation/ABI/testing/sysfs-kernel-mm-numa
 F:	Documentation/admin-guide/mm/
 F:	Documentation/mm/
-F:	drivers/char/mem.c
+F:	mm/char-mem.c
 F:	include/linux/cma.h
 F:	include/linux/dmapool.h
 F:	include/linux/ioremap.h
@@ -17493,7 +17493,7 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
-F:	drivers/char/mem.c
+F:	mm/char-mem.c
 F:	include/trace/events/mmap.h
 F:	fs/proc/task_mmu.c
 F:	fs/proc/task_nommu.c
diff --git a/mm/char-mem.c a/mm/char-mem.c
new file mode 100644
--- /dev/null
+++ a/mm/char-mem.c
@@ -0,0 +1,778 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ *  mm/char-mem.c
+ *
+ *  Copyright (C) 1991, 1992  Linus Torvalds
+ *
+ *  Added devfs support.
+ *    Jan-11-1998, C. Scott Ananian <cananian@alumni.princeton.edu>
+ *  Shared /dev/zero mmapping support, Feb 2000, Kanoj Sarcar <kanoj@sgi.com>
+ */
+
+#include <linux/mm.h>
+#include <linux/miscdevice.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/mman.h>
+#include <linux/random.h>
+#include <linux/init.h>
+#include <linux/tty.h>
+#include <linux/capability.h>
+#include <linux/ptrace.h>
+#include <linux/device.h>
+#include <linux/highmem.h>
+#include <linux/backing-dev.h>
+#include <linux/shmem_fs.h>
+#include <linux/splice.h>
+#include <linux/pfn.h>
+#include <linux/export.h>
+#include <linux/io.h>
+#include <linux/uio.h>
+#include <linux/uaccess.h>
+#include <linux/security.h>
+
+#define DEVMEM_MINOR	1
+#define DEVPORT_MINOR	4
+
+static inline unsigned long size_inside_page(unsigned long start,
+					     unsigned long size)
+{
+	unsigned long sz;
+
+	sz = PAGE_SIZE - (start & (PAGE_SIZE - 1));
+
+	return min(sz, size);
+}
+
+#ifndef ARCH_HAS_VALID_PHYS_ADDR_RANGE
+static inline int valid_phys_addr_range(phys_addr_t addr, size_t count)
+{
+	return addr + count <= __pa(high_memory);
+}
+
+static inline int valid_mmap_phys_addr_range(unsigned long pfn, size_t size)
+{
+	return 1;
+}
+#endif
+
+#ifdef CONFIG_STRICT_DEVMEM
+static inline int page_is_allowed(unsigned long pfn)
+{
+	return devmem_is_allowed(pfn);
+}
+#else
+static inline int page_is_allowed(unsigned long pfn)
+{
+	return 1;
+}
+#endif
+
+static inline bool should_stop_iteration(void)
+{
+	if (need_resched())
+		cond_resched();
+	return signal_pending(current);
+}
+
+/*
+ * This funcion reads the *physical* memory. The f_pos points directly to the
+ * memory location.
+ */
+static ssize_t read_mem(struct file *file, char __user *buf,
+			size_t count, loff_t *ppos)
+{
+	phys_addr_t p = *ppos;
+	ssize_t read, sz;
+	void *ptr;
+	char *bounce;
+	int err;
+
+	if (p != *ppos)
+		return 0;
+
+	if (!valid_phys_addr_range(p, count))
+		return -EFAULT;
+	read = 0;
+#ifdef __ARCH_HAS_NO_PAGE_ZERO_MAPPED
+	/* we don't have page 0 mapped on sparc and m68k.. */
+	if (p < PAGE_SIZE) {
+		sz = size_inside_page(p, count);
+		if (sz > 0) {
+			if (clear_user(buf, sz))
+				return -EFAULT;
+			buf += sz;
+			p += sz;
+			count -= sz;
+			read += sz;
+		}
+	}
+#endif
+
+	bounce = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!bounce)
+		return -ENOMEM;
+
+	while (count > 0) {
+		unsigned long remaining;
+		int allowed, probe;
+
+		sz = size_inside_page(p, count);
+
+		err = -EPERM;
+		allowed = page_is_allowed(p >> PAGE_SHIFT);
+		if (!allowed)
+			goto failed;
+
+		err = -EFAULT;
+		if (allowed == 2) {
+			/* Show zeros for restricted memory. */
+			remaining = clear_user(buf, sz);
+		} else {
+			/*
+			 * On ia64 if a page has been mapped somewhere as
+			 * uncached, then it must also be accessed uncached
+			 * by the kernel or data corruption may occur.
+			 */
+			ptr = xlate_dev_mem_ptr(p);
+			if (!ptr)
+				goto failed;
+
+			probe = copy_from_kernel_nofault(bounce, ptr, sz);
+			unxlate_dev_mem_ptr(p, ptr);
+			if (probe)
+				goto failed;
+
+			remaining = copy_to_user(buf, bounce, sz);
+		}
+
+		if (remaining)
+			goto failed;
+
+		buf += sz;
+		p += sz;
+		count -= sz;
+		read += sz;
+		if (should_stop_iteration())
+			break;
+	}
+	kfree(bounce);
+
+	*ppos += read;
+	return read;
+
+failed:
+	kfree(bounce);
+	return err;
+}
+
+static ssize_t write_mem(struct file *file, const char __user *buf,
+			 size_t count, loff_t *ppos)
+{
+	phys_addr_t p = *ppos;
+	ssize_t written, sz;
+	unsigned long copied;
+	void *ptr;
+
+	if (p != *ppos)
+		return -EFBIG;
+
+	if (!valid_phys_addr_range(p, count))
+		return -EFAULT;
+
+	written = 0;
+
+#ifdef __ARCH_HAS_NO_PAGE_ZERO_MAPPED
+	/* we don't have page 0 mapped on sparc and m68k.. */
+	if (p < PAGE_SIZE) {
+		sz = size_inside_page(p, count);
+		/* Hmm. Do something? */
+		buf += sz;
+		p += sz;
+		count -= sz;
+		written += sz;
+	}
+#endif
+
+	while (count > 0) {
+		int allowed;
+
+		sz = size_inside_page(p, count);
+
+		allowed = page_is_allowed(p >> PAGE_SHIFT);
+		if (!allowed)
+			return -EPERM;
+
+		/* Skip actual writing when a page is marked as restricted. */
+		if (allowed == 1) {
+			/*
+			 * On ia64 if a page has been mapped somewhere as
+			 * uncached, then it must also be accessed uncached
+			 * by the kernel or data corruption may occur.
+			 */
+			ptr = xlate_dev_mem_ptr(p);
+			if (!ptr) {
+				if (written)
+					break;
+				return -EFAULT;
+			}
+
+			copied = copy_from_user(ptr, buf, sz);
+			unxlate_dev_mem_ptr(p, ptr);
+			if (copied) {
+				written += sz - copied;
+				if (written)
+					break;
+				return -EFAULT;
+			}
+		}
+
+		buf += sz;
+		p += sz;
+		count -= sz;
+		written += sz;
+		if (should_stop_iteration())
+			break;
+	}
+
+	*ppos += written;
+	return written;
+}
+
+int __weak phys_mem_access_prot_allowed(struct file *file,
+	unsigned long pfn, unsigned long size, pgprot_t *vma_prot)
+{
+	return 1;
+}
+
+#ifndef __HAVE_PHYS_MEM_ACCESS_PROT
+
+/*
+ * Architectures vary in how they handle caching for addresses
+ * outside of main memory.
+ *
+ */
+#ifdef pgprot_noncached
+static int uncached_access(struct file *file, phys_addr_t addr)
+{
+	/*
+	 * Accessing memory above the top the kernel knows about or through a
+	 * file pointer
+	 * that was marked O_DSYNC will be done non-cached.
+	 */
+	if (file->f_flags & O_DSYNC)
+		return 1;
+	return addr >= __pa(high_memory);
+}
+#endif
+
+static pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
+				     unsigned long size, pgprot_t vma_prot)
+{
+#ifdef pgprot_noncached
+	phys_addr_t offset = pfn << PAGE_SHIFT;
+
+	if (uncached_access(file, offset))
+		return pgprot_noncached(vma_prot);
+#endif
+	return vma_prot;
+}
+#endif
+
+#ifndef CONFIG_MMU
+static unsigned long get_unmapped_area_mem(struct file *file,
+					   unsigned long addr,
+					   unsigned long len,
+					   unsigned long pgoff,
+					   unsigned long flags)
+{
+	if (!valid_mmap_phys_addr_range(pgoff, len))
+		return (unsigned long) -EINVAL;
+	return pgoff << PAGE_SHIFT;
+}
+
+/* permit direct mmap, for read, write or exec */
+static unsigned memory_mmap_capabilities(struct file *file)
+{
+	return NOMMU_MAP_DIRECT |
+		NOMMU_MAP_READ | NOMMU_MAP_WRITE | NOMMU_MAP_EXEC;
+}
+
+static unsigned zero_mmap_capabilities(struct file *file)
+{
+	return NOMMU_MAP_COPY;
+}
+
+/* can't do an in-place private mapping if there's no MMU */
+static inline int private_mapping_ok(struct vm_area_desc *desc)
+{
+	return is_nommu_shared_vma_flags(&desc->vma_flags);
+}
+#else
+
+static inline int private_mapping_ok(struct vm_area_desc *desc)
+{
+	return 1;
+}
+#endif
+
+static const struct vm_operations_struct mmap_mem_ops = {
+#ifdef CONFIG_HAVE_IOREMAP_PROT
+	.access = generic_access_phys
+#endif
+};
+
+static int mmap_mem_prepare(struct vm_area_desc *desc)
+{
+	struct file *file = desc->file;
+	const size_t size = vma_desc_size(desc);
+	const phys_addr_t offset = (phys_addr_t)desc->pgoff << PAGE_SHIFT;
+
+	/* Does it even fit in phys_addr_t? */
+	if (offset >> PAGE_SHIFT != desc->pgoff)
+		return -EINVAL;
+
+	/* It's illegal to wrap around the end of the physical address space. */
+	if (offset + (phys_addr_t)size - 1 < offset)
+		return -EINVAL;
+
+	if (!valid_mmap_phys_addr_range(desc->pgoff, size))
+		return -EINVAL;
+
+	if (!private_mapping_ok(desc))
+		return -ENOSYS;
+
+	if (!range_is_allowed(desc->pgoff, size))
+		return -EPERM;
+
+	if (!phys_mem_access_prot_allowed(file, desc->pgoff, size,
+					  &desc->page_prot))
+		return -EINVAL;
+
+	desc->page_prot = phys_mem_access_prot(file, desc->pgoff,
+					       size,
+					       desc->page_prot);
+
+	desc->vm_ops = &mmap_mem_ops;
+
+	/* Remap-pfn-range will mark the range with the I/O flag. */
+	mmap_action_remap_full(desc, desc->pgoff);
+	desc->action.error_override = -EAGAIN;
+
+	return 0;
+}
+
+#ifdef CONFIG_DEVPORT
+static ssize_t read_port(struct file *file, char __user *buf,
+			 size_t count, loff_t *ppos)
+{
+	unsigned long i = *ppos;
+	char __user *tmp = buf;
+
+	if (!access_ok(buf, count))
+		return -EFAULT;
+	while (count-- > 0 && i < 65536) {
+		if (__put_user(inb(i), tmp) < 0)
+			return -EFAULT;
+		i++;
+		tmp++;
+	}
+	*ppos = i;
+	return tmp-buf;
+}
+
+static ssize_t write_port(struct file *file, const char __user *buf,
+			  size_t count, loff_t *ppos)
+{
+	unsigned long i = *ppos;
+	const char __user *tmp = buf;
+
+	if (!access_ok(buf, count))
+		return -EFAULT;
+	while (count-- > 0 && i < 65536) {
+		char c;
+
+		if (__get_user(c, tmp)) {
+			if (tmp > buf)
+				break;
+			return -EFAULT;
+		}
+		outb(c, i);
+		i++;
+		tmp++;
+	}
+	*ppos = i;
+	return tmp-buf;
+}
+#endif
+
+static ssize_t read_null(struct file *file, char __user *buf,
+			 size_t count, loff_t *ppos)
+{
+	return 0;
+}
+
+static ssize_t write_null(struct file *file, const char __user *buf,
+			  size_t count, loff_t *ppos)
+{
+	return count;
+}
+
+static ssize_t read_iter_null(struct kiocb *iocb, struct iov_iter *to)
+{
+	return 0;
+}
+
+static ssize_t write_iter_null(struct kiocb *iocb, struct iov_iter *from)
+{
+	size_t count = iov_iter_count(from);
+	iov_iter_advance(from, count);
+	return count;
+}
+
+static int pipe_to_null(struct pipe_inode_info *info, struct pipe_buffer *buf,
+			struct splice_desc *sd)
+{
+	return sd->len;
+}
+
+static ssize_t splice_write_null(struct pipe_inode_info *pipe, struct file *out,
+				 loff_t *ppos, size_t len, unsigned int flags)
+{
+	return splice_from_pipe(pipe, out, ppos, len, flags, pipe_to_null);
+}
+
+static int uring_cmd_null(struct io_uring_cmd *ioucmd, unsigned int issue_flags)
+{
+	return 0;
+}
+
+static ssize_t read_iter_zero(struct kiocb *iocb, struct iov_iter *iter)
+{
+	size_t written = 0;
+
+	while (iov_iter_count(iter)) {
+		size_t chunk = iov_iter_count(iter), n;
+
+		if (chunk > PAGE_SIZE)
+			chunk = PAGE_SIZE;	/* Just for latency reasons */
+		n = iov_iter_zero(chunk, iter);
+		if (!n && iov_iter_count(iter))
+			return written ? written : -EFAULT;
+		written += n;
+		if (signal_pending(current))
+			return written ? written : -ERESTARTSYS;
+		if (!need_resched())
+			continue;
+		if (iocb->ki_flags & IOCB_NOWAIT)
+			return written ? written : -EAGAIN;
+		cond_resched();
+	}
+	return written;
+}
+
+static ssize_t read_zero(struct file *file, char __user *buf,
+			 size_t count, loff_t *ppos)
+{
+	size_t cleared = 0;
+
+	while (count) {
+		size_t chunk = min_t(size_t, count, PAGE_SIZE);
+		size_t left;
+
+		left = clear_user(buf + cleared, chunk);
+		if (unlikely(left)) {
+			cleared += (chunk - left);
+			if (!cleared)
+				return -EFAULT;
+			break;
+		}
+		cleared += chunk;
+		count -= chunk;
+
+		if (signal_pending(current))
+			break;
+		cond_resched();
+	}
+
+	return cleared;
+}
+
+static int mmap_zero_prepare(struct vm_area_desc *desc)
+{
+#ifndef CONFIG_MMU
+	return -ENOSYS;
+#endif
+	if (vma_desc_test(desc, VMA_MAYSHARE_BIT))
+		return shmem_zero_setup_desc(desc);
+
+	/*
+	 * This is a highly unique situation where we mark a MAP_PRIVATE mapping
+	 * of /dev/zero anonymous, despite it not being.
+	 */
+	vma_desc_set_anonymous(desc);
+	return 0;
+}
+
+#ifndef CONFIG_MMU
+static unsigned long get_unmapped_area_zero(struct file *file,
+				unsigned long addr, unsigned long len,
+				unsigned long pgoff, unsigned long flags)
+{
+	return -ENOSYS;
+}
+#else
+static unsigned long get_unmapped_area_zero(struct file *file,
+				unsigned long addr, unsigned long len,
+				unsigned long pgoff, unsigned long flags)
+{
+	if (flags & MAP_SHARED) {
+		/*
+		 * mmap_zero_prepare() will call shmem_zero_setup() to create a
+		 * file, so use shmem's get_unmapped_area in case it can be
+		 * huge; and pass NULL for file as in mmap.c's
+		 * get_unmapped_area(), so as not to confuse shmem with our
+		 * handle on "/dev/zero".
+		 */
+		return shmem_get_unmapped_area(NULL, addr, len, pgoff, flags);
+	}
+
+	/*
+	 * Otherwise flags & MAP_PRIVATE: with no shmem object beneath it,
+	 * attempt to map aligned to huge page size if possible, otherwise we
+	 * fall back to system page size mappings.
+	 */
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	return thp_get_unmapped_area(file, addr, len, pgoff, flags);
+#else
+	return mm_get_unmapped_area(file, addr, len, pgoff, flags);
+#endif
+}
+#endif /* CONFIG_MMU */
+
+static ssize_t write_full(struct file *file, const char __user *buf,
+			  size_t count, loff_t *ppos)
+{
+	return -ENOSPC;
+}
+
+/*
+ * Special lseek() function for /dev/null and /dev/zero.  Most notably, you
+ * can fopen() both devices with "a" now.  This was previously impossible.
+ * -- SRB.
+ */
+static loff_t null_lseek(struct file *file, loff_t offset, int orig)
+{
+	return file->f_pos = 0;
+}
+
+/*
+ * The memory devices use the full 32/64 bits of the offset, and so we cannot
+ * check against negative addresses: they are ok. The return value is weird,
+ * though, in that case (0).
+ *
+ * also note that seeking relative to the "end of file" isn't supported:
+ * it has no meaning, so it returns -EINVAL.
+ */
+static loff_t memory_lseek(struct file *file, loff_t offset, int orig)
+{
+	loff_t ret;
+
+	inode_lock(file_inode(file));
+	switch (orig) {
+	case SEEK_CUR:
+		offset += file->f_pos;
+		fallthrough;
+	case SEEK_SET:
+		/* to avoid userland mistaking f_pos=-9 as -EBADF=-9 */
+		if ((unsigned long long)offset >= -MAX_ERRNO) {
+			ret = -EOVERFLOW;
+			break;
+		}
+		file->f_pos = offset;
+		ret = file->f_pos;
+		force_successful_syscall_return();
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	inode_unlock(file_inode(file));
+	return ret;
+}
+
+static int open_port(struct inode *inode, struct file *filp)
+{
+	int rc;
+
+	if (!capable(CAP_SYS_RAWIO))
+		return -EPERM;
+
+	rc = security_locked_down(LOCKDOWN_DEV_MEM);
+	if (rc)
+		return rc;
+
+	if (iminor(inode) != DEVMEM_MINOR)
+		return 0;
+
+	/*
+	 * Use a unified address space to have a single point to manage
+	 * revocations when drivers want to take over a /dev/mem mapped
+	 * range.
+	 */
+	filp->f_mapping = iomem_get_mapping();
+
+	return 0;
+}
+
+#define zero_lseek	null_lseek
+#define full_lseek      null_lseek
+#define write_zero	write_null
+#define write_iter_zero	write_iter_null
+#define splice_write_zero	splice_write_null
+#define open_mem	open_port
+
+static const struct file_operations __maybe_unused mem_fops = {
+	.llseek		= memory_lseek,
+	.read		= read_mem,
+	.write		= write_mem,
+	.mmap_prepare	= mmap_mem_prepare,
+	.open		= open_mem,
+#ifndef CONFIG_MMU
+	.get_unmapped_area = get_unmapped_area_mem,
+	.mmap_capabilities = memory_mmap_capabilities,
+#endif
+	.fop_flags	= FOP_UNSIGNED_OFFSET,
+};
+
+static const struct file_operations null_fops = {
+	.llseek		= null_lseek,
+	.read		= read_null,
+	.write		= write_null,
+	.read_iter	= read_iter_null,
+	.write_iter	= write_iter_null,
+	.splice_write	= splice_write_null,
+	.uring_cmd	= uring_cmd_null,
+};
+
+#ifdef CONFIG_DEVPORT
+static const struct file_operations port_fops = {
+	.llseek		= memory_lseek,
+	.read		= read_port,
+	.write		= write_port,
+	.open		= open_port,
+};
+#endif
+
+static const struct file_operations zero_fops = {
+	.llseek		= zero_lseek,
+	.write		= write_zero,
+	.read_iter	= read_iter_zero,
+	.read		= read_zero,
+	.write_iter	= write_iter_zero,
+	.splice_read	= copy_splice_read,
+	.splice_write	= splice_write_zero,
+	.mmap_prepare	= mmap_zero_prepare,
+	.get_unmapped_area = get_unmapped_area_zero,
+#ifndef CONFIG_MMU
+	.mmap_capabilities = zero_mmap_capabilities,
+#endif
+};
+
+static const struct file_operations full_fops = {
+	.llseek		= full_lseek,
+	.read_iter	= read_iter_zero,
+	.write		= write_full,
+	.splice_read	= copy_splice_read,
+};
+
+static const struct memdev {
+	const char *name;
+	const struct file_operations *fops;
+	fmode_t fmode;
+	umode_t mode;
+} devlist[] = {
+#ifdef CONFIG_DEVMEM
+	[DEVMEM_MINOR] = { "mem", &mem_fops, 0, 0 },
+#endif
+	[3] = { "null", &null_fops, FMODE_NOWAIT, 0666 },
+#ifdef CONFIG_DEVPORT
+	[4] = { "port", &port_fops, 0, 0 },
+#endif
+	[5] = { "zero", &zero_fops, FMODE_NOWAIT, 0666 },
+	[7] = { "full", &full_fops, 0, 0666 },
+	[8] = { "random", &random_fops, FMODE_NOWAIT, 0666 },
+	[9] = { "urandom", &urandom_fops, FMODE_NOWAIT, 0666 },
+#ifdef CONFIG_PRINTK
+	[11] = { "kmsg", &kmsg_fops, 0, 0644 },
+#endif
+};
+
+static int memory_open(struct inode *inode, struct file *filp)
+{
+	int minor;
+	const struct memdev *dev;
+
+	minor = iminor(inode);
+	if (minor >= ARRAY_SIZE(devlist))
+		return -ENXIO;
+
+	dev = &devlist[minor];
+	if (!dev->fops)
+		return -ENXIO;
+
+	filp->f_op = dev->fops;
+	filp->f_mode |= dev->fmode;
+
+	if (dev->fops->open)
+		return dev->fops->open(inode, filp);
+
+	return 0;
+}
+
+static const struct file_operations memory_fops = {
+	.open = memory_open,
+	.llseek = noop_llseek,
+};
+
+static char *mem_devnode(const struct device *dev, umode_t *mode)
+{
+	if (mode && devlist[MINOR(dev->devt)].mode)
+		*mode = devlist[MINOR(dev->devt)].mode;
+	return NULL;
+}
+
+static const struct class mem_class = {
+	.name		= "mem",
+	.devnode	= mem_devnode,
+};
+
+static int __init chr_dev_init(void)
+{
+	int retval;
+	int minor;
+
+	if (register_chrdev(MEM_MAJOR, "mem", &memory_fops))
+		printk("unable to get major %d for memory devs\n", MEM_MAJOR);
+
+	retval = class_register(&mem_class);
+	if (retval)
+		return retval;
+
+	for (minor = 1; minor < ARRAY_SIZE(devlist); minor++) {
+		if (!devlist[minor].name)
+			continue;
+
+		/*
+		 * Create /dev/port?
+		 */
+		if ((minor == DEVPORT_MINOR) && !arch_has_dev_port())
+			continue;
+
+		device_create(&mem_class, NULL, MKDEV(MEM_MAJOR, minor),
+			      NULL, devlist[minor].name);
+	}
+
+	return tty_init();
+}
+
+fs_initcall(chr_dev_init);
--- a/mm/Makefile~mm-move-drivers-char-memc-to-mm-char-memc
+++ a/mm/Makefile
@@ -55,7 +55,8 @@ obj-y			:= filemap.o mempool.o oom_kill.
 			   mm_init.o percpu.o slab_common.o \
 			   compaction.o show_mem.o \
 			   interval_tree.o list_lru.o workingset.o \
-			   debug.o gup.o mmap_lock.o vma_init.o $(mmu-y)
+			   debug.o gup.o mmap_lock.o vma_init.o char-mem.o \
+			   $(mmu-y)
 
 # Give 'page_alloc' its own module-parameter namespace
 page-alloc-y := page_alloc.o
--- a/mm/shmem.c~mm-move-drivers-char-memc-to-mm-char-memc
+++ a/mm/shmem.c
@@ -2984,7 +2984,7 @@ unsigned long shmem_get_unmapped_area(st
 			sb = file_inode(file)->i_sb;
 		} else {
 			/*
-			 * Called directly from mm/mmap.c, or drivers/char/mem.c
+			 * Called directly from mm/mmap.c, or mm/char-mem.c
 			 * for "/dev/zero", to create a shared anonymous object.
 			 */
 			if (IS_ERR(shm_mnt))
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-fix-mmap_prepare-file-handling-remove-file_doesnt_need_get.patch
mm-vma-introduce-and-use-vma_can_merge.patch
mm-consistently-validate-vma-state-after-mmap-hooks.patch
mm-vma-ensure-mmap_prepare-doesnt-set-actions-on-a-mergeable-vma.patch
mm-make-map_kernel_pages_-internal-and-unexported.patch
mm-vma-tidy-up-map-kernel-pages-enum-values.patch
mm-add-mmap-action-for-discontiguous-kernel-page-mapping.patch
docs-filesystems-update-mmap_prepare-docs-for-discontig-kernel-pgs.patch
drivers-usb-mon-update-to-use-mmap_prepare-map-kernel-pages.patch
infiniband-update-hfi1-to-use-remap_vmalloc_range.patch
selinux-reject-writable-opens-of-policy-file-drop-mmap-shared-write-check.patch
alsa-pcm-use-vm_insert_page-to-map-pcm-status-page.patch
bpf-arena-mark-arena_map_mmap-mappings-vm_mixedmap.patch
mm-vma-add-vma_is_mm_managed-predicates.patch
mm-vma-only-allow-mmap-to-clear-vma_maywrite_bit-if-not-mm-managed.patch
mm-vma-add-and-use-vma__is_fixed_mapping.patch
scsi-sg-convert-mmap-hook-to-mmap_prepare-and-rework.patch
fbdev-defio-assert-fbinfo_virtfb-drop-vm_io-add-vm_mixedmap.patch
hsi-cmt_speech-convert-mmap-hook-to-mmap_prepare-refactor.patch
mm-gup-error-out-early-on-vma_mayread_bit-vmas.patch
uprobes-remove-vm_io-set-vm_mixedmap-for-mapped-kernel-pages.patch
mm-mlock-clear-vma_locked_mask-over-mmap-callback.patch
mm-mlock-eliminate-weird-vma_io_bit-abuse-and-simplify.patch
mm-vma-enforce-that-mm-managed-mappings-may-not-set-vma_io_bit.patch
mm-remove-vma_io_bit-check-in-vma_is_mm_managed.patch
mm-remove-hugetlb_inlineh.patch
mm-rename-is_vm_hugetlb_page-to-vma_is_hugetlb.patch
mm-drop-some-redundant-checks-around-hugetlb-vmas.patch
mm-madvise-update-is_valid_guard_vma-to-use-vma_can_merge.patch
mm-vma-introduce-vma_is_mm_backed.patch
mm-uffd-use-predicates-for-userfaultfd-checks.patch
mm-madvise-use-predicates-for-madvise-madv_dofork.patch
mm-eliminate-vma_special_flags-usage-when-hugetlb-explicitly-tested.patch
mm-eliminate-vma_special_flags-check-in-lru_gen_look_around.patch
mm-avoid-use-of-vma_special_flags-in-migrate_vma_setup.patch
mm-eliminate-vm_special-vma_special_flags.patch
fuse-dax-do-not-set-vm_mixedmap.patch
mm-huge_memory-remove-vma_is_special_huge.patch
mm-vma-const-ify-vma_assert_stabilised-and-associated-functions.patch
mm-implement-and-use-vma_has_anon_rmap-silence-kcsan.patch
mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma.patch
mm-vma-dont-remove-vma-from-rmap-if-pgoff-unchanged.patch

