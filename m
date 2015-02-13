From: akpm@linux-foundation.org
Subject: [merged] mm-fix-negative-nr_isolated-counts.patch removed from
 -mm tree
Date: Fri, 13 Feb 2015 12:21:09 -0800
Message-ID: <54de5cb5.vXLKYTncB5KW6EmA%akpm__22682.1365686648$1423858877$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48941 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbbBMUVK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:21:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, iamjoonsoo.kim@lge.com, stable@vger.kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix negative nr_isolated counts
has been removed from the -mm tree.  Its filename was
     mm-fix-negative-nr_isolated-counts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: fix negative nr_isolated counts

The vmstat interfaces are good at hiding negative counts (at least when
CONFIG_SMP); but if you peer behind the curtain, you find that
nr_isolated_anon and nr_isolated_file soon go negative, and grow ever more
negative: so they can absorb larger and larger numbers of isolated pages,
yet still appear to be zero.

I'm happy to avoid a congestion_wait() when too_many_isolated() myself;
but I guess it's there for a good reason, in which case we ought to get
too_many_isolated() working again.

The imbalance comes from isolate_migratepages()'s ISOLATE_ABORT case:
putback_movable_pages() decrements the NR_ISOLATED counts, but we forgot
to call acct_isolated() to increment them.

It is possible that the bug whcih this patch fixes could cause OOM kills
when the system still has a lot of reclaimable page cache.

Fixes: edc2ca612496 ("mm, compaction: move pageblock checks up from isolate_migratepages_range()")
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <stable@vger.kernel.org>	[3.18+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-fix-negative-nr_isolated-counts mm/compaction.c
--- a/mm/compaction.c~mm-fix-negative-nr_isolated-counts
+++ a/mm/compaction.c
@@ -1103,8 +1103,10 @@ static isolate_migrate_t isolate_migrate
 		low_pfn = isolate_migratepages_block(cc, low_pfn, end_pfn,
 								isolate_mode);
 
-		if (!low_pfn || cc->contended)
+		if (!low_pfn || cc->contended) {
+			acct_isolated(zone, cc);
 			return ISOLATE_ABORT;
+		}
 
 		/*
 		 * Either we isolated something and proceed with migration. Or
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch

