From: akpm@linux-foundation.org
Subject: [merged]
 mm-vma-move-vm_no_khugepaged-into-generic-header.patch removed from -mm
 tree
Date: Fri, 03 Apr 2020 13:38:08 -0700
Message-ID: <20200403203808.R5CLX2_ZE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727809AbgDCUiJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:38:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org, tglx@linutronix.de, vbabka@suse.cz


The patch titled
     Subject: mm/vma: move VM_NO_KHUGEPAGED into generic header
has been removed from the -mm tree.  Its filename was
     mm-vma-move-vm_no_khugepaged-into-generic-header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/vma: move VM_NO_KHUGEPAGED into generic header

Patch series "mm/vma: some more minor changes", v2.

The motivation here is to consolidate VMA flags and helpers in generic
memory header and reduce code duplication when ever applicable.  If there
are other possible similar instances which might be missing here, please
do let me me know.  I will be happy to incorporate them.


This patch (of 3):

Move VM_NO_KHUGEPAGED into generic header (include/linux/mm.h).  This just
makes sure that no VMA flag is scattered in individual function files any
longer.  While at this, fix an old comment which is no longer valid.  This
should not cause any functional change.

Link: http://lkml.kernel.org/r/1582782965-3274-2-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 +++-
 mm/khugepaged.c    |    2 --
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/mm.h~mm-vma-move-vm_no_khugepaged-into-generic-header
+++ a/include/linux/mm.h
@@ -356,10 +356,12 @@ extern unsigned int kobjsize(const void
 
 /*
  * Special vmas that are non-mergable, non-mlock()able.
- * Note: mm/huge_memory.c VM_NO_THP depends on this definition.
  */
 #define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_PFNMAP | VM_MIXEDMAP)
 
+/* This mask prevents VMA from being scanned with khugepaged */
+#define VM_NO_KHUGEPAGED (VM_SPECIAL | VM_HUGETLB)
+
 /* This mask defines which mm->def_flags a process can inherit its parent */
 #define VM_INIT_DEF_MASK	VM_NOHUGEPAGE
 
--- a/mm/khugepaged.c~mm-vma-move-vm_no_khugepaged-into-generic-header
+++ a/mm/khugepaged.c
@@ -308,8 +308,6 @@ struct attribute_group khugepaged_attr_g
 };
 #endif /* CONFIG_SYSFS */
 
-#define VM_NO_KHUGEPAGED (VM_SPECIAL | VM_HUGETLB)
