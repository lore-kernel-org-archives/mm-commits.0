From: akpm@linux-foundation.org
Subject: + thp-move-preallocated-pte-page-table-on-move_huge_pmd.patch
 added to -mm tree
Date: Wed, 04 Dec 2013 14:20:49 -0800
Message-ID: <529faac1.MVnt3LuioIZhzBlN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35807 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756022Ab3LDWUu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Dec 2013 17:20:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, avagin@openvz.org, kirill.shutemov@linux.intel.com

Subject: + thp-move-preallocated-pte-page-table-on-move_huge_pmd.patch added to -mm tree
To: kirill.shutemov@linux.intel.com,avagin@openvz.org,n-horiguchi@ah.jp.nec.com
From: akpm@linux-foundation.org
Date: Wed, 04 Dec 2013 14:20:49 -0800


The patch titled
     Subject: thp: move preallocated PTE page table on move_huge_pmd()
has been added to the -mm tree.  Its filename is
     thp-move-preallocated-pte-page-table-on-move_huge_pmd.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-move-preallocated-pte-page-table-on-move_huge_pmd.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-move-preallocated-pte-page-table-on-move_huge_pmd.patch

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
Subject: thp: move preallocated PTE page table on move_huge_pmd()

Andrey Wagin reported crash on VM_BUG_ON() in pgtable_pmd_page_dtor() with
fallowing backtrace:

  [<ffffffff8119427f>] free_pgd_range+0x2bf/0x410
  [<ffffffff8119449e>] free_pgtables+0xce/0x120
  [<ffffffff8119b900>] unmap_region+0xe0/0x120
  [<ffffffff811a0036>] ? move_page_tables+0x526/0x6b0
  [<ffffffff8119d6a9>] do_munmap+0x249/0x360
  [<ffffffff811a0304>] move_vma+0x144/0x270
  [<ffffffff811a07e9>] SyS_mremap+0x3b9/0x510
  [<ffffffff8172d512>] system_call_fastpath+0x16/0x1b

The crash can be reproduce with this test case:

  #define _GNU_SOURCE
  #include <sys/mman.h>
  #include <stdio.h>
  #include <unistd.h>

  #define MB (1024 * 1024UL)
  #define GB (1024 * MB)

  int main(int argc, char **argv)
  {
	char *p;
	int i;

	p = mmap((void *) GB, 10 * MB, PROT_READ | PROT_WRITE,
			MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0);
	for (i = 0; i < 10 * MB; i += 4096)
		p[i] = 1;
	mremap(p, 10 * MB, 10 * MB, MREMAP_FIXED | MREMAP_MAYMOVE, 2 * GB);
	return 0;
  }

Due to split PMD lock, we now store preallocated PTE tables for THP pages
per-PMD table.  It means we need to move them to other PMD table if huge
PMD moved there.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Andrey Vagin <avagin@openvz.org>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN mm/huge_memory.c~thp-move-preallocated-pte-page-table-on-move_huge_pmd mm/huge_memory.c
--- a/mm/huge_memory.c~thp-move-preallocated-pte-page-table-on-move_huge_pmd
+++ a/mm/huge_memory.c
@@ -1481,8 +1481,18 @@ int move_huge_pmd(struct vm_area_struct
 		pmd = pmdp_get_and_clear(mm, old_addr, old_pmd);
 		VM_BUG_ON(!pmd_none(*new_pmd));
 		set_pmd_at(mm, new_addr, new_pmd, pmd_mksoft_dirty(pmd));
-		if (new_ptl != old_ptl)
+		if (new_ptl != old_ptl) {
+			pgtable_t pgtable;
+
+			/*
+			 * Move preallocated PTE page table if new_pmd is on
+			 * different PMD page table.
+			 */
+			pgtable = pgtable_trans_huge_withdraw(mm, old_pmd);
+			pgtable_trans_huge_deposit(mm, new_pmd, pgtable);
+
 			spin_unlock(new_ptl);
+		}
 		spin_unlock(old_ptl);
 	}
 out:
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-move-preallocated-pte-page-table-on-move_huge_pmd.patch
mm-create-a-separate-slab-for-page-ptl-allocation-try-two.patch
linux-next.patch

