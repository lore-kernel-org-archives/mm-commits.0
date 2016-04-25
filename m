From: akpm@linux-foundation.org
Subject: +
 compaction-wrap-calculating-first-and-last-pfn-of-pageblock-fix.patch added to -mm tree
Date: Mon, 25 Apr 2016 13:09:17 -0700
Message-ID: <571e796d.l8H2ShO5QzUThICS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55212 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933368AbcDYUJS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Apr 2016 16:09:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: fix crash in get_pfnblock_flags_mask() from isolate_freepages():
has been added to the -mm tree.  Its filename is
     compaction-wrap-calculating-first-and-last-pfn-of-pageblock-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/compaction-wrap-calculating-first-and-last-pfn-of-pageblock-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/compaction-wrap-calculating-first-and-last-pfn-of-pageblock-fix.patch

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
Subject: mm, compaction: fix crash in get_pfnblock_flags_mask() from isolate_freepages():

In isolate_freepages(), low_pfn was mistakenly initialized to
pageblock_start_pfn() instead of pageblock_end_pfn(), creating a possible
underflow, as described by Hugh:

   There's a case when that "block_start_pfn -= pageblock_nr_pages" loop can
   pass through 0 and end up trying to access a pageblock before the start of
   the mem_map[].

Fixes: mmotm mm-compaction-wrap-calculating-first-and-last-pfn-of-pageblock.patch
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/compaction.c~compaction-wrap-calculating-first-and-last-pfn-of-pageblock-fix mm/compaction.c
--- a/mm/compaction.c~compaction-wrap-calculating-first-and-last-pfn-of-pageblock-fix
+++ a/mm/compaction.c
@@ -932,7 +932,7 @@ static void isolate_freepages(struct com
 	block_start_pfn = pageblock_start_pfn(cc->free_pfn);
 	block_end_pfn = min(block_start_pfn + pageblock_nr_pages,
 						zone_end_pfn(zone));
-	low_pfn = pageblock_start_pfn(cc->migrate_pfn);
+	low_pfn = pageblock_end_pfn(cc->migrate_pfn);
 
 	/*
 	 * Isolate free pages until enough are available to migrate the
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-wake-kcompactd-before-kswapds-short-sleep.patch
mm-compaction-wrap-calculating-first-and-last-pfn-of-pageblock.patch
compaction-wrap-calculating-first-and-last-pfn-of-pageblock-fix.patch
mm-compaction-reduce-spurious-pcplist-drains.patch
mm-compaction-skip-blocks-where-isolation-fails-in-async-direct-compaction.patch
cpuset-use-static-key-better-and-convert-to-new-api.patch

