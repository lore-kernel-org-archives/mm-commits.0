Return-Path: <SRS0=lzHQ=BG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 817FEC433E4
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jul 2020 19:47:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 618882073E
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jul 2020 19:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595879241;
	bh=ei9zALVd0a8s3s0aE9W2msTIY33SyBV0s5IVf84+wi4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=MbqEORLwsMtvlu076u4TbRlOnlw6A5fWCSH2u76bYYcjXO0nfapbWTpnNjFd0E3o4
	 gMFS1jdTHiuXLkEHhnWx6dI9j8fvq/r4U2VaTdqWKrmgrKusFx3NjR5nmdHM7n1WcW
	 BcHoyqzkxUxz8LHsJuUuv7Mq53NjQEPSVv3ufaK0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729004AbgG0TrV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Jul 2020 15:47:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:41612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728990AbgG0TrU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Jul 2020 15:47:20 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A831A20759;
        Mon, 27 Jul 2020 19:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595879239;
        bh=ei9zALVd0a8s3s0aE9W2msTIY33SyBV0s5IVf84+wi4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZC3JP8dB8ZA6mQr4LizJ75AR45TIxReCioXSH5EFKMiXxME2jwmBO/JkVZtFG9DQR
         WdUIJfh79T9TtnzQwmUoHRDmPjATtfk97OVMqEYCTXyEDVxOK8XVfwzEwhUohCXYur
         aA3eCqeewRIAwhQMCQkkIJiuiHkveygkO5gDFjzk=
Date:   Mon, 27 Jul 2020 12:47:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        pcc@google.com
Subject:  +
 mm-remove-unnecessary-wrapper-function-do_mmap_pgoff.patch added to -mm
 tree
Message-ID: <20200727194719.1vpmrGBhc%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove unnecessary wrapper function do_mmap_pgoff()
has been added to the -mm tree.  Its filename is
     mm-remove-unnecessary-wrapper-function-do_mmap_pgoff.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-unnecessary-wrapper-function-do_mmap_pgoff.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-unnecessary-wrapper-function-do_mmap_pgoff.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Collingbourne <pcc@google.com>
Subject: mm: remove unnecessary wrapper function do_mmap_pgoff()

