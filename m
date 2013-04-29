From: akpm@linux-foundation.org
Subject: [folded-merged] mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim-fix.patch removed from -mm tree
Date: Mon, 29 Apr 2013 14:55:01 -0700
Message-ID: <20130429215501.E59265A426B@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:59889 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759321Ab3D2VzC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 17:55:02 -0400
Received: by mail-qa0-f73.google.com with SMTP id p6so242114qad.0
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 14:55:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shli@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim-fix
has been removed from the -mm tree.  Its filename was
     mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim-fix.patch

This patch was dropped because it was folded into mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim.patch

------------------------------------------------------
From: Shaohua Li <shli@kernel.org>
Subject: mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim-fix

document split_huge_page_to_list

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN mm/huge_memory.c~mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim-fix mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim-fix
+++ a/mm/huge_memory.c
@@ -1800,6 +1800,13 @@ static void __split_huge_page(struct pag
 	BUG_ON(mapcount != mapcount2);
 }
 
+/*
+ * Split a hugepage into normal pages. This doesn't change the position of head
+ * page. If @list is null, tail pages will be added to LRU list, otherwise, to
+ * @list. Both head page and tail pages will inherit mapping, flags, and so on
+ * from the hugepage.
+ * Return 0 if the hugepage is split successfully otherwise return 1.
+ */
 int split_huge_page_to_list(struct page *page, struct list_head *list)
 {
 	struct anon_vma *anon_vma;
_

Patches currently in -mm which might be from shli@kernel.org are

mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim.patch
mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim-fix-fix.patch

