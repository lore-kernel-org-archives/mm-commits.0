From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?mm-hugetlb-soft=5Foffline-save-compound-page-order-before-?=
 =?US-ASCII?Q?page-migration.patch?= removed from -mm tree
Date: Wed, 04 Oct 2017 12:40:07 -0700
Message-ID: <20171004194007.Vv0Oy5IFz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33280 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbdJDTkI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2017 15:40:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 00moses.alexander00@gmail.com, aarcange@redhat.com, hdanton@sina.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, rppt@linux.vnet.ibm.com, shli@fb.com, stable@vger.kernel.org


The patch titled
     Subject: mm, hugetlb, soft_offline: save compound page order before page migration
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-soft_offline-save-compound-page-order-before-page-migration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandru Moise <00moses.alexander00@gmail.com>
Subject: mm, hugetlb, soft_offline: save compound page order before page migration

This fixes a bug in madvise() where if you'd try to soft offline a
hugepage via madvise(), while walking the address range you'd end up,
using the wrong page offset due to attempting to get the compound order of
a former but presently not compound page, due to dissolving the huge page
(since c3114a8).

As a result I ended up with all my free pages except one being
offlined.

Link: http://lkml.kernel.org/r/20170912204306.GA12053@gmail.com
Fixes: c3114a84f7f9 ("mm: hugetlb: soft-offline: dissolve source hugepage after successful migration")
Signed-off-by: Alexandru Moise <00moses.alexander00@gmail.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN mm/madvise.c~mm-hugetlb-soft_offline-save-compound-page-order-before-page-migration mm/madvise.c
--- a/mm/madvise.c~mm-hugetlb-soft_offline-save-compound-page-order-before-page-migration
+++ a/mm/madvise.c
@@ -625,18 +625,26 @@ static int madvise_inject_error(int beha
 {
 	struct page *page;
 	struct zone *zone;
+	unsigned int order;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	for (; start < end; start += PAGE_SIZE <<
-				compound_order(compound_head(page))) {
+
+	for (; start < end; start += PAGE_SIZE << order) {
 		int ret;
 
 		ret = get_user_pages_fast(start, 1, 0, &page);
 		if (ret != 1)
 			return ret;
 
+		/*
+		 * When soft offlining hugepages, after migrating the page
+		 * we dissolve it, therefore in the second loop "page" will
+		 * no longer be a compound page, and order will be 0.
+		 */
+		order = compound_order(compound_head(page));
+
 		if (PageHWPoison(page)) {
 			put_page(page);
 			continue;
_

Patches currently in -mm which might be from 00moses.alexander00@gmail.com are

mm-madvise-enable-soft-offline-of-hugetlb-pages-at-pud-level.patch

