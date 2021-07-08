Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12BA2C11F67
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:08:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE8C661CCF
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:08:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhGHBKq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jul 2021 21:10:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:50678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230111AbhGHBKq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Jul 2021 21:10:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 625E961CD1;
        Thu,  8 Jul 2021 01:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625706484;
        bh=U6cRZy2IHp9aBUC4n2rhaRMnP6ptY6peNS/lu1sCQtA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=bKFjqlTZAfx0UvRldmVmPSjx9mHIRuENDBUbkbMcDg+nQQddlcFsB7UsYkz590Nlq
         iW4bxMbXnbNqP0Ha++Ui1qP7qu8QUD2e8O0xtprH70wE6r+EVf/CoLQ00aWqBNz07u
         yVAtYdqQeK7CHV8G/5VBLs+cnKyJRi7VbxWej3Lo=
Date:   Wed, 07 Jul 2021 18:08:03 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, arnd@arndb.de, bp@alien8.de,
        catalin.marinas@arm.com, cl@linux.com, dan.j.williams@intel.com,
        dave.hansen@linux.intel.com, david@redhat.com,
        elena.reshetova@intel.com, guro@fb.com, hagen@jauu.net,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        jejb@linux.ibm.com, kirill@shutemov.name, linux-mm@kvack.org,
        lkp@intel.com, luto@kernel.org, mark.rutland@arm.com,
        mingo@redhat.com, mm-commits@vger.kernel.org,
        mtk.manpages@gmail.com, palmer@dabbelt.com,
        palmerdabbelt@google.com, paul.walmsley@sifive.com,
        peterz@infradead.org, rick.p.edgecombe@intel.com,
        rppt@linux.ibm.com, shakeelb@google.com, shuah@kernel.org,
        tglx@linutronix.de, torvalds@linux-foundation.org, tycho@tycho.ws,
        viro@zeniv.linux.org.uk, will@kernel.org, willy@infradead.org
Subject:  [patch 11/54] mm: introduce memfd_secret system call to
 create "secret" memory areas
Message-ID: <20210708010803.i6RiDHM3L%akpm@linux-foundation.org>
In-Reply-To: <20210707175950.eceddb86c6c555555d4730e2@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

Secretmem is designed to provide the following protections:

* Enhanced protection (in conjunction with all the other in-kernel
  attack prevention systems) against ROP attacks.  Seceretmem makes
  "simple" ROP insufficient to perform exfiltration, which increases the
  required complexity of the attack.  Along with other protections like
  the kernel stack size limit and address space layout randomization which
  make finding gadgets is really hard, absence of any in-kernel primitive
  for accessing secret memory means the one gadget ROP attack can't work. 
  Since the only way to access secret memory is to reconstruct the missing
  mapping entry, the attacker has to recover the physical page and insert
  a PTE pointing to it in the kernel and then retrieve the contents.  That
  takes at least three gadgets which is a level of difficulty beyond most
  standard attacks.

* Prevent cross-process secret userspace memory exposures.  Once the
  secret memory is allocated, the user can't accidentally pass it into the
  kernel to be transmitted somewhere.  The secreremem pages cannot be
  accessed via the direct map and they are disallowed in GUP.

* Harden against exploited kernel flaws.  In order to access secretmem,
  a kernel-side attack would need to either walk the page tables and
  create new ones, or spawn a new privileged uiserspace process to perform
  secrets exfiltration using ptrace.

The file descriptor based memory has several advantages over the
"traditional" mm interfaces, such as mlock(), mprotect(), madvise().  File
descriptor approach allows explicit and controlled sharing of the memory
areas, it allows to seal the operations.  Besides, file descriptor based
memory paves the way for VMMs to remove the secret memory range from the
userspace hipervisor process, for instance QEMU.  Andy Lutomirski says:

  "Getting fd-backed memory into a guest will take some possibly major
  work in the kernel, but getting vma-backed memory into a guest without
  mapping it in the host user address space seems much, much worse."

memfd_secret() is made a dedicated system call rather than an extension to
memfd_create() because it's purpose is to allow the user to create more
secure memory mappings rather than to simply allow file based access to
the memory.  Nowadays a new system call cost is negligible while it is way
simpler for userspace to deal with a clear-cut system calls than with a
multiplexer or an overloaded syscall.  Moreover, the initial
implementation of memfd_secret() is completely distinct from
memfd_create() so there is no much sense in overloading memfd_create() to
begin with.  If there will be a need for code sharing between these
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

