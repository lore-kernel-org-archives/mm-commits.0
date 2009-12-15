From: akpm@linux-foundation.org
Subject: [merged] include-linux-mmh-remove-unneeded-ifdef.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:54:29 -0800
Message-ID: <200912152154.nBFLsTrv015359@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39428 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761243AbZLOVy7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:54:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shijie8@gmail.com, mm-commits@vger.kernel.org


The patch titled
     include/linux/mm.h: remove unneeded ifdef
has been removed from the -mm tree.  Its filename was
     include-linux-mmh-remove-unneeded-ifdef.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/linux/mm.h: remove unneeded ifdef
From: Huang Shijie <shijie8@gmail.com>

The check code for CONFIG_SWAP is redundant, because there is a
non-CONFIG_SWAP version for PageSwapCache() which just returns 0.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN include/linux/mm.h~include-linux-mmh-remove-unneeded-ifdef include/linux/mm.h
--- a/include/linux/mm.h~include-linux-mmh-remove-unneeded-ifdef
+++ a/include/linux/mm.h
@@ -643,12 +643,9 @@ static inline struct address_space *page
 	struct address_space *mapping = page->mapping;
 
 	VM_BUG_ON(PageSlab(page));
-#ifdef CONFIG_SWAP
 	if (unlikely(PageSwapCache(page)))
 		mapping = &swapper_space;
-	else
-#endif
-	if (unlikely((unsigned long)mapping & PAGE_MAPPING_ANON))
+	else if (unlikely((unsigned long)mapping & PAGE_MAPPING_ANON))
 		mapping = NULL;
 	return mapping;
 }
_

Patches currently in -mm which might be from shijie8@gmail.com are

origin.patch

