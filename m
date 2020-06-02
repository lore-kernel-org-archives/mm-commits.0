From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 087/128] mm/memory: remove unnecessary pte_devmap
 case in copy_one_pte()
Date: Mon, 01 Jun 2020 21:50:08 -0700
Message-ID: <20200602045008.40kMct10z%akpm@linux-foundation.org>
References: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbgFBEuJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 00:50:09 -0400
In-Reply-To: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chenqiwu@xiaomi.com, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, willy@infradead.org

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
