From: akpm@linux-foundation.org
Subject: [merged] thp-prepare-change_huge_pmd-for-file-thp.patch removed
 from -mm tree
Date: Wed, 27 Jul 2016 12:02:32 -0700
Message-ID: <57990548.3k0meXpnU7glCvrX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40704 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757964AbcG0TCd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 15:02:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: prepare change_huge_pmd() for file thp
has been removed from the -mm tree.  Its filename was
     thp-prepare-change_huge_pmd-for-file-thp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: prepare change_huge_pmd() for file thp

change_huge_pmd() has assert which is not relvant for file page.
For shared mapping it's perfectly fine to have page table entry
writable, without explicit mkwrite.

Link: http://lkml.kernel.org/r/1466021202-61880-18-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/huge_memory.c~thp-prepare-change_huge_pmd-for-file-thp mm/huge_memory.c
--- a/mm/huge_memory.c~thp-prepare-change_huge_pmd-for-file-thp
+++ a/mm/huge_memory.c
@@ -1788,7 +1788,8 @@ int change_huge_pmd(struct vm_area_struc
 				entry = pmd_mkwrite(entry);
 			ret = HPAGE_PMD_NR;
 			set_pmd_at(mm, addr, pmd, entry);
-			BUG_ON(!preserve_write && pmd_write(entry));
+			BUG_ON(vma_is_anonymous(vma) && !preserve_write &&
+					pmd_write(entry));
 		}
 		spin_unlock(ptl);
 	}
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are


