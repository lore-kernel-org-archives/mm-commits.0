Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC5A1EE49A6
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:42:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbjHUUmd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbjHUUlr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:41:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 866F010C0
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66AC463F6D
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF1F3C433C7;
        Mon, 21 Aug 2023 20:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650455;
        bh=YIXXRzIGOr08T3/uFxnIkb7pz72wBYaOPqmgTOimHS4=;
        h=Date:To:From:Subject:From;
        b=U3nJRCzvUd5DrPkF0I6qqFBHTpJO7eLdYMmJ6RTzAtySibR9hCDejAwcIa69FWak2
         iEIIW0IUO4xo/vYaGDSPm3FTVeMwEMQBfFMGmpXdYvqwjS6QOl8Yb+9IgOHVE2ywNV
         oXR7EsMXrFU6z+/RpDmyD/AkqxEvn7+whbj109S0=
Date:   Mon, 21 Aug 2023 13:40:55 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mgorman@techsingularity.net, david@redhat.com,
        baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-remove-unnecessary-parameter-batch-of-nr_pcp_free.patch removed from -mm tree
Message-Id: <20230821204055.AF1F3C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: remove unnecessary parameter batch of nr_pcp_free
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-unnecessary-parameter-batch-of-nr_pcp_free.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/page_alloc: remove unnecessary parameter batch of nr_pcp_free
Date: Wed, 9 Aug 2023 18:07:54 +0800

We get batch from pcp and just pass it to nr_pcp_free immediately.  Get
batch from pcp inside nr_pcp_free to remove unnecessary parameter batch.

Link: https://lkml.kernel.org/r/20230809100754.3094517-3-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-unnecessary-parameter-batch-of-nr_pcp_free
+++ a/mm/page_alloc.c
@@ -2340,10 +2340,10 @@ static bool free_unref_page_prepare(stru
 	return true;
 }
 
-static int nr_pcp_free(struct per_cpu_pages *pcp, int high, int batch,
-		       bool free_high)
+static int nr_pcp_free(struct per_cpu_pages *pcp, int high, bool free_high)
 {
 	int min_nr_free, max_nr_free;
+	int batch = READ_ONCE(pcp->batch);
 
 	/* Free everything if batch freeing high-order pages. */
 	if (unlikely(free_high))
@@ -2410,9 +2410,7 @@ static void free_unref_page_commit(struc
 
 	high = nr_pcp_high(pcp, zone, free_high);
 	if (pcp->count >= high) {
-		int batch = READ_ONCE(pcp->batch);
-
-		free_pcppages_bulk(zone, nr_pcp_free(pcp, high, batch, free_high), pcp, pindex);
+		free_pcppages_bulk(zone, nr_pcp_free(pcp, high, free_high), pcp, pindex);
 	}
 }
 
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


