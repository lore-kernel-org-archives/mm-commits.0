From: akpm@linux-foundation.org
Subject: + mmcompaction-direct-compact-when-a-high-order-allocation-fails-fix.patch added to -mm tree
Date: Wed, 05 May 2010 08:47:20 -0400
Message-ID: <201005051548.o45FmpME001026@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48572 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754549Ab0EEPuC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 May 2010 11:50:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, mel@csn.ul.ie


The patch titled
     fix count_vm_event preempt in memory compaction direct reclaim
has been added to the -mm tree.  Its filename is
     mmcompaction-direct-compact-when-a-high-order-allocation-fails-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix count_vm_event preempt in memory compaction direct reclaim
From: Andrea Arcangeli <aarcange@redhat.com>

Preempt is enabled so it must use count_vm_event.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mmcompaction-direct-compact-when-a-high-order-allocation-fails-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mmcompaction-direct-compact-when-a-high-order-allocation-fails-fix
+++ a/mm/page_alloc.c
@@ -1788,7 +1788,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 				alloc_flags, preferred_zone,
 				migratetype);
 		if (page) {
-			__count_vm_event(COMPACTSUCCESS);
+			count_vm_event(COMPACTSUCCESS);
 			return page;
 		}
 
_

Patches currently in -mm which might be from aarcange@redhat.com are

rmap-remove-anon_vma-check-in-page_address_in_vma.patch
define-madv_hugepage.patch
mincore-cleanups.patch
mincore-break-do_mincore-into-logical-pieces.patch
mincore-pass-ranges-as-startend-address-pairs.patch
mincore-do-nested-page-table-walks.patch
mmcompaction-memory-compaction-core.patch
mmcompaction-direct-compact-when-a-high-order-allocation-fails-fix.patch
mm-document-follow_page.patch

