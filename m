From: akpm@linux-foundation.org
Subject: [to-be-updated] um-adjust-current_thread_info-for-gcc-46.patch removed from -mm tree
Date: Fri, 22 Apr 2011 11:44:54 -0700
Message-ID: <201104221844.p3MIissY025283@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55805 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756009Ab1DVSpC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Apr 2011 14:45:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     um: adjust current_thread_info() for gcc-4.6
has been removed from the -mm tree.  Its filename was
     um-adjust-current_thread_info-for-gcc-46.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: adjust current_thread_info() for gcc-4.6
From: Richard Weinberger <richard@nod.at>

In some cases gcc-4.6 will optimize away current_thread_info().  To
prevent gcc from doing so the stack address has to be obtained via inline
asm.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/asm/thread_info.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN arch/um/include/asm/thread_info.h~um-adjust-current_thread_info-for-gcc-46 arch/um/include/asm/thread_info.h
--- a/arch/um/include/asm/thread_info.h~um-adjust-current_thread_info-for-gcc-46
+++ a/arch/um/include/asm/thread_info.h
@@ -49,7 +49,10 @@ static inline struct thread_info *curren
 {
 	struct thread_info *ti;
 	unsigned long mask = THREAD_SIZE - 1;
-	ti = (struct thread_info *) (((unsigned long) &ti) & ~mask);
+	void *p;
+
+	asm volatile ("" : "=r" (p) : "0" (&ti));
+	ti = (struct thread_info *) (((unsigned long)p) & ~mask);
 	return ti;
 }
 
_

Patches currently in -mm which might be from richard@nod.at are

um-mdd-support-for-64-bit-atomic-operations.patch
uml-fix-hppfs-build.patch
mm-mmu_gather-rework.patch
powerpc-mmu_gather-rework.patch
sparc-mmu_gather-rework.patch
s390-mmu_gather-rework.patch
arm-mmu_gather-rework.patch
sh-mmu_gather-rework.patch
ia64-mmu_gather-rework.patch
um-mmu_gather-rework.patch
mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage.patch
mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code.patch
mm-extended-batches-for-generic-mmu_gather.patch
lockdep-mutex-provide-mutex_lock_nest_lock.patch
mm-remove-i_mmap_lock-lockbreak.patch
mm-convert-i_mmap_lock-to-a-mutex.patch
mm-revert-page_lock_anon_vma-lock-annotation.patch
mm-improve-page_lock_anon_vma-comment.patch
mm-use-refcounts-for-page_lock_anon_vma.patch
mm-convert-anon_vma-lock-to-a-mutex.patch
mm-optimize-page_lock_anon_vma-fast-path.patch

