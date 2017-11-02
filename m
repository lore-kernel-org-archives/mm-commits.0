From: akpm@linux-foundation.org
Subject: +
 mm-compaction-remove-unneeded-pageblock_skip_persistent-checks.patch added
 to -mm tree
Date: Thu, 02 Nov 2017 13:40:23 -0700
Message-ID: <59fb82b7.twl2tKSbgQgQaALn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42992 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964781AbdKBUkk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Nov 2017 16:40:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: remove unneeded pageblock_skip_persistent() checks
has been added to the -mm tree.  Its filename is
     mm-compaction-remove-unneeded-pageblock_skip_persistent-checks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-remove-unneeded-pageblock_skip_persistent-checks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-remove-unneeded-pageblock_skip_persistent-checks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: remove unneeded pageblock_skip_persistent() checks

f3c931633a59 ("mm, compaction: persistently skip hugetlbfs pageblocks")
has introduced pageblock_skip_persistent() checks into migration and free
scanners, to make sure pageblocks that should be persistently skipped are
marked as such, regardless of the ignore_skip_hint flag.

Since the previous patch introduced a new no_set_skip_hint flag, the
ignore flag no longer prevents marking pageblocks as skipped.  Therefore
we can remove the special cases.  The relevant pageblocks will be marked
as skipped by the common logic which marks each pageblock where no page
could be isolated.  This makes the code simpler.

Link: http://lkml.kernel.org/r/20171102121706.21504-3-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff -puN mm/compaction.c~mm-compaction-remove-unneeded-pageblock_skip_persistent-checks mm/compaction.c
--- a/mm/compaction.c~mm-compaction-remove-unneeded-pageblock_skip_persistent-checks
+++ a/mm/compaction.c
@@ -476,10 +476,7 @@ static unsigned long isolate_freepages_b
 		if (PageCompound(page)) {
 			const unsigned int order = compound_order(page);
 
-			if (pageblock_skip_persistent(page, order)) {
-				set_pageblock_skip(page);
-				blockpfn = end_pfn;
-			} else if (likely(order < MAX_ORDER)) {
+			if (likely(order < MAX_ORDER)) {
 				blockpfn += (1UL << order) - 1;
 				cursor += (1UL << order) - 1;
 			}
@@ -801,10 +798,7 @@ isolate_migratepages_block(struct compac
 		if (PageCompound(page)) {
 			const unsigned int order = compound_order(page);
 
-			if (pageblock_skip_persistent(page, order)) {
-				set_pageblock_skip(page);
-				low_pfn = end_pfn;
-			} else if (likely(order < MAX_ORDER))
+			if (likely(order < MAX_ORDER))
 				low_pfn += (1UL << order) - 1;
 			goto isolate_fail;
 		}
@@ -867,13 +861,7 @@ isolate_migratepages_block(struct compac
 			 * is safe to read and it's 0 for tail pages.
 			 */
 			if (unlikely(PageCompound(page))) {
-				const unsigned int order = compound_order(page);
