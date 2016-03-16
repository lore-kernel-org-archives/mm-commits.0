From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-print-symbolic-gfp_flags-on-allocation-failure.patch removed
 from -mm tree
Date: Wed, 16 Mar 2016 12:55:53 -0700
Message-ID: <56e9ba49.1LCeUzBF7zIUpMmm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38777 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934033AbcCPTzy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:55:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.com, minchan@kernel.org, rientjes@google.com, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: print symbolic gfp_flags on allocation failure
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-print-symbolic-gfp_flags-on-allocation-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: David Rientjes <rientjes@google.com>
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
@@ -2695,9 +2695,8 @@ void warn_alloc_failed(gfp_t gfp_mask, u
 		va_end(args);
 	}
 
-	pr_warn("%s: page allocation failure: order:%u, mode:0x%x\n",
-		current->comm, order, gfp_mask);
