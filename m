From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_alloc-remove-unnecessary-initialisation-from-__alloc_pages_nodemask-fix.patch removed from -mm tree
Date: Thu, 19 May 2016 16:52:57 -0700
Message-ID: <573e51d9.1Bn/KhTQIrI/xDai%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45643 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233AbcESXw7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 19:52:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, brouer@redhat.com, mgorman@techsingularity.net, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-remove-unnecessary-initialisation-from-__alloc_pages_nodemask-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-unnecessary-initialisation-from-__alloc_pages_nodemask-fix.patch

This patch was dropped because it was folded into mm-page_alloc-remove-unnecessary-initialisation-from-__alloc_pages_nodemask.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-remove-unnecessary-initialisation-from-__alloc_pages_nodemask-fix

mm/page_alloc.c: In function '__alloc_pages_nodemask':
mm/page_alloc.c:3350: warning: 'page' may be used uninitialized in this function

Not feeling good about what happened in here.

Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-remove-unnecessary-initialisation-from-__alloc_pages_nodemask-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-remove-unnecessary-initialisation-from-__alloc_pages_nodemask-fix
+++ a/mm/page_alloc.c
@@ -3393,8 +3393,11 @@ retry_cpuset:
 	/* The preferred zone is used for statistics later */
 	preferred_zoneref = first_zones_zonelist(ac.zonelist, ac.high_zoneidx,
 				ac.nodemask, &ac.preferred_zone);
-	if (!ac.preferred_zone)
+	if (!ac.preferred_zone) {
+		page = NULL;
 		goto out;
+	}
+
 	ac.classzone_idx = zonelist_zone_idx(preferred_zoneref);
 
 	/* First allocation attempt */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-nodemaskh-create-next_node_in-helper.patch
mm-hugetlbc-use-first_memory_node.patch
mm-mempolicyc-offset_il_node-document-and-clarify.patch
mm-uninline-page_mapped.patch
mm-page_alloc-remove-unnecessary-initialisation-from-__alloc_pages_nodemask.patch
mm-page_alloc-shorten-the-page-allocator-fast-path-fix.patch
mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice-fix.patch
mm-page_alloc-un-inline-the-bad-part-of-free_pages_check-fix.patch
mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain-fix.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix-fix.patch

