Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90FE6C6377A
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jul 2021 20:50:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78C4361244
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jul 2021 20:50:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbhGUUJt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Jul 2021 16:09:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229604AbhGUUJt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 21 Jul 2021 16:09:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81C3161009;
        Wed, 21 Jul 2021 20:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626900625;
        bh=E1nIaUcTZhLqujwRpvzR9m5P5hpNGcqWimt+9KTCaj0=;
        h=Date:From:To:Subject:From;
        b=R1UN/0u5nDkkcnCNjuiu088cYc3GU87hutgrpkVJpeSPCeIzkCfNM19qKemJ76kBF
         /klyBTyVKYTJv98MHwW/MC1Vpzn/2gS8dFSH0Uy2nMWphzehwq+VWWNlUQLMCuI/wI
         o9XoLYnJGuYSKYKWT1TceN5ZtxU757qfkeTSGVqk=
Date:   Wed, 21 Jul 2021 13:50:22 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org,
        weiyongjun1@huawei.com, wangkefeng.wang@huawei.com,
        vishal.l.verma@intel.com, viro@zeniv.linux.org.uk, vbabka@suse.cz,
        tsbogend@alpha.franken.de, tglx@linutronix.de,
        rcampbell@nvidia.com, mingo@redhat.com, minchan@kernel.org,
        mike.kravetz@oracle.com, luto@kernel.org, linux@armlinux.org.uk,
        kirill.shutemov@linux.intel.com, jhubbard@nvidia.com, jgg@ziepe.ca,
        hughd@google.com, dave.jiang@intel.com, dan.j.williams@intel.com,
        dan.carpenter@oracle.com, chenwandun@huawei.com,
        catalin.marinas@arm.com, bgeffon@google.com, dima@arista.com
Subject:  + mm-mremap-dont-account-pages-in-vma_to_resize.patch added
 to -mm tree
Message-ID: <20210721205022.NwcAI%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap: don't account pages in vma_to_resize()
has been added to the -mm tree.  Its filename is
     mm-mremap-dont-account-pages-in-vma_to_resize.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mremap-dont-account-pages-in-vma_to_resize.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mremap-dont-account-pages-in-vma_to_resize.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Brian Geffon <bgeffon@google.com>
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

mm-mremap-dont-account-pages-in-vma_to_resize.patch

