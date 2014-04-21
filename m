From: akpm@linux-foundation.org
Subject: + arc-call-find_vma-with-the-mmap_sem-held.patch added to -mm
 tree
Date: Mon, 21 Apr 2014 14:20:44 -0700
Message-ID: <53558bac.Pamks4mx+TMMQ183%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37111 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513AbaDUVUp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 17:20:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgupta@synopsys.com, davidlohr@hp.com

Subject: + arc-call-find_vma-with-the-mmap_sem-held.patch added to -mm tree
To: davidlohr@hp.com,vgupta@synopsys.com
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 14:20:44 -0700


The patch titled
     Subject: arc: call find_vma with the mmap_sem held
has been added to the -mm tree.  Its filename is
     arc-call-find_vma-with-the-mmap_sem-held.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arc-call-find_vma-with-the-mmap_sem-held.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arc-call-find_vma-with-the-mmap_sem-held.patch

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
Subject: arc: call find_vma with the mmap_sem held

Performing vma lookups without taking the mm->mmap_sem is asking for
trouble.  While doing the search, the vma in question can be modified or
even removed before returning to the caller.  Take the lock (shared) in
order to avoid races while iterating through the vmacache and/or rbtree.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/kernel/troubleshoot.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN arch/arc/kernel/troubleshoot.c~arc-call-find_vma-with-the-mmap_sem-held arch/arc/kernel/troubleshoot.c
--- a/arch/arc/kernel/troubleshoot.c~arc-call-find_vma-with-the-mmap_sem-held
+++ a/arch/arc/kernel/troubleshoot.c
@@ -90,7 +90,7 @@ static void show_faulting_vma(unsigned l
 	/* can't use print_vma_addr() yet as it doesn't check for
 	 * non-inclusive vma
 	 */
-
+	down_read(&current->active_mm->mmap_sem);
 	vma = find_vma(current->active_mm, address);
 
 	/* check against the find_vma( ) behaviour which returns the next VMA
@@ -110,9 +110,10 @@ static void show_faulting_vma(unsigned l
 			vma->vm_start < TASK_UNMAPPED_BASE ?
 				address : address - vma->vm_start,
 			nm, vma->vm_start, vma->vm_end);
-	} else {
+	} else
 		pr_info("    @No matching VMA found\n");
-	}
+
+	up_read(&current->active_mm->mmap_sem);
 }
 
 static void show_ecr_verbose(struct pt_regs *regs)
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

