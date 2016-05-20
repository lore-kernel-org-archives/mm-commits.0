From: akpm@linux-foundation.org
Subject: [folded-merged]
 memory-failure-replace-mce-with-memory-failure-fix.patch removed from -mm
 tree
Date: Fri, 20 May 2016 16:37:29 -0700
Message-ID: <573f9fb9.yWUdZs5QNza4ULI/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51203 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbcETXha (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:37:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: slaoub@gmail.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-failure-replace-mce-with-memory-failure-fix
has been removed from the -mm tree.  Its filename was
     memory-failure-replace-mce-with-memory-failure-fix.patch

This patch was dropped because it was folded into memory-failure-replace-mce-with-memory-failure.patch

------------------------------------------------------
From: Chen Yucong <slaoub@gmail.com>
Subject: memory-failure-replace-mce-with-memory-failure-fix

Signed-off-by: Chen Yucong <slaoub@gmail.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memory-failure.c~memory-failure-replace-mce-with-memory-failure-fix mm/memory-failure.c
--- a/mm/memory-failure.c~memory-failure-replace-mce-with-memory-failure-fix
+++ a/mm/memory-failure.c
@@ -894,7 +894,8 @@ int get_hwpoison_page(struct page *page)
 		if (head == compound_head(page))
 			return 1;
 
-		pr_info("MCE: %#lx cannot catch tail\n", page_to_pfn(page));
+		pr_info("Memory failure: %#lx cannot catch tail\n",
+			page_to_pfn(page));
 		put_page(head);
 	}
 
_

Patches currently in -mm which might be from slaoub@gmail.com are

memory-failure-replace-mce-with-memory-failure.patch

