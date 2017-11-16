From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_alloc-enable-disable-irqs-once-when-freeing-a-list-of-pages-fix.patch removed from -mm tree
Date: Wed, 15 Nov 2017 17:06:34 -0800
Message-ID: <5a0ce49a.gpcX+JrU+GaYomLy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36234 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751097AbdKPBGg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:06:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, ak@linux.intel.com, dave.hansen@intel.com, david@fromorbit.com, hannes@cmpxchg.org, jack@suse.cz, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-enable-disable-irqs-once-when-freeing-a-list-of-pages-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-enable-disable-irqs-once-when-freeing-a-list-of-pages-fix.patch

This patch was dropped because it was folded into mm-page_alloc-enable-disable-irqs-once-when-freeing-a-list-of-pages.patch

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm-page_alloc-enable-disable-irqs-once-when-freeing-a-list-of-pages-fix

Use page_private and set_page_private helpers.

Link: http://lkml.kernel.org/r/20171018101547.mjycw7zreb66jzpa@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-enable-disable-irqs-once-when-freeing-a-list-of-pages-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-enable-disable-irqs-once-when-freeing-a-list-of-pages-fix
+++ a/mm/page_alloc.c
@@ -2687,14 +2687,14 @@ void free_hot_cold_page_list(struct list
 		pfn = page_to_pfn(page);
 		if (!free_hot_cold_page_prepare(page, pfn))
 			list_del(&page->lru);
-		page->private = pfn;
+		set_page_private(page, pfn);
 	}
 
 	local_irq_save(flags);
 	list_for_each_entry_safe(page, next, list, lru) {
-		unsigned long pfn = page->private;
+		unsigned long pfn = page_private(page);
 
-		page->private = 0;
+		set_page_private(page, 0);
 		trace_mm_page_free_batched(page, cold);
 		free_hot_cold_page_commit(page, pfn, cold);
 	}
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-enable-disable-irqs-once-when-freeing-a-list-of-pages.patch
mm-truncate-do-not-check-mapping-for-every-page-being-truncated.patch
mm-truncate-remove-all-exceptional-entries-from-pagevec-under-one-lock.patch
mm-only-drain-per-cpu-pagevecs-once-per-pagevec-usage.patch
mm-pagevec-remove-cold-parameter-for-pagevecs.patch
mm-remove-cold-parameter-for-release_pages.patch
mm-remove-cold-parameter-from-free_hot_cold_page.patch
mm-remove-cold-parameter-from-free_hot_cold_page-fix.patch
mm-remove-__gfp_cold.patch
mm-pagevec-rename-pagevec-drained-field.patch

