From: akpm@linux-foundation.org
Subject: +
 mm-madvise-ensure-poisoned-pages-are-removed-from-per-cpu-lists.patch added to -mm tree
Date: Mon, 28 Aug 2017 14:57:02 -0700
Message-ID: <59a491ae.fXK29qGTwfux13Tl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35626 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750841AbdH1V5D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Aug 2017 17:57:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, dave.hansen@intel.com, nao.horiguchi@gmail.com, rientjes@google.com, stable@vger.kernel.org, tony.luck@intel.com, wendy.wang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, madvise: ensure poisoned pages are removed from per-cpu lists
has been added to the -mm tree.  Its filename is
     mm-madvise-ensure-poisoned-pages-are-removed-from-per-cpu-lists.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-madvise-ensure-poisoned-pages-are-removed-from-per-cpu-lists.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-madvise-ensure-poisoned-pages-are-removed-from-per-cpu-lists.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, madvise: ensure poisoned pages are removed from per-cpu lists

Wendy Wang reported off-list that a RAS HWPOISON-SOFT test case failed and
bisected it to the commit 479f854a207c ("mm, page_alloc: defer debugging
checks of pages allocated from the PCP").  The problem is that a page that
was poisoned with madvise() is reused.  The commit removed a check that
would trigger if DEBUG_VM was enabled but re-enabling the check only fixes
the problem as a side-effect by printing a bad_page warning and
recovering.

The root of the problem is that an madvise() can leave a poisoned page on
the per-cpu list.  This patch drains all per-cpu lists after pages are
poisoned so that they will not be reused.  Wendy reports that the test
case in question passes with this patch applied.  While this could be done
in a targeted fashion, it is over-complicated for such a rare operation.

Link: http://lkml.kernel.org/r/20170828133414.7qro57jbepdcyz5x@techsingularity.net
Fixes: 479f854a207c ("mm, page_alloc: defer debugging checks of pages allocated from the PCP")
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reported-by: Wang, Wendy <wendy.wang@intel.com>
Tested-by: Wang, Wendy <wendy.wang@intel.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: "Hansen, Dave" <dave.hansen@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/madvise.c~mm-madvise-ensure-poisoned-pages-are-removed-from-per-cpu-lists mm/madvise.c
--- a/mm/madvise.c~mm-madvise-ensure-poisoned-pages-are-removed-from-per-cpu-lists
+++ a/mm/madvise.c
@@ -613,6 +613,7 @@ static int madvise_inject_error(int beha
 		unsigned long start, unsigned long end)
 {
 	struct page *page;
+	struct zone *zone;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -646,6 +647,11 @@ static int madvise_inject_error(int beha
 		if (ret)
 			return ret;
 	}
+
+	/* Ensure that all poisoned pages are removed from per-cpu lists */
+	for_each_populated_zone(zone)
+		drain_all_pages(zone);
+
 	return 0;
 }
 #endif
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-madvise-ensure-poisoned-pages-are-removed-from-per-cpu-lists.patch
mm-always-flush-vma-ranges-affected-by-zap_page_range-v2.patch

