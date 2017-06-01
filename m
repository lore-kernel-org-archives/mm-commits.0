From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-return-immediately-for-hugetlb-page-in-__delete_from_page_cache.patch added to -mm tree
Date: Thu, 01 Jun 2017 15:37:59 -0700
Message-ID: <59309747.rpWSiJimYyxTniWC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41622 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751078AbdFAWiA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2017 18:38:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aneesh.kumar@linux.vnet.ibm.com, khandual@linux.vnet.ibm.com, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: return immediately for hugetlb page in __delete_from_page_cache()
has been added to the -mm tree.  Its filename is
     mm-hugetlb-return-immediately-for-hugetlb-page-in-__delete_from_page_cache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-return-immediately-for-hugetlb-page-in-__delete_from_page_cache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-return-immediately-for-hugetlb-page-in-__delete_from_page_cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: hugetlb: return immediately for hugetlb page in __delete_from_page_cache()

We avoid calling __mod_node_page_state(NR_FILE_PAGES) for hugetlb page
now, but it's not enough because later code doesn't handle hugetlb
properly.  Actually in our testing, WARN_ON_ONCE(PageDirty(page)) at the
end of this function fires for hugetlb, which makes no sense.  So we
should return immediately for hugetlb pages.

Link: http://lkml.kernel.org/r/1496305019-5493-3-git-send-email-n-horiguchi@ah.jp.nec.com
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN mm/filemap.c~mm-hugetlb-return-immediately-for-hugetlb-page-in-__delete_from_page_cache mm/filemap.c
--- a/mm/filemap.c~mm-hugetlb-return-immediately-for-hugetlb-page-in-__delete_from_page_cache
+++ a/mm/filemap.c
@@ -239,14 +239,16 @@ void __delete_from_page_cache(struct pag
 	/* Leave page->index set: truncation lookup relies upon it */
 
 	/* hugetlb pages do not participate in page cache accounting. */
-	if (!PageHuge(page))
-		__mod_node_page_state(page_pgdat(page), NR_FILE_PAGES, -nr);
+	if (PageHuge(page))
+		return;
+
+	__mod_node_page_state(page_pgdat(page), NR_FILE_PAGES, -nr);
 	if (PageSwapBacked(page)) {
 		__mod_node_page_state(page_pgdat(page), NR_SHMEM, -nr);
 		if (PageTransHuge(page))
 			__dec_node_page_state(page, NR_SHMEM_THPS);
 	} else {
-		VM_BUG_ON_PAGE(PageTransHuge(page) && !PageHuge(page), page);
+		VM_BUG_ON_PAGE(PageTransHuge(page), page);
 	}
 
 	/*
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-drop-null-return-check-of-pte_offset_map_lock.patch
mm-hugetlb-prevent-reuse-of-hwpoisoned-free-hugepages.patch
mm-hugetlb-return-immediately-for-hugetlb-page-in-__delete_from_page_cache.patch
mm-hwpoison-change-pagehwpoison-behavior-on-hugetlb-pages.patch
mm-soft-offline-dissolve-free-hugepage-if-soft-offlined.patch
mm-hwpoison-introduce-memory_failure_hugetlb.patch
mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error.patch
mm-hugetlb-delete-dequeue_hwpoisoned_huge_page.patch
mm-hwpoison-introduce-idenfity_page_state.patch

