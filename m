From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-initialize-pg_reserved-for-tail-pages-of-gigantig-compound-pages.patch added to -mm tree
Date: Thu, 10 Oct 2013 14:26:47 -0700
Message-ID: <52571b97./aTzlJdJUdHXxmwh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38302 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757574Ab3JJV0s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Oct 2013 17:26:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mgorman@suse.de, hughd@google.com, gleb@redhat.com, ajs124.ajs124@gmail.com, aarcange@redhat.com

Subject: + mm-hugetlb-initialize-pg_reserved-for-tail-pages-of-gigantig-compound-pages.patch added to -mm tree
To: aarcange@redhat.com,ajs124.ajs124@gmail.com,gleb@redhat.com,hughd@google.com,mgorman@suse.de,riel@redhat.com
From: akpm@linux-foundation.org
Date: Thu, 10 Oct 2013 14:26:47 -0700


The patch titled
     Subject: mm: hugetlb: initialize PG_reserved for tail pages of gigantig compound pages
has been added to the -mm tree.  Its filename is
     mm-hugetlb-initialize-pg_reserved-for-tail-pages-of-gigantig-compound-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-initialize-pg_reserved-for-tail-pages-of-gigantig-compound-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-initialize-pg_reserved-for-tail-pages-of-gigantig-compound-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm: hugetlb: initialize PG_reserved for tail pages of gigantig compound pages

11feeb498086 ("kvm: optimize away THP checks in kvm_is_mmio_pfn()")
introduced a memory leak when KVM is run on gigantic compound pages.

11feeb498086 depends on the assumption that PG_reserved is identical for
all head and tail pages of a compound page.  So that if get_user_pages
returns a tail page, we don't need to check the head page in order to know
if we deal with a reserved page that requires different refcounting.

The assumption that PG_reserved is the same for head and tail pages is
certainly correct for THP and regular hugepages, but gigantic hugepages
allocated through bootmem don't clear the PG_reserved on the tail pages
(the clearing of PG_reserved is done later only if the gigantic hugepage
is freed).

This patch corrects the gigantic compound page initialization so that we
can retain the optimization in 11feeb498086.  The cacheline was already
modified in order to set PG_tail so this won't affect the boot time of
large memory systems.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: andy123 <ajs124.ajs124@gmail.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~mm-hugetlb-initialize-pg_reserved-for-tail-pages-of-gigantig-compound-pages mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-initialize-pg_reserved-for-tail-pages-of-gigantig-compound-pages
+++ a/mm/hugetlb.c
@@ -696,8 +696,24 @@ static void prep_compound_gigantic_page(
 	/* we rely on prep_new_huge_page to set the destructor */
 	set_compound_order(page, order);
 	__SetPageHead(page);
+	__ClearPageReserved(page);
 	for (i = 1; i < nr_pages; i++, p = mem_map_next(p, page, i)) {
 		__SetPageTail(p);
+		/*
+		 * For gigantic hugepages allocated through bootmem at
+		 * boot, it's safer to be consistent with the
+		 * not-gigantic hugepages and to clear the PG_reserved
+		 * bit from all tail pages too. Otherwse drivers using
+		 * get_user_pages() to access tail pages, may get the
+		 * reference counting wrong if they see the
+		 * PG_reserved bitflag set on a tail page (despite the
+		 * head page didn't have PG_reserved set). Enforcing
+		 * this consistency between head and tail pages,
+		 * allows drivers to optimize away a check on the head
+		 * page when they need know if put_page is needed after
+		 * get_user_pages() or not.
+		 */
+		__ClearPageReserved(p);
 		set_page_count(p, 0);
 		p->first_page = page;
 	}
@@ -1330,9 +1346,9 @@ static void __init gather_bootmem_preall
 #else
 		page = virt_to_page(m);
 #endif
-		__ClearPageReserved(page);
 		WARN_ON(page_count(page) != 1);
 		prep_compound_huge_page(page, h->order);
+		WARN_ON(PageReserved(page));
 		prep_new_huge_page(h, page, page_to_nid(page));
 		/*
 		 * If we had gigantic hugepages allocated at boot time, we need
_

Patches currently in -mm which might be from aarcange@redhat.com are

mm-hugetlb-initialize-pg_reserved-for-tail-pages-of-gigantig-compound-pages.patch
mm-hugetlb-initialize-pg_reserved-for-tail-pages-of-gigantig-compound-pages-fix.patch
mm-thp-cleanup-mv-alloc_hugepage-to-better-place.patch
mm-thp-khugepaged-add-policy-for-finding-target-node.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
mm-avoid-increase-sizeofstruct-page-due-to-split-page-table-lock.patch
mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks.patch
mm-convert-mm-nr_ptes-to-atomic_long_t.patch
mm-introduce-api-for-split-page-table-lock-for-pmd-level.patch
mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock.patch
mm-thp-move-ptl-taking-inside-page_check_address_pmd.patch
mm-thp-do-not-access-mm-pmd_huge_pte-directly.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch
mm-convert-the-rest-to-new-page-table-lock-api.patch
mm-implement-split-page-table-lock-for-pmd-level.patch
x86-mm-enable-split-page-table-lock-for-pmd-level.patch

