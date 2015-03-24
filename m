From: akpm@linux-foundation.org
Subject: + clean-up-goto-just-return-err_ptr.patch added to -mm tree
Date: Tue, 24 Mar 2015 15:26:14 -0700
Message-ID: <5511e486.AMaXEnPqod+Ch77G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38064 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbbCXW0P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Mar 2015 18:26:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: denc716@gmail.com, crquan@ymail.com, kirill@shutemov.name, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap.c: clean up goto just return ERR_PTR
has been added to the -mm tree.  Its filename is
     clean-up-goto-just-return-err_ptr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/clean-up-goto-just-return-err_ptr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/clean-up-goto-just-return-err_ptr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Derek <denc716@gmail.com>
Subject: mm/mremap.c: clean up goto just return ERR_PTR

As suggested by Kirill the "goto"s in vma_to_resize aren't neccessary,
just change them to explicit return.

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
@@ -339,25 +339,25 @@ static struct vm_area_struct *vma_to_res
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
@@ -366,29 +366,20 @@ static struct vm_area_struct *vma_to_res
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
