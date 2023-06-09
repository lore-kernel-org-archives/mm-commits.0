Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28230C7EE43
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:32:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbjFIXc3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232573AbjFIXbh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:31:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD0F84688
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D41460FCA
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012B1C433D2;
        Fri,  9 Jun 2023 23:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353361;
        bh=9jMNKFwWL/DGUenXdm9NfnKmPZ3s20ThY5LFJmNjDOY=;
        h=Date:To:From:Subject:From;
        b=CWR8362CT7PgfpJm92p/PwHHC/ylpaoYXkBfIJ4y4I4CnMm/WXxNuAeAKpZxjpvVy
         jb1o1bc3Y3Ef5yQ5XHl8Q4g7/jMu13kmqGeLoJjF3nGO7ilWdeIr2ihlUROsR9liKU
         P/d26In/JFdLFlEIwcmkLNNKmIsjaXtxk53MGB2o=
Date:   Fri, 09 Jun 2023 16:29:20 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        mgorman@techsingularity.net, baolin.wang@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-skip-more-fully-scanned-pageblock.patch removed from -mm tree
Message-Id: <20230609232921.012B1C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: compaction: skip more fully scanned pageblock
has been removed from the -mm tree.  Its filename was
     mm-compaction-skip-more-fully-scanned-pageblock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: compaction: skip more fully scanned pageblock
Date: Thu, 25 May 2023 20:53:58 +0800

In fast_isolate_around(), it assumes the pageblock is fully scanned if
cc->nr_freepages < cc->nr_migratepages after trying to isolate some free
pages, and will set skip flag to avoid scanning in future.  However this
can miss setting the skip flag for a fully scanned pageblock (returned
'start_pfn' is equal to 'end_pfn') in the case where cc->nr_freepages is
larger than cc->nr_migratepages.

So using the returned 'start_pfn' from isolate_freepages_block() and
'end_pfn' to decide if a pageblock is fully scanned makes more sense.  It
can also cover the case where cc->nr_freepages < cc->nr_migratepages,
which means the 'start_pfn' is usually equal to 'end_pfn' except some
uncommon fatal error occurs after non-strict mode isolation.

Link: https://lkml.kernel.org/r/f4efd2fa08735794a6d809da3249b6715ba6ad38.1685018752.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-skip-more-fully-scanned-pageblock
+++ a/mm/compaction.c
@@ -1389,7 +1389,7 @@ fast_isolate_around(struct compact_contr
 	isolate_freepages_block(cc, &start_pfn, end_pfn, &cc->freepages, 1, false);
 
 	/* Skip this pageblock in the future as it's full or nearly full */
-	if (cc->nr_freepages < cc->nr_migratepages)
+	if (start_pfn == end_pfn)
 		set_pageblock_skip(page);
 
 	return;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


