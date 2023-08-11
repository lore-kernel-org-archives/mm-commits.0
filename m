Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B4FBC001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:05:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237022AbjHKXFD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233643AbjHKXDk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:03:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D453A90
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:01:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97A6067B6B
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:01:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EECB4C433C7;
        Fri, 11 Aug 2023 23:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794910;
        bh=LsPNwZXbNq2NhB//L/FTXpttIdQqcH+7K8i2lkas41Q=;
        h=Date:To:From:Subject:From;
        b=L9k/DzBMiT7wzgaw4c6CwnctPFXSlHoo8zSczUW5v9bitHQ3wttgpiKzON11f7T2G
         D2Sfaylq3Ap9dRoNw5DMqbUM+RMFERgJVig6fMKYSPZwUD7zB1PQtmC8RmZN/Hdi+6
         GWYxljnPxoSXtnAJ1qISh3ne+YMjjjNy7dvT/c/c=
Date:   Fri, 11 Aug 2023 16:01:49 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, david@redhat.com,
        anshuman.khandual@arm.com, haifeng.xu@shopee.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_initc-drop-node_start_pfn-from-adjust_zone_range_for_zone_movable.patch removed from -mm tree
Message-Id: <20230811230149.EECB4C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mm_init.c: drop node_start_pfn from adjust_zone_range_for_zone_movable()
has been removed from the -mm tree.  Its filename was
     mm-mm_initc-drop-node_start_pfn-from-adjust_zone_range_for_zone_movable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Haifeng Xu <haifeng.xu@shopee.com>
Subject: mm/mm_init.c: drop node_start_pfn from adjust_zone_range_for_zone_movable()
Date: Mon, 17 Jul 2023 06:58:11 +0000

node_start_pfn is not used in adjust_zone_range_for_zone_movable(), so it
is pointless to waste a function argument.  Drop the parameter.

Link: https://lkml.kernel.org/r/20230717065811.1262-1-haifeng.xu@shopee.com
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/mm_init.c~mm-mm_initc-drop-node_start_pfn-from-adjust_zone_range_for_zone_movable
+++ a/mm/mm_init.c
@@ -1105,7 +1105,6 @@ void __ref memmap_init_zone_device(struc
  */
 static void __init adjust_zone_range_for_zone_movable(int nid,
 					unsigned long zone_type,
-					unsigned long node_start_pfn,
 					unsigned long node_end_pfn,
 					unsigned long *zone_start_pfn,
 					unsigned long *zone_end_pfn)
@@ -1222,9 +1221,8 @@ static unsigned long __init zone_spanned
 	/* Get the start and end of the zone */
 	*zone_start_pfn = clamp(node_start_pfn, zone_low, zone_high);
 	*zone_end_pfn = clamp(node_end_pfn, zone_low, zone_high);
-	adjust_zone_range_for_zone_movable(nid, zone_type,
-				node_start_pfn, node_end_pfn,
-				zone_start_pfn, zone_end_pfn);
+	adjust_zone_range_for_zone_movable(nid, zone_type, node_end_pfn,
+					   zone_start_pfn, zone_end_pfn);
 
 	/* Check that this node has pages within the zone's required range */
 	if (*zone_end_pfn < node_start_pfn || *zone_start_pfn > node_end_pfn)
_

Patches currently in -mm which might be from haifeng.xu@shopee.com are


