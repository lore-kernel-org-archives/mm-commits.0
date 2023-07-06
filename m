Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36AE2EB64D9
	for <mm-commits@archiver.kernel.org>; Thu,  6 Jul 2023 20:11:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbjGFUL0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Jul 2023 16:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbjGFULZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2023 16:11:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5900A10EA
        for <mm-commits@vger.kernel.org>; Thu,  6 Jul 2023 13:11:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EACCA612CE
        for <mm-commits@vger.kernel.org>; Thu,  6 Jul 2023 20:11:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4953CC433C7;
        Thu,  6 Jul 2023 20:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688674283;
        bh=1V5ntQU3zTtI9OpVGKVW/qHGHexqlcrvy0llW+OyiEE=;
        h=Date:To:From:Subject:From;
        b=AYMoqtTR6KdXZYyDtNQqJ2XeNgavfI+5n/qo8zkzTMl7RQwbRmIn+QOt2OQ2EDObd
         fAPAMIYOOUvbC+SCP/V6cCMjBQ6hyhov2h8mf7543ZQifj24tBBE6SnuYZJ1939xnT
         vCKeoUTeRIGbOWZLPqAYKCf6jDHnzq64LtOJMSoU=
Date:   Thu, 06 Jul 2023 13:11:22 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        oliver.sang@intel.com, mike.kravetz@oracle.com,
        ackerleytng@google.com, fengwei.yin@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] readahead-correct-the-start-and-size-in-ondemand_readahead.patch removed from -mm tree
Message-Id: <20230706201123.4953CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: readahead: correct the start and size in ondemand_readahead()
has been removed from the -mm tree.  Its filename was
     readahead-correct-the-start-and-size-in-ondemand_readahead.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Yin Fengwei <fengwei.yin@intel.com>
Subject: readahead: correct the start and size in ondemand_readahead()
Date: Wed, 28 Jun 2023 12:43:03 +0800

Commit 9425c591e06a ("page cache: fix page_cache_next/prev_miss off by
one") updated the page_cache_next_miss() to return the index beyond range.

But it breaks the start/size of ra in ondemand_readahead() because the
offset by one is accumulated to readahead_index.  As a consequence, not
best readahead order is picked.

Tracing of the order parameter of filemap_alloc_folio() showed:
     page order    : count     distribution
        0          : 892073   |                                        |
        1          : 0        |                                        |
        2          : 65120457 |****************************************|
        3          : 32914005 |********************                    |
        4          : 33020991 |********************                    |
with 9425c591e06a9.

With parent commit:
     page order    : count     distribution
        0          : 3417288  |****                                    |
        1          : 0        |                                        |
        2          : 877012   |*                                       |
        3          : 288      |                                        |
        4          : 5607522  |*******                                 |
        5          : 29974228 |****************************************|

Fix the issue by removing the offset by one when page_cache_next_miss()
returns no gaps in the range.

After the fix:
    page order     : count     distribution
        0          : 2598561  |***                                     |
        1          : 0        |                                        |
        2          : 687739   |                                        |
        3          : 288      |                                        |
        4          : 207210   |                                        |
        5          : 32628260 |****************************************|

Link: https://lkml.kernel.org/r/20230628044303.1412624-1-fengwei.yin@intel.com
Fixes: 9425c591e06a ("page cache: fix page_cache_next/prev_miss off by one")
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202306211346.1e9ff03e-oliver.sang@intel.com
Signed-off-by: Yin Fengwei <fengwei.yin@intel.com>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/mm/readahead.c~readahead-correct-the-start-and-size-in-ondemand_readahead
+++ a/mm/readahead.c
@@ -613,9 +613,17 @@ static void ondemand_readahead(struct re
 				max_pages);
 		rcu_read_unlock();
 
-		if (!start || start - index > max_pages)
+		if (!start || start - index - 1 > max_pages)
 			return;
 
+		/*
+		 * If no gaps in the range, page_cache_next_miss() returns
+		 * index beyond range. Adjust it back to make sure
+		 * ractl->_index is updated correctly later.
+		 */
+		if ((start - index - 1) == max_pages)
+			start--;
+
 		ra->start = start;
 		ra->size = start - index;	/* old async_size */
 		ra->size += req_size;
_

Patches currently in -mm which might be from fengwei.yin@intel.com are


