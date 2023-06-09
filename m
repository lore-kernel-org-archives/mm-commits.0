Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DA1FC7EE45
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:27:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbjFIX1F (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232349AbjFIX05 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:26:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F67930FE
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:26:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFFA165CDB
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E641C433EF;
        Fri,  9 Jun 2023 23:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353215;
        bh=c8eTAGxl/kk/aNDFfES2ezmDHC/wicJRRTtEMN4OPl4=;
        h=Date:To:From:Subject:From;
        b=DPuWy5pfGRbs3dqkg/dCku5MVG55sarbUj/UfmNDnTMovCOMedh8UBiVyfl+j0HU1
         BpyorNsLkHKLEuN6uu5mPRHa3oJni8aY9PPghDLFoKyHfyFV93PjP86ElfsHCwwd64
         vJp907D181Aktr9o1WfGOFM0+ptwYF5R4++z0B60=
Date:   Fri, 09 Jun 2023 16:26:54 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com, vbabka@suse.cz,
        rppt@kernel.org, mhocko@suse.com, mgorman@techsingularity.net,
        david@redhat.com, baolin.wang@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-drop-the-unnecessary-pfn_valid-for-start-pfn.patch removed from -mm tree
Message-Id: <20230609232655.1E641C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: drop the unnecessary pfn_valid() for start pfn
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-drop-the-unnecessary-pfn_valid-for-start-pfn.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm/page_alloc: drop the unnecessary pfn_valid() for start pfn
Date: Mon, 24 Apr 2023 21:45:39 +0800

__pageblock_pfn_to_page() currently performs both pfn_valid check and
pfn_to_online_page().  The former one is redundant because the latter is a
stronger check.  Drop pfn_valid().

Link: https://lkml.kernel.org/r/c3868b58c6714c09a43440d7d02c7b4eed6e03f6.1682342634.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-drop-the-unnecessary-pfn_valid-for-start-pfn
+++ a/mm/page_alloc.c
@@ -1521,7 +1521,7 @@ struct page *__pageblock_pfn_to_page(uns
 	/* end_pfn is one past the range we are checking */
 	end_pfn--;
 
-	if (!pfn_valid(start_pfn) || !pfn_valid(end_pfn))
+	if (!pfn_valid(end_pfn))
 		return NULL;
 
 	start_page = pfn_to_online_page(start_pfn);
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


