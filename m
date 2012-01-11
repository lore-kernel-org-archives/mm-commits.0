From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-avoid-bogus-counter-of-surplus-huge-page.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:28:38 -0800
Message-ID: <20120111212838.AC2AB1E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:48989 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933955Ab2AKV2j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:28:39 -0500
Received: by mail-gx0-f202.google.com with SMTP id k3so134376ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:28:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhillf@gmail.com, heiko.carstens@de.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: avoid bogus counter of surplus huge page
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-avoid-bogus-counter-of-surplus-huge-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hillf Danton <dhillf@gmail.com>
Subject: mm/hugetlb.c: avoid bogus counter of surplus huge page

If we have to hand back the newly allocated huge page to page allocator,
for any reason, the changed counter should be recovered.

This affects only s390 at present.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~mm-hugetlb-avoid-bogus-counter-of-surplus-huge-page mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-avoid-bogus-counter-of-surplus-huge-page
+++ a/mm/hugetlb.c
@@ -800,7 +800,7 @@ static struct page *alloc_buddy_huge_pag
 
 	if (page && arch_prepare_hugepage(page)) {
 		__free_pages(page, huge_page_order(h));
-		return NULL;
+		page = NULL;
 	}
 
 	spin_lock(&hugetlb_lock);
_

Patches currently in -mm which might be from dhillf@gmail.com are

origin.patch
linux-next.patch
mm-hugetlb-undo-change-to-page-mapcount-in-fault-handler.patch

