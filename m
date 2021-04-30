Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5E80C433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:33:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA2B261449
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhD3FeX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:34:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:39296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhD3FeV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:34:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D2BA61449;
        Fri, 30 Apr 2021 05:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619760813;
        bh=hiFLq2fe+Hr4iFShm7fQPTtZs9UKixwPDWSMb6lJzjk=;
        h=Date:From:To:Subject:From;
        b=m36og438YulArAxdipQzfA2V/TQNeQVEG8R7N3bMZoODcoyIqujJswp3Qem+3xPPK
         Q0hqMk6DG8Q3/ZDbs5QgUGWBrszvGoEoqUvcPpFAsAO8YE3TeqLwrbu62Bt6pyPAfK
         eDkZWrUR2nwJhCZiCdE9OEv3V456XI2JwOR1CV8k=
Date:   Thu, 29 Apr 2021 22:33:33 -0700
From:   akpm@linux-foundation.org
To:     mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        vbabka@suse.cz
Subject:  [folded-merged]
 mm-page_alloc-add-a-bulk-page-allocator-fix-fix-fix.patch removed from -mm
 tree
Message-ID: <20210430053333.njG-o8N-z%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: add a bulk page allocator -fix -fix -fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-add-a-bulk-page-allocator-fix-fix-fix.patch

This patch was dropped because it was folded into mm-page_alloc-add-a-bulk-page-allocator.patch

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: add a bulk page allocator -fix -fix -fix

Vlastimil Babka noted that a comment is wrong, fix it.  This is the third
fix to the mmotm patch mm-page_alloc-add-a-bulk-page-allocator.patch.

Link: https://lkml.kernel.org/r/20210412110255.GV3697@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-add-a-bulk-page-allocator-fix-fix-fix
+++ a/mm/page_alloc.c
@@ -5048,7 +5048,7 @@ unsigned long __alloc_pages_bulk(gfp_t g
 		return 0;
 	gfp = alloc_gfp;
 
-	/* Find an allowed local zone that meets the high watermark. */
+	/* Find an allowed local zone that meets the low watermark. */
 	for_each_zone_zonelist_nodemask(zone, z, ac.zonelist, ac.highest_zoneidx, ac.nodemask) {
 		unsigned long mark;
 
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-rename-alloced-to-allocated.patch
mm-page_alloc-add-a-bulk-page-allocator.patch
mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator.patch
mm-memory_hotplug-make-unpopulated-zones-pcp-structures-unreachable-during-hot-remove.patch

