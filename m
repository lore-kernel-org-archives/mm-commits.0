From: akpm@linux-foundation.org
Subject: [patch 001/162] mm: workingset: only do workingset activations on reads
Date: Fri, 20 May 2016 16:56:25 -0700
Message-ID: <573fa429.ZM77am0tcH2hmPF3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52014 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbcETX41 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:56:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, riel@redhat.com, andres@anarazel.de, hannes@cmpxchg.org

From: Rik van Riel <riel@redhat.com>
Subject: mm: workingset: only do workingset activations on reads

This is a follow-up to
http://www.spinics.net/lists/linux-mm/msg101739.html where Andres reported
his database workingset being pushed out by the minimum size enforcement
of the inactive file list - currently 50% of cache - as well as repeatedly
written file pages that are never actually read.

Two changes fell out of the discussions.  The first change observes that
pages that are only ever written don't benefit from caching beyond what
the writeback cache does for partial page writes, and so we shouldn't
promote them to the active file list where they compete with pages whose
cached data is actually accessed repeatedly.  This change comes in two
patches - one for in-cache write accesses and one for refaults triggered
by writes, neither of which should promote a cache page.

Second, with the refault detection we don't need to set 50% of the cache
aside for used-once cache anymore since we can detect frequently used
pages even when they are evicted between accesses.  We can allow the
active list to be bigger and thus protect a bigger workingset that isn't
challenged by streamers.  Depending on the access patterns, this can
increase major faults during workingset transitions for better performance
during stable phases.



This patch (of 3):

When rewriting a page, the data in that page is replaced with new data. 
This means that evicting something else from the active file list, in
order to cache data that will be replaced by something else, is likely to
be a waste of memory.

It is better to save the active list for frequently read pages, because
reads actually use the data that is in the page.

This patch ignores partial writes, because it is unclear whether the
complexity of identifying those is worth any potential performance gain
obtained from better caching pages that see repeated partial writes at
large enough intervals to not get caught by the use-twice promotion code
used for the inactive file list.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Andres Freund <andres@anarazel.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/filemap.c~mm-workingset-only-do-workingset-activations-on-reads mm/filemap.c
--- a/mm/filemap.c~mm-workingset-only-do-workingset-activations-on-reads
+++ a/mm/filemap.c
@@ -713,8 +713,12 @@ int add_to_page_cache_lru(struct page *p
 		 * The page might have been evicted from cache only
 		 * recently, in which case it should be activated like
 		 * any other repeatedly accessed page.
+		 * The exception is pages getting rewritten; evicting other
+		 * data from the working set, only to cache data that will
+		 * get overwritten with something else, is a waste of memory.
 		 */
-		if (shadow && workingset_refault(shadow)) {
+		if (!(gfp_mask & __GFP_WRITE) &&
+		    shadow && workingset_refault(shadow)) {
 			SetPageActive(page);
 			workingset_activation(page);
 		} else
_
