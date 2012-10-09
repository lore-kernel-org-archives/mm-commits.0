From: akpm@linux-foundation.org
Subject: [merged] thp-s390-disable-thp-for-kvm-host-on-s390.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:08:43 -0700
Message-ID: <20121009180844.12B1B1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:56152 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756702Ab2JISIp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:08:45 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so661947vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:08:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerald.schaefer@de.ibm.com, aarcange@redhat.com, ak@linux.intel.com, dhillf@gmail.com, heiko.carstens@de.ibm.com, hughd@google.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp, s390: disable thp for kvm host on s390
has been removed from the -mm tree.  Its filename was
     thp-s390-disable-thp-for-kvm-host-on-s390.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: thp, s390: disable thp for kvm host on s390

This patch is part of the architecture backend for thp on s390.  It
disables thp for kvm hosts, because there is no kvm host hugepage support
so far.  Existing thp mappings are split by follow_page() with FOLL_SPLIT,
and future thp mappings are prevented by setting VM_NOHUGEPAGE in
mm->def_flags.

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/pgtable.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff -puN arch/s390/mm/pgtable.c~thp-s390-disable-thp-for-kvm-host-on-s390 arch/s390/mm/pgtable.c
--- a/arch/s390/mm/pgtable.c~thp-s390-disable-thp-for-kvm-host-on-s390
+++ a/arch/s390/mm/pgtable.c
@@ -787,6 +787,30 @@ void tlb_remove_table(struct mmu_gather 
 		tlb_table_flush(tlb);
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+void thp_split_vma(struct vm_area_struct *vma)
+{
+	unsigned long addr;
+	struct page *page;
+
+	for (addr = vma->vm_start; addr < vma->vm_end; addr += PAGE_SIZE) {
+		page = follow_page(vma, addr, FOLL_SPLIT);
+	}
+}
+
+void thp_split_mm(struct mm_struct *mm)
+{
+	struct vm_area_struct *vma = mm->mmap;
+
+	while (vma != NULL) {
+		thp_split_vma(vma);
+		vma->vm_flags &= ~VM_HUGEPAGE;
+		vma->vm_flags |= VM_NOHUGEPAGE;
+		vma = vma->vm_next;
+	}
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+
 /*
  * switch on pgstes for its userspace process (for kvm)
  */
@@ -824,6 +848,12 @@ int s390_enable_sie(void)
 	if (!mm)
 		return -ENOMEM;
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	/* split thp mappings and disable thp for future mappings */
+	thp_split_mm(mm);
+	mm->def_flags |= VM_NOHUGEPAGE;
+#endif
+
 	/* Now lets check again if something happened */
 	task_lock(tsk);
 	if (!tsk->mm || atomic_read(&tsk->mm->mm_users) > 1 ||
_

Patches currently in -mm which might be from gerald.schaefer@de.ibm.com are

origin.patch
linux-next.patch

