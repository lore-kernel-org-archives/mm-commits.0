From: akpm@linux-foundation.org
Subject: [merged]
 thp-do-not-mark-zero-page-pmd-write-protected-explicitly.patch removed from -mm tree
Date: Thu, 11 Dec 2014 10:57:23 -0800
Message-ID: <5489e913.lIcGjspYxF81eal+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45383 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794AbaLKS5Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:57:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: do not mark zero-page pmd write-protected explicitly
has been removed from the -mm tree.  Its filename was
     thp-do-not-mark-zero-page-pmd-write-protected-explicitly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: thp: do not mark zero-page pmd write-protected explicitly

Zero pages can be used only in anonymous mappings, which never have
writable vma->vm_page_prot: see protection_map in mm/mmap.c and __PX1X
definitions.

Let's drop redundant pmd_wrprotect() in set_huge_zero_page().

Signed-off-by: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/huge_memory.c~thp-do-not-mark-zero-page-pmd-write-protected-explicitly mm/huge_memory.c
--- a/mm/huge_memory.c~thp-do-not-mark-zero-page-pmd-write-protected-explicitly
+++ a/mm/huge_memory.c
@@ -784,7 +784,6 @@ static bool set_huge_zero_page(pgtable_t
 	if (!pmd_none(*pmd))
 		return false;
 	entry = mk_pmd(zero_page, vma->vm_page_prot);
-	entry = pmd_wrprotect(entry);
 	entry = pmd_mkhuge(entry);
 	pgtable_trans_huge_deposit(mm, pmd, pgtable);
 	set_pmd_at(mm, haddr, pmd, entry);
_

Patches currently in -mm which might be from kirill@shutemov.name are

origin.patch
mmfs-introduce-helpers-around-the-i_mmap_mutex.patch
mm-use-new-helper-functions-around-the-i_mmap_mutex.patch
mm-convert-i_mmap_mutex-to-rwsem.patch
mm-rmap-share-the-i_mmap_rwsem.patch
uprobes-share-the-i_mmap_rwsem.patch
mm-xip-share-the-i_mmap_rwsem.patch
mm-memory-failure-share-the-i_mmap_rwsem.patch
mm-nommu-share-the-i_mmap_rwsem.patch
mm-memoryc-share-the-i_mmap_rwsem.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch

