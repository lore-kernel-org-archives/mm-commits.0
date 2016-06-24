From: akpm@linux-foundation.org
Subject: +
 mm-compaction-remove-unnecessary-order-check-in-try_to_compact_pages.patch
 added to -mm tree
Date: Fri, 24 Jun 2016 13:58:46 -0700
Message-ID: <576d9f06.fWXjfEOAcJvw3Xon%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40538 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbcFXU6w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2016 16:58:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: opensource.ganesh@gmail.com, iamjoonsoo.kim@lge.com, khandual@linux.vnet.ibm.com, mhocko@suse.com, mina86@mina86.com, minchan@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: remove unnecessary order check in try_to_compact_pages()
has been added to the -mm tree.  Its filename is
     mm-compaction-remove-unnecessary-order-check-in-try_to_compact_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-remove-unnecessary-order-check-in-try_to_compact_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-remove-unnecessary-order-check-in-try_to_compact_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -1689,7 +1689,7 @@ enum compact_result try_to_compact_pages
 	*contended = COMPACT_CONTENDED_NONE;
 
 	/* Check if the GFP flags allow compaction */
-	if (!order || !may_enter_fs || !may_perform_io)
+	if (!may_enter_fs || !may_perform_io)
 		return COMPACT_SKIPPED;
 
 	trace_mm_compaction_try_to_compact_pages(order, gfp_mask, mode);
_

Patches currently in -mm which might be from opensource.ganesh@gmail.com are

mm-migrate-support-non-lru-movable-page-migration-fix.patch
mm-zsmalloc-add-trace-events-for-zs_compact.patch
mm-compaction-remove-unnecessary-order-check-in-try_to_compact_pages.patch

