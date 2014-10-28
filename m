From: akpm@linux-foundation.org
Subject: + thp-do-not-mark-zero-page-pmd-write-protected-explicitly.patch
 added to -mm tree
Date: Tue, 28 Oct 2014 13:41:27 -0700
Message-ID: <544fff77.LrwJFaCVt5ciXX/J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32996 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919AbaJ1Ul0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Oct 2014 16:41:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: do not mark zero-page pmd write-protected explicitly
has been added to the -mm tree.  Its filename is
     thp-do-not-mark-zero-page-pmd-write-protected-explicitly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-do-not-mark-zero-page-pmd-write-protected-explicitly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-do-not-mark-zero-page-pmd-write-protected-explicitly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: do not mark zero-page pmd write-protected explicitly

Zero pages can be used only in anonymous mappings, which never have
writable vma->vm_page_prot: see protection_map in mm/mmap.c and __PX1X
definitions.

Let's drop redundant pmd_wrprotect() in set_huge_zero_page().

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/huge_memory.c~thp-do-not-mark-zero-page-pmd-write-protected-explicitly mm/huge_memory.c
--- a/mm/huge_memory.c~thp-do-not-mark-zero-page-pmd-write-protected-explicitly
+++ a/mm/huge_memory.c
@@ -789,7 +789,6 @@ static bool set_huge_zero_page(pgtable_t
 	if (!pmd_none(*pmd))
 		return false;
 	entry = mk_pmd(zero_page, vma->vm_page_prot);
-	entry = pmd_wrprotect(entry);
 	entry = pmd_mkhuge(entry);
 	pgtable_trans_huge_deposit(mm, pmd, pgtable);
 	set_pmd_at(mm, haddr, pmd, entry);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-free-compound-page-with-correct-order.patch
mm-thp-fix-collapsing-of-hugepages-on-madvise.patch
mm-verify-compound-order-when-freeing-a-page.patch
thp-do-not-mark-zero-page-pmd-write-protected-explicitly.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch

