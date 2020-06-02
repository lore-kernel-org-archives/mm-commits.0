From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory-remove-unnecessary-pte_devmap-case-in-copy_one_pte.patch removed
 from -mm tree
Date: Tue, 02 Jun 2020 14:41:13 -0700
Message-ID: <20200602214113.bEAMWCUif%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728226AbgFBVlN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:41:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chenqiwu@xiaomi.com, mhocko@suse.com, mm-commits@vger.kernel.org, willy@infradead.org


The patch titled
     Subject: mm/memory: remove unnecessary pte_devmap case in copy_one_pte()
has been removed from the -mm tree.  Its filename was
     mm-memory-remove-unnecessary-pte_devmap-case-in-copy_one_pte.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: chenqiwu <chenqiwu@xiaomi.com>
Subject: mm/memory: remove unnecessary pte_devmap case in copy_one_pte()

Since commit 25b2995a35b6 ("mm: remove MEMORY_DEVICE_PUBLIC support"), the
assignment to 'page' for pte_devmap case has been unnecessary.  Let's
remove it.

[willy@infradead.org: changelog]
Link: http://lkml.kernel.org/r/1587349685-31712-1-git-send-email-qiwuchen55@gmail.com
Signed-off-by: chenqiwu <chenqiwu@xiaomi.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/memory.c~mm-memory-remove-unnecessary-pte_devmap-case-in-copy_one_pte
+++ a/mm/memory.c
@@ -802,8 +802,6 @@ copy_one_pte(struct mm_struct *dst_mm, s
 		get_page(page);
 		page_dup_rmap(page, false);
 		rss[mm_counter(page)]++;
-	} else if (pte_devmap(pte)) {
-		page = pte_page(pte);
 	}
 
 out_set_pte:
_

Patches currently in -mm which might be from chenqiwu@xiaomi.com are

mm-memblock-fix-minor-typo-and-unclear-comment.patch
mm-replace-zero-length-array-with-flexible-array-member.patch
