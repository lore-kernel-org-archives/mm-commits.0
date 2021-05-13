Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58DD7C433B4
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 21:55:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E95461438
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 21:55:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233616AbhEMV4J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 May 2021 17:56:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:33096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233574AbhEMV4J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 May 2021 17:56:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 189FD61439;
        Thu, 13 May 2021 21:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620942899;
        bh=R0N53EqnCCaaqkUMpdmwg/BcSdnRYgC3rSXUlBexA1U=;
        h=Date:From:To:Subject:From;
        b=DnLv2L6+uZvbo9LmEp3Gz2a2QJqEBX8qwZRYtWh750HzyJ4pk31UQCzaTKHwfuvVF
         bqtlFzPfuGqRSV0iXvsG7ZaH30owHMBXDO5Aejp7Teo4Rvnx2ePHQt9pDUomj5HppE
         ljgNOlVRaJeeg/tgrjX/2a9B+kFWN0EAgWc5iNQA=
Date:   Thu, 13 May 2021 14:54:57 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, bp@alien8.de, catalin.marinas@arm.com, cl@linux.com,
        dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        elena.reshetova@intel.com, guro@fb.com, hagen@jauu.net,
        hpa@zytor.com, jejb@linux.ibm.com, kirill@shutemov.name,
        luto@kernel.org, mark.rutland@arm.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, mtk.manpages@gmail.com,
        palmer@dabbelt.com, palmerdabbelt@google.com,
        paul.walmsley@sifive.com, peterz@infradead.org,
        rick.p.edgecombe@intel.com, rppt@linux.ibm.com,
        shakeelb@google.com, shuah@kernel.org, tglx@linutronix.de,
        tycho@tycho.ws, viro@zeniv.linux.org.uk, will@kernel.org,
        willy@infradead.org
Subject:  [to-be-updated]
 mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
 removed from -mm tree
Message-ID: <20210513215457.yQBTG0upW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce memfd_secret system call to create "secret" memory areas
has been removed from the -mm tree.  Its filename was
     mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm: introduce memfd_secret system call to create "secret" memory areas

Introduce "memfd_secret" system call with the ability to create memory
areas visible only in the context of the owning process and not mapped not
only to other processes but in the kernel page tables as well.

The secretmem feature is off by default and the user must explicitly
enable it at the boot time.

Once secretmem is enabled, the user will be able to create a file
descriptor using the memfd_secret() system call.  The memory areas created
by mmap() calls from this file descriptor will be unmapped from the kernel
direct map and they will be only mapped in the page table of the processes
that have access to the file descriptor.

The file descriptor based memory has several advantages over the
"traditional" mm interfaces, such as mlock(), mprotect(), madvise().  File
descriptor approach allows explict and controlled sharing of the memory
areas, it allows to seal the operations.  Besides, file descriptor based
memory paves the way for VMMs to remove the secret memory range from the
userpace hipervisor process, for instance QEMU.  Andy Lutomirski says:

  "Getting fd-backed memory into a guest will take some possibly major
  work in the kernel, but getting vma-backed memory into a guest without
  mapping it in the host user address space seems much, much worse."

memfd_secret() is made a dedicated system call rather than an extention to
memfd_create() because it's purpose is to allow the user to create more
secure memory mappings rather than to simply allow file based access to
the memory.  Nowadays a new system call cost is negligible while it is way
simpler for userspace to deal with a clear-cut system calls than with a
multiplexer or an overloaded syscall.  Moreover, the initial
implementation of memfd_secret() is completely distinct from
memfd_create() so there is no much sense in overloading memfd_create()
to begin with.  If there will be a need for code sharing between these
implementation it can be easily achieved without a need to adjust user
visible APIs.

The secret memory remains accessible in the process context using uaccess
primitives, but it is not exposed to the kernel otherwise; secret memory
areas are removed from the direct map and functions in the
follow_page()/get_user_page() family will refuse to return a page that
belongs to the secret memory area.

