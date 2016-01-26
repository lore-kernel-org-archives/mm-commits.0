From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-print-symbolic-gfp_flags-on-allocation-failure.patch added to -mm tree
Date: Tue, 26 Jan 2016 13:04:10 -0800
Message-ID: <56a7df4a.wSUT7KMZgtbYUdvf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50908 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbcAZVEL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 16:04:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.com, minchan@kernel.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: print symbolic gfp_flags on allocation failure
has been added to the -mm tree.  Its filename is
     mm-page_alloc-print-symbolic-gfp_flags-on-allocation-failure.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-print-symbolic-gfp_flags-on-allocation-failure.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-print-symbolic-gfp_flags-on-allocation-failure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_alloc: print symbolic gfp_flags on allocation failure

It would be useful to translate gfp_flags into string representation when
printing in case of an allocation failure, especially as the flags have
been undergoing some changes recently and the script
./scripts/gfp-translate needs a matching source version to be accurate.

Example output:

stapio: page allocation failure: order:9, mode:0x2080020(GFP_ATOMIC)

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-print-symbolic-gfp_flags-on-allocation-failure mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-print-symbolic-gfp_flags-on-allocation-failure
+++ a/mm/page_alloc.c
@@ -2703,9 +2703,8 @@ void warn_alloc_failed(gfp_t gfp_mask, u
 		va_end(args);
 	}
 
-	pr_warn("%s: page allocation failure: order:%u, mode:0x%x\n",
-		current->comm, order, gfp_mask);
