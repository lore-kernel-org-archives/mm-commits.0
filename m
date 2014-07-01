From: akpm@linux-foundation.org
Subject: + hwpoison-fix-race-with-changing-page-during-offlining-v2.patch
 added to -mm tree
Date: Tue, 01 Jul 2014 15:27:23 -0700
Message-ID: <53b335cb.Y9WYRBmHwSCsicV+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:38855 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030325AbaGAW1Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2014 18:27:24 -0400
Received: by mail-oa0-f74.google.com with SMTP id i7so2375238oag.3
        for <mm-commits@vger.kernel.org>; Tue, 01 Jul 2014 15:27:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hwpoison: fix race with changing page during offlining
has been added to the -mm tree.  Its filename is
     hwpoison-fix-race-with-changing-page-during-offlining-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hwpoison-fix-race-with-changing-page-during-offlining-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hwpoison-fix-race-with-changing-page-during-offlining-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: hwpoison: fix race with changing page during offlining

When a hwpoison page is locked it could change state due to parallel
modifications.  Check after the lock if the page is still the same
compound page.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN mm/memory-failure.c~hwpoison-fix-race-with-changing-page-during-offlining-v2 mm/memory-failure.c
--- a/mm/memory-failure.c~hwpoison-fix-race-with-changing-page-during-offlining-v2
+++ a/mm/memory-failure.c
@@ -1165,6 +1165,16 @@ int memory_failure(unsigned long pfn, in
 	lock_page(hpage);
 
 	/*
+	 * The page could have changed compound pages during the locking.
+	 * If this happens just bail out.
+	 */
+	if (compound_head(p) != hpage) {
+		action_result(pfn, "different compound page after locking", IGNORED);
+		res = -EBUSY;
+		goto out;
+	}
+
+	/*
 	 * We use page flags to determine what action should be taken, but
 	 * the flags can be modified by the error containment action.  One
 	 * example is an mlocked page, where PG_mlocked is cleared by
_

Patches currently in -mm which might be from ak@linux.intel.com are

hwpoison-fix-race-with-changing-page-during-offlining-v2.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

