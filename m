From: akpm@linux-foundation.org
Subject: - mm-unlockless-reclaim.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:33:33 -0700
Message-ID: <200810202033.m9KKXXXr010652@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45624 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753686AbYJTUfl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:35:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm: unlockless reclaim
has been removed from the -mm tree.  Its filename was
     mm-unlockless-reclaim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: unlockless reclaim
From: Nick Piggin <npiggin@suse.de>

unlock_page is fairly expensive.  It can be avoided in page reclaim
success path.  By definition if we have any other references to the page
it would be a bug anyway.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-unlockless-reclaim mm/vmscan.c
--- a/mm/vmscan.c~mm-unlockless-reclaim
+++ a/mm/vmscan.c
@@ -732,7 +732,14 @@ static unsigned long shrink_page_list(st
 		if (!mapping || !__remove_mapping(mapping, page))
 			goto keep_locked;
 
-		unlock_page(page);
+		/*
+		 * At this point, we have no other references and there is
+		 * no way to pick any more up (removed from LRU, removed
+		 * from pagecache). Can use non-atomic bitops now (and
+		 * we obviously don't have to worry about waking up a process
+		 * waiting on the page lock, because there are no references.
+		 */
+		__clear_page_locked(page);
 free_it:
 		nr_reclaimed++;
 		if (!pagevec_add(&freed_pvec, page)) {
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

