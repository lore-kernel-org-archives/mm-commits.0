From: akpm@linux-foundation.org
Subject: [merged] arc-call-find_vma-with-the-mmap_sem-held.patch removed
 from -mm tree
Date: Thu, 05 Jun 2014 12:50:05 -0700
Message-ID: <5390c9ed./tDq373jrFN4qrel%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55943 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbaFETuG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:50:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgupta@synopsys.com, davidlohr@hp.com

Subject: [merged] arc-call-find_vma-with-the-mmap_sem-held.patch removed from -mm tree
To: davidlohr@hp.com,vgupta@synopsys.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:50:05 -0700


The patch titled
     Subject: arc: call find_vma with the mmap_sem held
has been removed from the -mm tree.  Its filename was
     arc-call-find_vma-with-the-mmap_sem-held.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: arc: call find_vma with the mmap_sem held

Performing vma lookups without taking the mm->mmap_sem is asking for
trouble.  While doing the search, the vma in question can be modified or
even removed before returning to the caller.  Take the lock (shared) in
order to avoid races while iterating through the vmacache and/or rbtree.

[akpm@linux-foundation.org: CSE current->active_mm, per Vineet]
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Acked-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/kernel/troubleshoot.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN arch/arc/kernel/troubleshoot.c~arc-call-find_vma-with-the-mmap_sem-held arch/arc/kernel/troubleshoot.c
--- a/arch/arc/kernel/troubleshoot.c~arc-call-find_vma-with-the-mmap_sem-held
+++ a/arch/arc/kernel/troubleshoot.c
@@ -86,12 +86,13 @@ static void show_faulting_vma(unsigned l
 	unsigned long ino = 0;
 	dev_t dev = 0;
 	char *nm = buf;
+	struct mm_struct *active_mm = current->active_mm;
 
 	/* can't use print_vma_addr() yet as it doesn't check for
 	 * non-inclusive vma
 	 */
-
-	vma = find_vma(current->active_mm, address);
+	down_read(&active_mm->mmap_sem);
+	vma = find_vma(active_mm, address);
 
 	/* check against the find_vma( ) behaviour which returns the next VMA
 	 * if the container VMA is not found
@@ -110,9 +111,10 @@ static void show_faulting_vma(unsigned l
 			vma->vm_start < TASK_UNMAPPED_BASE ?
 				address : address - vma->vm_start,
 			nm, vma->vm_start, vma->vm_end);
-	} else {
+	} else
 		pr_info("    @No matching VMA found\n");
-	}
+
+	up_read(&active_mm->mmap_sem);
 }
 
 static void show_ecr_verbose(struct pt_regs *regs)
_

Patches currently in -mm which might be from davidlohr@hp.com are

origin.patch
m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush.patch
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

