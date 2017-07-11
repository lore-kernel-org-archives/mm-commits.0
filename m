From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?mm-page=5Fref-ensure-page=5Fref=5Funfreeze-is-ordered-agai?=
 =?US-ASCII?Q?nst-prior-accesses.patch?= removed from -mm tree
Date: Tue, 11 Jul 2017 12:23:43 -0700
Message-ID: <20170711192343.DJuxyQ4L_%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47698 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933729AbdGKTXo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:23:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mark.rutland@arm.com, mgorman@suse.de, mm-commits@vger.kernel.org, steve.capper@arm.com, vbabka@suse.cz, will.deacon@arm.com


The patch titled
     Subject: include/linux/page_ref.h: ensure page_ref_unfreeze is ordered against prior accesses
has been removed from the -mm tree.  Its filename was
     mm-page_ref-ensure-page_ref_unfreeze-is-ordered-against-prior-accesses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Will Deacon <will.deacon@arm.com>
Subject: include/linux/page_ref.h: ensure page_ref_unfreeze is ordered against prior accesses

page_ref_freeze and page_ref_unfreeze are designed to be used as a pair,
wrapping a critical section where struct pages can be modified without
having to worry about consistency for a concurrent fast-GUP.

Whilst page_ref_freeze has full barrier semantics due to its use of
atomic_cmpxchg, page_ref_unfreeze is implemented using atomic_set, which
doesn't provide any barrier semantics and allows the operation to be
reordered with respect to page modifications in the critical section.

This patch ensures that page_ref_unfreeze is ordered after any critical
section updates, by invoking smp_mb() prior to the atomic_set.

Link: http://lkml.kernel.org/r/1497349722-6731-3-git-send-email-will.deacon@arm.com
Signed-off-by: Will Deacon <will.deacon@arm.com>
Acked-by: Steve Capper <steve.capper@arm.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_ref.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/page_ref.h~mm-page_ref-ensure-page_ref_unfreeze-is-ordered-against-prior-accesses include/linux/page_ref.h
--- a/include/linux/page_ref.h~mm-page_ref-ensure-page_ref_unfreeze-is-ordered-against-prior-accesses
+++ a/include/linux/page_ref.h
@@ -174,6 +174,7 @@ static inline void page_ref_unfreeze(str
 	VM_BUG_ON_PAGE(page_count(page) != 0, page);
 	VM_BUG_ON(count == 0);
 
+	smp_mb();
 	atomic_set(&page->_refcount, count);
 	if (page_ref_tracepoint_active(__tracepoint_page_ref_unfreeze))
 		__page_ref_unfreeze(page, count);
_

Patches currently in -mm which might be from will.deacon@arm.com are


