From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-compaction-split-freepages-without-holding-the-zone-lock-fix-2.patch
 removed from -mm tree
Date: Tue, 26 Jul 2016 14:54:16 -0700
Message-ID: <5797dc08.DylHMHaWcbqpMK8w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55627 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757891AbcGZVyR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 17:54:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-split-freepages-without-holding-the-zone-lock-fix-2
has been removed from the -mm tree.  Its filename was
     mm-compaction-split-freepages-without-holding-the-zone-lock-fix-2.patch

This patch was dropped because it was folded into mm-compaction-split-freepages-without-holding-the-zone-lock.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-compaction-split-freepages-without-holding-the-zone-lock-fix-2

Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-compaction-split-freepages-without-holding-the-zone-lock-fix-2 mm/compaction.c
--- a/mm/compaction.c~mm-compaction-split-freepages-without-holding-the-zone-lock-fix-2
+++ a/mm/compaction.c
@@ -498,10 +498,14 @@ static unsigned long isolate_freepages_b
 		/* Found a free page, will break it into order-0 pages */
 		order = page_order(page);
 		isolated = __isolate_free_page(page, order);
+		if (!isolated)
+			break;
 		set_page_private(page, order);
+
 		total_isolated += isolated;
-		list_add_tail(&page->lru, freelist);
 		cc->nr_freepages += isolated;
+		list_add_tail(&page->lru, freelist);
+
 		if (!strict && cc->nr_migratepages <= cc->nr_freepages) {
 			blockpfn += isolated;
 			break;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-compaction-split-freepages-without-holding-the-zone-lock.patch
mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch
mm-add-nr_zsmalloc-to-vmstat-fix.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
mm-fix-build-warnings-in-linux-compactionh-fix.patch

