From: akpm@linux-foundation.org
Subject: [merged]
 mm-balloon_compaction-fix-deflation-when-compaction-is-disabled.patch
 removed from -mm tree
Date: Thu, 30 Oct 2014 13:28:07 -0700
Message-ID: <54529f57.ieXgiQzDqewmjLO2%akpm__19742.1511788436$1414700942$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40550 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161212AbaJ3U2G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Oct 2014 16:28:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.khlebnikov@samsung.com, mmullins@mmlx.us, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/balloon_compaction: fix deflation when compaction is disabled
has been removed from the -mm tree.  Its filename was
     mm-balloon_compaction-fix-deflation-when-compaction-is-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Subject: mm/balloon_compaction: fix deflation when compaction is disabled

If CONFIG_BALLOON_COMPACTION=n balloon_page_insert() does not link pages
with balloon and doesn't set PagePrivate flag, as a result
balloon_page_dequeue() cannot get any pages because it thinks that all of
them are isolated.  Without balloon compaction nobody can isolate
ballooned pages.  It's safe to remove this check.

Fixes: d6d86c0a7f8ddc ("mm/balloon_compaction: redesign ballooned pages management").
Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Reported-by: Matt Mullins <mmullins@mmlx.us>
Cc: <stable@vger.kernel.org>	[3.17]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/balloon_compaction.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/balloon_compaction.c~mm-balloon_compaction-fix-deflation-when-compaction-is-disabled mm/balloon_compaction.c
--- a/mm/balloon_compaction.c~mm-balloon_compaction-fix-deflation-when-compaction-is-disabled
+++ a/mm/balloon_compaction.c
@@ -68,11 +68,13 @@ struct page *balloon_page_dequeue(struct
 		 * to be released by the balloon driver.
 		 */
 		if (trylock_page(page)) {
+#ifdef CONFIG_BALLOON_COMPACTION
 			if (!PagePrivate(page)) {
 				/* raced with isolation */
 				unlock_page(page);
 				continue;
 			}
+#endif
 			spin_lock_irqsave(&b_dev_info->pages_lock, flags);
 			balloon_page_delete(page);
 			__count_vm_event(BALLOON_DEFLATE);
_

Patches currently in -mm which might be from k.khlebnikov@samsung.com are

origin.patch

