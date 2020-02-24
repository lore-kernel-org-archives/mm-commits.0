From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-vma-append-unlikely-while-testing-vma-access-permissions.patch added to
 -mm tree
Date: Mon, 24 Feb 2020 14:14:16 -0800
Message-ID: <20200224221416.HVGJuk4n_%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbgBXWOS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Feb 2020 17:14:18 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, anshuman.khandual@arm.com, geert@linux-m68k.org, guoren@kernel.org, mm-commits@vger.kernel.org, paulburton@kernel.org, ralf@linux-mips.org, rppt@linux.ibm.com


The patch titled
     Subject: mm/vma: append unlikely() while testing VMA access permissions
has been added to the -mm tree.  Its filename is
     mm-vma-append-unlikely-while-testing-vma-access-permissions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vma-append-unlikely-while-testing-vma-access-permissions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vma-append-unlikely-while-testing-vma-access-permissions.patch

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
@@ -137,7 +137,7 @@ good_area:
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

mm-debug-add-tests-validating-architecture-page-table-helpers.patch
mm-vma-add-missing-vma-flag-readable-name-for-vm_sync.patch
mm-vma-make-vma_is_accessible-available-for-general-use.patch
mm-vma-replace-all-remaining-open-encodings-with-is_vm_hugetlb_page.patch
mm-vma-replace-all-remaining-open-encodings-with-vma_is_anonymous.patch
mm-vma-append-unlikely-while-testing-vma-access-permissions.patch
