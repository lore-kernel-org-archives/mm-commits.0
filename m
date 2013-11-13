From: akpm@linux-foundation.org
Subject: [merged] mm-fix-page_group_by_mobility_disabled-breakage.patch
 removed from -mm tree
Date: Wed, 13 Nov 2013 12:39:16 -0800
Message-ID: <5283e374.pxMVWZE/1J7GnfId%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42778 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab3KMUjR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:39:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mgorman@suse.de, kosaki.motohiro@jp.fujitsu.com

Subject: [merged] mm-fix-page_group_by_mobility_disabled-breakage.patch removed from -mm tree
To: kosaki.motohiro@jp.fujitsu.com,mgorman@suse.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:39:16 -0800


The patch titled
     Subject: mm: fix page_group_by_mobility_disabled breakage
has been removed from the -mm tree.  Its filename was
     mm-fix-page_group_by_mobility_disabled-breakage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: mm: fix page_group_by_mobility_disabled breakage

Currently, set_pageblock_migratetype() screws up MIGRATE_CMA and
MIGRATE_ISOLATE if page_group_by_mobility_disabled is true.  It rewrites
the argument to MIGRATE_UNMOVABLE and we lost these attribute.

The problem was introduced by 49255c619f ("page allocator: move check for
disabled anti-fragmentation out of fastpath").  So a 4 year old issue may
mean that nobody uses page_group_by_mobility_disabled.

But anyway, this patch fixes the problem.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-fix-page_group_by_mobility_disabled-breakage mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-page_group_by_mobility_disabled-breakage
+++ a/mm/page_alloc.c
@@ -234,8 +234,8 @@ int page_group_by_mobility_disabled __re
 
 void set_pageblock_migratetype(struct page *page, int migratetype)
 {
