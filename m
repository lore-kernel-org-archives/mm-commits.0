From: akpm@linux-foundation.org
Subject: - mm-more-likely-reclaim-madv_sequential-mappings.patch removed from -mm tree
Date: Sun, 19 Oct 2008 10:04:08 -0700
Message-ID: <200810191704.m9JH48Ze027659@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34404 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750704AbYJSREf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 19 Oct 2008 13:04:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@saeurebad.de, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: more likely reclaim MADV_SEQUENTIAL mappings
has been removed from the -mm tree.  Its filename was
     mm-more-likely-reclaim-madv_sequential-mappings.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: more likely reclaim MADV_SEQUENTIAL mappings
From: Johannes Weiner <hannes@saeurebad.de>

File pages accessed only once through sequential-read mappings between
fault and scan time are perfect candidates for reclaim.

This patch makes page_referenced() ignore these singular references and
the pages stay on the inactive list where they likely fall victim to the
next reclaim phase.

Already activated pages are still treated normally.  If they were accessed
multiple times and therefor promoted to the active list, we probably want
to keep them.

Benchmarks show that big (relative to the system's memory) MADV_SEQUENTIAL
mappings read sequentially cause much less kernel activity.  Especially
less LRU moving-around because we never activate read-once pages in the
first place just to demote them again.

And leaving these perfect reclaim candidates on the inactive list makes
it more likely for the real working set to survive the next reclaim
scan.

Benchmark graphs and the test-application can be found here:

	http://hannes.saeurebad.de/madvseq/

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff -puN mm/rmap.c~mm-more-likely-reclaim-madv_sequential-mappings mm/rmap.c
--- a/mm/rmap.c~mm-more-likely-reclaim-madv_sequential-mappings
+++ a/mm/rmap.c
@@ -327,8 +327,18 @@ static int page_referenced_one(struct pa
 		goto out_unmap;
 	}
 
-	if (ptep_clear_flush_young_notify(vma, address, pte))
-		referenced++;
+	if (ptep_clear_flush_young_notify(vma, address, pte)) {
+		/*
+		 * If there was just one sequential access to the
+		 * page, ignore it.  Otherwise, mark_page_accessed()
+		 * will have promoted the page to the active list and
+		 * it should be kept.
+		 */
+		if (VM_SequentialReadHint(vma) && !PageActive(page))
+			ClearPageReferenced(page);
+		else
+			referenced++;
+	}
 
 	/* Pretend the page is referenced if the task has the
 	   swap token and is in the middle of a page fault. */
@@ -449,9 +459,6 @@ int page_referenced(struct page *page, i
 {
 	int referenced = 0;
 
-	if (TestClearPageReferenced(page))
-		referenced++;
