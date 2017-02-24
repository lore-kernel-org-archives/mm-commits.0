From: akpm@linux-foundation.org
Subject: [patch 084/124] mm/page_alloc.c: remove redundant init code for
 ZONE_MOVABLE
Date: Fri, 24 Feb 2017 14:59:45 -0800
Message-ID: <58b0bae1.r5UG4fVAHhZb/KfO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38818 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751660AbdBXW7q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:59:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, richard.weiyang@gmail.com, khandual@linux.vnet.ibm.com, mgorman@techsingularity.net, mhocko@suse.com

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
@@ -6489,8 +6489,6 @@ void __init free_area_init_nodes(unsigne
 
 		start_pfn = end_pfn;
 	}
-	arch_zone_lowest_possible_pfn[ZONE_MOVABLE] = 0;
-	arch_zone_highest_possible_pfn[ZONE_MOVABLE] = 0;
 
 	/* Find the PFNs that ZONE_MOVABLE begins at in each node */
 	memset(zone_movable_pfn, 0, sizeof(zone_movable_pfn));
_
