From: akpm@linux-foundation.org
Subject: [patch 098/126] thp: prepare change_huge_pmd() for file thp
Date: Tue, 26 Jul 2016 15:25:45 -0700
Message-ID: <5797e369.aoC2EAc2Zti3Ww63%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57047 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758604AbcGZWZq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:25:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com

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
