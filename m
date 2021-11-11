Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A08D8C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:43:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84F3D611F2
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233906AbhKKCpx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:45:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:51090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234183AbhKKCpv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:45:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34FAC60F46;
        Thu, 11 Nov 2021 02:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598583;
        bh=Hxwl8QoeLreZ5XXtb98N6jS7nIfZhF3gDg6VN2qQsUw=;
        h=Date:From:To:Subject:From;
        b=xXdNsF8oCIrYAPQH85z11n2yP90irsBv/Pq4CVgR+vEEwqMzwVJXh9wYeIinGuyY2
         +9boucDlZOdm75eH0E9wBi0B5TuqUrzlGK+aiIzQ3MWImIFMO1TYY3OBjHgKrPFIzu
         nvkIcT0qeg25vv611thon2BDAO1khnnPG5Ne4QL4=
Date:   Wed, 10 Nov 2021 18:43:01 -0800
From:   akpm@linux-foundation.org
To:     bgeffon@google.com, catalin.marinas@arm.com, chenwandun@huawei.com,
        dan.carpenter@oracle.com, dan.j.williams@intel.com,
        dave.jiang@intel.com, dima@arista.com, hughd@google.com,
        jgg@ziepe.ca, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com,
        linux@armlinux.org.uk, luto@kernel.org, mike.kravetz@oracle.com,
        minchan@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com, tglx@linutronix.de,
        tsbogend@alpha.franken.de, vbabka@suse.cz, viro@zeniv.linux.org.uk,
        vishal.l.verma@intel.com, wangkefeng.wang@huawei.com,
        weiyongjun1@huawei.com, will@kernel.org
Subject:  [merged]
 mm-mremap-dont-account-pages-in-vma_to_resize.patch removed from -mm tree
Message-ID: <20211111024301.DUznHbagH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap: don't account pages in vma_to_resize()
has been removed from the -mm tree.  Its filename was
     mm-mremap-dont-account-pages-in-vma_to_resize.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Safonov <dima@arista.com>
Subject: mm/mremap: don't account pages in vma_to_resize()

