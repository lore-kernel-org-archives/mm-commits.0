From: akpm@linux-foundation.org
Subject: [merged] mem-hotplug-call-isolate_lru_page-with-elevated-refcount.patch removed from -mm tree
Date: Wed, 25 May 2011 13:29:18 -0700
Message-ID: <201105252027.p4PKRfvk014599@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932089Ab1EYU2X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:28:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, andi@firstfloor.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mem-hotplug: call isolate_lru_page with elevated refcount
has been removed from the -mm tree.  Its filename was
     mem-hotplug-call-isolate_lru_page-with-elevated-refcount.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mem-hotplug: call isolate_lru_page with elevated refcount
From: Konstantin Khlebnikov <khlebnikov@openvz.org>

isolate_lru_page() must be called only with stable reference to page.  So,
let's grab normal page reference.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~mem-hotplug-call-isolate_lru_page-with-elevated-refcount mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mem-hotplug-call-isolate_lru_page-with-elevated-refcount
+++ a/mm/memory_hotplug.c
@@ -706,7 +706,7 @@ do_migrate_range(unsigned long start_pfn
 		if (!pfn_valid(pfn))
 			continue;
 		page = pfn_to_page(pfn);
-		if (!page_count(page))
+		if (!get_page_unless_zero(page))
 			continue;
 		/*
 		 * We can skip free pages. And we can only deal with pages on
@@ -714,6 +714,7 @@ do_migrate_range(unsigned long start_pfn
 		 */
 		ret = isolate_lru_page(page);
 		if (!ret) { /* Success */
+			put_page(page);
 			list_add_tail(&page->lru, &source);
 			move_pages--;
 			inc_zone_page_state(page, NR_ISOLATED_ANON +
@@ -725,6 +726,7 @@ do_migrate_range(unsigned long start_pfn
 			       pfn);
 			dump_page(page);
 #endif
+			put_page(page);
 			/* Because we don't have big zone->lock. we should
 			   check this again here. */
 			if (page_count(page)) {
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch

