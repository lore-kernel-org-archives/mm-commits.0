From: akpm@linux-foundation.org
Subject: [merged]
 hwpoison-fix-race-with-changing-page-during-offlining-v2.patch removed from -mm tree
Date: Thu, 07 Aug 2014 13:05:21 -0700
Message-ID: <53e3dc01.oUSuXhktCJpJOXhQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f73.google.com ([209.85.218.73]:45832 "EHLO
	mail-oi0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbaHGUFV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:05:21 -0400
Received: by mail-oi0-f73.google.com with SMTP id u20so838042oif.2
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:05:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hwpoison: fix race with changing page during offlining
has been removed from the -mm tree.  Its filename was
     hwpoison-fix-race-with-changing-page-during-offlining-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: hwpoison: fix race with changing page during offlining

When a hwpoison page is locked it could change state due to parallel
modifications.  The original compound page can be torn down and then this
4k page becomes part of a differently-size compound page is is a
standalone regular page.

Check after the lock if the page is still the same compound page.

We could go back, grab the new head page and try again but it should be
quite rare, so I thought this was safest.  A retry loop would be more
difficult to test and may have more side effects.

The hwpoison code by design only tries to handle cases that are reasonably
common in workloads, as visible in page-flags.

I'm not really that concerned about handling this (likely rare case), just
not crashing on it.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN mm/memory-failure.c~hwpoison-fix-race-with-changing-page-during-offlining-v2 mm/memory-failure.c
--- a/mm/memory-failure.c~hwpoison-fix-race-with-changing-page-during-offlining-v2
+++ a/mm/memory-failure.c
@@ -1173,6 +1173,16 @@ int memory_failure(unsigned long pfn, in
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

origin.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

