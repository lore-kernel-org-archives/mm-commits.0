From: akpm@linux-foundation.org
Subject: + mm-compaction-kcompactd-should-not-ignore-pageblock-skip.patch
 added to -mm tree
Date: Thu, 17 Aug 2017 15:53:22 -0700
Message-ID: <59961e62.CKi3X9wZpXZ3u1bu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51920 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753271AbdHQWxX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Aug 2017 18:53:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mgorman@techsingularity.net, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: kcompactd should not ignore pageblock skip
has been added to the -mm tree.  Its filename is
     mm-compaction-kcompactd-should-not-ignore-pageblock-skip.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-kcompactd-should-not-ignore-pageblock-skip.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-kcompactd-should-not-ignore-pageblock-skip.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, compaction: kcompactd should not ignore pageblock skip

Kcompactd is needlessly ignoring pageblock skip information.  It is doing
MIGRATE_SYNC_LIGHT compaction, which is no more powerful than MIGRATE_SYNC
compaction.

If compaction recently failed to isolate memory from a set of pageblocks,
there is nothing to indicate that kcompactd will be able to do so, or that
it is beneficial from attempting to isolate memory.

Use the pageblock skip hint to avoid rescanning pageblocks needlessly
until that information is reset.

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1708151638550.106658@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/compaction.c~mm-compaction-kcompactd-should-not-ignore-pageblock-skip mm/compaction.c
--- a/mm/compaction.c~mm-compaction-kcompactd-should-not-ignore-pageblock-skip
+++ a/mm/compaction.c
@@ -1927,9 +1927,8 @@ static void kcompactd_do_work(pg_data_t
 		.total_free_scanned = 0,
 		.classzone_idx = pgdat->kcompactd_classzone_idx,
 		.mode = MIGRATE_SYNC_LIGHT,
-		.ignore_skip_hint = true,
+		.ignore_skip_hint = false,
 		.gfp_mask = GFP_KERNEL,
