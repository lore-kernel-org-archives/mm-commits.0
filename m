Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64E82EB64D7
	for <mm-commits@archiver.kernel.org>; Fri, 23 Jun 2023 23:53:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbjFWXxH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 19:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbjFWXxG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 19:53:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A288B2706
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 16:53:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F78C61458
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 23:53:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851E7C433C8;
        Fri, 23 Jun 2023 23:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687564384;
        bh=gvVW03d8jJQ8xbzj6lO5rbr9xWDdY09ULHxKY1p1BPI=;
        h=Date:To:From:Subject:From;
        b=WiLeNs7kHoY7vEPTGQkeGH4kuskymamfnftdtLcL6l/wqmG1kZlqs1liIilYaWatd
         w7FXc8GoGdx7PJ67CZzGKjadVgapw/U6XwjQRU3zTtnsYqT1tjQiK/X4zVaXgGxgQW
         pAfwBJ/DwllhsTWS076hZ6QsHZWio9Lw+ydXswIQ=
Date:   Fri, 23 Jun 2023 16:53:03 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com, vbabka@suse.cz,
        mgorman@techsingularity.net, david@redhat.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-compaction-skip-memory-hole-rapidly-when-isolating-migratable-pages-v4.patch removed from -mm tree
Message-Id: <20230623235304.851E7C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-compaction-skip-memory-hole-rapidly-when-isolating-migratable-pages-v4
has been removed from the -mm tree.  Its filename was
     mm-compaction-skip-memory-hole-rapidly-when-isolating-migratable-pages-v4.patch

This patch was dropped because it was folded into mm-compaction-skip-memory-hole-rapidly-when-isolating-migratable-pages.patch

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm-compaction-skip-memory-hole-rapidly-when-isolating-migratable-pages-v4
Date: Mon, 19 Jun 2023 10:22:24 +0800

limit next_ptn to not exceed cc->free_pfn

Link: https://lkml.kernel.org/r/a1d859c28af0c7e85e91795e7473f553eb180a9d.1686813379.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-skip-memory-hole-rapidly-when-isolating-migratable-pages-v4
+++ a/mm/compaction.c
@@ -1987,7 +1987,7 @@ static isolate_migrate_t isolate_migrate
 
 			next_pfn = skip_offline_sections(block_start_pfn);
 			if (next_pfn)
-				block_end_pfn = next_pfn;
+				block_end_pfn = min(next_pfn, cc->free_pfn);
 			continue;
 		}
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-compaction-skip-memory-hole-rapidly-when-isolating-migratable-pages.patch
mm-page_alloc-use-the-correct-type-of-list-for-free-pages.patch

