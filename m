From: akpm@linux-foundation.org
Subject: [folded] powerpc-make-the-cmm-memory-hotplug-aware-update.patch removed from -mm tree
Date: Thu, 17 Dec 2009 16:43:27 -0800
Message-ID: <200912180043.nBI0hSWT028369@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40214 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754866AbZLRAoq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Dec 2009 19:44:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rcj@linux.vnet.ibm.com, benh@kernel.crashing.org, brking@linux.vnet.ibm.com, geralds@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mingo@elte.hu, paulus@samba.org


The patch titled
     powerpc-make-the-cmm-memory-hotplug-aware-update
has been removed from the -mm tree.  Its filename was
     powerpc-make-the-cmm-memory-hotplug-aware-update.patch

This patch was dropped because it was folded into powerpc-make-the-cmm-memory-hotplug-aware.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc-make-the-cmm-memory-hotplug-aware-update
From: Robert Jennings <rcj@linux.vnet.ibm.com>

The pages used to track loaned pages should not be marked as MOVABLE, so
they need to be handled during a memory offline event.

Changes:
 * The structures for recording loaned pages are not allocated as MOVABLE
 * The structures for recording loaned pages are removed from sections
   being taken offline by moving their contents to a newly allocated page.

Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Brian King <brking@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Gerald Schaefer <geralds@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/pseries/cmm.c |   39 +++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 3 deletions(-)

diff -puN arch/powerpc/platforms/pseries/cmm.c~powerpc-make-the-cmm-memory-hotplug-aware-update arch/powerpc/platforms/pseries/cmm.c
--- a/arch/powerpc/platforms/pseries/cmm.c~powerpc-make-the-cmm-memory-hotplug-aware-update
+++ a/arch/powerpc/platforms/pseries/cmm.c
@@ -148,8 +148,7 @@ static long cmm_alloc_pages(long nr)
 			spin_unlock(&cmm_lock);
 			npa = (struct cmm_page_array *)__get_free_page(
 					GFP_NOIO | __GFP_NOWARN |
-					__GFP_NORETRY | __GFP_NOMEMALLOC |
-					__GFP_MOVABLE);
+					__GFP_NORETRY | __GFP_NOMEMALLOC);
 			if (!npa) {
 				pr_info("%s: Can not allocate new page list\n", __func__);
 				free_page(addr);
@@ -480,6 +479,8 @@ static unsigned long cmm_count_pages(voi
 	spin_lock(&cmm_lock);
 	pa = cmm_page_list;
 	while (pa) {
+		if ((unsigned long)pa >= start && (unsigned long)pa < end)
+			marg->pages_found++;
 		for (idx = 0; idx < pa->index; idx++)
 			if (pa->page[idx] >= start && pa->page[idx] < end)
 				marg->pages_found++;
@@ -531,7 +532,7 @@ static int cmm_mem_going_offline(void *a
 	struct memory_notify *marg = arg;
 	unsigned long start_page = (unsigned long)pfn_to_kaddr(marg->start_pfn);
 	unsigned long end_page = start_page + (marg->nr_pages << PAGE_SHIFT);
-	struct cmm_page_array *pa_curr, *pa_last;
+	struct cmm_page_array *pa_curr, *pa_last, *npa;
 	unsigned long idx;
 	unsigned long freed = 0;
 
@@ -539,6 +540,7 @@ static int cmm_mem_going_offline(void *a
 			start_page, marg->nr_pages);
 	spin_lock(&cmm_lock);
 
+	/* Search the page list for pages in the range to be offlined */
 	pa_last = pa_curr = cmm_page_list;
 	while (pa_curr) {
 		for (idx = (pa_curr->index - 1); (idx + 1) > 0; idx--) {
@@ -563,6 +565,37 @@ static int cmm_mem_going_offline(void *a
 		}
 		pa_curr = pa_curr->next;
 	}
+
+	/* Search for page list structures in the range to be offlined */
+	pa_last = NULL;
+	pa_curr = cmm_page_list;
+	while (pa_curr) {
+		if (((unsigned long)pa_curr >= start_page) &&
+				((unsigned long)pa_curr < end_page)) {
+			npa = (struct cmm_page_array *)__get_free_page(
+					GFP_NOIO | __GFP_NOWARN |
+					__GFP_NORETRY | __GFP_NOMEMALLOC);
+			if (!npa) {
+				spin_unlock(&cmm_lock);
+				cmm_dbg("Failed to allocate memory for list "
+						"management. Memory hotplug "
+						"failed.\n");
+				return ENOMEM;
+			}
+			memcpy(npa, pa_curr, PAGE_SIZE);
+			if (pa_curr == cmm_page_list)
+				cmm_page_list = npa;
+			if (pa_last)
+				pa_last->next = npa;
+			free_page((unsigned long) pa_curr);
+			freed++;
+			pa_curr = npa;
+		}
+
+		pa_last = pa_curr;
+		pa_curr = pa_curr->next;
+	}
+
 	spin_unlock(&cmm_lock);
 	cmm_dbg("Released %ld pages in the search range.\n", freed);
 
_

Patches currently in -mm which might be from rcj@linux.vnet.ibm.com are

mm-add-notifier-in-pageblock-isolation-for-balloon-drivers.patch
powerpc-make-the-cmm-memory-hotplug-aware.patch
powerpc-make-the-cmm-memory-hotplug-aware-update.patch

