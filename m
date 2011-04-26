From: akpm@linux-foundation.org
Subject: + readahead-readahead-page-allocations-are-ok-to-fail.patch added to -mm tree
Date: Tue, 26 Apr 2011 12:49:16 -0700
Message-ID: <201104261949.p3QJnG5H014791@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46214 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756988Ab1DZTt5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Apr 2011 15:49:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, hidave.darkstar@gmail.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, penberg@kernel.org


The patch titled
     readahead: readahead page allocations are OK to fail
has been added to the -mm tree.  Its filename is
     readahead-readahead-page-allocations-are-ok-to-fail.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: readahead: readahead page allocations are OK to fail
From: Wu Fengguang <fengguang.wu@intel.com>

Pass __GFP_NORETRY|__GFP_NOWARN for readahead page allocations.

readahead page allocations are completely optional.  They are OK to fail
and in particular shall not trigger OOM on themselves.

Reported-by: Dave Young <hidave.darkstar@gmail.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    6 ++++++
 mm/readahead.c          |    2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -puN include/linux/pagemap.h~readahead-readahead-page-allocations-are-ok-to-fail include/linux/pagemap.h
--- a/include/linux/pagemap.h~readahead-readahead-page-allocations-are-ok-to-fail
+++ a/include/linux/pagemap.h
@@ -219,6 +219,12 @@ static inline struct page *page_cache_al
 	return __page_cache_alloc(mapping_gfp_mask(x)|__GFP_COLD);
 }
 
+static inline struct page *page_cache_alloc_readahead(struct address_space *x)
+{
+	return __page_cache_alloc(mapping_gfp_mask(x) |
+				  __GFP_COLD | __GFP_NORETRY | __GFP_NOWARN);
+}
+
 typedef int filler_t(void *, struct page *);
 
 extern struct page * find_get_page(struct address_space *mapping,
diff -puN mm/readahead.c~readahead-readahead-page-allocations-are-ok-to-fail mm/readahead.c
--- a/mm/readahead.c~readahead-readahead-page-allocations-are-ok-to-fail
+++ a/mm/readahead.c
@@ -180,7 +180,7 @@ __do_page_cache_readahead(struct address
 		if (page)
 			continue;
 
-		page = page_cache_alloc_cold(mapping);
+		page = page_cache_alloc_readahead(mapping);
 		if (!page)
 			break;
 		page->index = page_offset;
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

mm-per-node-vmstat-show-proper-vmstats.patch
mm-per-node-vmstat-show-proper-vmstats-fix.patch
writeback-pass-writeback_control-down-to-move_expired_inodes.patch
writeback-introduce-writeback_controlinodes_cleaned.patch
writeback-try-more-writeback-as-long-as-something-was-written.patch
writeback-the-kupdate-expire-timestamp-should-be-a-moving-target.patch
writeback-sync-expired-inodes-first-in-background-writeback.patch
writeback-sync-expired-inodes-first-in-background-writeback-fix.patch
writeback-refill-b_io-iff-empty.patch
readahead-readahead-page-allocations-are-ok-to-fail.patch

