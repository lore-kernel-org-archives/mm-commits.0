From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-readaheadc-fix-readahead-fail-for-no-local-memory-and-limit-readahead-pages.patch removed from -mm tree
Date: Tue, 18 Feb 2014 13:14:25 -0800
Message-ID: <5303cd31.7+9RvrBRLryJ7LkY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50041 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbaBRVO1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Feb 2014 16:14:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, jack@suse.cz, fengguang.wu@intel.com, raghavendra.kt@linux.vnet.ibm.com

Subject: [to-be-updated] mm-readaheadc-fix-readahead-fail-for-no-local-memory-and-limit-readahead-pages.patch removed from -mm tree
To: raghavendra.kt@linux.vnet.ibm.com,fengguang.wu@intel.com,jack@suse.cz,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 18 Feb 2014 13:14:25 -0800


The patch titled
     Subject: mm/readahead.c: fix readahead fail for no local memory and limit readahead pages
has been removed from the -mm tree.  Its filename was
     mm-readaheadc-fix-readahead-fail-for-no-local-memory-and-limit-readahead-pages.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Subject: mm/readahead.c: fix readahead fail for no local memory and limit readahead pages

max_sane_readahead() returns zero on the cpu having no local memory node. 
Fix that by returning a sanitized number of pages viz., minimum of
(requested pages, 4k)

Result:
fadvise experiment with FADV_WILLNEED on a x240 machine with 1GB testfile
32GB* 4G RAM  numa machine ( 12 iterations) yielded

Kernel     Avg      Stddev
base      7.2963    1.10 %
patched   7.2972    1.18 %

Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff -puN mm/readahead.c~mm-readaheadc-fix-readahead-fail-for-no-local-memory-and-limit-readahead-pages mm/readahead.c
--- a/mm/readahead.c~mm-readaheadc-fix-readahead-fail-for-no-local-memory-and-limit-readahead-pages
+++ a/mm/readahead.c
@@ -233,14 +233,32 @@ int force_page_cache_readahead(struct ad
 	return 0;
 }
 
+#define MAX_REMOTE_READAHEAD   4096UL
 /*
  * Given a desired number of PAGE_CACHE_SIZE readahead pages, return a
  * sensible upper limit.
  */
 unsigned long max_sane_readahead(unsigned long nr)
 {
-	return min(nr, (node_page_state(numa_node_id(), NR_INACTIVE_FILE)
-		+ node_page_state(numa_node_id(), NR_FREE_PAGES)) / 2);
+	unsigned long local_free_page;
+	int nid;
+
+	nid = numa_node_id();
+	if (node_present_pages(nid)) {
+		/*
+		 * We sanitize readahead size depending on free memory in
+		 * the local node.
+		 */
+		local_free_page = node_page_state(nid, NR_INACTIVE_FILE)
+				 + node_page_state(nid, NR_FREE_PAGES);
+		return min(nr, local_free_page / 2);
+	}
+	/*
+	 * Readahead onto remote memory is better than no readahead when local
+	 * numa node does not have memory. We limit the readahead to 4k
+	 * pages though to avoid trashing page cache.
+	 */
+	return min(nr, MAX_REMOTE_READAHEAD);
 }
 
 /*
_

Patches currently in -mm which might be from raghavendra.kt@linux.vnet.ibm.com are

mm-readahead-fix-readahead-fail-for-memoryless-cpu-and-limit-readahead-pages.patch
linux-next.patch

