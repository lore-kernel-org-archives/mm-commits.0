From: akpm@linux-foundation.org
Subject: + mm-alloc_contig-re-allow-cma-to-compact-fs-pages.patch added to -mm tree
Date: Fri, 13 Jan 2017 15:06:07 -0800
Message-ID: <58795d5f.A822FPqA+E8qwmL4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49228 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751580AbdAMXGI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2017 18:06:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: l.stach@pengutronix.de, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: alloc_contig: re-allow CMA to compact FS pages
has been added to the -mm tree.  Its filename is
     mm-alloc_contig-re-allow-cma-to-compact-fs-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-alloc_contig-re-allow-cma-to-compact-fs-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-alloc_contig-re-allow-cma-to-compact-fs-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lucas Stach <l.stach@pengutronix.de>
Subject: mm: alloc_contig: re-allow CMA to compact FS pages

Commit 73e64c51afc5 (mm, compaction: allow compaction for GFP_NOFS
requests) changed compation to skip FS pages if not explicitly allowed to
touch them, but missed to update the CMA compact_control.

This leads to a very high isolation failure rate, crippling performance of
CMA even on a lightly loaded system.  Re-allow CMA to compact FS pages by
setting the correct GFP flags, restoring CMA behavior and performance to
the kernel 4.9 level.

Fixes: 73e64c51afc5 (mm, compaction: allow compaction for GFP_NOFS requests)
Link: http://lkml.kernel.org/r/20170113115155.24335-1-l.stach@pengutronix.de
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/page_alloc.c~mm-alloc_contig-re-allow-cma-to-compact-fs-pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-alloc_contig-re-allow-cma-to-compact-fs-pages
+++ a/mm/page_alloc.c
@@ -7248,6 +7248,7 @@ int alloc_contig_range(unsigned long sta
 		.zone = page_zone(pfn_to_page(start)),
 		.mode = MIGRATE_SYNC,
 		.ignore_skip_hint = true,
+		.gfp_mask = GFP_KERNEL,
 	};
 	INIT_LIST_HEAD(&cc.migratepages);
 
_

Patches currently in -mm which might be from l.stach@pengutronix.de are

mm-alloc_contig-re-allow-cma-to-compact-fs-pages.patch