Once there will be a use case that will require exposing secretmem to the
kernel it will be an opt-in request in the system call flags so that user
would have to decide what data can be exposed to the kernel.

Removing of the pages from the direct map may cause its fragmentation on
architectures that use large pages to map the physical memory which
affects the system performance.  However, the original Kconfig text for
CONFIG_DIRECT_GBPAGES said that gigabyte pages in the direct map "...  can
improve the kernel's performance a tiny bit ..." (commit 00d1c5e05736
("x86: add gbpages switches")) and the recent report [1] showed that "... 
although 1G mappings are a good default choice, there is no compelling
evidence that it must be the only choice".  Hence, it is sufficient to
have secretmem disabled by default with the ability of a system
administrator to enable it at boot time.

Pages in the secretmem regions are unevictable and unmovable to avoid
accidental exposure of the sensitive data via swap or during page
migration.

Since the secretmem mappings are locked in memory they cannot exceed
RLIMIT_MEMLOCK.  Since these mappings are already locked independently
from mlock(), an attempt to mlock()/munlock() secretmem range would fail
and mlockall()/munlockall() will ignore secretmem mappings.

However, unlike mlock()ed memory, secretmem currently behaves more like
long-term GUP: secretmem mappings are unmovable mappings directly consumed
by user space.  With default limits, there is no excessive use of
secretmem and it poses no real problem in combination with
ZONE_MOVABLE/CMA, but in the future this should be addressed to allow
balanced use of large amounts of secretmem along with ZONE_MOVABLE/CMA.

A page that was a part of the secret memory area is cleared when it is
freed to ensure the data is not exposed to the next user of that page.

The following example demonstrates creation of a secret mapping (error
handling is omitted):

	fd = memfd_secret(0);
	ftruncate(fd, MAP_SIZE);
	ptr = mmap(NULL, MAP_SIZE, PROT_READ | PROT_WRITE,
		   MAP_SHARED, fd, 0);

[1] https://lore.kernel.org/linux-mm/213b4567-46ce-f116-9cdf-bbd0c884eb3c@linux.intel.com/
Link: https://lkml.kernel.org/r/20210303162209.8609-7-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christopher Lameter <cl@linux.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Elena Reshetova <elena.reshetova@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Bottomley <jejb@linux.ibm.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Palmer Dabbelt <palmerdabbelt@google.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tycho Andersen <tycho@tycho.ws>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/secretmem.h  |   24 +++
 include/uapi/linux/magic.h |    1 
 kernel/sys_ni.c            |    2 
 mm/Kconfig                 |    3 
 mm/Makefile                |    1 
 mm/gup.c                   |   10 +
 mm/mlock.c                 |    3 
 mm/secretmem.c             |  246 +++++++++++++++++++++++++++++++++++
 8 files changed, 289 insertions(+), 1 deletion(-)

--- /dev/null
+++ a/include/linux/secretmem.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _LINUX_SECRETMEM_H
+#define _LINUX_SECRETMEM_H
+
+#ifdef CONFIG_SECRETMEM
+
+bool vma_is_secretmem(struct vm_area_struct *vma);
+bool page_is_secretmem(struct page *page);
+
+#else
+
+static inline bool vma_is_secretmem(struct vm_area_struct *vma)
+{
+	return false;
+}
+
+static inline bool page_is_secretmem(struct page *page)
+{
+	return false;
+}
+
+#endif /* CONFIG_SECRETMEM */
+
+#endif /* _LINUX_SECRETMEM_H */
--- a/include/uapi/linux/magic.h~mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas
+++ a/include/uapi/linux/magic.h
@@ -97,5 +97,6 @@
 #define DEVMEM_MAGIC		0x454d444d	/* "DMEM" */
 #define Z3FOLD_MAGIC		0x33
 #define PPC_CMM_MAGIC		0xc7571590
+#define SECRETMEM_MAGIC		0x5345434d	/* "SECM" */
 
 #endif /* __LINUX_MAGIC_H__ */
