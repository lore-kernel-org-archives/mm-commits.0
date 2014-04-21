From: akpm@linux-foundation.org
Subject: + mips-call-find_vma-with-the-mmap_sem-held.patch added to -mm
 tree
Date: Mon, 21 Apr 2014 14:20:43 -0700
Message-ID: <53558bab.CD5Q0wW5eVjMiekR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027AbaDUVUo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 17:20:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ralf@linux-mips.org, davidlohr@hp.com

Subject: + mips-call-find_vma-with-the-mmap_sem-held.patch added to -mm tree
To: davidlohr@hp.com,ralf@linux-mips.org
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 14:20:43 -0700


The patch titled
     Subject: mips: call find_vma with the mmap_sem held
has been added to the -mm tree.  Its filename is
     mips-call-find_vma-with-the-mmap_sem-held.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mips-call-find_vma-with-the-mmap_sem-held.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mips-call-find_vma-with-the-mmap_sem-held.patch

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
Subject: mips: call find_vma with the mmap_sem held

Performing vma lookups without taking the mm->mmap_sem is asking for
trouble.  While doing the search, the vma in question can be modified or
even removed before returning to the caller.  Take the lock (exclusively)
in order to avoid races while iterating through the vmacache and/or
rbtree.

Updates two functions:
  - process_fpemu_return()
  - cteon_flush_cache_sigtramp()

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/traps.c |    2 ++
 arch/mips/mm/c-octeon.c  |    2 ++
 2 files changed, 4 insertions(+)

diff -puN arch/mips/kernel/traps.c~mips-call-find_vma-with-the-mmap_sem-held arch/mips/kernel/traps.c
--- a/arch/mips/kernel/traps.c~mips-call-find_vma-with-the-mmap_sem-held
+++ a/arch/mips/kernel/traps.c
@@ -712,10 +712,12 @@ int process_fpemu_return(int sig, void _
 		si.si_addr = fault_addr;
 		si.si_signo = sig;
 		if (sig == SIGSEGV) {
+			down_read(&current->mm->mmap_sem);
 			if (find_vma(current->mm, (unsigned long)fault_addr))
 				si.si_code = SEGV_ACCERR;
 			else
 				si.si_code = SEGV_MAPERR;
+			up_read(&current->mm->mmap_sem);
 		} else {
 			si.si_code = BUS_ADRERR;
 		}
diff -puN arch/mips/mm/c-octeon.c~mips-call-find_vma-with-the-mmap_sem-held arch/mips/mm/c-octeon.c
--- a/arch/mips/mm/c-octeon.c~mips-call-find_vma-with-the-mmap_sem-held
+++ a/arch/mips/mm/c-octeon.c
@@ -137,8 +137,10 @@ static void octeon_flush_cache_sigtramp(
 {
 	struct vm_area_struct *vma;
 
+	down_read(&current->mm->mmap_sem);
 	vma = find_vma(current->mm, addr);
 	octeon_flush_icache_all_cores(vma);
+	up_read(&current->mm->mmap_sem);
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

