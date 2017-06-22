From: akpm@linux-foundation.org
Subject: +
 mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online-fix-2.patch added to -mm tree
Date: Thu, 22 Jun 2017 14:21:50 -0700
Message-ID: <594c34ee.OyAZSii/OS/KHX92%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49254 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753842AbdFVVV4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 22 Jun 2017 17:21:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard.weiyang@gmail.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: remove duplicate call for set_page_links
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/memory_hotplug: remove duplicate call for set_page_links

In move_pfn_range_to_zone(), memmap_init_zone() will call set_page_links
for each page.  This means we don't need to call it on each page
explicitly.

This patch just removes the loop.

Link: http://lkml.kernel.org/r/20170616092335.5177-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online-fix-2 mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online-fix-2
+++ a/mm/memory_hotplug.c
@@ -1103,10 +1103,6 @@ void move_pfn_range_to_zone(struct zone
 	 * are reserved so nobody should be touching them so we should be safe
 	 */
 	memmap_init_zone(nr_pages, nid, zone_idx(zone), start_pfn, MEMMAP_HOTPLUG);
-	for (i = 0; i < nr_pages; i++) {
-		unsigned long pfn = start_pfn + i;
-		set_page_links(pfn_to_page(pfn), zone_idx(zone), nid, pfn);
-	}
 
 	set_zone_contiguous(zone);
 }
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-slub-remove-a-redundant-assignment-in-___slab_alloc.patch
mm-slub-reset-cpu_slabs-pointer-in-deactivate_slab.patch
mm-slub-pack-red_left_pad-with-another-int-to-save-a-word.patch
mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial.patch
mm-slub-wrap-kmem_cache-cpu_partial-in-config-config_slub_cpu_partial.patch
mm-nobootmem-return-0-when-start_pfn-equals-end_pfn.patch
mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online-fix.patch
mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online-fix-2.patch
mm-page_alloc-return-0-in-case-this-node-has-no-page-within-the-zone.patch

