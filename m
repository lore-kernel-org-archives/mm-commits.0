From: akpm@linux-foundation.org
Subject: [merged] cma-make-putback_lru_pages-call-conditional.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:48:14 -0800
Message-ID: <20130225204814.9AB1B31C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:64026 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757981Ab3BYUsQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:48:16 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so345846vch.4
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:48:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: srinivas.pandruvada@linux.intel.com, b.zolnierkie@samsung.com, m.szyprowski@samsung.com, mina86@mina86.com, mm-commits@vger.kernel.org


The patch titled
     Subject: CMA: make putback_lru_pages() call conditional
has been removed from the -mm tree.  Its filename was
     cma-make-putback_lru_pages-call-conditional.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Subject: CMA: make putback_lru_pages() call conditional

As per documentation and other places calling putback_lru_pages(),
putback_lru_pages() is called on error only.  Make the CMA code behave
consistently.

[akpm@linux-foundation.org: remove a test-n-branch in the wrapup code]
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~cma-make-putback_lru_pages-call-conditional mm/page_alloc.c
--- a/mm/page_alloc.c~cma-make-putback_lru_pages-call-conditional
+++ a/mm/page_alloc.c
@@ -5806,9 +5806,11 @@ static int __alloc_contig_migrate_range(
 				    0, false, MIGRATE_SYNC,
 				    MR_CMA);
 	}
