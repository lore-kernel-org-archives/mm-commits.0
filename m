From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-hugetlb-introduce-pagehugeactive-flag-fix-fix.patch removed from -mm
 tree
Date: Wed, 15 Apr 2015 15:39:57 -0700
Message-ID: <552ee8bd.ry6Uzby5xVssFfHk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51890 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014AbbDOWj6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 18:39:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: set_page_huge_active() can be static
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-introduce-pagehugeactive-flag-fix-fix.patch

This patch was dropped because it was folded into mm-hugetlb-introduce-pagehugeactive-flag.patch

------------------------------------------------------
From: kbuild test robot <fengguang.wu@intel.com>
Subject: set_page_huge_active() can be static

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-introduce-pagehugeactive-flag-fix-fix mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-introduce-pagehugeactive-flag-fix-fix
+++ a/mm/hugetlb.c
@@ -937,13 +937,13 @@ bool page_huge_active(struct page *page)
 }
 
 /* never called for tail page */
-void set_page_huge_active(struct page *page)
+static void set_page_huge_active(struct page *page)
 {
 	VM_BUG_ON_PAGE(!PageHeadHuge(page), page);
 	SetPagePrivate(&page[1]);
 }
 
-void clear_page_huge_active(struct page *page)
+static void clear_page_huge_active(struct page *page)
 {
 	VM_BUG_ON_PAGE(!PageHeadHuge(page), page);
 	ClearPagePrivate(&page[1]);
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
mm-hugetlb-introduce-pagehugeactive-flag.patch