[akpm@linux-foundation.org: suppress Kconfig whine]
Link: https://lkml.kernel.org/r/20210518072034.31572-5-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Hagen Paul Pfeifer <hagen@jauu.net>
Acked-by: James Bottomley <James.Bottomley@HansenPartnership.com>
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
Cc: David Hildenbrand <david@redhat.com>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/secretmem.h  |   48 +++++++
 include/uapi/linux/magic.h |    1 
 kernel/sys_ni.c            |    2 
 mm/Kconfig                 |    4 
 mm/Makefile                |    1 
 mm/gup.c                   |   12 +
 mm/mlock.c                 |    3 
 mm/secretmem.c             |  239 +++++++++++++++++++++++++++++++++++
 8 files changed, 309 insertions(+), 1 deletion(-)

--- /dev/null
+++ a/include/linux/secretmem.h
@@ -0,0 +1,48 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _LINUX_SECRETMEM_H
+#define _LINUX_SECRETMEM_H
+
+#ifdef CONFIG_SECRETMEM
+
+extern const struct address_space_operations secretmem_aops;
+
+static inline bool page_is_secretmem(struct page *page)
+{
+	struct address_space *mapping;
+
+	/*
+	 * Using page_mapping() is quite slow because of the actual call
+	 * instruction and repeated compound_head(page) inside the
+	 * page_mapping() function.
+	 * We know that secretmem pages are not compound and LRU so we can
+	 * save a couple of cycles here.
+	 */
+	if (PageCompound(page) || !PageLRU(page))
+		return false;
+
+	mapping = (struct address_space *)
+		((unsigned long)page->mapping & ~PAGE_MAPPING_FLAGS);
+
+	if (mapping != page->mapping)
+		return false;
+
+	return mapping->a_ops == &secretmem_aops;
+}
+
+bool vma_is_secretmem(struct vm_area_struct *vma);
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
@@ -855,6 +856,9 @@ struct page *follow_page(struct vm_area_
 	struct follow_page_context ctx = { NULL };
 	struct page *page;
 
+	if (vma_is_secretmem(vma))
+		return NULL;
+
 	page = follow_page_mask(vma, address, foll_flags, &ctx);
 	if (ctx.pgmap)
 		put_dev_pagemap(ctx.pgmap);
@@ -988,6 +992,9 @@ static int check_vma_flags(struct vm_are
 	if ((gup_flags & FOLL_LONGTERM) && vma_is_fsdax(vma))
 		return -EOPNOTSUPP;
 
+	if (vma_is_secretmem(vma))
+		return -EFAULT;
+
 	if (write) {
 		if (!(vm_flags & VM_WRITE)) {
 			if (!(gup_flags & FOLL_FORCE))
@@ -2170,6 +2177,11 @@ static int gup_pte_range(pmd_t pmd, unsi
 		if (!head)
 			goto pte_unmap;
 
+		if (unlikely(page_is_secretmem(page))) {
+			put_compound_head(head, 1, flags);
+			goto pte_unmap;
+		}
+
 		if (unlikely(pte_val(pte) != pte_val(*ptep))) {
 			put_compound_head(head, 1, flags);
 			goto pte_unmap;
--- a/mm/Kconfig~mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas
+++ a/mm/Kconfig
@@ -885,4 +885,8 @@ config KMAP_LOCAL
 # struct io_mapping based helper.  Selected by drivers that need them
 config IO_MAPPING
 	bool
+
+config SECRETMEM
+	def_bool ARCH_HAS_SET_DIRECT_MAP && !EMBEDDED
+
 endmenu
--- a/mm/Makefile~mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas
+++ a/mm/Makefile
@@ -113,6 +113,7 @@ obj-$(CONFIG_CMA)	+= cma.o
 obj-$(CONFIG_MEMORY_BALLOON) += balloon_compaction.o
 obj-$(CONFIG_PAGE_EXTENSION) += page_ext.o
 obj-$(CONFIG_CMA_DEBUGFS) += cma_debug.o
+obj-$(CONFIG_SECRETMEM) += secretmem.o
 obj-$(CONFIG_CMA_SYSFS) += cma_sysfs.o
 obj-$(CONFIG_USERFAULTFD) += userfaultfd.o
 obj-$(CONFIG_IDLE_PAGE_TRACKING) += page_idle.o
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
@@ -0,0 +1,239 @@
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
+		err = set_direct_map_invalid_noflush(page);
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
+			set_direct_map_default_noflush(page);
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
+	set_direct_map_default_noflush(page);
+	clear_highpage(page);
+}
+
+const struct address_space_operations secretmem_aops = {
+	.freepage	= secretmem_freepage,
+	.migratepage	= secretmem_migratepage,
+	.isolate_page	= secretmem_isolate_page,
+};
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
+SYSCALL_DEFINE1(memfd_secret, unsigned int, flags)
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
+	/* prevent secretmem mappings from ever getting PROT_EXEC */
+	secretmem_mnt->mnt_flags |= MNT_NOEXEC;
+
+	return ret;
+}
+fs_initcall(secretmem_init);
_
