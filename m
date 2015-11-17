From: akpm@linux-foundation.org
Subject: + mm-cma-always-check-which-page-cause-allocation-failure.patch
 added to -mm tree
Date: Tue, 17 Nov 2015 14:42:54 -0800
Message-ID: <564bad6e./7hOEwuJI6AaunQ2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47111 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbbKQWmz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Nov 2015 17:42:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, iamjoonsoo.kim@lge.com, mina86@mina86.com, minchan@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma: always check which page caused allocation failure
has been added to the -mm tree.  Its filename is
     mm-cma-always-check-which-page-cause-allocation-failure.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-always-check-which-page-cause-allocation-failure.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-always-check-which-page-cause-allocation-failure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm/cma: always check which page caused allocation failure

Now, we have tracepoint in test_pages_isolated() to notify which pfn
cannot be isolated.  But in alloc_contig_range(), some error paths don't
call test_pages_isolated() so it's still hard to know the exact pfn that
caused allocation failure.

This patch changes this situation by calling test_pages_isolated() in
error paths.  In the allocation failure case, some overhead is added by
this change, but allocation failure is a really rare event so it does not
matter.

In the fatal signal pending case, we don't call test_pages_isolated()
because this failure is an intentional one.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-cma-always-check-which-page-cause-allocation-failure mm/page_alloc.c
--- a/mm/page_alloc.c~mm-cma-always-check-which-page-cause-allocation-failure
+++ a/mm/page_alloc.c
@@ -6724,8 +6724,12 @@ int alloc_contig_range(unsigned long sta
 	if (ret)
 		return ret;
 
+	/*
+	 * In case of -EBUSY, we'd like to know which page causes problem.
+	 * So, just fall through. We will check it in test_pages_isolated().
+	 */
 	ret = __alloc_contig_migrate_range(&cc, start, end);
-	if (ret)
+	if (ret && ret != -EBUSY)
 		goto done;
 
 	/*
@@ -6752,8 +6756,8 @@ int alloc_contig_range(unsigned long sta
 	outer_start = start;
 	while (!PageBuddy(pfn_to_page(outer_start))) {
 		if (++order >= MAX_ORDER) {
-			ret = -EBUSY;
-			goto done;
+			outer_start = start;
+			break;
 		}
 		outer_start &= ~0UL << order;
 	}
_

Patches currently in -mm which might be from js1304@gmail.com are

mm-page_isolation-return-last-tested-pfn-rather-than-failure-indicator.patch
mm-page_isolation-add-new-tracepoint-test_pages_isolated.patch
mm-cma-always-check-which-page-cause-allocation-failure.patch

