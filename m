From: akpm@linux-foundation.org
Subject: [merged] thp-make-madv_hugepage-check-for-mm-def_flags.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:08:31 -0700
Message-ID: <20121009180832.84D2B200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:50789 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756702Ab2JISIf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:08:35 -0400
Received: by mail-lb0-f202.google.com with SMTP id l12so362977lbo.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:08:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerald.schaefer@de.ibm.com, aarcange@redhat.com, ak@linux.intel.com, dhillf@gmail.com, heiko.carstens@de.ibm.com, hughd@google.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: make MADV_HUGEPAGE check for mm->def_flags
has been removed from the -mm tree.  Its filename was
     thp-make-madv_hugepage-check-for-mm-def_flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: thp: make MADV_HUGEPAGE check for mm->def_flags

This adds a check to hugepage_madvise(), to refuse MADV_HUGEPAGE if
VM_NOHUGEPAGE is set in mm->def_flags.  On s390, the VM_NOHUGEPAGE flag
will be set in mm->def_flags for kvm processes, to prevent any future thp
mappings.  In order to also prevent MADV_HUGEPAGE on such an mm,
hugepage_madvise() should check mm->def_flags.

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/huge_memory.c~thp-make-madv_hugepage-check-for-mm-def_flags mm/huge_memory.c
--- a/mm/huge_memory.c~thp-make-madv_hugepage-check-for-mm-def_flags
+++ a/mm/huge_memory.c
@@ -1450,6 +1450,8 @@ out:
 int hugepage_madvise(struct vm_area_struct *vma,
 		     unsigned long *vm_flags, int advice)
 {
+	struct mm_struct *mm = vma->vm_mm;
+
 	switch (advice) {
 	case MADV_HUGEPAGE:
 		/*
@@ -1457,6 +1459,8 @@ int hugepage_madvise(struct vm_area_stru
 		 */
 		if (*vm_flags & (VM_HUGEPAGE | VM_NO_THP))
 			return -EINVAL;
+		if (mm->def_flags & VM_NOHUGEPAGE)
+			return -EINVAL;
 		*vm_flags &= ~VM_NOHUGEPAGE;
 		*vm_flags |= VM_HUGEPAGE;
 		/*
_

Patches currently in -mm which might be from gerald.schaefer@de.ibm.com are

origin.patch
linux-next.patch

