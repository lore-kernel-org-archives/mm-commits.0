From: akpm@linux-foundation.org
Subject: + mm-vma-move-vm_no_khugepaged-into-generic-header.patch
 added to -mm tree
Date: Sat, 29 Feb 2020 20:51:45 -0800
Message-ID: <20200301045145.pi8s4nL7g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbgCAEvr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 29 Feb 2020 23:51:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org, tglx@linutronix.de, vbabka@suse.cz


The patch titled
     Subject: mm/vma: move VM_NO_KHUGEPAGED into generic header
has been added to the -mm tree.  Its filename is
     mm-vma-move-vm_no_khugepaged-into-generic-header.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vma-move-vm_no_khugepaged-into-generic-header.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vma-move-vm_no_khugepaged-into-generic-header.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
