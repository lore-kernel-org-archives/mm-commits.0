Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56B2BC07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:15:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AD8D6103E
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:15:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231727AbhGFTRy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:17:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:51960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231693AbhGFTRy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:17:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F2BE60FE3;
        Tue,  6 Jul 2021 19:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598915;
        bh=defpRVyJ5m9e4WsSnASKWK5psFLTIlhQNtL2yqCbZnM=;
        h=Date:From:To:Subject:From;
        b=yFQEpPm9Aum28+ZxXmiqLKpUFIHufgc0fSmmms76sEFgg/BthSv7iS07/4rFI18J1
         qSluhukC3vgXTrALEf36FBD8LMF/WC8xQTQqhPbEvK02atu269JbpOQke/2DYXPvTV
         pBxhfmZf9kh8BcXnHCfto7Sjaty79/5n375hqorQ=
Date:   Tue, 06 Jul 2021 12:15:15 -0700
From:   akpm@linux-foundation.org
To:     aisheng.dong@nxp.com, david@redhat.com, mm-commits@vger.kernel.org
Subject:  [merged] mm-page_alloc-improve-memmap_pages-dbg-msg.patch
 removed from -mm tree
Message-ID: <20210706191515.2Wb2iJSBR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: improve memmap_pages dbg msg
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-improve-memmap_pages-dbg-msg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dong Aisheng <aisheng.dong@nxp.com>
Subject: mm/page_alloc: improve memmap_pages dbg msg

Make debug message more accurate.

Link: https://lkml.kernel.org/r/20210531091908.1738465-6-aisheng.dong@nxp.com
Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-improve-memmap_pages-dbg-msg
+++ a/mm/page_alloc.c
@@ -7383,7 +7383,7 @@ static void __init free_area_init_core(s
 					pr_debug("  %s zone: %lu pages used for memmap\n",
 						 zone_names[j], memmap_pages);
 			} else
-				pr_warn("  %s zone: %lu pages exceeds freesize %lu\n",
+				pr_warn("  %s zone: %lu memmap pages exceeds freesize %lu\n",
 					zone_names[j], memmap_pages, freesize);
 		}
 
_

Patches currently in -mm which might be from aisheng.dong@nxp.com are


