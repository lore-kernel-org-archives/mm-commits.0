From: akpm@linux-foundation.org
Subject: +
 mm-readaheadc-fix-readahead-failure-for-memoryless-numa-nodes-and-limit-readahead-pages.patch added to -mm tree
Date: Tue, 18 Feb 2014 13:17:26 -0800
Message-ID: <5303cde6.mxyqBi91sIn5itJP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50056 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbaBRVR1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Feb 2014 16:17:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, torvalds@linux-foundation.org, rientjes@google.com, jack@suse.cz, fengguang.wu@intel.com, raghavendra.kt@linux.vnet.ibm.com

Subject: + mm-readaheadc-fix-readahead-failure-for-memoryless-numa-nodes-and-limit-readahead-pages.patch added to -mm tree
To: raghavendra.kt@linux.vnet.ibm.com,fengguang.wu@intel.com,jack@suse.cz,rientjes@google.com,torvalds@linux-foundation.org
From: akpm@linux-foundation.org
Date: Tue, 18 Feb 2014 13:17:26 -0800


The patch titled
     Subject: mm/readahead.c: fix readahead failure for memoryless NUMA nodes and limit readahead pages
has been added to the -mm tree.  Its filename is
     mm-readaheadc-fix-readahead-failure-for-memoryless-numa-nodes-and-limit-readahead-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-readaheadc-fix-readahead-failure-for-memoryless-numa-nodes-and-limit-readahead-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-readaheadc-fix-readahead-failure-for-memoryless-numa-nodes-and-limit-readahead-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-readaheadc-fix-readahead-failure-for-memoryless-numa-nodes-and-limit-readahead-pages.patch
linux-next.patch

