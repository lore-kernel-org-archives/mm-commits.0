From: akpm@linux-foundation.org
Subject: + mm-page_ref-use-atomic_set_release-in-page_ref_unfreeze.patch
 added to -mm tree
Date: Fri, 16 Feb 2018 16:19:52 -0800
Message-ID: <5a877528.VL25A+bABnKs8+ot%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44390 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751038AbeBQATy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Feb 2018 19:19:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@yandex-team.ru, kirill.shutemov@linux.intel.com, mhocko@suse.com, npiggin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_ref: use atomic_set_release in page_ref_unfreeze
has been added to the -mm tree.  Its filename is
     mm-page_ref-use-atomic_set_release-in-page_ref_unfreeze.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_ref-use-atomic_set_release-in-page_ref_unfreeze.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_ref-use-atomic_set_release-in-page_ref_unfreeze.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: mm/page_ref: use atomic_set_release in page_ref_unfreeze

page_ref_unfreeze() has exactly that semantic.  No functional changes:
just minus one barrier and proper handling of PPro errata.

Link: http://lkml.kernel.org/r/151844393004.210639.4672319312617954272.stgit@buzz
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_ref.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN include/linux/page_ref.h~mm-page_ref-use-atomic_set_release-in-page_ref_unfreeze include/linux/page_ref.h
--- a/include/linux/page_ref.h~mm-page_ref-use-atomic_set_release-in-page_ref_unfreeze
+++ a/include/linux/page_ref.h
@@ -175,8 +175,7 @@ static inline void page_ref_unfreeze(str
 	VM_BUG_ON_PAGE(page_count(page) != 0, page);
 	VM_BUG_ON(count == 0);
 
-	smp_mb();
-	atomic_set(&page->_refcount, count);
+	atomic_set_release(&page->_refcount, count);
 	if (page_ref_tracepoint_active(__tracepoint_page_ref_unfreeze))
 		__page_ref_unfreeze(page, count);
 }
_

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are

mm-page_ref-use-atomic_set_release-in-page_ref_unfreeze.patch
mm-huge_memoryc-reorder-operations-in-__split_huge_page_tail.patch

