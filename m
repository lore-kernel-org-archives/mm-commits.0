From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix.patch removed from
 -mm tree
Date: Tue, 08 Dec 2015 12:35:18 -0800
Message-ID: <56673f06.MzxfrQeo4El2Mc6/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44904 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbbLHUfU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2015 15:35:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mgorman@techsingularity.net, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmpressure: fix scan window after SWAP_CLUSTER_MAX increase
has been removed from the -mm tree.  Its filename was
     mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix.patch

This patch was dropped because it was folded into mm-increase-swap_cluster_max-to-batch-tlb-flushes.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmpressure: fix scan window after SWAP_CLUSTER_MAX increase

mm-increase-swap_cluster_max-to-batch-tlb-flushes.patch changed
SWAP_CLUSTER_MAX from 32 pages to 256 pages, inadvertantly switching the
scan window for vmpressure detection from 2MB to 16MB.  Fix.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmpressure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmpressure.c~mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix mm/vmpressure.c
--- a/mm/vmpressure.c~mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix
+++ a/mm/vmpressure.c
@@ -38,7 +38,7 @@
  * TODO: Make the window size depend on machine size, as we do for vmstat
  * thresholds. Currently we set it to 512 pages (2MB for 4KB pages).
  */
-static const unsigned long vmpressure_win = SWAP_CLUSTER_MAX * 16;
+static const unsigned long vmpressure_win = SWAP_CLUSTER_MAX;
 
 /*
  * These thresholds are used when we account memory pressure through
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

maintainers-make-vladimir-co-maintainer-of-the-memory-controller.patch
mm-page_alloc-generalize-the-dirty-balance-reserve.patch
proc-meminfo-estimate-available-memory-more-conservatively.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes.patch

