From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages-fix.patch added to -mm tree
Date: Fri, 02 May 2014 15:19:15 -0700
Message-ID: <536419e3.mesaglqm35TGLQ7V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49255 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbaEBWTQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2014 18:19:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sasha.levin@oracle.com, vbabka@suse.cz

Subject: + mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages-fix.patch added to -mm tree
To: vbabka@suse.cz,sasha.levin@oracle.com
From: akpm@linux-foundation.org
Date: Fri, 02 May 2014 15:19:15 -0700


The patch titled
     Subject: mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages-fix
has been added to the -mm tree.  Its filename is
     mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages-fix

Use VM_BUG_ON_PAGE instead of VM_BUG_ON as suggested by Sasha Levin.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages-fix
+++ a/mm/page_alloc.c
@@ -699,7 +699,7 @@ static void free_pcppages_bulk(struct zo
 			/* must delete as __free_one_page list manipulates */
 			list_del(&page->lru);
 
-			VM_BUG_ON(!check_freepage_migratetype(page));
+			VM_BUG_ON_PAGE(!check_freepage_migratetype(page), page);
 			mt = get_freepage_migratetype(page);
 			/* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
 			__free_one_page(page, zone, 0, mt);
@@ -1193,7 +1193,7 @@ static int rmqueue_bulk(struct zone *zon
 		struct page *page = __rmqueue(zone, order, migratetype);
 		if (unlikely(page == NULL))
 			break;
-		VM_BUG_ON(!check_freepage_migratetype(page));
+		VM_BUG_ON_PAGE(!check_freepage_migratetype(page), page);
 
 		/*
 		 * Split buddy pages returned by expand() are received here
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-compaction-make-isolate_freepages-start-at-pageblock-boundary.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch
mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages.patch
mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages-fix.patch
mm-compaction-clean-up-unused-code-lines.patch
mm-compaction-cleanup-isolate_freepages.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
mm-compaction-cleanup-isolate_freepages-fix-2.patch

