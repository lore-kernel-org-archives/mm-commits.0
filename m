From: akpm@linux-foundation.org
Subject: + mm-page_alloc-remove-redundant-init-code-for-zone_movable.patch added to -mm tree
Date: Wed, 15 Feb 2017 12:54:14 -0800
Message-ID: <58a4bff6.cpAzPfR5AJkUvebU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41412 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751299AbdBOUyP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Feb 2017 15:54:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard.weiyang@gmail.com, khandual@linux.vnet.ibm.com, mgorman@techsingularity.net, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: remove redundant init code for ZONE_MOVABLE
has been added to the -mm tree.  Its filename is
     mm-page_alloc-remove-redundant-init-code-for-zone_movable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-remove-redundant-init-code-for-zone_movable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-remove-redundant-init-code-for-zone_movable.patch

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
Subject: mm/page_alloc.c: remove redundant init code for ZONE_MOVABLE

arch_zone_lowest/highest_possible_pfn[] is set to 0 and [ZONE_MOVABLE] is
skipped in the loop. No need to reset them to 0 again.

This patch just removes the redundant code.

Link: http://lkml.kernel.org/r/20170209141731.60208-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-remove-redundant-init-code-for-zone_movable mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-remove-redundant-init-code-for-zone_movable
+++ a/mm/page_alloc.c
@@ -6494,8 +6494,6 @@ void __init free_area_init_nodes(unsigne
 
 		start_pfn = end_pfn;
 	}
-	arch_zone_lowest_possible_pfn[ZONE_MOVABLE] = 0;
-	arch_zone_highest_possible_pfn[ZONE_MOVABLE] = 0;
 
 	/* Find the PFNs that ZONE_MOVABLE begins at in each node */
 	memset(zone_movable_pfn, 0, sizeof(zone_movable_pfn));
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-memblockc-trivial-code-refine-in-memblock_is_region_memory.patch
mm-memblockc-check-return-value-of-memblock_reserve-in-memblock_virt_alloc_internal.patch
mm-page_alloc-return-0-in-case-this-node-has-no-page-within-the-zone.patch
mm-page_alloc-remove-redundant-init-code-for-zone_movable.patch

