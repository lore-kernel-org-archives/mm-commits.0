From: akpm@linux-foundation.org
Subject: [patch 06/51] mm, hugetlb, soft_offline: save compound page order before page migration
Date: Tue, 03 Oct 2017 16:14:31 -0700
Message-ID: <59d419d7.4h+Q6aDuhFNCUnQB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58370 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJCXOc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 19:14:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, 00moses.alexander00@gmail.com, aarcange@redhat.com, hdanton@sina.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, rppt@linux.vnet.ibm.com, shli@fb.com, stable@vger.kernel.org

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
