From: akpm@linux-foundation.org
Subject: + mm-page_isolation-clean-up-confused-code.patch added to -mm
 tree
Date: Fri, 24 Jun 2016 16:19:54 -0700
Message-ID: <576dc01a.cQFHoPc8CTWpsqyz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42025 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbcFXXTz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2016 19:19:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_isolation: clean up confused code
has been added to the -mm tree.  Its filename is
     mm-page_isolation-clean-up-confused-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_isolation-clean-up-confused-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_isolation-clean-up-confused-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/page_isolation: clean up confused code

When there is an isolated_page, post_alloc_hook() is called with page but
__free_pages() is called with isolated_page.  Since they are the same so
no problem but it's very confusing.  To reduce it, this patch changes
isolated_page to boolean type and uses page variable consistently.

Link: http://lkml.kernel.org/r/1466150259-27727-10-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/page_isolation.c~mm-page_isolation-clean-up-confused-code mm/page_isolation.c
--- a/mm/page_isolation.c~mm-page_isolation-clean-up-confused-code
+++ a/mm/page_isolation.c
@@ -81,7 +81,7 @@ static void unset_migratetype_isolate(st
 {
 	struct zone *zone;
 	unsigned long flags, nr_pages;
-	struct page *isolated_page = NULL;
+	bool isolated_page = false;
 	unsigned int order;
 	unsigned long page_idx, buddy_idx;
 	struct page *buddy;
@@ -109,7 +109,7 @@ static void unset_migratetype_isolate(st
 			if (pfn_valid_within(page_to_pfn(buddy)) &&
 			    !is_migrate_isolate_page(buddy)) {
 				__isolate_free_page(page, order);
-				isolated_page = page;
+				isolated_page = true;
 			}
 		}
 	}
@@ -129,7 +129,7 @@ out:
 	spin_unlock_irqrestore(&zone->lock, flags);
 	if (isolated_page) {
 		post_alloc_hook(page, order, __GFP_MOVABLE);
-		__free_pages(isolated_page, order);
+		__free_pages(page, order);
 	}
 }
 
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-compaction-split-freepages-without-holding-the-zone-lock.patch
mm-page_owner-initialize-page-owner-without-holding-the-zone-lock.patch
mm-page_owner-copy-last_migrate_reason-in-copy_page_owner.patch
mm-page_owner-introduce-split_page_owner-and-replace-manual-handling.patch
tools-vm-page_owner-increase-temporary-buffer-size.patch
mm-page_owner-use-stackdepot-to-store-stacktrace.patch
mm-page_owner-use-stackdepot-to-store-stacktrace-v3.patch
mm-page_alloc-introduce-post-allocation-processing-on-page-allocator.patch
mm-page_alloc-introduce-post-allocation-processing-on-page-allocator-v3.patch
mm-page_isolation-clean-up-confused-code.patch

