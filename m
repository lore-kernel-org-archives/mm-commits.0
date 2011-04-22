From: akpm@linux-foundation.org
Subject: + mem-hotplug-call-isolate_lru_page-with-elevated-refcount.patch added to -mm tree
Date: Fri, 22 Apr 2011 13:15:53 -0700
Message-ID: <201104222015.p3MKFsMb029718@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57489 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756240Ab1DVUQk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Apr 2011 16:16:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, andi@firstfloor.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, riel@redhat.com


The patch titled
     mem-hotplug: call isolate_lru_page with elevated refcount
has been added to the -mm tree.  Its filename is
     mem-hotplug-call-isolate_lru_page-with-elevated-refcount.patch

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

linux-next.patch
tmpfs-fix-race-between-umount-and-writepage.patch
mem-hotplug-call-isolate_lru_page-with-elevated-refcount.patch
mem-hwpoison-fix-page-refcount-around-isolate_lru_page.patch
mm-strictly-require-elevated-page-refcount-in-isolate_lru_page.patch