--- a/kernel/sys_ni.c~mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas
+++ a/kernel/sys_ni.c
@@ -358,6 +358,8 @@ COND_SYSCALL(pkey_mprotect);
 COND_SYSCALL(pkey_alloc);
 COND_SYSCALL(pkey_free);
 
+/* memfd_secret */
+COND_SYSCALL(memfd_secret);
 
 /*
  * Architecture specific weak syscall entries.
--- a/mm/gup.c~mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas
+++ a/mm/gup.c
@@ -10,6 +10,7 @@
 #include <linux/rmap.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
+#include <linux/secretmem.h>
 
 #include <linux/sched/signal.h>
 #include <linux/rwsem.h>
@@ -827,6 +828,9 @@ struct page *follow_page(struct vm_area_
 	struct follow_page_context ctx = { NULL };
 	struct page *page;
 
+	if (vma_is_secretmem(vma))
+		return NULL;
+
 	page = follow_page_mask(vma, address, foll_flags, &ctx);
 	if (ctx.pgmap)
 		put_dev_pagemap(ctx.pgmap);
@@ -960,6 +964,9 @@ static int check_vma_flags(struct vm_are
 	if ((gup_flags & FOLL_LONGTERM) && vma_is_fsdax(vma))
 		return -EOPNOTSUPP;
 
+	if (vma_is_secretmem(vma))
+		return -EFAULT;
+
 	if (write) {
 		if (!(vm_flags & VM_WRITE)) {
 			if (!(gup_flags & FOLL_FORCE))
@@ -2138,6 +2145,9 @@ static int gup_pte_range(pmd_t pmd, unsi
 		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
 		page = pte_page(pte);
 
+		if (page_is_secretmem(page))
+			goto pte_unmap;
+
 		head = try_grab_compound_head(page, 1, flags);
 		if (!head)
 			goto pte_unmap;
--- a/mm/Kconfig~mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas
+++ a/mm/Kconfig
@@ -901,6 +901,9 @@ config MAPPING_DIRTY_HELPERS
 config KMAP_LOCAL
 	bool
 
+config SECRETMEM
+	def_bool ARCH_HAS_SET_DIRECT_MAP && !EMBEDDED
+
 # struct io_mapping based helper.  Selected by drivers that need them
 config IO_MAPPING
 	bool
--- a/mm/Makefile~mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas
+++ a/mm/Makefile
@@ -114,6 +114,7 @@ obj-$(CONFIG_MEMORY_BALLOON) += balloon_
 obj-$(CONFIG_PAGE_EXTENSION) += page_ext.o
 obj-$(CONFIG_CMA_DEBUGFS) += cma_debug.o
 obj-$(CONFIG_CMA_SYSFS) += cma_sysfs.o
+obj-$(CONFIG_SECRETMEM) += secretmem.o
 obj-$(CONFIG_USERFAULTFD) += userfaultfd.o
 obj-$(CONFIG_IDLE_PAGE_TRACKING) += page_idle.o
 obj-$(CONFIG_DEBUG_PAGE_REF) += debug_page_ref.o
--- a/mm/mlock.c~mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas
+++ a/mm/mlock.c
@@ -23,6 +23,7 @@
 #include <linux/hugetlb.h>
 #include <linux/memcontrol.h>
 #include <linux/mm_inline.h>
+#include <linux/secretmem.h>
 
 #include "internal.h"
 
@@ -503,7 +504,7 @@ static int mlock_fixup(struct vm_area_st
 
 	if (newflags == vma->vm_flags || (vma->vm_flags & VM_SPECIAL) ||
 	    is_vm_hugetlb_page(vma) || vma == get_gate_vma(current->mm) ||
-	    vma_is_dax(vma))
+	    vma_is_dax(vma) || vma_is_secretmem(vma))
 		/* don't set VM_LOCKED or VM_LOCKONFAULT and don't count */
 		goto out;
 
