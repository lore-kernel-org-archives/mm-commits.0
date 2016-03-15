From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-fix.patch removed from -mm tree
Date: Tue, 15 Mar 2016 14:42:52 -0700
Message-ID: <56e881dc.grBk6u0jcl56nnvF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59980 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbcCOVmx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Mar 2016 17:42:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aaron.lu@intel.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-fix.patch

This patch was dropped because it was folded into mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-fix

don't forget to restore zone->contiguous on error path, per Vlastimil

Cc: Aaron Lu <aaron.lu@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/memory_hotplug.c~mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-fix mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-fix
+++ a/mm/memory_hotplug.c
@@ -526,7 +526,8 @@ int __ref __add_pages(int nid, struct zo
 		if (altmap->base_pfn != phys_start_pfn
 				|| vmem_altmap_offset(altmap) > nr_pages) {
 			pr_warn_once("memory add fail, invalid altmap\n");
-			return -EINVAL;
+			err = -EINVAL;
+			goto out;
 		}
 		altmap->alloc = 0;
 	}
@@ -544,9 +545,8 @@ int __ref __add_pages(int nid, struct zo
 		err = 0;
 	}
 	vmemmap_populate_print_last();
-
+out:
 	set_zone_contiguous(zone);
