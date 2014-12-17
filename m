From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-place-zone_id-check-before-vm_bug_on_page-check.patch added
 to -mm tree
Date: Wed, 17 Dec 2014 15:29:38 -0800
Message-ID: <549211e2.a942Gll5RfrzniWa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44376 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbaLQX3j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Dec 2014 18:29:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weijie.yang@samsung.com, hannes@cmpxchg.org, mgorman@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: place zone_id check before VM_BUG_ON_PAGE check
has been added to the -mm tree.  Its filename is
     mm-page_alloc-place-zone_id-check-before-vm_bug_on_page-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-place-zone_id-check-before-vm_bug_on_page-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-place-zone_id-check-before-vm_bug_on_page-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Weijie Yang <weijie.yang@samsung.com>
Subject: mm/page_alloc.c: place zone_id check before VM_BUG_ON_PAGE check

If the freeing page and its buddy page are not at the same zone, the
current holding zone->lock for the freeing page cann't prevent buddy page
getting allocated, this could trigger VM_BUG_ON_PAGE in page_is_buddy() at
a very tiny chance, such as:

cpu 0:						cpu 1:
hold zone_1 lock
check page and it buddy
PageBuddy(buddy) is true			hold zone_2 lock
page_order(buddy) == order is true		alloc buddy
trigger VM_BUG_ON_PAGE(page_count(buddy) != 0)

zone_1->lock prevents the freeing page getting allocated
zone_2->lock prevents the buddy page getting allocated
they are not the same zone->lock.

If we can't remove the zone_id check statement, it's better handle this
rare race.  This patch fixes this by placing the zone_id check before the
VM_BUG_ON_PAGE check.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-place-zone_id-check-before-vm_bug_on_page-check mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-place-zone_id-check-before-vm_bug_on_page-check
+++ a/mm/page_alloc.c
@@ -552,17 +552,15 @@ static inline int page_is_buddy(struct p
 		return 0;
 
 	if (page_is_guard(buddy) && page_order(buddy) == order) {
-		VM_BUG_ON_PAGE(page_count(buddy) != 0, buddy);
-
 		if (page_zone_id(page) != page_zone_id(buddy))
 			return 0;
 
+		VM_BUG_ON_PAGE(page_count(buddy) != 0, buddy);
+
 		return 1;
 	}
 
 	if (PageBuddy(buddy) && page_order(buddy) == order) {
-		VM_BUG_ON_PAGE(page_count(buddy) != 0, buddy);
