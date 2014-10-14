From: akpm@linux-foundation.org
Subject: +
 mm-compaction-avoid-premature-range-skip-in-isolate_migratepages_range.patch added to -mm tree
Date: Tue, 14 Oct 2014 13:53:44 -0700
Message-ID: <543d8d58.g9K7YpzF5ZOXeQqj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45542 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaJNUxp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 16:53:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction.c: avoid premature range skip in isolate_migratepages_range
has been added to the -mm tree.  Its filename is
     mm-compaction-avoid-premature-range-skip-in-isolate_migratepages_range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-avoid-premature-range-skip-in-isolate_migratepages_range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-avoid-premature-range-skip-in-isolate_migratepages_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/compaction.c: avoid premature range skip in isolate_migratepages_range

commit edc2ca612496 ("mm, compaction: move pageblock checks up from
isolate_migratepages_range()") commonizes isolate_migratepages variants
and make them use isolate_migratepages_block().

isolate_migratepages_block() could stop the execution when enough pages
are isolated, but, there is no code in isolate_migratepages_range() to
handle this case.  In the result, even if isolate_migratepages_block()
returns prematurely without checking all pages in the range,

isolate_migratepages_block() is called repeately on the following
pageblock and some pages in the previous range are skipped to check.
Then, CMA is failed frequently due to this fact.

To fix this problem, this patch let isolate_migratepages_range() know the
situation that enough pages are isolated and stop the isolation in that
case.

Note that isolate_migratepages() has no such problem, because, it always
stops the isolation after just one call of isolate_migratepages_block().

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/compaction.c~mm-compaction-avoid-premature-range-skip-in-isolate_migratepages_range mm/compaction.c
--- a/mm/compaction.c~mm-compaction-avoid-premature-range-skip-in-isolate_migratepages_range
+++ a/mm/compaction.c
@@ -784,6 +784,9 @@ isolate_migratepages_range(struct compac
 			cc->nr_migratepages = 0;
 			break;
 		}
+
+		if (cc->nr_migratepages == COMPACT_CLUSTER_MAX)
+			break;
 	}
 	acct_isolated(cc->zone, cc);
 
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-compaction-avoid-premature-range-skip-in-isolate_migratepages_range.patch
zsmalloc-merge-size_class-to-reduce-fragmentation.patch
page-owners-correct-page-order-when-to-free-page.patch

