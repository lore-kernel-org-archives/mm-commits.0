From: akpm@linux-foundation.org
Subject: [merged]
 mm-try_to_unmap_cluster-should-lock_page-before-mlocking.patch removed from -mm tree
Date: Tue, 08 Apr 2014 13:55:58 -0700
Message-ID: <5344625e.2gwwCygbeX0ljiVr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56578 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756778AbaDHUz7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:55:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, stable@vger.kernel.org, sasha.levin@oracle.com, rientjes@google.com, riel@redhat.com, mgorman@suse.de, liwanp@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, iamjoonsoo.kim@lge.com, hughd@google.com, bob.liu@oracle.com, vbabka@suse.cz

Subject: [merged] mm-try_to_unmap_cluster-should-lock_page-before-mlocking.patch removed from -mm tree
To: vbabka@suse.cz,bob.liu@oracle.com,hughd@google.com,iamjoonsoo.kim@lge.com,kosaki.motohiro@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,riel@redhat.com,rientjes@google.com,sasha.levin@oracle.com,stable@vger.kernel.org,walken@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:55:58 -0700


The patch titled
     Subject: mm: try_to_unmap_cluster() should lock_page() before mlocking
has been removed from the -mm tree.  Its filename was
     mm-try_to_unmap_cluster-should-lock_page-before-mlocking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm: try_to_unmap_cluster() should lock_page() before mlocking

A BUG_ON(!PageLocked) was triggered in mlock_vma_page() by Sasha Levin
fuzzing with trinity.  The call site try_to_unmap_cluster() does not lock
the pages other than its check_page parameter (which is already locked).

The BUG_ON in mlock_vma_page() is not documented and its purpose is
somewhat unclear, but apparently it serializes against page migration,
which could otherwise fail to transfer the PG_mlocked flag.  This would
not be fatal, as the page would be eventually encountered again, but
NR_MLOCK accounting would become distorted nevertheless.  This patch adds
a comment to the BUG_ON in mlock_vma_page() and munlock_vma_page() to that
effect.

The call site try_to_unmap_cluster() is fixed so that for page !=
check_page, trylock_page() is attempted (to avoid possible deadlocks as we
already have check_page locked) and mlock_vma_page() is performed only
upon success.  If the page lock cannot be obtained, the page is left
without PG_mlocked, which is again not a problem in the whole unevictable
memory design.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Bob Liu <bob.liu@oracle.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    2 ++
 mm/rmap.c  |   14 ++++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff -puN mm/mlock.c~mm-try_to_unmap_cluster-should-lock_page-before-mlocking mm/mlock.c
--- a/mm/mlock.c~mm-try_to_unmap_cluster-should-lock_page-before-mlocking
+++ a/mm/mlock.c
@@ -79,6 +79,7 @@ void clear_page_mlock(struct page *page)
  */
 void mlock_vma_page(struct page *page)
 {
+	/* Serialize with page migration */
 	BUG_ON(!PageLocked(page));
 
 	if (!TestSetPageMlocked(page)) {
@@ -174,6 +175,7 @@ unsigned int munlock_vma_page(struct pag
 	unsigned int nr_pages;
 	struct zone *zone = page_zone(page);
 
+	/* For try_to_munlock() and to serialize with page migration */
 	BUG_ON(!PageLocked(page));
 
 	/*
diff -puN mm/rmap.c~mm-try_to_unmap_cluster-should-lock_page-before-mlocking mm/rmap.c
--- a/mm/rmap.c~mm-try_to_unmap_cluster-should-lock_page-before-mlocking
+++ a/mm/rmap.c
@@ -1332,9 +1332,19 @@ static int try_to_unmap_cluster(unsigned
 		BUG_ON(!page || PageAnon(page));
 
 		if (locked_vma) {
-			mlock_vma_page(page);   /* no-op if already mlocked */
-			if (page == check_page)
+			if (page == check_page) {
+				/* we know we have check_page locked */
+				mlock_vma_page(page);
 				ret = SWAP_MLOCK;
+			} else if (trylock_page(page)) {
+				/*
+				 * If we can lock the page, perform mlock.
+				 * Otherwise leave the page alone, it will be
+				 * eventually encountered again later.
+				 */
+				mlock_vma_page(page);
+				unlock_page(page);
+			}
 			continue;	/* don't unmap */
 		}
 
_

Patches currently in -mm which might be from vbabka@suse.cz are

origin.patch

