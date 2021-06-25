Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B44CC49EA6
	for <mm-commits@archiver.kernel.org>; Fri, 25 Jun 2021 01:40:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40BB8613BA
	for <mm-commits@archiver.kernel.org>; Fri, 25 Jun 2021 01:40:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233028AbhFYBm2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Jun 2021 21:42:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:33258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232993AbhFYBm2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 24 Jun 2021 21:42:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 139D1613B9;
        Fri, 25 Jun 2021 01:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624585208;
        bh=wub0Ep+mr2DVrtJVDWiEVD8T/w0yF1osYmCdLbJ3AQg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=oAHV6BimLjnwccuIZmeARj9Q5f2oQk4/mlEzrwKvQlbrG7+d3RVseILFCX4fGKi4W
         GSUy9p6Mk2FGkvdhD9V6Hmt5GDGtPBB6gDVkU+RdOxG1Oa+L7JUNpxg7GVm4zImHv0
         OScX3BZmZkrq7MYFSx9DrUACCgHUFioC4WaZMLo0=
Date:   Thu, 24 Jun 2021 18:40:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, brouer@redhat.com,
        dan.carpenter@oracle.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mgorman@techsinguliarity.net,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 22/24] mm/page_alloc: do bulk array bounds check
 after checking populated elements
Message-ID: <20210625014007.ThvxOTuQ9%akpm@linux-foundation.org>
In-Reply-To: <20210624183838.ac3161ca4a43989665ac8b2f@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: do bulk array bounds check after checking populated elements

Dan Carpenter reported the following

  The patch 0f87d9d30f21: "mm/page_alloc: add an array-based interface
  to the bulk page allocator" from Apr 29, 2021, leads to the following
  static checker warning:

        mm/page_alloc.c:5338 __alloc_pages_bulk()
        warn: potentially one past the end of array 'page_array[nr_populated]'

The problem can occur if an array is passed in that is fully populated. 
That potentially ends up allocating a single page and storing it past the
end of the array.  This patch returns 0 if the array is fully populated.

Link: https://lkml.kernel.org/r/20210618125102.GU30378@techsingularity.net
Fixes: 0f87d9d30f21 ("mm/page_alloc: add an array-based interface to the bulk page allocator")
Signed-off-by: Mel Gorman <mgorman@techsinguliarity.net>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-do-bulk-array-bounds-check-after-checking-populated-elements
+++ a/mm/page_alloc.c
@@ -5056,6 +5056,10 @@ unsigned long __alloc_pages_bulk(gfp_t g
 	while (page_array && nr_populated < nr_pages && page_array[nr_populated])
 		nr_populated++;
 
+	/* Already populated array? */
+	if (unlikely(page_array && nr_pages - nr_populated == 0))
+		return 0;
+
 	/* Use the single page allocator for one page. */
 	if (nr_pages - nr_populated == 1)
 		goto failed;
_
