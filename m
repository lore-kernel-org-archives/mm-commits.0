From: akpm@linux-foundation.org
Subject: + mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix.patch
 added to -mm tree
Date: Mon, 19 Oct 2015 14:08:53 -0700
Message-ID: <56255be5.EJ9q0839kYWxyTYi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45834 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbbJSVIy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Oct 2015 17:08:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mgorman@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmpressure: fix scan window after SWAP_CLUSTER_MAX increase
has been added to the -mm tree.  Its filename is
     mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmpressure: fix scan window after SWAP_CLUSTER_MAX increase

mm-increase-swap_cluster_max-to-batch-tlb-flushes.patch changed
SWAP_CLUSTER_MAX from 32 pages to 256 pages, inadvertantly switching the
scan window for vmpressure detection from 2MB to 16MB.  Fix.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
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

mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix.patch

