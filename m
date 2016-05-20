From: akpm@linux-foundation.org
Subject: [merged] mm-page_alloc-simplify-last-cpupid-reset.patch removed
 from -mm tree
Date: Fri, 20 May 2016 14:06:34 -0700
Message-ID: <573f7c5a.gfVAYR3JsusM0HEh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47339 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbcETVGf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:06:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: simplify last cpupid reset
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-simplify-last-cpupid-reset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: simplify last cpupid reset

The current reset unnecessarily clears flags and makes pointless calculations.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN include/linux/mm.h~mm-page_alloc-simplify-last-cpupid-reset include/linux/mm.h
--- a/include/linux/mm.h~mm-page_alloc-simplify-last-cpupid-reset
+++ a/include/linux/mm.h
@@ -850,10 +850,7 @@ extern int page_cpupid_xchg_last(struct
 
 static inline void page_cpupid_reset_last(struct page *page)
 {
-	int cpupid = (1 << LAST_CPUPID_SHIFT) - 1;
