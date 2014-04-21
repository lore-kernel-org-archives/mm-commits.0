From: akpm@linux-foundation.org
Subject: +
 m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush.patch added to
 -mm tree
Date: Mon, 21 Apr 2014 14:20:42 -0700
Message-ID: <53558baa.ExY7zfsjlAXa7/bG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37106 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027AbaDUVUn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 17:20:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, geert@linux-m68k.org, davidlohr@hp.com

Subject: + m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush.patch added to -mm tree
To: davidlohr@hp.com,geert@linux-m68k.org
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 14:20:42 -0700


The patch titled
     Subject: m68k: call find_vma with the mmap_sem held in sys_cacheflush()
has been added to the -mm tree.  Its filename is
     m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: m68k: call find_vma with the mmap_sem held in sys_cacheflush()

Performing vma lookups without taking the mm->mmap_sem is asking for
trouble.  While doing the search, the vma in question can be modified or
even removed before returning to the caller.  Take the lock (shared) in
order to avoid races while iterating through the vmacache and/or rbtree.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/kernel/sys_m68k.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff -puN arch/m68k/kernel/sys_m68k.c~m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush arch/m68k/kernel/sys_m68k.c
--- a/arch/m68k/kernel/sys_m68k.c~m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush
+++ a/arch/m68k/kernel/sys_m68k.c
@@ -376,7 +376,6 @@ cache_flush_060 (unsigned long addr, int
 asmlinkage int
 sys_cacheflush (unsigned long addr, int scope, int cache, unsigned long len)
 {
-	struct vm_area_struct *vma;
 	int ret = -EINVAL;
 
 	if (scope < FLUSH_SCOPE_LINE || scope > FLUSH_SCOPE_ALL ||
@@ -389,16 +388,23 @@ sys_cacheflush (unsigned long addr, int
 		if (!capable(CAP_SYS_ADMIN))
 			goto out;
 	} else {
+		struct vm_area_struct *vma;
+		bool invalid;
+
+		/* Check for overflow.  */
+		if (addr + len < addr)
+			goto out;
+
 		/*
 		 * Verify that the specified address region actually belongs
 		 * to this process.
 		 */
-		vma = find_vma (current->mm, addr);
 		ret = -EINVAL;
-		/* Check for overflow.  */
-		if (addr + len < addr)
-			goto out;
-		if (vma == NULL || addr < vma->vm_start || addr + len > vma->vm_end)
+		down_read(&current->mm->mmap_sem);
+		vma = find_vma(current->mm, addr);
+		invalid = !vma || addr < vma->vm_start || addr + len > vma->vm_end;
+		up_read(&current->mm->mmap_sem);
+		if (invalid)
 			goto out;
 	}
 
_

Patches currently in -mm which might be from davidlohr@hp.com are

mmvmacache-add-debug-data.patch
mmvmacache-optimize-overflow-system-wide-flushing.patch
mm-pass-vm_bug_on-reason-to-dump_page.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
hugetlb-add-hstate_is_gigantic.patch
hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
hugetlb-move-helpers-up-in-the-file.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
blackfin-ptrace-call-find_vma-with-the-mmap_sem-held.patch
m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush.patch
mips-call-find_vma-with-the-mmap_sem-held.patch
arc-call-find_vma-with-the-mmap_sem-held.patch
driverssgi-gru-grufaultc-call-find_vma-with-the-mmap_sem-held.patch
drm-exynos-call-find_vma-with-the-mmap_sem-held.patch
ipc-constify-ipc_ops.patch
linux-next.patch

