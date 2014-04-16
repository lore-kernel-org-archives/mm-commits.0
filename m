From: akpm@linux-foundation.org
Subject: + thp-close-race-between-split-and-zap-huge-pages.patch added to
 -mm tree
Date: Wed, 16 Apr 2014 13:20:02 -0700
Message-ID: <534ee5f2.6tgFtUcKPgTZc7Pb%akpm__45418.244895018$1397679621$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45791 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756499AbaDPUUD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Apr 2014 16:20:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, vbabka@suse.cz, stable@vger.kernel.org, sasha.levin@oracle.com, riel@redhat.com, mgorman@suse.de, lliubbo@gmail.com, davej@redhat.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com

Subject: + thp-close-race-between-split-and-zap-huge-pages.patch added to -mm tree
To: kirill.shutemov@linux.intel.com,aarcange@redhat.com,davej@redhat.com,lliubbo@gmail.com,mgorman@suse.de,riel@redhat.com,sasha.levin@oracle.com,stable@vger.kernel.org,vbabka@suse.cz,walken@google.com
From: akpm@linux-foundation.org
Date: Wed, 16 Apr 2014 13:20:02 -0700


The patch titled
     Subject: thp: close race between split and zap huge pages
has been added to the -mm tree.  Its filename is
     thp-close-race-between-split-and-zap-huge-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-close-race-between-split-and-zap-huge-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-close-race-between-split-and-zap-huge-pages.patch

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
Subject: thp: close race between split and zap huge pages

Sasha Levin has reported two THP BUGs[1][2].  I believe both of them have
the same root cause.  Let's look to them one by one.

The first bug[1] is "kernel BUG at mm/huge_memory.c:1829!".  It's
BUG_ON(mapcount != page_mapcount(page)) in __split_huge_page().  From my
testing I see that page_mapcount() is higher than mapcount here.

I think it happens due to race between zap_huge_pmd() and
page_check_address_pmd().  page_check_address_pmd() misses PMD which is
under zap:

	CPU0						CPU1
						zap_huge_pmd()
						  pmdp_get_and_clear()
__split_huge_page()
  anon_vma_interval_tree_foreach()
    __split_huge_page_splitting()
      page_check_address_pmd()
        mm_find_pmd()
	  /*
	   * We check if PMD present without taking ptl: no
	   * serialization against zap_huge_pmd(). We miss this PMD,
	   * it's not accounted to 'mapcount' in __split_huge_page().
	   */
	  pmd_present(pmd) == 0

  BUG_ON(mapcount != page_mapcount(page)) // CRASH!!!

						  page_remove_rmap(page)
						    atomic_add_negative(-1, &page->_mapcount)

The second bug[2] is "kernel BUG at mm/huge_memory.c:1371!".
It's VM_BUG_ON_PAGE(!PageHead(page), page) in zap_huge_pmd().

This happens in similar way:

	CPU0						CPU1
						zap_huge_pmd()
						  pmdp_get_and_clear()
						  page_remove_rmap(page)
						    atomic_add_negative(-1, &page->_mapcount)
__split_huge_page()
  anon_vma_interval_tree_foreach()
    __split_huge_page_splitting()
      page_check_address_pmd()
        mm_find_pmd()
	  pmd_present(pmd) == 0	/* The same comment as above */
  /*
   * No crash this time since we already decremented page->_mapcount in
   * zap_huge_pmd().
   */
  BUG_ON(mapcount != page_mapcount(page))

  /*
   * We split the compound page here into small pages without
   * serialization against zap_huge_pmd()
   */
  __split_huge_page_refcount()
						VM_BUG_ON_PAGE(!PageHead(page), page); // CRASH!!!

So my understanding the problem is pmd_present() check in mm_find_pmd()
without taking page table lock.

The bug was introduced by me commit with commit 117b0791ac42. Sorry for
that. :(

Let's open code mm_find_pmd() in page_check_address_pmd() and do the
check under page table lock.

Note that __page_check_address() does the same for PTE entires
if sync != 0.

I've stress tested split and zap code paths for 36+ hours by now and
don't see crashes with the patch applied. Before it took <20 min to
trigger the first bug and few hours for second one (if we ignore
first).

[1] https://lkml.kernel.org/g/<53440991.9090001@oracle.com>
[2] https://lkml.kernel.org/g/<5310C56C.60709@oracle.com>

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Bob Liu <lliubbo@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michel Lespinasse <walken@google.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>	[3.13+]

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN mm/huge_memory.c~thp-close-race-between-split-and-zap-huge-pages mm/huge_memory.c
--- a/mm/huge_memory.c~thp-close-race-between-split-and-zap-huge-pages
+++ a/mm/huge_memory.c
@@ -1536,16 +1536,23 @@ pmd_t *page_check_address_pmd(struct pag
 			      enum page_check_address_pmd_flag flag,
 			      spinlock_t **ptl)
 {
+	pgd_t *pgd;
+	pud_t *pud;
 	pmd_t *pmd;
 
 	if (address & ~HPAGE_PMD_MASK)
 		return NULL;
 
-	pmd = mm_find_pmd(mm, address);
-	if (!pmd)
+	pgd = pgd_offset(mm, address);
+	if (!pgd_present(*pgd))
 		return NULL;
+	pud = pud_offset(pgd, address);
+	if (!pud_present(*pud))
+		return NULL;
+	pmd = pmd_offset(pud, address);
+
 	*ptl = pmd_lock(mm, pmd);
-	if (pmd_none(*pmd))
+	if (!pmd_present(*pmd))
 		goto unlock;
 	if (pmd_page(*pmd) != page)
 		goto unlock;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-close-race-between-split-and-zap-huge-pages.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

