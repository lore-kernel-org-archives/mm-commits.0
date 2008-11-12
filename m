From: akpm@linux-foundation.org
Subject: + mm-more-likely-reclaim-madv_sequential-mappings.patch added to -mm tree
Date: Tue, 11 Nov 2008 16:00:51 -0800
Message-ID: <200811120000.mAC00pOf030889@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54617 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751458AbYKLABv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Nov 2008 19:01:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, hannes@saeurebad.de, kosaki.motohiro@jp.fujitsu.com, npiggin@suse.de, riel@redhat.com


The patch titled
     mm: more likely reclaim MADV_SEQUENTIAL mappings
has been added to the -mm tree.  Its filename is
     mm-more-likely-reclaim-madv_sequential-mappings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: more likely reclaim MADV_SEQUENTIAL mappings
From: Johannes Weiner <hannes@cmpxchg.org>

File pages mapped only in sequentially read mappings are perfect reclaim
canditates.

This patch makes these mappings behave like weak references, their pages
will be reclaimed unless they have a strong reference from a normal
mapping as well.

It changes the reclaim and the unmap path where they check if the page has
been referenced.  In both cases, accesses through sequentially read
mappings will be ignored.

Benchmark results from KOSAKI Motohiro:

    http://marc.info/?l=linux-mm&m=122485301925098&w=2

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    3 ++-
 mm/rmap.c   |   13 +++++++++++--
 2 files changed, 13 insertions(+), 3 deletions(-)

diff -puN mm/memory.c~mm-more-likely-reclaim-madv_sequential-mappings mm/memory.c
--- a/mm/memory.c~mm-more-likely-reclaim-madv_sequential-mappings
+++ a/mm/memory.c
@@ -757,7 +757,8 @@ static unsigned long zap_pte_range(struc
 			else {
 				if (pte_dirty(ptent))
 					set_page_dirty(page);
-				if (pte_young(ptent))
+				if (pte_young(ptent) &&
+				    likely(!VM_SequentialReadHint(vma)))
 					mark_page_accessed(page);
 				file_rss--;
 			}
diff -puN mm/rmap.c~mm-more-likely-reclaim-madv_sequential-mappings mm/rmap.c
--- a/mm/rmap.c~mm-more-likely-reclaim-madv_sequential-mappings
+++ a/mm/rmap.c
@@ -360,8 +360,17 @@ static int page_referenced_one(struct pa
 		goto out_unmap;
 	}
 
-	if (ptep_clear_flush_young_notify(vma, address, pte))
-		referenced++;
+	if (ptep_clear_flush_young_notify(vma, address, pte)) {
+		/*
+		 * Don't treat a reference through a sequentially read
+		 * mapping as such.  If the page has been used in
+		 * another mapping, we will catch it; if this other
+		 * mapping is already gone, the unmap path will have
+		 * set PG_referenced or activated the page.
+		 */
+		if (likely(!VM_SequentialReadHint(vma)))
+			referenced++;
+	}
 
 	/* Pretend the page is referenced if the task has the
 	   swap token and is in the middle of a page fault. */
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-more-likely-reclaim-madv_sequential-mappings.patch

