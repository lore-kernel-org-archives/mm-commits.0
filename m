From: akpm@linux-foundation.org
Subject: + mm-hwpoison-use-compound_head-flags-for-huge-pages.patch added
 to -mm tree
Date: Thu, 01 Jun 2017 15:44:25 -0700
Message-ID: <593098c9.S9QgnsnDHkTMcznU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41794 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751105AbdFAWo0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2017 18:44:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: james.morse@arm.com, n-horiguchi@ah.jp.nec.com, punit.agrawal@arm.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: use compound_head() flags for huge pages
has been added to the -mm tree.  Its filename is
     mm-hwpoison-use-compound_head-flags-for-huge-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-use-compound_head-flags-for-huge-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-use-compound_head-flags-for-huge-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: James Morse <james.morse@arm.com>
Subject: mm/memory-failure.c: use compound_head() flags for huge pages

memory_failure() chooses a recovery action function based on the page
flags. For huge pages it uses the tail page flags which don't have
anything interesting set, resulting in:

> Memory failure: 0x9be3b4: Unknown page state
> Memory failure: 0x9be3b4: recovery action for unknown page: Failed

Instead, save a copy of the head page's flags if this is a huge page, this
means if there are no relevant flags for this tail page, we use the head
pages flags instead.  This results in the me_huge_page() recovery action
being called:

> Memory failure: 0x9b7969: recovery action for huge page: Delayed

For hugepages that have not yet been allocated, this allows the hugepage
to be dequeued.

Fixes: 524fca1e7356 ("HWPOISON: fix misjudgement of page_action() for errors on mlocked pages")
Link: http://lkml.kernel.org/r/20170524130204.21845-1-james.morse@arm.com
Signed-off-by: James Morse <james.morse@arm.com>
Tested-by: Punit Agrawal <punit.agrawal@arm.com>
Acked-by: Punit Agrawal <punit.agrawal@arm.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/memory-failure.c~mm-hwpoison-use-compound_head-flags-for-huge-pages mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-use-compound_head-flags-for-huge-pages
+++ a/mm/memory-failure.c
@@ -1184,7 +1184,10 @@ int memory_failure(unsigned long pfn, in
 	 * page_remove_rmap() in try_to_unmap_one(). So to determine page status
 	 * correctly, we save a copy of the page flags at this time.
 	 */
-	page_flags = p->flags;
+	if (PageHuge(p))
+		page_flags = hpage->flags;
+	else
+		page_flags = p->flags;
 
 	/*
 	 * unpoison always clear PG_hwpoison inside page lock
_

Patches currently in -mm which might be from james.morse@arm.com are

mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified.patch
mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified-v2.patch
mm-hwpoison-use-compound_head-flags-for-huge-pages.patch