The current split between do_mmap() and do_mmap_pgoff() was introduced in
commit 1fcfd8db7f82 ("mm, mpx: add "vm_flags_t vm_flags" arg to
do_mmap_pgoff()") to support MPX.

The wrapper function do_mmap_pgoff() always passed 0 as the value of the
vm_flags argument to do_mmap().  However, MPX support has subsequently
been removed from the kernel and there were no more direct callers of
do_mmap(); all calls were going via do_mmap_pgoff().

Simplify the code by removing do_mmap_pgoff() and changing all callers to
directly call do_mmap(), which now no longer takes a vm_flags argument.

Link: http://lkml.kernel.org/r/20200727194109.1371462-1-pcc@google.com
Signed-off-by: Peter Collingbourne <pcc@google.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c             |    6 +++---
 fs/hugetlbfs/inode.c |    2 +-
 include/linux/fs.h   |    2 +-
 include/linux/mm.h   |   12 +-----------
 ipc/shm.c            |    2 +-
 mm/mmap.c            |   16 ++++++++--------
 mm/nommu.c           |    6 +++---
 mm/shmem.c           |    2 +-
 mm/util.c            |    4 ++--
 9 files changed, 21 insertions(+), 31 deletions(-)

--- a/fs/aio.c~mm-remove-unnecessary-wrapper-function-do_mmap_pgoff
+++ a/fs/aio.c
@@ -525,9 +525,9 @@ static int aio_setup_ring(struct kioctx
 		return -EINTR;
 	}
 
-	ctx->mmap_base = do_mmap_pgoff(ctx->aio_ring_file, 0, ctx->mmap_size,
-				       PROT_READ | PROT_WRITE,
-				       MAP_SHARED, 0, &unused, NULL);
+	ctx->mmap_base = do_mmap(ctx->aio_ring_file, 0, ctx->mmap_size,
+				 PROT_READ | PROT_WRITE,
+				 MAP_SHARED, 0, &unused, NULL);
 	mmap_write_unlock(mm);
 	if (IS_ERR((void *)ctx->mmap_base)) {
 		ctx->mmap_size = 0;
--- a/fs/hugetlbfs/inode.c~mm-remove-unnecessary-wrapper-function-do_mmap_pgoff
+++ a/fs/hugetlbfs/inode.c
@@ -140,7 +140,7 @@ static int hugetlbfs_file_mmap(struct fi
 	 * already been checked by prepare_hugepage_range.  If you add
 	 * any error returns here, do so after setting VM_HUGETLB, so
 	 * is_vm_hugetlb_page tests below unmap_region go the right
-	 * way when do_mmap_pgoff unwinds (may be important on powerpc
+	 * way when do_mmap unwinds (may be important on powerpc
 	 * and ia64).
 	 */
 	vma->vm_flags |= VM_HUGETLB | VM_DONTEXPAND;
--- a/include/linux/fs.h~mm-remove-unnecessary-wrapper-function-do_mmap_pgoff
+++ a/include/linux/fs.h
@@ -559,7 +559,7 @@ static inline int mapping_mapped(struct
 
 /*
  * Might pages of this file have been modified in userspace?
- * Note that i_mmap_writable counts all VM_SHARED vmas: do_mmap_pgoff
+ * Note that i_mmap_writable counts all VM_SHARED vmas: do_mmap
  * marks vma as VM_SHARED if it is shared, and the file was opened for
  * writing i.e. vma may be mprotected writable even if now readonly.
  *
--- a/include/linux/mm.h~mm-remove-unnecessary-wrapper-function-do_mmap_pgoff
+++ a/include/linux/mm.h
@@ -2536,23 +2536,13 @@ extern unsigned long mmap_region(struct
 	struct list_head *uf);
 extern unsigned long do_mmap(struct file *file, unsigned long addr,
 	unsigned long len, unsigned long prot, unsigned long flags,
-	vm_flags_t vm_flags, unsigned long pgoff, unsigned long *populate,
-	struct list_head *uf);
+	unsigned long pgoff, unsigned long *populate, struct list_head *uf);
 extern int __do_munmap(struct mm_struct *, unsigned long, size_t,
 		       struct list_head *uf, bool downgrade);
 extern int do_munmap(struct mm_struct *, unsigned long, size_t,
 		     struct list_head *uf);
 extern int do_madvise(unsigned long start, size_t len_in, int behavior);
 
-static inline unsigned long
-do_mmap_pgoff(struct file *file, unsigned long addr,
-	unsigned long len, unsigned long prot, unsigned long flags,
-	unsigned long pgoff, unsigned long *populate,
-	struct list_head *uf)
-{
-	return do_mmap(file, addr, len, prot, flags, 0, pgoff, populate, uf);
-}
-
 #ifdef CONFIG_MMU
 extern int __mm_populate(unsigned long addr, unsigned long len,
 			 int ignore_errors);
--- a/ipc/shm.c~mm-remove-unnecessary-wrapper-function-do_mmap_pgoff
+++ a/ipc/shm.c
@@ -1558,7 +1558,7 @@ long do_shmat(int shmid, char __user *sh
 			goto invalid;
 	}
 
-	addr = do_mmap_pgoff(file, addr, size, prot, flags, 0, &populate, NULL);
+	addr = do_mmap(file, addr, size, prot, flags, 0, &populate, NULL);
 	*raddr = addr;
 	err = 0;
 	if (IS_ERR_VALUE(addr))
--- a/mm/mmap.c~mm-remove-unnecessary-wrapper-function-do_mmap_pgoff
+++ a/mm/mmap.c
@@ -1030,7 +1030,7 @@ static inline int is_mergeable_anon_vma(
  * anon_vmas, nor if same anon_vma is assigned but offsets incompatible.
  *
  * We don't check here for the merged mmap wrapping around the end of pagecache
- * indices (16TB on ia32) because do_mmap_pgoff() does not permit mmap's which
+ * indices (16TB on ia32) because do_mmap() does not permit mmap's which
  * wrap, nor mmaps which cover the final page at index -1UL.
  */
 static int
@@ -1365,11 +1365,11 @@ static inline bool file_mmap_ok(struct f
  */
 unsigned long do_mmap(struct file *file, unsigned long addr,
 			unsigned long len, unsigned long prot,
-			unsigned long flags, vm_flags_t vm_flags,
-			unsigned long pgoff, unsigned long *populate,
-			struct list_head *uf)
+			unsigned long flags, unsigned long pgoff,
+			unsigned long *populate, struct list_head *uf)
 {
 	struct mm_struct *mm = current->mm;
+	vm_flags_t vm_flags;
 	int pkey = 0;
 
 	*populate = 0;
@@ -1431,7 +1431,7 @@ unsigned long do_mmap(struct file *file,
 	 * to. we assume access permissions have been handled by the open
 	 * of the memory object, so we don't do any here.
 	 */
-	vm_flags |= calc_vm_prot_bits(prot, pkey) | calc_vm_flag_bits(flags) |
+	vm_flags = calc_vm_prot_bits(prot, pkey) | calc_vm_flag_bits(flags) |
 			mm->def_flags | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC;
 
 	if (flags & MAP_LOCKED)
@@ -2245,7 +2245,7 @@ get_unmapped_area(struct file *file, uns
 		/*
 		 * mmap_region() will call shmem_zero_setup() to create a file,
 		 * so use shmem's get_unmapped_area in case it can be huge.
-		 * do_mmap_pgoff() will clear pgoff, so match alignment.
+		 * do_mmap() will clear pgoff, so match alignment.
 		 */
 		pgoff = 0;
 		get_area = shmem_get_unmapped_area;
@@ -3018,7 +3018,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 	}
 
 	file = get_file(vma->vm_file);
-	ret = do_mmap_pgoff(vma->vm_file, start, size,
+	ret = do_mmap(vma->vm_file, start, size,
 			prot, flags, pgoff, &populate, NULL);
 	fput(file);
 out:
@@ -3237,7 +3237,7 @@ int insert_vm_struct(struct mm_struct *m
 	 * By setting it to reflect the virtual start address of the
 	 * vma, merges and splits can happen in a seamless way, just
 	 * using the existing file pgoff checks and manipulations.
-	 * Similarly in do_mmap_pgoff and in do_brk.
+	 * Similarly in do_mmap and in do_brk.
 	 */
 	if (vma_is_anonymous(vma)) {
 		BUG_ON(vma->anon_vma);
--- a/mm/nommu.c~mm-remove-unnecessary-wrapper-function-do_mmap_pgoff
+++ a/mm/nommu.c
@@ -1078,7 +1078,6 @@ unsigned long do_mmap(struct file *file,
 			unsigned long len,
 			unsigned long prot,
 			unsigned long flags,
-			vm_flags_t vm_flags,
 			unsigned long pgoff,
 			unsigned long *populate,
 			struct list_head *uf)
@@ -1086,6 +1085,7 @@ unsigned long do_mmap(struct file *file,
 	struct vm_area_struct *vma;
 	struct vm_region *region;
 	struct rb_node *rb;
+	vm_flags_t vm_flags;
 	unsigned long capabilities, result;
 	int ret;
 
@@ -1104,7 +1104,7 @@ unsigned long do_mmap(struct file *file,
 
 	/* we've determined that we can make the mapping, now translate what we
 	 * now know into VMA flags */
-	vm_flags |= determine_vm_flags(file, prot, flags, capabilities);
+	vm_flags = determine_vm_flags(file, prot, flags, capabilities);
 
 	/* we're going to need to record the mapping */
 	region = kmem_cache_zalloc(vm_region_jar, GFP_KERNEL);
@@ -1763,7 +1763,7 @@ EXPORT_SYMBOL_GPL(access_process_vm);
  *
  * Check the shared mappings on an inode on behalf of a shrinking truncate to
  * make sure that that any outstanding VMAs aren't broken and then shrink the
- * vm_regions that extend that beyond so that do_mmap_pgoff() doesn't
+ * vm_regions that extend that beyond so that do_mmap() doesn't
  * automatically grant mappings that are too large.
  */
 int nommu_shrink_inode_mappings(struct inode *inode, size_t size,
--- a/mm/shmem.c~mm-remove-unnecessary-wrapper-function-do_mmap_pgoff
+++ a/mm/shmem.c
@@ -4245,7 +4245,7 @@ EXPORT_SYMBOL_GPL(shmem_file_setup_with_
 
 /**
  * shmem_zero_setup - setup a shared anonymous mapping
- * @vma: the vma to be mmapped is prepared by do_mmap_pgoff
+ * @vma: the vma to be mmapped is prepared by do_mmap
  */
 int shmem_zero_setup(struct vm_area_struct *vma)
 {
--- a/mm/util.c~mm-remove-unnecessary-wrapper-function-do_mmap_pgoff
+++ a/mm/util.c
@@ -503,8 +503,8 @@ unsigned long vm_mmap_pgoff(struct file
 	if (!ret) {
 		if (mmap_write_lock_killable(mm))
 			return -EINTR;
-		ret = do_mmap_pgoff(file, addr, len, prot, flag, pgoff,
-				    &populate, &uf);
+		ret = do_mmap(file, addr, len, prot, flag, pgoff, &populate,
+			      &uf);
 		mmap_write_unlock(mm);
 		userfaultfd_unmap_complete(mm, &uf);
 		if (populate)
_

Patches currently in -mm which might be from pcc@google.com are

mm-remove-unnecessary-wrapper-function-do_mmap_pgoff.patch

