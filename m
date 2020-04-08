From: akpm@linux-foundation.org
Subject: [merged]
 mm-vma-append-unlikely-while-testing-vma-access-permissions.patch removed
 from -mm tree
Date: Tue, 07 Apr 2020 18:56:38 -0700
Message-ID: <20200408015638.NE9lJ92Gl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726443AbgDHB4j (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:56:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, anshuman.khandual@arm.com, geert@linux-m68k.org, guoren@kernel.org, mm-commits@vger.kernel.org, paulburton@kernel.org, ralf@linux-mips.org, rppt@linux.ibm.com


The patch titled
     Subject: mm/vma: append unlikely() while testing VMA access permissions
has been removed from the -mm tree.  Its filename was
     mm-vma-append-unlikely-while-testing-vma-access-permissions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/vma: append unlikely() while testing VMA access permissions

It is unlikely that an inaccessible VMA without required permission flags
will get a page fault.  Hence lets just append unlikely() directive to
such checks in order to improve performance while also standardizing it
across various platforms.

Link: http://lkml.kernel.org/r/1582525304-32113-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Burton <paulburton@kernel.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/csky/mm/fault.c |    2 +-
 arch/m68k/mm/fault.c |    2 +-
 arch/mips/mm/fault.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/csky/mm/fault.c~mm-vma-append-unlikely-while-testing-vma-access-permissions
+++ a/arch/csky/mm/fault.c
@@ -141,7 +141,7 @@ good_area:
 		if (!(vma->vm_flags & VM_WRITE))
 			goto bad_area;
 	} else {
-		if (!vma_is_accessible(vma))
+		if (unlikely(!vma_is_accessible(vma)))
 			goto bad_area;
 	}
 
--- a/arch/m68k/mm/fault.c~mm-vma-append-unlikely-while-testing-vma-access-permissions
+++ a/arch/m68k/mm/fault.c
@@ -125,7 +125,7 @@ good_area:
 		case 1:		/* read, present */
 			goto acc_err;
 		case 0:		/* read, not present */
-			if (!vma_is_accessible(vma))
+			if (unlikely(!vma_is_accessible(vma)))
 				goto acc_err;
 	}
 
--- a/arch/mips/mm/fault.c~mm-vma-append-unlikely-while-testing-vma-access-permissions
+++ a/arch/mips/mm/fault.c
@@ -142,7 +142,7 @@ good_area:
 				goto bad_area;
 			}
 		} else {
-			if (!vma_is_accessible(vma))
+			if (unlikely(!vma_is_accessible(vma)))
 				goto bad_area;
 		}
 	}
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-vma-define-a-default-value-for-vm_data_default_flags.patch
mm-vma-introduce-vm_access_flags.patch
mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial.patch
mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial-v3.patch
mm-debug-add-tests-validating-architecture-page-table-helpers.patch
