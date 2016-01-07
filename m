From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-page_alloc-print-symbolic-gfp_flags-on-allocation-failure.patch removed
 from -mm tree
Date: Thu, 07 Jan 2016 15:50:16 -0800
Message-ID: <568ef9b8.MGSfgveUsQYN+XM3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34924 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbcAGXuR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jan 2016 18:50:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.com, minchan@kernel.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: print symbolic gfp_flags on allocation failure
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-print-symbolic-gfp_flags-on-allocation-failure.patch

This patch was dropped because an updated version will be merged

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
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-print-symbolic-gfp_flags-on-allocation-failure mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-print-symbolic-gfp_flags-on-allocation-failure
+++ a/mm/page_alloc.c
@@ -2703,9 +2703,9 @@ void warn_alloc_failed(gfp_t gfp_mask, u
 		va_end(args);
 	}
 
-	pr_warn("%s: page allocation failure: order:%u, mode:0x%x\n",
+	pr_warn("%s: page allocation failure: order:%u, mode:0x%x",
 		current->comm, order, gfp_mask);
