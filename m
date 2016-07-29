From: akpm@linux-foundation.org
Subject: [merged]
 lib-stackdepotc-use-__gfp_nowarn-for-stack-allocations.patch removed from
 -mm tree
Date: Fri, 29 Jul 2016 11:57:26 -0700
Message-ID: <579ba716.Z6CZGlR2sqUZ1585%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37706 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbcG2S51 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:57:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, aryabinin@virtuozzo.com, glider@google.com, mgorman@techsingularity.net, mhocko@suse.cz, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot.c: use __GFP_NOWARN for stack allocations
has been removed from the -mm tree.  Its filename was
     lib-stackdepotc-use-__gfp_nowarn-for-stack-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: lib/stackdepot.c: use __GFP_NOWARN for stack allocations

This (large, atomic) allocation attempt can fail.  We expect and handle
that, so avoid the scary warning.

Link: http://lkml.kernel.org/r/20160720151905.GB19146@node.shutemov.name
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/stackdepot.c~lib-stackdepotc-use-__gfp_nowarn-for-stack-allocations lib/stackdepot.c
--- a/lib/stackdepot.c~lib-stackdepotc-use-__gfp_nowarn-for-stack-allocations
+++ a/lib/stackdepot.c
@@ -242,6 +242,7 @@ depot_stack_handle_t depot_save_stack(st
 		 */
 		alloc_flags &= ~GFP_ZONEMASK;
 		alloc_flags &= (GFP_ATOMIC | GFP_KERNEL);
+		alloc_flags |= __GFP_NOWARN;
 		page = alloc_pages(alloc_flags, STACK_ALLOC_ORDER);
 		if (page)
 			prealloc = page_address(page);
_

Patches currently in -mm which might be from kirill@shutemov.name are


