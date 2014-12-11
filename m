From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-count-only-dirty-pages-as-congested.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 10:56:32 -0800
Message-ID: <5489e8e0.yI/sIDHrNo8wTDzY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45175 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbaLKS4d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:56:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jamieliu@google.com, gthelen@google.com, hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: count only dirty pages as congested
has been removed from the -mm tree.  Its filename was
     mm-vmscan-count-only-dirty-pages-as-congested.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jamie Liu <jamieliu@google.com>
Subject: mm: vmscan: count only dirty pages as congested

shrink_page_list() counts all pages with a mapping, including clean pages,
toward nr_congested if they're on a write-congested BDI. 
shrink_inactive_list() then sets ZONE_CONGESTED if nr_dirty ==
nr_congested.  Fix this apples-to-oranges comparison by only counting
pages for nr_congested if they count for nr_dirty.

Signed-off-by: Jamie Liu <jamieliu@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-vmscan-count-only-dirty-pages-as-congested mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-count-only-dirty-pages-as-congested
+++ a/mm/vmscan.c
@@ -874,7 +874,8 @@ static unsigned long shrink_page_list(st
 		 * end of the LRU a second time.
 		 */
 		mapping = page_mapping(page);
-		if ((mapping && bdi_write_congested(mapping->backing_dev_info)) ||
+		if (((dirty || writeback) && mapping &&
+		     bdi_write_congested(mapping->backing_dev_info)) ||
 		    (writeback && PageReclaim(page)))
 			nr_congested++;
 
_

Patches currently in -mm which might be from jamieliu@google.com are

origin.patch

