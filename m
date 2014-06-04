From: akpm@linux-foundation.org
Subject: [merged] mips-call-find_vma-with-the-mmap_sem-held.patch removed
 from -mm tree
Date: Wed, 04 Jun 2014 12:01:23 -0700
Message-ID: <538f6d03.GTfgcyj5SfFkNF92%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37370 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaFDTBY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2014 15:01:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ralf@linux-mips.org, andreas.herrmann@caviumnetworks.com, davidlohr@hp.com

Subject: [merged] mips-call-find_vma-with-the-mmap_sem-held.patch removed from -mm tree
To: davidlohr@hp.com,andreas.herrmann@caviumnetworks.com,ralf@linux-mips.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 04 Jun 2014 12:01:23 -0700


The patch titled
     Subject: mips: call find_vma with the mmap_sem held
has been removed from the -mm tree.  Its filename was
     mips-call-find_vma-with-the-mmap_sem-held.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Tested-by: Andreas Herrmann <andreas.herrmann@caviumnetworks.com>
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

origin.patch
mmvmacache-add-debug-data.patch
mmvmacache-optimize-overflow-system-wide-flushing.patch
mm-pass-vm_bug_on-reason-to-dump_page.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
hugetlb-add-hstate_is_gigantic.patch
hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
hugetlb-move-helpers-up-in-the-file.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush.patch
arc-call-find_vma-with-the-mmap_sem-held.patch
arc-call-find_vma-with-the-mmap_sem-held-fix.patch
drm-exynos-call-find_vma-with-the-mmap_sem-held.patch
mm-hugetlb-move-the-error-handle-logic-out-of-normal-code-path.patch
mm-process_vm_access-move-config-option-into-init-kconfig.patch
ipc-constify-ipc_ops.patch
ipc-shmc-check-for-ulong-overflows-in-shmat.patch
ipc-shmc-check-for-overflows-of-shm_tot.patch
ipc-shmc-check-for-integer-overflow-during-shmget.patch
ipc-shmc-increase-the-defaults-for-shmall-shmmax.patch
ipcshm-document-new-limits-in-the-uapi-header.patch
ipcshm-document-new-limits-in-the-uapi-header-v2.patch
ipcshm-document-new-limits-in-the-uapi-header-v3.patch
ipcmsg-use-current-state-helpers.patch
ipcmsg-move-some-msgq-ns-code-around.patch
ipcmsg-document-volatile-r_msg.patch
ipc-semc-add-a-printk_once-for-semctlgetncnt-getzcnt.patch
linux-next.patch
blackfin-ptrace-call-find_vma-with-the-mmap_sem-held.patch
rwsem-support-optimistic-spinning.patch

