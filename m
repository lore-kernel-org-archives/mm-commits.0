From: akpm@linux-foundation.org
Subject: +
 mm-page_ref-ensure-page_ref_unfreeze-is-ordered-against-prior-accesses.patch added to -mm tree
Date: Thu, 15 Jun 2017 13:31:44 -0700
Message-ID: <5942eeb0./k/QI86zAYY3b0y2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35352 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752271AbdFOUcA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jun 2017 16:32:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: will.deacon@arm.com, kirill.shutemov@linux.intel.com, mark.rutland@arm.com, mgorman@suse.de, steve.capper@arm.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/page_ref.h: ensure page_ref_unfreeze is ordered against prior accesses
has been added to the -mm tree.  Its filename is
     mm-page_ref-ensure-page_ref_unfreeze-is-ordered-against-prior-accesses.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_ref-ensure-page_ref_unfreeze-is-ordered-against-prior-accesses.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_ref-ensure-page_ref_unfreeze-is-ordered-against-prior-accesses.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-gup-remove-broken-vm_bug_on_page-compound-check-for-hugepages.patch
mm-page_ref-ensure-page_ref_unfreeze-is-ordered-against-prior-accesses.patch
mm-migrate-stabilise-page-count-when-migrating-transparent-hugepages.patch

