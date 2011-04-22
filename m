From: akpm@linux-foundation.org
Subject: + mm-strictly-require-elevated-page-refcount-in-isolate_lru_page.patch added to -mm tree
Date: Fri, 22 Apr 2011 13:15:58 -0700
Message-ID: <201104222015.p3MKFxXm029725@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55367 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756253Ab1DVUQl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Apr 2011 16:16:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, andi@firstfloor.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, riel@redhat.com


The patch titled
     mm: strictly require elevated page refcount in isolate_lru_page()
has been added to the -mm tree.  Its filename is
     mm-strictly-require-elevated-page-refcount-in-isolate_lru_page.patch

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
Subject: mm: strictly require elevated page refcount in isolate_lru_page()
From: Konstantin Khlebnikov <khlebnikov@openvz.org>

isolate_lru_page() must be called only with stable reference to the page,
this is what is written in the comment above it, this is reasonable.

current isolate_lru_page() users and its page extra reference sources:

mm/huge_memory.c
__collapse_huge_page_isolate()		- reference from pte

mm/memcontrol.c
mem_cgroup_move_parent()		- get_page_unless_zero()
mem_cgroup_move_charge_pte_range()	- reference from pte

mm/memory-failure.c
soft_offline_page()			- fixed, reference from get_any_page()
delete_from_lru_cache() - reference from caller or get_page_unless_zero()
[seems like there bug, because __memory_failure() can call page_action() for
 hpages tail, but it is ok for isolate_lru_page(), tail getted and not in lru]

mm/memory_hotplug.c
do_migrate_range()			- fixed, get_page_unless_zero()

mm/mempolicy.c
migrate_page_add()			- reference from pte

mm/migrate.c
do_move_page_to_node_array()		- reference from follow_page()

mlock.c					- various external references

mm/vmscan.c
putback_lru_page()			- reference from isolate_lru_page()

It seems that all isolate_lru_page() users are ready now for this restriction.
So, let's replace redundant get_page_unless_zero() with get_page() and
add page initial reference count check with VM_BUG_ON()

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-strictly-require-elevated-page-refcount-in-isolate_lru_page mm/vmscan.c
--- a/mm/vmscan.c~mm-strictly-require-elevated-page-refcount-in-isolate_lru_page
+++ a/mm/vmscan.c
@@ -1201,13 +1201,16 @@ int isolate_lru_page(struct page *page)
 {
 	int ret = -EBUSY;
 
+	VM_BUG_ON(!page_count(page));
+
 	if (PageLRU(page)) {
 		struct zone *zone = page_zone(page);
 
 		spin_lock_irq(&zone->lru_lock);
-		if (PageLRU(page) && get_page_unless_zero(page)) {
+		if (PageLRU(page)) {
 			int lru = page_lru(page);
 			ret = 0;
+			get_page(page);
 			ClearPageLRU(page);
 
 			del_page_from_lru_list(zone, page, lru);
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

linux-next.patch
tmpfs-fix-race-between-umount-and-writepage.patch
mem-hotplug-call-isolate_lru_page-with-elevated-refcount.patch
mem-hwpoison-fix-page-refcount-around-isolate_lru_page.patch
mm-strictly-require-elevated-page-refcount-in-isolate_lru_page.patch

