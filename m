Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1732FC761A6
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:45:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233720AbjDFCpF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234987AbjDFCoc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:44:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B4C86B6
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:44:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE4D964272
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:44:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E4FC433D2;
        Thu,  6 Apr 2023 02:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749070;
        bh=UP5tY4IOBCBARGITpnC5R60BT5aWTOZN+cLsdvcsJk0=;
        h=Date:To:From:Subject:From;
        b=2qh2ZEwA+Ql1o+HZ8AL1gBtcexnngNFHvMtIaKNGd7erKSEZaxwT3VWzUBrZpuyNU
         y+vrkp0x4mKmGBjgKN+Vp75ltVgnSeHeGDBQnuZX9VDVrsOMICgdS03bqTyfKeGu3h
         3jHhpCux68n1ok4LE5CULck6VPMEGnOcxemauio0=
Date:   Wed, 05 Apr 2023 19:44:29 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@kernel.org,
        mike.kravetz@oracle.com, mgorman@suse.de, david@redhat.com,
        davem@davemloft.net, kirill.shutemov@linux.intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sparc-mm-fix-max_order-usage-in-tsb_grow.patch removed from -mm tree
Message-Id: <20230406024430.43E4FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: sparc/mm: fix MAX_ORDER usage in tsb_grow()
has been removed from the -mm tree.  Its filename was
     sparc-mm-fix-max_order-usage-in-tsb_grow.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: sparc/mm: fix MAX_ORDER usage in tsb_grow()
Date: Wed, 15 Mar 2023 14:31:24 +0300

Patch series "Fix confusion around MAX_ORDER".

MAX_ORDER currently defined as number of orders page allocator supports:
user can ask buddy allocator for page order between 0 and MAX_ORDER-1.

This definition is counter-intuitive and lead to number of bugs all over
the kernel.

Fix the bugs and then change the definition of MAX_ORDER to be
inclusive: the range of orders user can ask from buddy allocator is
0..MAX_ORDER now.


This patch (of 10):

MAX_ORDER is not inclusive: the maximum allocation order buddy allocator
can deliver is MAX_ORDER-1.

Fix MAX_ORDER usage in tsb_grow().

Link: https://lkml.kernel.org/r/20230315113133.11326-1-kirill.shutemov@linux.intel.com
Link: https://lkml.kernel.org/r/20230315113133.11326-2-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: David Miller <davem@davemloft.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/tsb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/sparc/mm/tsb.c~sparc-mm-fix-max_order-usage-in-tsb_grow
+++ a/arch/sparc/mm/tsb.c
@@ -402,8 +402,8 @@ void tsb_grow(struct mm_struct *mm, unsi
 	unsigned long new_rss_limit;
 	gfp_t gfp_flags;
 
-	if (max_tsb_size > (PAGE_SIZE << MAX_ORDER))
-		max_tsb_size = (PAGE_SIZE << MAX_ORDER);
+	if (max_tsb_size > (PAGE_SIZE << (MAX_ORDER - 1)))
+		max_tsb_size = (PAGE_SIZE << (MAX_ORDER - 1));
 
 	new_cache_index = 0;
 	for (new_size = 8192; new_size < max_tsb_size; new_size <<= 1UL) {
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are


