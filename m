From: akpm@linux-foundation.org
Subject: + mremap-dont-do-uneccesary-checks-if-new_len-==-old_len.patch
 added to -mm tree
Date: Thu, 09 Jul 2015 15:26:32 -0700
Message-ID: <559ef518.J41dLtmbCHhvhFui%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53092 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105AbbGIW0d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 18:26:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, bcrl@kvack.org, hughd@google.com, jmoyer@redhat.com, kirill.shutemov@linux.intel.com, ldufour@linux.vnet.ibm.com, rientjes@google.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mremap: don't do uneccesary checks if new_len == old_len
has been added to the -mm tree.  Its filename is
     mremap-dont-do-uneccesary-checks-if-new_len-==-old_len.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mremap-dont-do-uneccesary-checks-if-new_len-%3D%3D-old_len.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mremap-dont-do-uneccesary-checks-if-new_len-%3D%3D-old_len.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: mremap: don't do uneccesary checks if new_len == old_len

The "new_len > old_len" branch in vma_to_resize() looks very confusing. 
It only covers the VM_DONTEXPAND/pgoff checks but everything below is
equally unneeded if new_len == old_len.

Change this code to return if "new_len == old_len", new_len < old_len is
not possible, otherwise the code below is wrong anyway.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff -puN mm/mremap.c~mremap-dont-do-uneccesary-checks-if-new_len-==-old_len mm/mremap.c
--- a/mm/mremap.c~mremap-dont-do-uneccesary-checks-if-new_len-==-old_len
+++ a/mm/mremap.c
@@ -346,6 +346,7 @@ static struct vm_area_struct *vma_to_res
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma = find_vma(mm, addr);
+	unsigned long pgoff;
 
 	if (!vma || vma->vm_start > addr)
 		return ERR_PTR(-EFAULT);
@@ -357,17 +358,17 @@ static struct vm_area_struct *vma_to_res
 	if (old_len > vma->vm_end - addr)
 		return ERR_PTR(-EFAULT);
 
+	if (new_len == old_len)
+		return vma;
+
 	/* Need to be careful about a growing mapping */
-	if (new_len > old_len) {
-		unsigned long pgoff;
+	pgoff = (addr - vma->vm_start) >> PAGE_SHIFT;
+	pgoff += vma->vm_pgoff;
+	if (pgoff + (new_len >> PAGE_SHIFT) < pgoff)
+		return ERR_PTR(-EINVAL);
 
-		if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP))
-			return ERR_PTR(-EFAULT);
-		pgoff = (addr - vma->vm_start) >> PAGE_SHIFT;
-		pgoff += vma->vm_pgoff;
-		if (pgoff + (new_len >> PAGE_SHIFT) < pgoff)
-			return ERR_PTR(-EINVAL);
-	}
+	if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP))
+		return ERR_PTR(-EFAULT);
 
 	if (vma->vm_flags & VM_LOCKED) {
 		unsigned long locked, lock_limit;
_

Patches currently in -mm which might be from oleg@redhat.com are

mremap-dont-leak-new_vma-if-f_op-mremap-fails.patch
mm-move-mremap-from-file_operations-to-vm_operations_struct.patch
mremap-dont-do-mm_populatenew_addr-on-failure.patch
mremap-dont-do-uneccesary-checks-if-new_len-==-old_len.patch
mremap-simplify-the-overlap-check-in-mremap_to.patch
kmod-bunch-of-internal-functions-renames.patch
kmod-add-up-to-date-explanations-on-the-purpose-of-each-asynchronous-levels.patch
kmod-remove-unecessary-explicit-wide-cpu-affinity-setting.patch
linux-next.patch

