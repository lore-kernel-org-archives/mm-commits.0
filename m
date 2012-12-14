From: akpm@linux-foundation.org
Subject: [merged] thp-change_huge_pmd-make-sure-we-dont-try-to-make-a-page-writable.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:27:15 -0800
Message-ID: <20121214232716.5E63C200083@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:46299 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418Ab2LNX1T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:27:19 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt14so208094wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:27:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, ak@linux.intel.com, hpa@linux.intel.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: change_huge_pmd(): make sure we don't try to make a page writable
has been removed from the -mm tree.  Its filename was
     thp-change_huge_pmd-make-sure-we-dont-try-to-make-a-page-writable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: change_huge_pmd(): make sure we don't try to make a page writable

mprotect core never tries to make page writable using change_huge_pmd(). 
Let's add an assert that the assumption is true.  It's important to be
sure we will not make huge zero page writable.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/huge_memory.c~thp-change_huge_pmd-make-sure-we-dont-try-to-make-a-page-writable mm/huge_memory.c
--- a/mm/huge_memory.c~thp-change_huge_pmd-make-sure-we-dont-try-to-make-a-page-writable
+++ a/mm/huge_memory.c
@@ -1273,6 +1273,7 @@ int change_huge_pmd(struct vm_area_struc
 		pmd_t entry;
 		entry = pmdp_get_and_clear(mm, addr, pmd);
 		entry = pmd_modify(entry, newprot);
+		BUG_ON(pmd_write(entry));
 		set_pmd_at(mm, addr, pmd, entry);
 		spin_unlock(&vma->vm_mm->page_table_lock);
 		ret = 1;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
linux-next.patch
x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions.patch

