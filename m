From: akpm@linux-foundation.org
Subject: +
 mm-compaction-dont-isolate-pagewriteback-pages-in-migrate_sync_light-mode.patch added to -mm tree
Date: Thu, 21 Jul 2016 12:26:28 -0700
Message-ID: <579121e4.K7chcXx7RLWYHdWh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51995 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbcGUT03 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jul 2016 15:26:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, mgorman@techsingularity.net, mhocko@suse.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: don't isolate PageWriteback pages in MIGRATE_SYNC_LIGHT mode
has been added to the -mm tree.  Its filename is
     mm-compaction-dont-isolate-pagewriteback-pages-in-migrate_sync_light-mode.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-dont-isolate-pagewriteback-pages-in-migrate_sync_light-mode.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-dont-isolate-pagewriteback-pages-in-migrate_sync_light-mode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm, compaction: don't isolate PageWriteback pages in MIGRATE_SYNC_LIGHT mode

At present MIGRATE_SYNC_LIGHT is allowing __isolate_lru_page() to isolate
a PageWriteback page, which __unmap_and_move() then rejects with -EBUSY:
of course the writeback might complete in between, but that's not what we
usually expect, so probably better not to isolate it.

When tested by stress-highalloc from mmtests, this has reduced the number
of page migrate failures by 60-70%.

Link: http://lkml.kernel.org/r/20160721073614.24395-2-vbabka@suse.cz
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-compaction-dont-isolate-pagewriteback-pages-in-migrate_sync_light-mode mm/compaction.c
--- a/mm/compaction.c~mm-compaction-dont-isolate-pagewriteback-pages-in-migrate_sync_light-mode
+++ a/mm/compaction.c
@@ -1200,7 +1200,7 @@ static isolate_migrate_t isolate_migrate
 	struct page *page;
 	const isolate_mode_t isolate_mode =
 		(sysctl_compact_unevictable_allowed ? ISOLATE_UNEVICTABLE : 0) |
-		(cc->mode == MIGRATE_ASYNC ? ISOLATE_ASYNC_MIGRATE : 0);
+		(cc->mode != MIGRATE_SYNC ? ISOLATE_ASYNC_MIGRATE : 0);
 
 	/*
 	 * Start at where we last stopped, or beginning of the zone as
_

Patches currently in -mm which might be from hughd@google.com are

shmem-get_unmapped_area-align-huge-page.patch
mm-compaction-dont-isolate-pagewriteback-pages-in-migrate_sync_light-mode.patch

