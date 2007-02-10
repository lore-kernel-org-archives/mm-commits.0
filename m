From: akpm@linux-foundation.org
Subject: - use-zvc-for-free_pages-fix-4.patch removed from -mm tree
Date: Sat, 10 Feb 2007 00:05:20 -0800
Message-ID: <200702100805.l1A85KZk006859@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39188 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735AbXBJIF3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 03:05:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michal.k.k.piotrowski@gmail.com, mm-commits@vger.kernel.org


The patch titled
     use-zvc-for-free_pages-fix-4
has been removed from the -mm tree.  Its filename was
     use-zvc-for-free_pages-fix-4.patch

This patch was dropped because it was folded into use-zvc-for-free_pages.patch

------------------------------------------------------
Subject: use-zvc-for-free_pages-fix-4
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

Additional fix

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/power/snapshot.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/power/snapshot.c~use-zvc-for-free_pages-fix-4 kernel/power/snapshot.c
--- a/kernel/power/snapshot.c~use-zvc-for-free_pages-fix-4
+++ a/kernel/power/snapshot.c
@@ -591,7 +591,7 @@ static unsigned int count_free_highmem_p
 
 	for_each_zone(zone)
 		if (populated_zone(zone) && is_highmem(zone))
-			cnt += zone->free_pages;
+			cnt += zone_page_state(zone, NR_FREE_PAGES);
 
 	return cnt;
 }
@@ -869,7 +869,7 @@ static int enough_free_mem(unsigned int 
 	for_each_zone(zone) {
 		meta += snapshot_additional_pages(zone);
 		if (!is_highmem(zone))
-			free += zone->free_pages;
+			free += zone_page_state(zone, NR_FREE_PAGES);
 	}
 
 	nr_pages += count_pages_for_highmem(nr_highmem);
_

Patches currently in -mm which might be from michal.k.k.piotrowski@gmail.com are

use-zvc-for-free_pages.patch
use-zvc-for-free_pages-fix-4.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-3.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
reiser4-configh.patch
sysctl-remove-insert_at_head-from-register_sysctl-fix.patch
