From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-compaction-enhance-compaction-finish-condition-fix.patch removed from
 -mm tree
Date: Tue, 14 Apr 2015 15:13:52 -0700
Message-ID: <552d9120.wKL8LTthGZj5qVHM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54286 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141AbbDNWNx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Apr 2015 18:13:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, mgorman@suse.de, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-enhance-compaction-finish-condition-fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-enhance-compaction-finish-condition-fix.patch

This patch was dropped because it was folded into mm-compaction-enhance-compaction-finish-condition.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-compaction-enhance-compaction-finish-condition-fix

fix CONFIG_CMA=n build

Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-compaction-enhance-compaction-finish-condition-fix mm/compaction.c
--- a/mm/compaction.c~mm-compaction-enhance-compaction-finish-condition-fix
+++ a/mm/compaction.c
@@ -1180,11 +1180,12 @@ static int __compact_finished(struct zon
 		if (!list_empty(&area->free_list[migratetype]))
 			return COMPACT_PARTIAL;
 
+#ifdef CONFIG_CMA
 		/* MIGRATE_MOVABLE can fallback on MIGRATE_CMA */
 		if (migratetype == MIGRATE_MOVABLE &&
 			!list_empty(&area->free_list[MIGRATE_CMA]))
 			return COMPACT_PARTIAL;
