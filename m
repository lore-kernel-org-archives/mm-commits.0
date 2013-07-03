From: akpm@linux-foundation.org
Subject: [folded-merged]
 memory_hotplug-use-pgdat_resize_lock-in-__offline_pages.patch removed from
 -mm tree
Date: Wed, 03 Jul 2013 14:26:47 -0700
Message-ID: <51d49717.NnKFeTxZiQerhrvl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39973 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab3GCV0s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jul 2013 17:26:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, cody@linux.vnet.ibm.com

Subject: [folded-merged] memory_hotplug-use-pgdat_resize_lock-in-__offline_pages.patch removed from -mm tree
To: cody@linux.vnet.ibm.com,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 03 Jul 2013 14:26:47 -0700


The patch titled
     Subject: memory_hotplug: use pgdat_resize_lock() in __offline_pages()
has been removed from the -mm tree.  Its filename was
     memory_hotplug-use-pgdat_resize_lock-in-__offline_pages.patch

This patch was dropped because it was folded into memory_hotplug-use-pgdat_resize_lock-in-online_pages.patch

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: memory_hotplug: use pgdat_resize_lock() in __offline_pages()

mmzone.h documents node_size_lock (which pgdat_resize_lock() locks) as
follows:

        * Must be held any time you expect node_start_pfn, node_present_pages
        * or node_spanned_pages stay constant.  [...]

So actually hold it when we update node_present_pages in __offline_pages().

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/memory_hotplug.c~memory_hotplug-use-pgdat_resize_lock-in-__offline_pages mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory_hotplug-use-pgdat_resize_lock-in-__offline_pages
+++ a/mm/memory_hotplug.c
@@ -1585,7 +1585,11 @@ repeat:
 	/* removal success */
 	zone->managed_pages -= offlined_pages;
 	zone->present_pages -= offlined_pages;
+
+	pgdat_resize_lock(zone->zone_pgdat, &flags);
 	zone->zone_pgdat->node_present_pages -= offlined_pages;
+	pgdat_resize_unlock(zone->zone_pgdat, &flags);
+
 	totalram_pages -= offlined_pages;
 
 	init_per_zone_wmark_min();
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

mm-page_alloc-factor-out-setting-of-pcp-high-and-pcp-batch.patch
mm-page_alloc-prevent-concurrent-updaters-of-pcp-batch-and-high.patch
mm-page_alloc-insert-memory-barriers-to-allow-async-update-of-pcp-batch-and-high.patch
mm-page_alloc-protect-pcp-batch-accesses-with-access_once.patch
mm-page_alloc-convert-zone_pcp_update-to-rely-on-memory-barriers-instead-of-stop_machine.patch
mm-page_alloc-when-handling-percpu_pagelist_fraction-dont-unneedly-recalulate-high.patch
mm-page_alloc-factor-setup_pageset-into-pageset_init-and-pageset_set_batch.patch
mm-page_alloc-relocate-comment-to-be-directly-above-code-it-refers-to.patch
mm-page_alloc-factor-zone_pageset_init-out-of-setup_zone_pageset.patch
mm-page_alloc-in-zone_pcp_update-uze-zone_pageset_init.patch
mm-page_alloc-rename-setup_pagelist_highmark-to-match-naming-of-pageset_set_batch.patch
mm-page_alloc-dont-re-init-pageset-in-zone_pcp_update.patch
mm-fix-comment-referring-to-non-existent-size_seqlock-change-to-span_seqlock.patch
mmzone-note-that-node_size_lock-should-be-manipulated-via-pgdat_resize_lock.patch
memory_hotplug-use-pgdat_resize_lock-in-online_pages.patch
memory_hotplug-use-pgdat_resize_lock-in-__offline_pages-fix.patch
sparsemem-add-build_bug_on-when-sizeof-mem_section-is-non-power-of-2.patch

