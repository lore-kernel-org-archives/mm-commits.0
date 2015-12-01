From: akpm@linux-foundation.org
Subject: +
 proc-meminfo-estimate-available-memory-more-conservatively.patch added to
 -mm tree
Date: Mon, 30 Nov 2015 16:42:03 -0800
Message-ID: <565cecdb.gKx8CrDfF4qlic1x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37448 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314AbbLAAmE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Nov 2015 19:42:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mgorman@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: meminfo: estimate available memory more conservatively
has been added to the -mm tree.  Its filename is
     proc-meminfo-estimate-available-memory-more-conservatively.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-meminfo-estimate-available-memory-more-conservatively.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-meminfo-estimate-available-memory-more-conservatively.patch

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
Subject: proc: meminfo: estimate available memory more conservatively

The MemAvailable item in /proc/meminfo is to give users a hint of how much
memory is allocatable without causing swapping, so it excludes the zones'
low watermarks as unavailable to userspace.

However, for a userspace allocation, kswapd will actually reclaim until
the free pages hit a combination of the high watermark and the page
allocator's lowmem protection that keeps a certain amount of DMA and DMA32
memory from userspace as well.

Subtract the full amount we know to be unavailable to userspace from the
number of free pages when calculating MemAvailable.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/meminfo.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN fs/proc/meminfo.c~proc-meminfo-estimate-available-memory-more-conservatively fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~proc-meminfo-estimate-available-memory-more-conservatively
+++ a/fs/proc/meminfo.c
@@ -57,11 +57,8 @@ static int meminfo_proc_show(struct seq_
 	/*
 	 * Estimate the amount of memory available for userspace allocations,
 	 * without causing swapping.
-	 *
-	 * Free memory cannot be taken below the low watermark, before the
-	 * system starts swapping.
 	 */
-	available = i.freeram - wmark_low;
+	available = i.freeram - totalreserve_pages;
 
 	/*
 	 * Not all the page cache can be freed, otherwise the system will
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

maintainers-make-vladimir-co-maintainer-of-the-memory-controller.patch
mm-page_alloc-generalize-the-dirty-balance-reserve.patch
proc-meminfo-estimate-available-memory-more-conservatively.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix.patch

