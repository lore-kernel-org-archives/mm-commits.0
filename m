From: akpm@linux-foundation.org
Subject: [merged]
 mm-readaheadc-fix-readahead-failure-for-memoryless-numa-nodes-and-limit-readahead-pages.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:32:16 -0700
Message-ID: <533f08c0.jyuF4J5/mtGYAGZG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43140 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbaDDTcR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:32:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, torvalds@linux-foundation.org, rientjes@google.com, jack@suse.cz, fengguang.wu@intel.com, raghavendra.kt@linux.vnet.ibm.com

Subject: [merged] mm-readaheadc-fix-readahead-failure-for-memoryless-numa-nodes-and-limit-readahead-pages.patch removed from -mm tree
To: raghavendra.kt@linux.vnet.ibm.com,fengguang.wu@intel.com,jack@suse.cz,rientjes@google.com,torvalds@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:32:16 -0700


The patch titled
     Subject: mm/readahead.c: fix readahead failure for memoryless NUMA nodes and limit readahead pages
has been removed from the -mm tree.  Its filename was
     mm-readaheadc-fix-readahead-failure-for-memoryless-numa-nodes-and-limit-readahead-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Subject: mm/readahead.c: fix readahead failure for memoryless NUMA nodes and limit readahead pages

Currently max_sane_readahead() returns zero on the cpu whose NUMA node has
no local memory which leads to readahead failure.  Fix this readahead
failure by returning minimum of (requested pages, 512).  Users running
applications on a memory-less cpu which needs readahead such as streaming
application see considerable boost in the performance.

Result:

fadvise experiment with FADV_WILLNEED on a PPC machine having memoryless
CPU with 1GB testfile (12 iterations) yielded around 46.66% improvement.

fadvise experiment with FADV_WILLNEED on a x240 machine with 1GB testfile
32GB* 4G RAM numa machine (12 iterations) showed no impact on the normal
NUMA cases w/ patch.

Kernel     Avg  Stddev
base	7.4975	3.92%
patched	7.4174  3.26%

[Andrew: making return value PAGE_SIZE independent]
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Acked-by: Jan Kara <jack@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/readahead.c~mm-readaheadc-fix-readahead-failure-for-memoryless-numa-nodes-and-limit-readahead-pages mm/readahead.c
--- a/mm/readahead.c~mm-readaheadc-fix-readahead-failure-for-memoryless-numa-nodes-and-limit-readahead-pages
+++ a/mm/readahead.c
@@ -233,14 +233,14 @@ int force_page_cache_readahead(struct ad
 	return 0;
 }
 
+#define MAX_READAHEAD   ((512*4096)/PAGE_CACHE_SIZE)
 /*
  * Given a desired number of PAGE_CACHE_SIZE readahead pages, return a
  * sensible upper limit.
  */
 unsigned long max_sane_readahead(unsigned long nr)
 {
-	return min(nr, (node_page_state(numa_node_id(), NR_INACTIVE_FILE)
-		+ node_page_state(numa_node_id(), NR_FREE_PAGES)) / 2);
+	return min(nr, MAX_READAHEAD);
 }
 
 /*
_

Patches currently in -mm which might be from raghavendra.kt@linux.vnet.ibm.com are

origin.patch