--- /dev/null
+++ a/mm/secretmem.c
@@ -0,0 +1,246 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright IBM Corporation, 2021
+ *
+ * Author: Mike Rapoport <rppt@linux.ibm.com>
+ */
+
+#include <linux/mm.h>
+#include <linux/fs.h>
+#include <linux/swap.h>
+#include <linux/mount.h>
+#include <linux/memfd.h>
+#include <linux/bitops.h>
+#include <linux/printk.h>
+#include <linux/pagemap.h>
+#include <linux/syscalls.h>
+#include <linux/pseudo_fs.h>
+#include <linux/secretmem.h>
+#include <linux/set_memory.h>
+#include <linux/sched/signal.h>
+
+#include <uapi/linux/magic.h>
+
+#include <asm/tlbflush.h>
+
+#include "internal.h"
+
+#undef pr_fmt
+#define pr_fmt(fmt) "secretmem: " fmt
+
+/*
+ * Define mode and flag masks to allow validation of the system call
+ * parameters.
+ */
+#define SECRETMEM_MODE_MASK	(0x0)
+#define SECRETMEM_FLAGS_MASK	SECRETMEM_MODE_MASK
+
+static bool secretmem_enable __ro_after_init;
+module_param_named(enable, secretmem_enable, bool, 0400);
+MODULE_PARM_DESC(secretmem_enable,
+		 "Enable secretmem and memfd_secret(2) system call");
+
+static vm_fault_t secretmem_fault(struct vm_fault *vmf)
+{
+	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
+	struct inode *inode = file_inode(vmf->vma->vm_file);
+	pgoff_t offset = vmf->pgoff;
+	gfp_t gfp = vmf->gfp_mask;
+	unsigned long addr;
+	struct page *page;
+	int err;
+
+	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
+		return vmf_error(-EINVAL);
+
+retry:
+	page = find_lock_page(mapping, offset);
+	if (!page) {
+		page = alloc_page(gfp | __GFP_ZERO);
+		if (!page)
+			return VM_FAULT_OOM;
+
+		err = set_direct_map_invalid_noflush(page, 1);
+		if (err) {
+			put_page(page);
+			return vmf_error(err);
+		}
+
+		__SetPageUptodate(page);
+		err = add_to_page_cache_lru(page, mapping, offset, gfp);
+		if (unlikely(err)) {
+			put_page(page);
+			/*
+			 * If a split of large page was required, it
+			 * already happened when we marked the page invalid
+			 * which guarantees that this call won't fail
+			 */
+			set_direct_map_default_noflush(page, 1);
+			if (err == -EEXIST)
+				goto retry;
+
+			return vmf_error(err);
+		}
+
+		addr = (unsigned long)page_address(page);
+		flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
+	}
+
+	vmf->page = page;
+	return VM_FAULT_LOCKED;
+}
+
+static const struct vm_operations_struct secretmem_vm_ops = {
+	.fault = secretmem_fault,
+};
+
+static int secretmem_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	unsigned long len = vma->vm_end - vma->vm_start;
+
+	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) == 0)
+		return -EINVAL;
+
+	if (mlock_future_check(vma->vm_mm, vma->vm_flags | VM_LOCKED, len))
+		return -EAGAIN;
+
+	vma->vm_flags |= VM_LOCKED | VM_DONTDUMP;
+	vma->vm_ops = &secretmem_vm_ops;
+
+	return 0;
+}
+
+bool vma_is_secretmem(struct vm_area_struct *vma)
+{
+	return vma->vm_ops == &secretmem_vm_ops;
+}
+
+static const struct file_operations secretmem_fops = {
+	.mmap		= secretmem_mmap,
+};
+
+static bool secretmem_isolate_page(struct page *page, isolate_mode_t mode)
+{
+	return false;
+}
+
+static int secretmem_migratepage(struct address_space *mapping,
+				 struct page *newpage, struct page *page,
+				 enum migrate_mode mode)
+{
+	return -EBUSY;
+}
+
+static void secretmem_freepage(struct page *page)
+{
+	set_direct_map_default_noflush(page, 1);
+	clear_highpage(page);
+}
+
+static const struct address_space_operations secretmem_aops = {
+	.freepage	= secretmem_freepage,
+	.migratepage	= secretmem_migratepage,
+	.isolate_page	= secretmem_isolate_page,
+};
+
+bool page_is_secretmem(struct page *page)
+{
+	struct address_space *mapping = page_mapping(page);
+
+	if (!mapping)
+		return false;
+
+	return mapping->a_ops == &secretmem_aops;
+}
+
+static struct vfsmount *secretmem_mnt;
+
+static struct file *secretmem_file_create(unsigned long flags)
+{
+	struct file *file = ERR_PTR(-ENOMEM);
+	struct inode *inode;
+
+	inode = alloc_anon_inode(secretmem_mnt->mnt_sb);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
+
+	file = alloc_file_pseudo(inode, secretmem_mnt, "secretmem",
+				 O_RDWR, &secretmem_fops);
+	if (IS_ERR(file))
+		goto err_free_inode;
+
+	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
+	mapping_set_unevictable(inode->i_mapping);
+
+	inode->i_mapping->a_ops = &secretmem_aops;
+
+	/* pretend we are a normal file with zero size */
+	inode->i_mode |= S_IFREG;
+	inode->i_size = 0;
+
+	return file;
+
+err_free_inode:
+	iput(inode);
+	return file;
+}
+
+SYSCALL_DEFINE1(memfd_secret, unsigned long, flags)
+{
+	struct file *file;
+	int fd, err;
+
+	/* make sure local flags do not confict with global fcntl.h */
+	BUILD_BUG_ON(SECRETMEM_FLAGS_MASK & O_CLOEXEC);
+
+	if (!secretmem_enable)
+		return -ENOSYS;
+
+	if (flags & ~(SECRETMEM_FLAGS_MASK | O_CLOEXEC))
+		return -EINVAL;
+
+	fd = get_unused_fd_flags(flags & O_CLOEXEC);
+	if (fd < 0)
+		return fd;
+
+	file = secretmem_file_create(flags);
+	if (IS_ERR(file)) {
+		err = PTR_ERR(file);
+		goto err_put_fd;
+	}
+
+	file->f_flags |= O_LARGEFILE;
+
+	fd_install(fd, file);
+	return fd;
+
+err_put_fd:
+	put_unused_fd(fd);
+	return err;
+}
+
+static int secretmem_init_fs_context(struct fs_context *fc)
+{
+	return init_pseudo(fc, SECRETMEM_MAGIC) ? 0 : -ENOMEM;
+}
+
+static struct file_system_type secretmem_fs = {
+	.name		= "secretmem",
+	.init_fs_context = secretmem_init_fs_context,
+	.kill_sb	= kill_anon_super,
+};
+
+static int secretmem_init(void)
+{
+	int ret = 0;
+
+	if (!secretmem_enable)
+		return ret;
+
+	secretmem_mnt = kern_mount(&secretmem_fs);
+	if (IS_ERR(secretmem_mnt))
+		ret = PTR_ERR(secretmem_mnt);
+
+	return ret;
+}
+fs_initcall(secretmem_init);
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-mmzoneh-simplify-is_highmem_idx.patch
docs-procrst-meminfo-briefly-describe-gaps-in-memory-accounting.patch
include-linux-mmzoneh-add-documentation-for-pfn_valid.patch
memblock-update-initialization-of-reserved-pages.patch
arm64-decouple-check-whether-pfn-is-in-linear-map-from-pfn_valid.patch
arm64-drop-pfn_valid_within-and-simplify-pfn_valid.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch
secretmem-test-add-basic-selftest-for-memfd_secret2-fix.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix-2.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix-3.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant-fix.patch

