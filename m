From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_alloc-shorten-the-page-allocator-fast-path-fix.patch removed from
 -mm tree
Date: Thu, 19 May 2016 16:56:01 -0700
Message-ID: <573e5291.8uTKvu4O6Yosli15%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45761 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbcESX4C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 19:56:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mgorman@techsingularity.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-shorten-the-page-allocator-fast-path-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-shorten-the-page-allocator-fast-path-fix.patch

This patch was dropped because it was folded into mm-page_alloc-shorten-the-page-allocator-fast-path.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-shorten-the-page-allocator-fast-path-fix

Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-shorten-the-page-allocator-fast-path-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-shorten-the-page-allocator-fast-path-fix
+++ a/mm/page_alloc.c
@@ -3398,7 +3398,7 @@ retry_cpuset:
 				ac.nodemask, &ac.preferred_zone);
 	if (!ac.preferred_zone) {
 		page = NULL;
-		goto out;
+		goto no_zone;
 	}
 
 	ac.classzone_idx = zonelist_zone_idx(preferred_zoneref);
@@ -3417,7 +3417,7 @@ retry_cpuset:
 
 	page = __alloc_pages_slowpath(alloc_mask, order, &ac);
 
-out:
+no_zone:
 	/*
 	 * When updating a task's mems_allowed, it is possible to race with
 	 * parallel threads in such a way that an allocation can fail while
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-nodemaskh-create-next_node_in-helper.patch
mm-hugetlbc-use-first_memory_node.patch
mm-mempolicyc-offset_il_node-document-and-clarify.patch
mm-uninline-page_mapped.patch
mm-page_alloc-shorten-the-page-allocator-fast-path.patch
mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice-fix.patch
mm-page_alloc-un-inline-the-bad-part-of-free_pages_check-fix.patch
mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain-fix.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix-fix.patch

