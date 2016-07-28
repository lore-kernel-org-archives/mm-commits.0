From: akpm@linux-foundation.org
Subject: [patch 014/101] mm/compaction: remove unnecessary order check in
 try_to_compact_pages()
Date: Thu, 28 Jul 2016 15:45:13 -0700
Message-ID: <579a8af9.aHMHwaO80nPAVlBI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56630 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbcG1WpO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:45:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, opensource.ganesh@gmail.com, iamjoonsoo.kim@lge.com, khandual@linux.vnet.ibm.com, mhocko@suse.com, mina86@mina86.com, minchan@kernel.org, vbabka@suse.cz

From: Ganesh Mahendran <opensource.ganesh@gmail.com>
Subject: mm/compaction: remove unnecessary order check in try_to_compact_pages()

The caller __alloc_pages_direct_compact() already checked (order == 0) so
there's no need to check again.

Link: http://lkml.kernel.org/r/1465973568-3496-1-git-send-email-opensource.ganesh@gmail.com
Signed-off-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-compaction-remove-unnecessary-order-check-in-try_to_compact_pages mm/compaction.c
--- a/mm/compaction.c~mm-compaction-remove-unnecessary-order-check-in-try_to_compact_pages
+++ a/mm/compaction.c
@@ -1681,7 +1681,7 @@ enum compact_result try_to_compact_pages
 	*contended = COMPACT_CONTENDED_NONE;
 
 	/* Check if the GFP flags allow compaction */
-	if (!order || !may_enter_fs || !may_perform_io)
+	if (!may_enter_fs || !may_perform_io)
 		return COMPACT_SKIPPED;
 
 	trace_mm_compaction_try_to_compact_pages(order, gfp_mask, mode);
_
