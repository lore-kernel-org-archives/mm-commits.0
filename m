From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-clear-compound_mapcount-when-freeing-gigantic-pages.patch
 removed from -mm tree
Date: Tue, 28 Jun 2016 19:02:58 -0700
Message-ID: <57732c52.O5ioZI0Ip9A/Tbnh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41787 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbcF2CK7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jun 2016 22:10:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerald.schaefer@de.ibm.com, aneesh.kumar@linux.vnet.ibm.com, dave.hansen@linux.intel.com, heiko.carstens@de.ibm.com, hillf.zj@alibaba-inc.com, kirill.shutemov@linux.intel.com, lcapitulino@redhat.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: clear compound_mapcount when freeing gigantic pages
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-clear-compound_mapcount-when-freeing-gigantic-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: mm/hugetlb: clear compound_mapcount when freeing gigantic pages

While working on s390 support for gigantic hugepages I ran into the following
"Bad page state" warning when freeing gigantic pages:

BUG: Bad page state in process bash  pfn:580001
page:000003d116000040 count:0 mapcount:0 mapping:ffffffff00000000 index:0x0
flags: 0x7fffc0000000000()
page dumped because: non-NULL mapping

This is because page->compound_mapcount, which is part of a union with
page->mapping, is initialized with -1 in prep_compound_gigantic_page(), and
not cleared again during destroy_compound_gigantic_page(). Fix this by
clearing the compound_mapcount in destroy_compound_gigantic_page() before
clearing compound_head.

Interestingly enough, the warning will not show up on x86_64, although this
should not be architecture specific. Apparently there is an endianness issue,
combined with the fact that the union contains both a 64 bit ->mapping
pointer and a 32 bit atomic_t ->compound_mapcount as members. The resulting
bogus page->mapping on x86_64 therefore contains 00000000ffffffff instead
of ffffffff00000000 on s390, which will falsely trigger the PageAnon() check
in free_pages_prepare() because page->mapping & PAGE_MAPPING_ANON is true
on little-endian architectures like x86_64 in this case (the page is not
compound anymore, ->compound_head was already cleared before). As a result,
page->mapping will be cleared before doing the checks in free_pages_check().

Not sure if the bogus "PageAnon() returning true" on x86_64 for the first
tail page of a gigantic page (at this stage) has other theoretical
implications, but they would also be fixed with this patch.

Link: http://lkml.kernel.org/r/1466612719-5642-1-git-send-email-gerald.schaefer@de.ibm.com
Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/hugetlb.c~mm-hugetlb-clear-compound_mapcount-when-freeing-gigantic-pages mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-clear-compound_mapcount-when-freeing-gigantic-pages
+++ a/mm/hugetlb.c
@@ -1030,6 +1030,7 @@ static void destroy_compound_gigantic_pa
 	int nr_pages = 1 << order;
 	struct page *p = page + 1;
 
+	atomic_set(compound_mapcount_ptr(page), 0);
 	for (i = 1; i < nr_pages; i++, p = mem_map_next(p, page, i)) {
 		clear_compound_head(p);
 		set_page_refcounted(p);
_

Patches currently in -mm which might be from gerald.schaefer@de.ibm.com are