All this vm_unacct_memory(charged) dance seems to complicate the life
without a good reason.  Furthermore, it seems not always done right on
error-pathes in mremap_to().  And worse than that: this `charged'
difference is sometimes double-accounted for growing MREMAP_DONTUNMAP
mremap()s in move_vma():

	if (security_vm_enough_memory_mm(mm, new_len >> PAGE_SHIFT))

Let's not do this.  Account memory in mremap() fast-path for growing VMAs
or in move_vma() for actually moving things.  The same simpler way as it's
done by vm_stat_account(), but with a difference to call
security_vm_enough_memory_mm() before copying/adjusting VMA.

Originally noticed by Chen Wandun:
https://lkml.kernel.org/r/20210717101942.120607-1-chenwandun@huawei.com

Link: https://lkml.kernel.org/r/20210721131320.522061-1-dima@arista.com
Fixes: e346b3813067 ("mm/mremap: add MREMAP_DONTUNMAP to mremap()")
Signed-off-by: Dmitry Safonov <dima@arista.com>
Acked-by: Brian Geffon <bgeffon@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chen Wandun <chenwandun@huawei.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yongjun <weiyongjun1@huawei.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   50 ++++++++++++++++++++++----------------------------
 1 file changed, 22 insertions(+), 28 deletions(-)

--- a/mm/mremap.c~mm-mremap-dont-account-pages-in-vma_to_resize
+++ a/mm/mremap.c
@@ -565,6 +565,7 @@ static unsigned long move_vma(struct vm_
 		bool *locked, unsigned long flags,
 		struct vm_userfaultfd_ctx *uf, struct list_head *uf_unmap)
 {
+	long to_account = new_len - old_len;
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *new_vma;
 	unsigned long vm_flags = vma->vm_flags;
@@ -583,6 +584,9 @@ static unsigned long move_vma(struct vm_
 	if (mm->map_count >= sysctl_max_map_count - 3)
 		return -ENOMEM;
 
+	if (unlikely(flags & MREMAP_DONTUNMAP))
+		to_account = new_len;
+
 	if (vma->vm_ops && vma->vm_ops->may_split) {
 		if (vma->vm_start != old_addr)
 			err = vma->vm_ops->may_split(vma, old_addr);
@@ -604,8 +608,8 @@ static unsigned long move_vma(struct vm_
 	if (err)
 		return err;
 
-	if (unlikely(flags & MREMAP_DONTUNMAP && vm_flags & VM_ACCOUNT)) {
-		if (security_vm_enough_memory_mm(mm, new_len >> PAGE_SHIFT))
+	if (vm_flags & VM_ACCOUNT) {
+		if (security_vm_enough_memory_mm(mm, to_account >> PAGE_SHIFT))
 			return -ENOMEM;
 	}
 
@@ -613,8 +617,8 @@ static unsigned long move_vma(struct vm_
 	new_vma = copy_vma(&vma, new_addr, new_len, new_pgoff,
 			   &need_rmap_locks);
 	if (!new_vma) {
-		if (unlikely(flags & MREMAP_DONTUNMAP && vm_flags & VM_ACCOUNT))
-			vm_unacct_memory(new_len >> PAGE_SHIFT);
+		if (vm_flags & VM_ACCOUNT)
+			vm_unacct_memory(to_account >> PAGE_SHIFT);
 		return -ENOMEM;
 	}
 
@@ -708,8 +712,7 @@ static unsigned long move_vma(struct vm_
 }
 
 static struct vm_area_struct *vma_to_resize(unsigned long addr,
-	unsigned long old_len, unsigned long new_len, unsigned long flags,
-	unsigned long *p)
+	unsigned long old_len, unsigned long new_len, unsigned long flags)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
@@ -768,13 +771,6 @@ static struct vm_area_struct *vma_to_res
 				(new_len - old_len) >> PAGE_SHIFT))
 		return ERR_PTR(-ENOMEM);
 
-	if (vma->vm_flags & VM_ACCOUNT) {
-		unsigned long charged = (new_len - old_len) >> PAGE_SHIFT;
-		if (security_vm_enough_memory_mm(mm, charged))
-			return ERR_PTR(-ENOMEM);
-		*p = charged;
-	}
-
 	return vma;
 }
 
@@ -787,7 +783,6 @@ static unsigned long mremap_to(unsigned
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	unsigned long ret = -EINVAL;
-	unsigned long charged = 0;
 	unsigned long map_flags = 0;
 
 	if (offset_in_page(new_addr))
@@ -830,7 +825,7 @@ static unsigned long mremap_to(unsigned
 		old_len = new_len;
 	}
 
-	vma = vma_to_resize(addr, old_len, new_len, flags, &charged);
+	vma = vma_to_resize(addr, old_len, new_len, flags);
 	if (IS_ERR(vma)) {
 		ret = PTR_ERR(vma);
 		goto out;
@@ -853,7 +848,7 @@ static unsigned long mremap_to(unsigned
 				((addr - vma->vm_start) >> PAGE_SHIFT),
 				map_flags);
 	if (IS_ERR_VALUE(ret))
-		goto out1;
+		goto out;
 
 	/* We got a new mapping */
 	if (!(flags & MREMAP_FIXED))
@@ -862,12 +857,6 @@ static unsigned long mremap_to(unsigned
 	ret = move_vma(vma, addr, old_len, new_len, new_addr, locked, flags, uf,
 		       uf_unmap);
 
-	if (!(offset_in_page(ret)))
-		goto out;
-
-out1:
-	vm_unacct_memory(charged);
-
 out:
 	return ret;
 }
@@ -899,7 +888,6 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	unsigned long ret = -EINVAL;
-	unsigned long charged = 0;
 	bool locked = false;
 	bool downgraded = false;
 	struct vm_userfaultfd_ctx uf = NULL_VM_UFFD_CTX;
@@ -981,7 +969,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 	/*
 	 * Ok, we need to grow..
 	 */
-	vma = vma_to_resize(addr, old_len, new_len, flags, &charged);
+	vma = vma_to_resize(addr, old_len, new_len, flags);
 	if (IS_ERR(vma)) {
 		ret = PTR_ERR(vma);
 		goto out;
@@ -992,10 +980,18 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 	if (old_len == vma->vm_end - addr) {
 		/* can we just expand the current mapping? */
 		if (vma_expandable(vma, new_len - old_len)) {
-			int pages = (new_len - old_len) >> PAGE_SHIFT;
+			long pages = (new_len - old_len) >> PAGE_SHIFT;
+
+			if (vma->vm_flags & VM_ACCOUNT) {
+				if (security_vm_enough_memory_mm(mm, pages)) {
+					ret = -ENOMEM;
+					goto out;
+				}
+			}
 
 			if (vma_adjust(vma, vma->vm_start, addr + new_len,
 				       vma->vm_pgoff, NULL)) {
+				vm_unacct_memory(pages);
 				ret = -ENOMEM;
 				goto out;
 			}
@@ -1034,10 +1030,8 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 			       &locked, flags, &uf, &uf_unmap);
 	}
 out:
-	if (offset_in_page(ret)) {
-		vm_unacct_memory(charged);
+	if (offset_in_page(ret))
 		locked = false;
-	}
 	if (downgraded)
 		mmap_read_unlock(current->mm);
 	else
_

Patches currently in -mm which might be from dima@arista.com are


