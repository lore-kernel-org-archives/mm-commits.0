From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix.patch removed from -mm tree
Date: Fri, 06 Nov 2015 16:08:31 -0800
Message-ID: <563d40ff.nDneCyWH0Rpsd1TO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52611 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757821AbbKGAIc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 19:08:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mgorman@techsingularity.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix.patch

This patch was dropped because it was folded into mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix

fix build

Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 mm/page_alloc.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix mm/memcontrol.c
--- a/mm/memcontrol.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix
+++ a/mm/memcontrol.c
@@ -2120,7 +2120,7 @@ done_restock:
 	/*
 	 * If the hierarchy is above the normal consumption range, schedule
 	 * reclaim on returning to userland.  We can perform reclaim here
-	 * if __GFP_WAIT but let's always punt for simplicity and so that
+	 * if __GFP_RECLAIM but let's always punt for simplicity and so that
 	 * GFP_KERNEL can consistently be used during reclaim.  @memcg is
 	 * not recorded as it most likely matches current's and won't
 	 * change in the meantime.  As high limit is checked again before
diff -puN mm/page_alloc.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix
+++ a/mm/page_alloc.c
@@ -2183,7 +2183,8 @@ static bool should_fail_alloc_page(gfp_t
 		return false;
 	if (fail_page_alloc.ignore_gfp_highmem && (gfp_mask & __GFP_HIGHMEM))
 		return false;
-	if (fail_page_alloc.ignore_gfp_wait && (gfp_mask & __GFP_DIRECT_RECLAIM))
+	if (fail_page_alloc.ignore_gfp_reclaim &&
+			(gfp_mask & __GFP_DIRECT_RECLAIM))
 		return false;
 
 	return should_fail(&fail_page_alloc.attr, 1 << order);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-checkpatch-fixes.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix-99.patch
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix-fix.patch
include-linux-mmzoneh-reflow-comment.patch
mm-fs-introduce-mapping_gfp_constraint-checkpatch-fixes.patch
mm-memcontrolc-uninline-mem_cgroup_usage.patch
zsmalloc-add-comments-for-inuse-to-zspage-v2-fix.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
fs-jffs2-wbufc-remove-stray-semicolon.patch
lib-documentation-synchronize-%p-formatting-documentation-fix-fix.patch
rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe-fix.patch
dma-mapping-tidy-up-dma_parms-default-handling-fix.patch
panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out-fix.patch

