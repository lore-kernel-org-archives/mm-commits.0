From: akpm@linux-foundation.org
Subject: [merged] clean-up-goto-just-return-err_ptr.patch removed from -mm tree
Date: Thu, 16 Apr 2015 09:52:06 -0700
Message-ID: <552fe8b6.QZDEsIg7EQrcyB83%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42713 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806AbbDPQqh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:46:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: denc716@gmail.com, crquan@ymail.com, kirill@shutemov.name, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap.c: clean up goto just return ERR_PTR
has been removed from the -mm tree.  Its filename was
     clean-up-goto-just-return-err_ptr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Derek <denc716@gmail.com>
Subject: mm/mremap.c: clean up goto just return ERR_PTR

As suggested by Kirill the "goto"s in vma_to_resize aren't necessary, just
change them to explicit return.

Signed-off-by: Derek Che <crquan@ymail.com>
Suggested-by: "Kirill A. Shutemov" <kirill@shutemov.name>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff -puN mm/mremap.c~clean-up-goto-just-return-err_ptr mm/mremap.c
--- a/mm/mremap.c~clean-up-goto-just-return-err_ptr
+++ a/mm/mremap.c
@@ -345,25 +345,25 @@ static struct vm_area_struct *vma_to_res
 	struct vm_area_struct *vma = find_vma(mm, addr);
 
 	if (!vma || vma->vm_start > addr)
-		goto Efault;
+		return ERR_PTR(-EFAULT);
 
 	if (is_vm_hugetlb_page(vma))
-		goto Einval;
+		return ERR_PTR(-EINVAL);
 
 	/* We can't remap across vm area boundaries */
 	if (old_len > vma->vm_end - addr)
-		goto Efault;
+		return ERR_PTR(-EFAULT);
 
 	/* Need to be careful about a growing mapping */
 	if (new_len > old_len) {
 		unsigned long pgoff;
 
 		if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP))
-			goto Efault;
+			return ERR_PTR(-EFAULT);
 		pgoff = (addr - vma->vm_start) >> PAGE_SHIFT;
 		pgoff += vma->vm_pgoff;
 		if (pgoff + (new_len >> PAGE_SHIFT) < pgoff)
-			goto Einval;
+			return ERR_PTR(-EINVAL);
 	}
 
 	if (vma->vm_flags & VM_LOCKED) {
@@ -372,29 +372,20 @@ static struct vm_area_struct *vma_to_res
 		lock_limit = rlimit(RLIMIT_MEMLOCK);
 		locked += new_len - old_len;
 		if (locked > lock_limit && !capable(CAP_IPC_LOCK))
-			goto Eagain;
+			return ERR_PTR(-EAGAIN);
 	}
 
 	if (!may_expand_vm(mm, (new_len - old_len) >> PAGE_SHIFT))
-		goto Enomem;
+		return ERR_PTR(-ENOMEM);
 
 	if (vma->vm_flags & VM_ACCOUNT) {
 		unsigned long charged = (new_len - old_len) >> PAGE_SHIFT;
 		if (security_vm_enough_memory_mm(mm, charged))
-			goto Enomem;
+			return ERR_PTR(-ENOMEM);
 		*p = charged;
 	}
 
 	return vma;
