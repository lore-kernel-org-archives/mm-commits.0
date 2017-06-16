From: akpm@linux-foundation.org
Subject: [patch 1/5] mm/memory-failure.c: use compound_head() flags for
 huge pages
Date: Fri, 16 Jun 2017 14:02:29 -0700
Message-ID: <59444765.ADsBnBCE/0u9ytwU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47714 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751818AbdFPVCa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jun 2017 17:02:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, james.morse@arm.com, n-horiguchi@ah.jp.nec.com, punit.agrawal@arm.com, stable@vger.kernel.org

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
