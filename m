From: akpm@linux-foundation.org
Subject: +
 mm-cma-always-check-which-page-cause-allocation-failure-v2.patch added to
 -mm tree
Date: Wed, 25 Nov 2015 14:06:24 -0800
Message-ID: <565630e0.zVPwwpk0BsmR5j8E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57331 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbbKYWGZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Nov 2015 17:06:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, iamjoonsoo.kim@lge.com, mina86@mina86.com, minchan@kernel.org, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma: always check which page cause allocation failure
has been added to the -mm tree.  Its filename is
     mm-cma-always-check-which-page-cause-allocation-failure-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-always-check-which-page-cause-allocation-failure-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-always-check-which-page-cause-allocation-failure-v2.patch

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
Subject: mm/cma: always check which page cause allocation failure

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN mm/page_alloc.c~mm-cma-always-check-which-page-cause-allocation-failure-v2 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-cma-always-check-which-page-cause-allocation-failure-v2
+++ a/mm/page_alloc.c
@@ -6763,6 +6763,19 @@ int alloc_contig_range(unsigned long sta
 		outer_start &= ~0UL << order;
 	}
 
+	if (outer_start != start) {
+		order = page_order(pfn_to_page(outer_start));
+
+		/*
+		 * outer_start page could be small order buddy page and
+		 * it doesn't include start page. Adjust outer_start
+		 * in this case to report failed page properly
+		 * on tracepoint in test_pages_isolated()
+		 */
+		if (outer_start + (1UL << order) <= start)
+			outer_start = start;
+	}
+
 	/* Make sure the range is really isolated. */
 	if (test_pages_isolated(outer_start, end, false)) {
 		pr_info("%s: [%lx, %lx) PFNs busy\n",
_

Patches currently in -mm which might be from js1304@gmail.com are

mm-page_isolation-return-last-tested-pfn-rather-than-failure-indicator.patch
mm-page_isolation-add-new-tracepoint-test_pages_isolated.patch
mm-cma-always-check-which-page-cause-allocation-failure.patch
mm-cma-always-check-which-page-cause-allocation-failure-v2.patch

