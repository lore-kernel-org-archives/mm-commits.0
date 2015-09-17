From: akpm@linux-foundation.org
Subject: +
 mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch added to
 -mm tree
Date: Thu, 17 Sep 2015 13:08:06 -0700
Message-ID: <55fb1da6.IMocgQL4iGbtUhsr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42355 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbbIQUIH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Sep 2015 16:08:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, ebru.akagunduz@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: khugepaged: __collapse_huge_page_swapin(): drop unused 'pte' parameter
has been added to the -mm tree.  Its filename is
     mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch

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
Subject: khugepaged: __collapse_huge_page_swapin(): drop unused 'pte' parameter

'pte' dereference is eliminated by compiler, since nobody uses the
pteval until it's overwritten inside the loop.

Value of 'pte' itself is overwritten by pte_offset_map() before first
real use.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/huge_memory.c~mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2 mm/huge_memory.c
--- a/mm/huge_memory.c~mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2
+++ a/mm/huge_memory.c
@@ -2594,11 +2594,10 @@ static bool hugepage_vma_check(struct vm
 
 static void __collapse_huge_page_swapin(struct mm_struct *mm,
 					struct vm_area_struct *vma,
-					unsigned long address, pmd_t *pmd,
-					pte_t *pte)
+					unsigned long address, pmd_t *pmd)
 {
 	unsigned long _address;
-	pte_t pteval = *pte;
+	pte_t *pte, pteval;
 	int swapped_in = 0, ret = 0;
 
 	pte = pte_offset_map(pmd, address);
@@ -2694,7 +2693,7 @@ static void collapse_huge_page(struct mm
 
 	anon_vma_lock_write(vma->anon_vma);
 
-	__collapse_huge_page_swapin(mm, vma, address, pmd, pte);
+	__collapse_huge_page_swapin(mm, vma, address, pmd);
 
 	pte = pte_offset_map(pmd, address);
 	pte_ptl = pte_lockptr(mm, pmd);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-dax-vma-with-vm_ops-pfn_mkwrite-wants-to-be-write-notified.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-drop-page-slab_page.patch
slab-slub-use-page-rcu_head-instead-of-page-lru-plus-cast.patch
zsmalloc-use-page-private-instead-of-page-first_page.patch
mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page.patch
mm-make-compound_head-robust.patch
mm-use-unsigned-int-for-page-order.patch
mm-use-unsigned-int-for-compound_dtor-compound_order-on-64bit.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-support-madvisemadv_free-fix-3.patch

