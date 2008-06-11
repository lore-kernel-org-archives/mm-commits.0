From: akpm@linux-foundation.org
Subject: + vmscan-move-isolate_lru_page-to-vmscanc-fix.patch added to -mm tree
Date: Tue, 10 Jun 2008 22:54:38 -0700
Message-ID: <200806110554.m5B5scwt015847@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50685 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752075AbYFKFzi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jun 2008 01:55:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: y-goto@jp.fujitsu.com, Lee.Schermerhorn@hp.com, npiggin@suse.de, riel@redhat.com


The patch titled
     vmscan-move-isolate_lru_page-to-vmscanc fix
has been added to the -mm tree.  Its filename is
     vmscan-move-isolate_lru_page-to-vmscanc-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan-move-isolate_lru_page-to-vmscanc fix
From: Yasunori Goto <y-goto@jp.fujitsu.com>

> lockess pagecache
>
> +vmscan-move-isolate_lru_page-to-vmscanc.patch
>   :

This patch is cause of compile error in mm/memory_hotplug.c.
Obviously, just here is old against changing interface of
isolate_lru_page(). :-(

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~vmscan-move-isolate_lru_page-to-vmscanc-fix mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~vmscan-move-isolate_lru_page-to-vmscanc-fix
+++ a/mm/memory_hotplug.c
@@ -595,8 +595,9 @@ do_migrate_range(unsigned long start_pfn
 		 * We can skip free pages. And we can only deal with pages on
 		 * LRU.
 		 */
-		ret = isolate_lru_page(page, &source);
+		ret = isolate_lru_page(page);
 		if (!ret) { /* Success */
+			list_add_tail(&page->lru, &source);
 			move_pages--;
 		} else {
 			/* Becasue we don't have big zone->lock. we should
_

Patches currently in -mm which might be from y-goto@jp.fujitsu.com are

bootmem-respect-goal-more-likely.patch
bootmem-revisit-alloc_bootmem_section.patch
vmscan-move-isolate_lru_page-to-vmscanc-fix.patch

