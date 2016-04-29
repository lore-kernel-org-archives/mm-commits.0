From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory-failure-fix-race-with-compound-page-split-merge.patch removed
 from -mm tree
Date: Fri, 29 Apr 2016 15:05:48 -0700
Message-ID: <5723dabc.8BjwvxFTJTrEAAhx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45460 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbcD2WFt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2016 18:05:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@yandex-team.ru, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure: fix race with compound page split/merge
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-fix-race-with-compound-page-split-merge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: mm/memory-failure: fix race with compound page split/merge

get_hwpoison_page() must recheck relation between head and tail pages.

n-horiguchi said: without this recheck, the race causes kernel to pin an
irrelevant page, and finally makes kernel crash for refcount mismatch.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN mm/memory-failure.c~mm-memory-failure-fix-race-with-compound-page-split-merge mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failure-fix-race-with-compound-page-split-merge
+++ a/mm/memory-failure.c
@@ -888,7 +888,15 @@ int get_hwpoison_page(struct page *page)
 		}
 	}
 
-	return get_page_unless_zero(head);
+	if (get_page_unless_zero(head)) {
+		if (head == compound_head(page))
+			return 1;
+
+		pr_info("MCE: %#lx cannot catch tail\n", page_to_pfn(page));
+		put_page(head);
+	}
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(get_hwpoison_page);
 
_

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are

mm-rmap-replace-bug_onanon_vma-degree-with-vm_warn_on.patch

