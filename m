Return-Path: <SRS0=SeUK=EF=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 675A0C2D0A3
	for <mm-commits@archiver.kernel.org>; Fri, 30 Oct 2020 00:30:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E838F2076B
	for <mm-commits@archiver.kernel.org>; Fri, 30 Oct 2020 00:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604017849;
	bh=7JoqI7FbaAp45frEQlGiyipYHqRA6RMiw82ZBLFBrv4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=gNnnBhlEFCF62fUpegxkHypJFGwJKi/L2cI2AR7+lI6eKxnRMwVFy6DAs2Mz/vZfz
	 CDyLUl2RlDSA6JYKLqFKCRAAEP4d+lsCOwX5QU9W6nTYEXLYmyYKjRqD8EjGvp5Ub9
	 FLqSww/PpCweLdt3cyj3lV6Ow+de2Yup38dp4Xbo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725780AbgJ3Aas (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Oct 2020 20:30:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbgJ3Aas (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 29 Oct 2020 20:30:48 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E67C320738;
        Fri, 30 Oct 2020 00:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604017847;
        bh=7JoqI7FbaAp45frEQlGiyipYHqRA6RMiw82ZBLFBrv4=;
        h=Date:From:To:Subject:From;
        b=ikmd5Zc7r1fsug8PL20ouEdso4gOqsxRofYsKlxKfnlCkFRcLaoLzdD/F68TV4tGB
         /O4NIoTprZqSNjJ1KgyOQmc7oCLi2+LXyc3dPiSm/gJRUvNBcL0gSjzRTybiOfstpd
         LlSGqzxVQXxxkVR/vfimwuGTm7YqIQ0hbk82uDX0=
Date:   Thu, 29 Oct 2020 17:30:46 -0700
From:   akpm@linux-foundation.org
To:     mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, riel@surriel.com, shy828301@gmail.com,
        vbabka@suse.cz, ziy@nvidia.com
Subject:  +
 mm-compaction-count-pages-and-stop-correctly-during-page-isolation.patch
 added to -mm tree
Message-ID: <20201030003046.5zGUnCC-I%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: count pages and stop correctly during page isolation
has been added to the -mm tree.  Its filename is
     mm-compaction-count-pages-and-stop-correctly-during-page-isolation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-count-pages-and-stop-correctly-during-page-isolation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-count-pages-and-stop-correctly-during-page-isolation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/compaction: count pages and stop correctly during page isolation

In isolate_migratepages_block, when cc->alloc_contig is true, we are able
to isolate compound pages, nr_migratepages and nr_isolated did not count
compound pages correctly, causing us to isolate more pages than we
thought.  Use thp_nr_pages to count pages.  Otherwise, we might be trapped
in too_many_isolated while loop, since the actual isolated pages can go up
to COMPACT_CLUSTER_MAX*512=3D16384, where COMPACT_CLUSTER_MAX is 32, since
we stop isolation after cc->nr_migratepages reaches to
COMPACT_CLUSTER_MAX.

In addition, after we fix the issue above, cc->nr_migratepages could never
be equal to COMPACT_CLUSTER_MAX if compound pages are isolated, thus page
isolation could not stop as we intended.  Change the isolation stop
condition to >=3D.

Link: https://lkml.kernel.org/r/20201029200435.3386066-1-zi.yan@sent.com
Fixes: 1da2f328fa64 ("cmm,thp,compaction,cma: allow THP migration for CMA allocations")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/compaction.c~mm-compaction-count-pages-and-stop-correctly-during-page-isolation
+++ a/mm/compaction.c
@@ -1012,8 +1012,8 @@ isolate_migratepages_block(struct compac
 
 isolate_success:
 		list_add(&page->lru, &cc->migratepages);
-		cc->nr_migratepages++;
-		nr_isolated++;
+		cc->nr_migratepages += thp_nr_pages(page);
+		nr_isolated += thp_nr_pages(page);
 
 		/*
 		 * Avoid isolating too much unless this block is being
@@ -1021,7 +1021,7 @@ isolate_success:
 		 * or a lock is contended. For contention, isolate quickly to
 		 * potentially remove one source of contention.
 		 */
-		if (cc->nr_migratepages == COMPACT_CLUSTER_MAX &&
+		if (cc->nr_migratepages >= COMPACT_CLUSTER_MAX &&
 		    !cc->rescan && !cc->contended) {
 			++low_pfn;
 			break;
@@ -1132,7 +1132,7 @@ isolate_migratepages_range(struct compac
 		if (!pfn)
 			break;
 
-		if (cc->nr_migratepages == COMPACT_CLUSTER_MAX)
+		if (cc->nr_migratepages >= COMPACT_CLUSTER_MAX)
 			break;
 	}
 
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-compaction-count-pages-and-stop-correctly-during-page-isolation.patch

